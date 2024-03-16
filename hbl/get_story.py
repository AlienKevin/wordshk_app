import json
from tqdm import tqdm

# Load the JSON files
with open('data/books.json') as f:
    books_data = json.load(f)

with open('data/pages.json') as f:
    pages_data = json.load(f)

with open('data/sents.json') as f:
    sents_data = json.load(f)

with open('data/mand.json') as f:
    mand_data = json.load(f)

with open('data/glosses.json') as f:
    glosses_data = json.load(f)

with open('data/chars.json') as f:
    chars_data = json.load(f)

# Create a dictionary to store the collated data
collated_data = {}

# Iterate over the books data
for i in tqdm(range(len(books_data['id']))):
    book_id = books_data['id'][i]
    collated_data[book_id] = {
        'title_C': books_data['title_C'][i],
        'title_E': books_data['title_E'][i],
        'pages': []
    }

    # Iterate over the pages data
    for j in range(len(pages_data['id'])):
        if pages_data['id'][j] == book_id:
            page_data = {
                'pg': pages_data['pg'][j],
                'audio': pages_data['audio'][j],
                'struct': pages_data['struct'][j],
                'sentences': []
            }

            # Iterate over the sentences data
            for k in range(len(sents_data['id'])):
                if sents_data['id'][k] == book_id and sents_data['pg'][k] == pages_data['pg'][j]:
                    sent_data = {
                        'sent': sents_data['sent'][k],
                        'C': sents_data['C'][k],
                        'E': sents_data['E'][k],
                        'verif_transl': sents_data['verif_transl'][k],
                        'mand': [],
                        'glosses': [],
                        'chars': []
                    }

                    # Iterate over the Mandarin data
                    for l in range(len(mand_data['id'])):
                        if mand_data['id'][l] == book_id and mand_data['pg'][l] == pages_data['pg'][j] and mand_data['sent'][l] == sents_data['sent'][k]:
                            sent_data['mand'].append({
                                'C': mand_data['C'][l],
                                'C_s': mand_data['C_s'][l]
                            })

                    # Iterate over the glosses data
                    for m in range(len(glosses_data['id'])):
                        if glosses_data['id'][m] == book_id and glosses_data['pg'][m] == pages_data['pg'][j] and glosses_data['sent'][m] == sents_data['sent'][k]:
                            sent_data['glosses'].append({
                                'glo': glosses_data['glo'][m],
                                'C': glosses_data['C'][m],
                                'E': glosses_data['E'][m]
                            })

                    # Iterate over the characters data
                    for n in range(len(chars_data['id'])):
                        if chars_data['id'][n] == book_id and chars_data['pg'][n] == pages_data['pg'][j] and chars_data['sent'][n] == sents_data['sent'][k]:
                            sent_data['chars'].append({
                                'char': chars_data['char'][n],
                                'C': chars_data['C'][n],
                                'jyutping': chars_data['jyutping'][n],
                                'yale': chars_data['yale'][n],
                                'csdb': chars_data['csdb'][n]
                            })

                    page_data['sentences'].append(sent_data)

            collated_data[book_id]['pages'].append(page_data)

# Save the collated data to a JSON file
with open('collated_data.json', 'w') as f:
    json.dump(collated_data, f, indent=2, ensure_ascii=False)
