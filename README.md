# 🚀 VastAI Instance Auto-Creation Script

This script automates the process of searching, creating, and initializing GPU instances on [Vast.ai](https://vast.ai), based on your custom requirements. It is designed to work across **Linux (Ubuntu/Arch)** and **Windows** (via WSL or Git Bash).

---

## 📋 Features

- 🔐 **Secure API integration** with VastAI.
- 🔍 **Auto-search** for available high-performance GPU instances.
- ⚙️ **Automated instance creation** with Jupyter and PyTorch image.
- 📄 **Custom logic** for filtering and selecting instances via Python.
- 🧠 Compatible with Linux and Windows (via WSL or Git Bash).

---

## 📦 Prerequisites

Before running the script, ensure you have the following installed:

### 🧰 System Dependencies

| Tool      | Ubuntu                         | Arch                           | Windows (via WSL or Git Bash)                        |
|-----------|--------------------------------|--------------------------------|------------------------------------------------------|
| `bash`    | Preinstalled                   | Preinstalled                   | [Git Bash](https://git-scm.com/) or WSL             |
| `jq`      | `sudo apt install jq`          | `sudo pacman -S jq`            | [jq Download](https://stedolan.github.io/jq/)       |
| `conda`   | [Miniconda](https://docs.conda.io/en/latest/miniconda.html) |
| `vastai`  | `pip install vastai`           | `pip install vastai`           | `pip install vastai`                                |

### 🐍 Python Dependencies

- `vastai` (CLI + API integration):  
```bash
  pip install vastai
```
### 🧪 Usage Example 1 :
```bash
chmod +x create_ins.sh && ./create_ins.sh
```


### 🧪 Usage Example 2 :
```bash
bash ./create_ins.sh
```
## 🛠 Script Overview
```bash
#!/bin/bash

# 1. Activate Conda Environment
# 2. Set VastAI API Key
# 3. Search for GPU offers with high specs
# 4. Extract target instance IDs using filter_data.py
# 5. Create instances and log details
```


## 🔒 Security Note
⚠️ Do not hardcode your VastAI API key in production environments.
Use environment variables or secure vaults when possible.
```bash
export VAST_API_KEY=your_api_key_here
vastai set api-key $VAST_API_KEY
```


## 📁 File Structure
```bash
├── create_ins.sh     # Main automation script
├── filter_data.py                   # Custom logic to parse VastAI offers
├── vastai_output.txt         # Output file from search
└── README.md                 # This file

```

# 🙋‍♂️ Need Help?
Open an issue or ping me if you need help extending or debugging the automation.
```bash

Let me know if you want to make this README fancier with badges, screenshots, or real-time instance metrics!

```