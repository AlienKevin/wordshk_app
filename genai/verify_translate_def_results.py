import json

def verify_translation_format(file_path):
    with open(file_path, 'r', encoding='utf-8') as file:
        for line in file:
            entry = json.loads(line)
            result = entry.get('result', '')
            if 'error' in result:
                print(f"Error entry ID {entry['id']}: {result['error']}")
            elif not (result.startswith('國語翻譯：') and '\n國語解釋：' in result):
                print(f"Entry ID {entry['id']} has an incorrect format in 'result': {result}")

# Specify the path to the results.jsonl file
results_file_path = 'results.jsonl'
verify_translation_format(results_file_path)
