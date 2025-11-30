# ## Stage 1: Basis-Image mit CUDA 11.8
# Wir verwenden das offizielle NVIDIA-Image als Grundlage.
FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04

# ## Metadaten für das Image
LABEL maintainer="your-email@example.com"
LABEL description="PyTorch (CUDA 11.8) with Pointnet2.ScanNet repo and ScanNet data."

# ## Umgebungsvariablen setzen
ENV DEBIAN_FRONTEND=noninteractive

# ## Systemabhängigkeiten, Python, Git und Unzip installieren
# Wir fügen 'unzip' hinzu, um .zip-Dateien entpacken zu können.
RUN apt-get update && \
    apt-get install -y python3 python3-pip python3-dev git unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# ## Pip aktualisieren und gdown installieren
# gdown wird benötigt, um Dateien direkt von Google Drive herunterzuladen.
RUN pip3 install --no-cache-dir --upgrade pip setuptools wheel && \
    pip3 install --no-cache-dir gdown

# ## PyTorch, Torchvision und Torchaudio installieren (passend zur CUDA-Version 11.8)
RUN pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118

# ## Arbeitsverzeichnis erstellen und das neue Repository klonen
WORKDIR /workspace
RUN git clone https://github.com/daveredrum/Pointnet2.ScanNet.git .

# ## Daten von Google Drive herunterladen und entpacken
# Der Befehl lädt die Datei herunter, entpackt sie und löscht anschließend die .zip-Datei.
RUN gdown 'https://drive.google.com/uc?id=1twJmV1QuAZ2GHfp8Ae7HyJkKvWbWPK5l' && \
    unzip *.zip && \
    rm *.zip

# ## PointNet2-Module kompilieren und installieren
# Dieser Schritt ist notwendig, um die benutzerdefinierten CUDA-Operationen zu bauen.
RUN cd pointnet2 && python3 setup.py install

# ## Standardbefehl
# Startet eine interaktive Bash-Shell, damit Sie direkt mit dem geklonten Code arbeiten können.
CMD ["bash"]
