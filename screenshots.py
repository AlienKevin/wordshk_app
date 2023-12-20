import os
import shutil
import subprocess
import threading
from flask import Flask, request, jsonify
from pathlib import Path

app = Flask(__name__)
device_id = ""

@app.route('/takeScreenshot', methods=['POST'])
def take_screenshot():
    name = request.json
    print(f"Received screenshot name: {name}")

    # Take screenshot
    cmd_screenshot = ["adb", "-s", device_id, "shell", "screencap", "-p", "/sdcard/screenshot.png"]
    result = subprocess.run(cmd_screenshot, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if result.returncode != 0:
        print(f"Error taking screenshot: {result.stderr.decode()}")
        return False

    # Pull screenshot
    cmd_pull = ["adb", "-s", device_id, "pull", "/sdcard/screenshot.png"]
    result = subprocess.run(cmd_pull, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if result.returncode != 0:
        print(f"Error pulling screenshot: {result.stderr.decode()}")
        return False
    dir = Path("screenshots")/device_id
    print(f"Saving screenshot to {dir}")
    os.makedirs(dir, exist_ok=True)
    path = dir/f"{name}.png"
    print(f"Moving screenshot to {path}")
    shutil.move("screenshot.png", path)
    print(f"Screenshot saved to {path}")
    return jsonify({'status': 'ok'})

def get_device_ids():
    # Run the adb devices command
    result = subprocess.run(['adb', 'devices'], stdout=subprocess.PIPE, text=True)
    # Parse the output
    lines = result.stdout.splitlines()
    device_ids = []
    for line in lines:
        # Each line represents a device in the format "device_id\tdevice_status"
        if "\t" in line:
            id, _ = line.split("\t")
            device_ids.append(id)
    return device_ids

if __name__ == "__main__":
    # Running the Flask server on a separate thread
    server_thread = threading.Thread(target=lambda: app.run(debug=True, host='0.0.0.0', port=5000, use_reloader=False))
    server_thread.start()

    device_ids = get_device_ids()
    for id in device_ids:
        device_id = id
        print(f"Device ID: {id}")
        os.system(f"flutter test integration_test/app_test.dart -d {device_id}")
