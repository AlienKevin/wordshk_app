Initialize virtual environment:
```bash
python3.11 -m venv venv
```

Activate venv and install dependencies:
```bash
source venv/bin/activate
pip install -r requirements.txt
```

Install and initialize Zappa:
```bash
pip install zappa
zappa init
```

Deploy to AWS:
```bash
zappa deploy dev
```

Dev server URL:
```
https://1cvycekk7e.execute-api.ap-east-1.amazonaws.com/dev
```

Inspect snapshots:
```bash
aws lambda invoke --function-name inspect_snapshots output.txt
```

Delete snapshots:
```bash
aws lambda invoke --function-name delete_snapshots output.txt
```

# Configurations for lambda functions
1. Enable VPC access
2. Add File System from EFS, set Local mount path to `/mnt/efs`
