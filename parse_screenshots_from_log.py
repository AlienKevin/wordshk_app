import json
import os

def main():
    log_file_path = 'log.txt'
    screenshot_dir_path = 'screenshots/'

    # Read the log file
    log_contents = read_file(log_file_path)

    # Find the JSON string after "====SCREENSHOTS===="
    json_string = extract_json_string(log_contents)

    # Parse JSON and save screenshots
    save_screenshots(json_string, screenshot_dir_path)

def read_file(file_path):
    with open(file_path, 'r') as file:
        return file.read()

def extract_json_string(contents):
    lines = contents.split('\n')
    for i, line in enumerate(lines):
        if "====SCREENSHOTS====" in line:
            return lines[i + 1]
    raise ValueError("====SCREENSHOTS==== not found in log file")

def save_screenshots(json_string, dir_path):
    screenshots = json.loads(json_string)

    # Create screenshot directory if it doesn't exist
    if not os.path.exists(dir_path):
        os.makedirs(dir_path)

    # Save each screenshot
    for screenshot in screenshots:
        file_name = screenshot['screenshotName']
        bytes_data = screenshot['bytes']
        file_path = os.path.join(dir_path, f'{file_name}.png')

        with open(file_path, 'wb') as file:
            file.write(bytearray(bytes_data))

        print(f'Saved screenshot: {file_path}')

if __name__ == "__main__":
    main()
