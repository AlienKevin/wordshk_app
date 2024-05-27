import json
from opencc import OpenCC
from cedict_utils.cedict import CedictParser

cc = OpenCC('t2s')

def extract_result(result):
    start_tag = '<mandarin>'
    end_tag = '</mandarin>'
    
    start_index = result.find(start_tag)
    end_index = result.find(end_tag, start_index)
    
    if start_index != -1 and end_index != -1:
        start_index += len(start_tag)
        mandarin_content = result[start_index:end_index]
    else:
        mandarin_content = ''
    
    return mandarin_content.split('/')

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
            else:
                translations = extract_result(result)
                definition = cc.convert(entry['yueDef'])
                variants = [cc.convert(variant) for variant in entry['variants']]
                if len(set(translations).intersection(set(variants))) == 0 and \
                    not any(variant in mandarin_phrases for variant in variants) and \
                    not any('/'.join(variants) == translation for translation in translations) and \
                    not any(len(translation) > 2 * max(len(variant) for variant in variants) for translation in translations):
                    cantonese_phrases[entry['id']] = ('/'.join(entry['variants']), translations, entry['defIndex'])
    return cantonese_phrases

# Specify the path to the results.jsonl file
results_file_path = 'results.jsonl'
cantonese_phrases = verify_translation_format(results_file_path)

print(f'Number of Cantonese phrases: {len(cantonese_phrases)}')
with open('cantonese_phrase_translations.tsv', 'w') as f:
    f.write('entry_id\tdef_index\tvariants\tmandarin_translations\n')
    for id, (cantonese, translations, def_index) in cantonese_phrases.items():
        f.write(str(id) + '\t' + str(def_index) + '\t' + cantonese + '\t' + '/'.join(translations) + '\n')
