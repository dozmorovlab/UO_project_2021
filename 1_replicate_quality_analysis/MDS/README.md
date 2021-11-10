# SSC Pipeline
# Note: WIP
### Author: Brian Palmer
### 10/9/2021
### Week 1

##### Usage
**useful link: https://stackoverflow.com/questions/48787250/set-up-virtualenv-using-a-requirements-txt-generated-by-conda**

1. Create conda environment for hicexplorer
```bash
conda env create --file environment.yaml
conda activate scc
```

2. Create virtual environment (Hicrep is installed using pip)
```bash
python3 -m venv venv
```

 On osx/linux
```bash
source venv/bin/activate
```
 On windows
```bash
source venv/Scripts/Activate.bat
```

 Install packages from pip file 
```bash
pip install -r requirements.txt
```



