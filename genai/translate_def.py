from openai import OpenAI

with open('deepseek_api_key.txt', 'r') as file:
    api_key = file.read().strip()

client = OpenAI(api_key=api_key, base_url="https://api.deepseek.com")

import json

with open('translate_def_prompt.json', 'r') as file:
    prompt = json.load(file)

def translate(variant, yue_def):
    response = client.chat.completions.create(
        model="deepseek-chat",
        messages=[*prompt,
                  {
                    "role": "user",
                    "content": f"粵語詞條：{variant}\n粵語解釋：{yue_def}"
                  }],
        max_tokens=256,
        temperature=0.7,
        stream=False
    )
    return response.choices[0].message.content

if __name__ == '__main__':
    result = translate('滋陰', '(中醫)食一啲嘢或做一啲舉措去補充#陰 液, 係一種治療#陰虛 嘅方法')
    print(result)
