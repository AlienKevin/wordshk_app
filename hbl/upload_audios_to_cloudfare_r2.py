import os
import subprocess
from tqdm import tqdm
from concurrent.futures import ThreadPoolExecutor
import time

def upload_file_to_cloudfare(file_path, folder):
    time.sleep(2)  # Wait for 2 seconds to avoid hitting the 1200 requests per five minutes rate limit
    # Construct the cloudflare path
    cloudflare_path = f"hbl/{folder}_{os.path.basename(file_path)}"
    # Construct the command to upload the file
    command = f"npx wrangler r2 object put {cloudflare_path} --file={file_path} --content-type audio/mpeg"
    # Execute the command and only print if it fails
    result = subprocess.run(command, shell=True, capture_output=True, text=True)
    if result.returncode != 0:
        print(f"Failed to upload {file_path}: {result.stderr}")

def upload_audios_to_cloudfare():
    # Path to the directory containing all audio folders
    base_dir = "data/audios/"
    
    # Create a ThreadPoolExecutor to upload files in parallel
    with ThreadPoolExecutor() as executor:
        # Initialize tqdm progress bar with the total number of files to upload
        folders = sorted(os.listdir(base_dir))
        total_files = sum(len(files) for _, _, files in os.walk(base_dir) if files)
        pbar = tqdm(total=total_files)
        
        # Iterate through each folder in the base directory
        for folder in folders:
            folder_path = os.path.join(base_dir, folder)
            
            # Check if the current item is a directory
            if os.path.isdir(folder_path):
                # Iterate through each file in the directory
                for file in sorted(os.listdir(folder_path)):
                    if file.endswith(".mp3"):
                        file_path = os.path.join(folder_path, file)
                        # Submit the upload task to the executor
                        future = executor.submit(upload_file_to_cloudfare, file_path, folder)
                        # Increment the progress bar once the task is completed
                        future.add_done_callback(lambda p: pbar.update(1))
    # Ensure the progress bar is closed
    pbar.close()

if __name__ == "__main__":
    upload_audios_to_cloudfare()
