# Schritt 1: Basis-Image festlegen
#FROM pytorch/pytorch:2.7.0-cuda12.8-cudnn9-devel
FROM nvidia/cuda:12.9.1-cudnn-devel-ubuntu24.04

LABEL description="Docker container for MASt3R with dependencies installed. CUDA VERSION"
ENV DEVICE="cuda"
ENV MODEL="MASt3R_ViTLarge_BaseDecoder_512_dpt.pth"
ARG DEBIAN_FRONTEND=noninteractive
ENV TORCH_CUDA_ARCH_LIST="12.0"

RUN export TORCH_CUDA_ARCH_LIST="12.0"

# Ersetzen Sie Ihre alte RUN-Zeile durch diese Blöcke

# Setzt die Umgebung, um interaktive Installations-Dialoge zu unterdrücken
ENV DEBIAN_FRONTEND=noninteractive

# Installiere jedes Paket einzeln zur Fehlersuche
# Der Build wird genau bei dem Paket fehlschlagen, das das Problem verursacht.
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
WORKDIR /mast3r/dust3r
RUN pip install --break-system-packages -r requirements.txt
RUN pip install --break-system-packages -r requirements_optional.txt
RUN pip install --break-system-packages opencv-python==4.8.0.74

WORKDIR /mast3r/dust3r/croco/models/curope/
RUN python setup.py build_ext --inplace

WORKDIR /mast3r
RUN pip install --break-system-packages -r requirements.txt

#COPY entrypoint.sh docker/files/entrypoint.sh
RUN chmod +x ./docker/files/entrypoint.sh

ENTRYPOINT ["./docker/files/entrypoint.sh"]

