# Setup

```
conda create -n hbl maturin requests
```

```
maturin init
```
Pick pyo3

# Develop
```
maturin develop
```

# Create collated dataset
```
python get_story.py
python add_simplified.py
python add_gloss_start_end.py
python minify_json.py
```

# Normalize audio loudness
```
conda activate hbl
python -m pip install pyloudnorm pydub soundfile librosa tqdm
```

# Upload audios to Cloudfare R2
1. Install Volta for node.js version management
```
curl https://get.volta.sh | bash
```

2. Install node
```
volta install node
```

3. Install wrangler CLI
```
npm install wrangler@latest
```

4. Login to Wrangler
```
npx wrangler login
```

5. Upload audios to Cloudfare R2
```
python upload_audios_to_cloudfare_r2.py
```

# chinvocab HBL issues

1. Book 00110: aud/06.mp3 jumps directly to aud/08.mp3 (07.mp3 is a short silence). Similarly, 10.mp3, 13.mp3, 16.mp3, 18.mp3 are all silence.
