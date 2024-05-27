import json
from opencc import OpenCC
from cedict_utils.cedict import CedictParser

cc = OpenCC('t2s')

def extract_result(result):
    if '國語翻譯：' in result and '\n國語解釋：' in result:
        translation_start = result.find('國語翻譯：') + len('國語翻譯：')
        definition_start = result.find('\n國語解釋：') + len('\n國語解釋：')
        translation = result[translation_start:result.find('\n', translation_start)].strip()
        definition = result[definition_start:].strip()
        return translation, definition
    return None, None

mandarin_phrases = set()
parser = CedictParser()
entries = parser.parse()
for e in entries:
    mandarin_phrases.add(e.simplified)


def verify_translation_format(file_path):
    cantonese_phrases = {}
    with open(file_path, 'r', encoding='utf-8') as file:
        for line in file:
            entry = json.loads(line)
            result = entry.get('result', '')
            if 'error' in result:
                print(f"Error entry ID {entry['id']}: {result['error']}")
            elif not (result.startswith('國語翻譯：') and '\n國語解釋：' in result):
                print(f"Entry ID {entry['id']} has an incorrect format in 'result': {result}")
            else:
                (translation, definition) = extract_result(result)
                trans = cc.convert(translation)
                defi = cc.convert(definition)
                vars = [cc.convert(variant) for variant in entry['variants']]
                if trans not in vars and trans not in defi.split('；') and \
                    not any(variant in mandarin_phrases for variant in vars) and all(len(variant) > 1 for variant in vars):
                    if '/'.join(vars) != trans and '#' not in translation and len(trans) <= 2 * max(len(var) for var in vars):
                        cantonese_phrases[entry['id']] = ('/'.join(entry['variants']), translation)
    return cantonese_phrases

# Specify the path to the results.jsonl file
results_file_path = 'results.jsonl'
cantonese_phrases = verify_translation_format(results_file_path)

print(f'Number of Cantonese phrases: {len(cantonese_phrases)}')
with open('cantonese_phrase_translations.tsv', 'w') as f:
    for id, (cantonese, mandarin) in cantonese_phrases.items():
        f.write(str(id) + '\t' + cantonese + '\t' + mandarin + '\n')
