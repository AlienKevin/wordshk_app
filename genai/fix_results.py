import json
import openai
from tqdm import tqdm

MAX_SAMPLE_FIXES = 100

# Read the JSONL file line by line and store the data in a list
sample_fixes = []
with open("sample_fixes.jsonl", "r") as f:
    for line in f:
        sample_fixes.append(json.loads(line))

def generate_prompt(sample):
    user = ''
    user += '粵語詞條：' + '/'.join(sample['variants']) + '\n'
    user += '粵語解釋：' + sample['yueDef'] + '\n'
    user += sample['result'].replace('國語翻譯', '國語詞條')
    if 'fix' not in sample:
        return {"role": "user", "content": user}
    if sample['fix'] is None:
        assistant = '國語糾錯：無'
    else:
        both = 'word' in sample['fix'] and 'def' in sample['fix']
        assistant = '國語糾錯：' + (('國語詞條：' + sample['fix']['word']) if 'word' in sample['fix'] else '') + \
            ('\n' if both else '') + ('國語解釋：' + sample['fix']['def'] if 'def' in sample['fix'] else '')
    return [
        {"role": "user", "content": user},
        {"role": "system", "content": assistant},
    ]

with open('deepseek_api_key.txt', 'r') as file:
    api_key = file.read().strip()
client = openai.OpenAI(api_key=api_key, base_url="https://api.deepseek.com")

# client = openai.OpenAI(
#     base_url="http://localhost:8080/v1",
#     api_key = "sk-no-key-required"
# )

def fix(sample):
    prompt = [
        {"role": "system", "content": "你是一個熟練掌握粵語和國語的香港人，需要幫助一個粵語詞典糾錯翻譯好的國語詞條和解釋。糾錯時注意#後面跟的粵語詞語是一個超連結，如果連結的詞語在粵語和國語都說得通，則保留原連結，不然則翻譯連結內容並且去除#。注意只翻譯粵語詞條和解釋，不要添加額外註解或者翻譯過程中的選詞原因。國語翻譯可以列出多個對應的國語表達。原文提到粵拼時，不要改成漢語拼音。"},
        *(p for sample in sample_fixes[:MAX_SAMPLE_FIXES] for p in generate_prompt(sample)),
        generate_prompt(sample),
    ]

    completion = client.chat.completions.create(
        model="deepseek-chat",
        messages=prompt,
        max_tokens=256,
        temperature=0,
        stream=False
    )

    return completion.choices[0].message.content

with open("results.jsonl", "r") as f:
    for line in tqdm(f.readlines()):
        print(line)
        print(fix(json.loads(line)))
