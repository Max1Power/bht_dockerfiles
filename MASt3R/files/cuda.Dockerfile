FROM nvidia/cuda:12.9.1-cudnn-devel-ubuntu24.04

LABEL description="Docker container for MASt3R with dependencies installed. CUDA VERSION"
ENV DEVICE="cuda"
ENV MODEL="MASt3R_ViTLarge_BaseDecoder_512_dpt.pth"
ARG DEBIAN_FRONTEND=noninteractive
ENV TORCH_CUDA_ARCH_LIST="12.0"

RUN export TORCH_CUDA_ARCH_LIST="12.0"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    openssh-server \
    git \
    build-essential \
    python3-dev \
    libgl1 \
    libglib2.0-0 \
    python3 \
    python3-pip \
    vim \
    python-is-python3 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN pip uninstall --break-system-packages torch torchvision torchaudio
RUN pip install --break-system-packages --upgrade torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/cu129
RUN git clone --recursive https://github.com/naver/mast3r /mast3r

RUN ls -R /mast3r

WORKDIR /mast3r/dust3r
RUN pip install --break-system-packages -r requirements.txt
RUN pip install --break-system-packages -r requirements_optional.txt
RUN pip install --break-system-packages opencv-python==4.8.0.74

WORKDIR /mast3r/dust3r/croco/models/curope/
RUN python setup.py build_ext --inplace

WORKDIR /mast3r
RUN pip install --break-system-packages -r requirements.txt
RUN pip install --break-system-packages numpy==1.26.4 --force-reinstall

RUN chmod +x ./docker/files/entrypoint.sh

ENTRYPOINT ["./docker/files/entrypoint.sh"]

