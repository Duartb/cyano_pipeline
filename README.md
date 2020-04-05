# Pipeline to recover cyanobacteria genomes from metageme sequences
## From raw metagenomic fastq read files to individual assembled bacteria genomes, with read filtering and quality checking

**Requirements:**
- Docker (https://docs.docker.com/install/)

**Usage:**

1. Clone this repository to your machine and move into its directory \
```git clone https://github.com/Duartb/cyano_pipeline``` \
```cd path/to/cyano_pipeline```
2. Move your datasets and reference genomes into /myData (Illumina read datasets must be put into separate directories. Create output directories as you wish inside the /outputs dir) e.g. \
```mkdir myData/Dataset1 && mkdir myData/refGenomes && mkdir outputs/Outputs1``` \
```cp /path/to/dataset myData/Dataset1 && cp /path/to/reference myData/refGenomes```
3. Build docker image \
```docker build -f Dockerfile . -t cyanopipe:1.0```
4. Run CyanoPipeline GUI (choose an output dir inside CyanoPipeline/outputs/ to have access on local host)\
```ddocker run -it -v /tmp/.X11-unix:/tmp/.X11-unix -v $(pwd)/outputs:/home/CyanoPipeline/outputs -e DISPLAY=$DISPLAY -u qtuser cyanopipe:1.0 python3 /home/CyanoPipeline/CyanoPipeline.py```

![Pipeline](/resources/pipeline_flow.png?raw=true "CyanoPipe")
