import json

with open('collated_data_simplified.json', 'r') as f:
    collated_data = json.load(f)
    for book in collated_data:
        for page in collated_data[book]['pages']:
            for sent in page['sentences']:
                start = 0
                end = 1
                for gloss in sent['glosses']:
                    phrase = gloss['C']
                    while end <= len(sent['chars']):
                        sent['chars'][start:end]
                        if ''.join([char['C'] for char in sent['chars'][start:end]]) == phrase:
                            gloss['start'] = start
                            gloss['end'] = end
                            start = end
                            break
                        else:
                            end += 1
                assert(end == len(sent['chars']))

with open('collated_data_simplified_glossed.json', 'w') as f:
    json.dump(collated_data, f, ensure_ascii=False, indent=2)
