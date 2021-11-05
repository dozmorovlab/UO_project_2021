# Min Resolution

This script uses juicers calculate_map_resolution.sh to calculate the minimmum resolution available for the merged file.

### Setup

```
git clone https://github.com/aidenlab/juicer.git
```

### Usage
```
Usage: blender.sh [-h help] [-j Juicer_directory] [-m Merged File Path] [-c Coverage Filename] [-a account] [-p partition]

[-j] - Root directory of juicer repository
[-m] - Path to merged file
[-c] - Coverage file (to create)
[-a] - Slurm account (optional)
[-p] - Slurm partition (optional)


This file requries juicer/misc/calculate_map_resolution.sh from the juicer repo.
Make sure to visit: https://github.com/aidenlab/juicer and download repository.
 
NOTE: Make sure juicer/misc/calculate_map_resolution.sh contains the correct genome size count!!!
```