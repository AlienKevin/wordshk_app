from openai import OpenAI
from concurrent.futures import ThreadPoolExecutor
from tqdm import tqdm
import time
import json
from threading import Lock
from opencc import OpenCC

cc = OpenCC('t2s')

with open('deepseek_api_key.txt', 'r') as file:
    api_key = file.read().strip()

client = OpenAI(api_key=api_key, base_url="https://api.deepseek.com")

with open('translate_def_prompt_v2.json', 'r') as file:
    prompt = json.load(file)

def translate(variant, yue_def, eng_def):
    attempts = 0
    while True:
        try:
            response = client.chat.completions.create(
                model="deepseek-chat",
                messages=[*prompt,
                          {
                            "role": "user",
                            "content": f"<english>{eng_def}</english>\n<cantonese>{variant}</cantonese>"
                          }],
                max_tokens=256,
                temperature=1.1,
                stream=False
            )
            return response.choices[0].message.content
        except Exception as e:
            print(f'{variant} encountered an error: {e}')
            time.sleep(1)
            attempts += 1
            if attempts >= 3:
                return {'error': str(e)}


cantonese_ids = set()
with open('cantonese_phrase_translations.tsv', 'r') as file:
    for line in file:
        id = line.split('\t')[0]
        cantonese_ids.add(int(id))
print(f'Number of Cantonese phrases: {len(cantonese_ids)}')

# idiom.json from: https://github.com/mapull/chinese-dictionary/blob/main/idiom/idiom.json
mandarin_words = set()
with open('idiom.json', 'r') as file:
    idioms = json.load(file)
    for idiom in idioms:
        mandarin_words.add(idiom['word'])

# word.json from: https://github.com/mapull/chinese-dictionary/blob/main/word/word.json
with open('word.json', 'r') as file:
    words = json.load(file)
    for word in words:
        mandarin_words.add(word['word'])
print(f'Number of Mandarin words: {len(mandarin_words)}')


def extract_yue_variants_and_defs(data):
    entries = []
    for entry in data.values():
        if entry['id'] not in cantonese_ids:
            continue
        variants = entry.get('variants', [])
        variants = [variant.get('w', '') for variant in variants]

        if any(cc.convert(variant) in mandarin_words for variant in variants):
            continue

        for def_index, definition in enumerate(entry.get('defs', [])):
            yue_def_lines = []
            for line in definition.get('yue', []):
                yue_def_line = ''
                for segment in line:
                    segment_type, segment_content = segment[0], segment[1]
                    yue_def_line += segment_content
                yue_def_lines.append(yue_def_line)
            
            if definition.get('eng') is None:
                continue

            eng_def_lines = []
            for line in definition.get('eng', []):
                eng_def_line = ''
                for segment in line:
                    segment_type, segment_content = segment[0], segment[1]
                    eng_def_line += segment_content
                eng_def_lines.append(eng_def_line)
            entries.append({"id": entry.get('id'), "variants": variants, "defIndex": def_index, "yueDef": '\n'.join(yue_def_lines), "engDef": '\n'.join(eng_def_lines)})
    return entries


if __name__ == '__main__':
    # Load the data from dict.json
    with open('dict.json', 'r') as file:
        data = json.load(file)

    # Extract variants and definitions using the predefined function
    extracted_entries = extract_yue_variants_and_defs(data)

    with ThreadPoolExecutor(max_workers=10) as executor:
        with open('results.jsonl', 'w+') as file:
            lock = Lock()
            def process_entry(entry):
                result = {"id": entry['id'],
                          "variants": entry['variants'],
                          "yueDef": entry['yueDef'],
                          "engDef": entry['engDef'],
                          "defIndex": entry['defIndex'],
                          "result": translate('/'.join(entry['variants']), entry['yueDef'], entry['engDef'])
                          }
                with lock:
                    file.write(json.dumps(result, ensure_ascii=False) + '\n')
                    file.flush()
                return result
            list(tqdm(executor.map(process_entry, extracted_entries), total=len(extracted_entries)))
