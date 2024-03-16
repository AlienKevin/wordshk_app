import json
import hbl

with open('collated_data.json', 'r') as f:
    collated_data = json.load(f)
    for book in collated_data.values():
        book['title_C_s'] = hbl.to_simplified(book['title_C'])
        for page in book['pages']:
            for sent in page['sentences']:
                for gloss in sent['glosses']:
                    gloss['C_s'] = hbl.to_simplified(gloss['C'])

with open('collated_data_simplified.json', 'w') as f:
    json.dump(collated_data, f, ensure_ascii=False, indent=2)
