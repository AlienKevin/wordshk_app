Initialize virtual environment:
```bash
python3.11 -m venv venv
```

Activate venv and install dependencies:
```bash
source venv/bin/activate
pip install -r requirements.txt
```

## Get full content of DynanoDB table
```bash
aws dynamodb scan --table-name wordshk | jq .
```

## Clears all items from DynanoDB table
```bash
cd scripts
python clear_table.py
```
