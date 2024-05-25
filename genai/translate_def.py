from openai import OpenAI
from concurrent.futures import ThreadPoolExecutor
from tqdm import tqdm
import time
import json
from threading import Lock

with open('deepseek_api_key.txt', 'r') as file:
    api_key = file.read().strip()

client = OpenAI(api_key=api_key, base_url="https://api.deepseek.com")

with open('translate_def_prompt.json', 'r') as file:
    prompt = json.load(file)

def translate(variant, yue_def):
    attempts = 0
    while True:
        try:
            response = client.chat.completions.create(
                model="deepseek-chat",
                messages=[*prompt,
                          {
                            "role": "user",
                            "content": f"粵語詞條：{variant}\n粵語解釋：{yue_def}"
                          }],
                max_tokens=256,
                temperature=0,
                stream=False
            )
            return response.choices[0].message.content
        except Exception as e:
            print(f'{variant} encountered an error: {e}')
            time.sleep(1)
            attempts += 1
            if attempts >= 3:
                return {'error': str(e)}


def extract_yue_variants_and_defs(data):
    entries = []
    for entry in data.values():
        variants = entry.get('variants', [])
        variants = [variant.get('w', '') for variant in variants]
        
        for definition in entry.get('defs', []):
            yue_def_lines = []
            for line in definition.get('yue', []):
                yue_def_line = ''
                for i, segment in enumerate(line):
                    segment_type, segment_content = segment[0], segment[1]
                    if segment_type == 'L':
                        segment_content = f"{'' if i == 0 else ' '}#{segment_content}{' ' if i < len(line) - 1 else ''}"
                    yue_def_line += segment_content
                yue_def_lines.append(yue_def_line)
            entries.append({"id": entry.get('id'), "variants": variants, "defIndex": i, "yueDef": ''.join(yue_def_lines)})
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
                          "result": translate('/'.join(entry['variants']), entry['yueDef'])
                          }
                with lock:
                    file.write(json.dumps(result, ensure_ascii=False) + '\n')
                    file.flush()
                return result
            list(tqdm(executor.map(process_entry, extracted_entries), total=len(extracted_entries)))
