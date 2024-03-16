import json
import os

audios_dir = 'data/audios'

if not os.path.exists(audios_dir):
    os.makedirs(audios_dir)

with open('collated_data.json', 'r') as f:
    collated_data = json.load(f)
    for book_id, book in collated_data.items():
        book_audio_dir = f'{audios_dir}/{book_id}'
        if not os.path.exists(book_audio_dir):
            os.makedirs(book_audio_dir)
        num_sents = sum([len(page['sentences']) for page in book['pages']])
        for sent in range(num_sents):
            sent_id = f'{sent + 1:02d}'
            url = f'https://chinvocab.com/hbl/stories/{book_id}/aud/{sent_id}.mp3'
            import requests
            audio_response = requests.get(url)
            if audio_response.status_code == 200:
                with open(f'{book_audio_dir}/{sent_id}.mp3', 'wb') as audio_file:
                    audio_file.write(audio_response.content)
            else:
                print(f"Failed to download audio for {book_id} sentence {sent} from {url}")
