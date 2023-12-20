import json
import os
import shutil
import subprocess
from flask import Flask, request, jsonify, current_app
from multiprocessing import Process, Manager
from pathlib import Path

app = Flask(__name__)

@app.route('/takeScreenshot', methods=['POST'])
def take_screenshot():
    is_android = current_app.config['d']['is_android']
    device_id = current_app.config['d']['device_id']
    locale = current_app.config['d']['locale']

    name = request.json
    print(f"Device ID: {device_id}")
    print(f"Received screenshot name: {name}")

    if is_android:
        # Take screenshot
        cmd_screenshot = ["adb", "-s", device_id, "shell", "screencap", "-p", "/sdcard/screenshot.png"]
        result = subprocess.run(cmd_screenshot, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        if result.returncode != 0:
            print(f"Error taking screenshot: {result.stderr}")
            return False
        # Pull screenshot
        cmd_pull = ["adb", "-s", device_id, "pull", "/sdcard/screenshot.png"]
        result = subprocess.run(cmd_pull, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        if result.returncode != 0:
            print(f"Error pulling screenshot: {result.stderr}")
            return False
    else:
        # Take screenshot
        cmd_screenshot = ["xcrun", "simctl", "io", device_id, "screenshot", "screenshot.png"]
        result = subprocess.run(cmd_screenshot, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        if result.returncode != 0:
            print(f"Error taking screenshot: {result.stderr}")
            return False
    os_name = "android" if is_android else "ios"
    dir = Path("screenshots")/os_name/device_id/locale
    print(f"Saving screenshot to {dir}")
    os.makedirs(dir, exist_ok=True)
    path = dir/f"{name}.png"
    print(f"Moving screenshot to {path}")
    shutil.move("screenshot.png", path)
    print(f"Screenshot saved to {path}")
    return jsonify({'status': 'ok'})

def get_android_device_ids():
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

def get_ios_device_ids():
    # Run the xcrun simctl list devices command
    result = subprocess.run(['xcrun', 'simctl', 'list', 'devices', '--json'], stdout=subprocess.PIPE, text=True)
    # Parse the output
    device_ids = []
    for version in json.loads(result.stdout)["devices"].values():
        for device in version:
            if device["state"] == "Booted":
                device_ids.append(device["udid"])
    return device_ids

def run_server(d):
    app.config['d'] = d
    app.run(debug=True, host='0.0.0.0', port=5000, use_reloader=False)

def locale_to_language(locale):
    match locale:
        case "zh_HK":
            return "zhHant"
        case "zh_CN":
            return "zhHans"
        case "en_US":
            return "en"
        case _:
            raise Exception(f"Invalid locale {locale}")

def process(os_name, device_ids, d):
    d['is_android'] = os_name == "android"
    for id in device_ids:
        d['device_id'] = id
        print(f"{os_name} Device ID: {id}")
        for locale in locales:
            d['locale'] = locale

            # Don't set the system locale for now
            # https://medium.com/@tejasv2/update-language-and-region-in-ios-simulator-f558728815b
            # home_dir = os.environ['HOME']
            # plist_path = f"{home_dir}/Library/Developer/CoreSimulator/Devices/{id}/data/Library/Preferences/.GlobalPreferences.plist"
            # command = ["plutil", "-replace", "AppleLocale", "-string", locale, plist_path]
            # subprocess.run(command, text=True)
            # command = ["plutil", "-replace", "AppleLanguages", "-json", f'["{locale}"]', plist_path]
            # subprocess.run(command, text=True)
            # subprocess.run(["xcrun", "simctl", "shutdown", id])
            # subprocess.run(["xcrun", "simctl", "boot", id])
            print(f"Locale set to {locale}")

            # Do set the language in the app
            command = ["flutter", "test", "integration_test/app_test.dart", "-d", id, "--dart-define", f"language={locale_to_language(locale)}"]
            result = subprocess.run(command, text=True)
            if result.returncode != 0:
                print(f"Error running integration test on device ID {id}")
                break


if __name__ == "__main__":
    manager = Manager()
    d = manager.dict()
    d['is_android'] = True
    locales = ["zh_HK", "zh_CN", "en_US"]

    # Clear the screenshots directory
    shutil.rmtree("screenshots", ignore_errors=True)

    # Running the Flask server on a separate thread
    server = Process(target=run_server, args=(d,))
    server.start()

    process("android", get_android_device_ids(), d)

    process("ios", get_ios_device_ids(), d)

    # Terminate the Flask server once the screenshots are taken
    server.terminate()
    server.join()
