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
```
