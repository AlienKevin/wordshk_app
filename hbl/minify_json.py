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

                for char in sent['chars']:
                    del char['char']
                    del char['yale']
                    del char['csdb']

                    char['pr'] = char['jyutping']
                    del char['jyutping']

                for gloss in sent['glosses']:
                    del gloss['glo']
                    del gloss['C_s']
                    del gloss['C']
                    gloss['chars'] = [sent['chars'][i] for i in range(gloss['start'], gloss['end'])]
                    del gloss['start']
                    del gloss['end']

                del sent['chars']

with open('hbl.json', 'w') as f:
    json.dump(collated_data, f, ensure_ascii=False, indent=None, separators=(',', ':'))
