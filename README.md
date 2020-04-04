# Pipeline to recover cyanobacteria genomes from metageme sequences
## From raw metagenomic fastq read files to individual assembled bacteria genomes, with read filtering and quality checking

**Requirements:**
- Docker (https://docs.docker.com/install/)

**Usage:**

1. Clone this repository to your machine;
2. Build docker image
```docker build -f Dockerfile . -t cyanopipe:1.0```
3. Run CyanoPipeline GUI
```docker run -it -v /tmp/.X11-unix:/tmp/.X11-unix -v $(pwd)/test:/app -e DISPLAY=$DISPLAY -u qtuser cyanopipe:1.0 python3 /home/CyanoPipeline/CyanoPipeline.py ```
4. Copy the results to the host machine
```docker cp 72ca2488b353:/foo.txt foo.txt```
or check them inside the Docker container
```docker run -it -u qtuser cyanopipe:1.0```
4. Profit!

![Pipeline](/resources/pipeline_flow.png?raw=true "CyanoPipe")
