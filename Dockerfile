# We will use Ubuntu for our image
FROM ubuntu:16.04

# Set bash as default image shell
SHELL ["/bin/bash", "-c"]

# Updating Ubuntu packages
RUN apt-get update && yes|apt-get upgrade

# Adding wget and bzip2
RUN apt-get install -y wget bzip2 make sudo python3-pyqt5 default-jre

# Copying the pipeline and making bash scripts executable
COPY ./ /home/CyanoPipeline/

# Creating user
RUN adduser --disabled-password --gecos '' qtuser
RUN chown -R qtuser: /home/qtuser && chown -R qtuser: /home/CyanoPipeline
USER qtuser

# Anaconda installing
RUN cd /home/qtuser/ && wget https://repo.continuum.io/miniconda/Miniconda3-py37_4.8.2-Linux-x86_64.sh
RUN bash /home/qtuser/Miniconda3-py37_4.8.2-Linux-x86_64.sh -b -p /home/qtuser/miniconda3
RUN rm /home/qtuser/Miniconda3-py37_4.8.2-Linux-x86_64.sh

# Set path to conda
ENV PATH /home/qtuser/miniconda3/bin:$PATH

# Updating Anaconda packages
RUN conda update conda
RUN conda update --all

# Setting conda environments
COPY ./conda_envs/* /home/CyanoPipeline/conda_envs/
RUN conda env create -f /home/CyanoPipeline/conda_envs/cutadapt_env.yml
RUN conda env create -f /home/CyanoPipeline/conda_envs/fastqc_env.yml
RUN conda env create -f /home/CyanoPipeline/conda_envs/kraken2_env.yml
RUN conda env create -f /home/CyanoPipeline/conda_envs/maxbin2_env.yml
RUN conda env create -f /home/CyanoPipeline/conda_envs/quast_env.yml
RUN conda env create -f /home/CyanoPipeline/conda_envs/spades_env.yml
RUN conda env create -f /home/CyanoPipeline/conda_envs/base_env.yml
RUN rm -r /home/CyanoPipeline/conda_envs/

#Install bbmap
RUN cd /home/qtuser/ && \
    wget https://sourceforge.net/projects/bbmap/files/BBMap_38.32.tar.gz && \
    tar -xvzf BBMap_38.32.tar.gz

RUN conda install -c anaconda pyqt -y
