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
