import json

with open('collated_data_simplified_glossed.json', 'r') as f:
    collated_data = json.load(f)
    for book in collated_data.values():
        for page in book['pages']:
            del page['pg']
            del page['audio']
            del page['struct']
            for sent in page['sentences']:
                del sent['sent']
                del sent['verif_transl']
                for gloss in sent['glosses']:
                    del gloss['glo']
                    del gloss['E']
                    del gloss['C_s']

                for char in sent['chars']:
                    del char['char']
                    del char['yale']
                    del char['csdb']

                    char['pr'] = char['jyutping']
                    del char['jyutping']

with open('collated_data_minified.json', 'w') as f:
    json.dump(collated_data, f, ensure_ascii=False, indent=None, separators=(',', ':'))
