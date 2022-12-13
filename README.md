# Annotator example
This example is a 2D image viewer with an overlayed binary mask display in red and transparent.

The goal is to annotate a new mask by freely drawing with the mouse on the image.
This example demonstrate the slowness of a "classic" approach to do this live scribbling on high-resolution image.

## Install
This example has only been tested with PySide2==5.14.1 and python==3.8.10.

Clone the repo:
```bash
git clone https://github.com/AdrienChassignet/annotator_example.git
cd annotator_example
```

Install dependencies with conda:
```bash
conda env create --file environment.yml
```

## Getting started
Activate the conda environment:
```bash
conda activate annotator-example
```

Run the program:
```bash
python annotator
```