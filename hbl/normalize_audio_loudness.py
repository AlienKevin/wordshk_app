import pyloudnorm as pyln
import soundfile as sf
import os
from pydub import AudioSegment
from tqdm import tqdm
import librosa

# Directory paths
source_dir = "data/audios"
target_dir = "data/audios_normalized"

# Create target directory if it doesn't exist
if not os.path.exists(target_dir):
    os.makedirs(target_dir)

# Traverse deep folder structure and process all mp3 files
for root, dirs, files in tqdm(os.walk(source_dir)):
    for file in files:
        if file.endswith(".mp3"):
            file_path = os.path.join(root, file)
            # Load the audio file with pydub
            data, rate = librosa.load(file_path, sr=None, mono=True, dtype='float32')
            
            # Measure the loudness
            meter = pyln.Meter(rate)  # create BS.1770 meter
            loudness = meter.integrated_loudness(data)
            
            # Loudness normalize audio to -16 dB LUFS
            loudness_normalized_audio = pyln.normalize.loudness(data, loudness, -16.0)
            
            # Construct the new file path in the target directory, preserving folder structure
            relative_path = os.path.relpath(root, source_dir)
            target_folder = os.path.join(target_dir, relative_path)
            if not os.path.exists(target_folder):
                os.makedirs(target_folder)
            new_file_path = os.path.join(target_folder, file)
            
            # Save the normalized audio to a temporary WAV file
            temp_wav_path = os.path.join(target_folder, file.replace(".mp3", "_temp.wav"))
            sf.write(temp_wav_path, loudness_normalized_audio, rate)
            
            # Convert the WAV file to MP3
            sound = AudioSegment.from_wav(temp_wav_path)
            sound.export(new_file_path, format="mp3")
            
            # Remove the temporary WAV file
            os.remove(temp_wav_path)
