FROM nvidia/cuda:11.8.0-devel-ubuntu22.04

# System-Pakete installieren (inkl. git)
RUN apt-get update && \
    apt-get install -y wget git build-essential && \
    rm -rf /var/lib/apt/lists/*

# Miniconda installieren
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh
ENV PATH=/opt/conda/bin:$PATH

# Conda Terms of Service akzeptieren
RUN conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main && \
    conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r

# Conda Umgebung einrichten
RUN conda create -n pointcept python=3.8 -y
SHELL ["conda", "run", "-n", "pointcept", "/bin/bash", "-c"]

# Dependencies
RUN conda install ninja -y
RUN conda install pytorch==2.1.0 torchvision==0.16.0 torchaudio==2.1.0 pytorch-cuda=11.8 -c pytorch -c nvidia -y
RUN conda install h5py pyyaml -c anaconda -y
RUN conda install sharedarray tensorboard tensorboardx yapf addict einops scipy plyfile termcolor timm -c conda-forge -y
RUN conda install pytorch-cluster pytorch-scatter pytorch-sparse -c pyg -y
RUN pip install torch-geometric

# Klone das PointTransformerV3-Repo (Pfad anpassen, wenn nötig)
WORKDIR /workspace
RUN git clone --recursive https://github.com/Pointcept/PointTransformerV3.git
RUN ls -la  ./PointTransformerV3/ # Sollte setup.py anzeigen!

# Baue pointops
WORKDIR /workspace/PointTransformerV3/Pointcept/libs/pointops
ENV TORCH_CUDA_ARCH_LIST="8.6;8.0;7.5;7.0;6.2;6.1;6.0"

RUN python setup.py install

WORKDIR /workspace

# pip-Pakete
RUN pip install spconv-cu118
RUN pip install open3d

ENTRYPOINT ["conda", "run", "-n", "pointcept", "bash"]

