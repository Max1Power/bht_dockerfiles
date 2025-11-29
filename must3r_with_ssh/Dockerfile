FROM nvidia/cuda:12.9.1-cudnn-devel-ubuntu24.04

LABEL description="Docker container for MUSt3R with dependencies installed. CUDA VERSION"
ENV DEVICE="cuda"
ENV MODEL="MUSt3R_512.pth"
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
    wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# --- HINZUGEFÜGT: SSH-Server Konfiguration ---
# 1. Notwendige Verzeichnisse erstellen und Konfiguration anpassen
RUN mkdir /var/run/sshd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    mkdir -p /root/.ssh

# 2. SSH-Schlüssel des Benutzers kopieren
#    WICHTIG: Stellen Sie sicher, dass sich eine Datei namens 'id_rsa.pub' im selben Verzeichnis wie dieses Dockerfile befindet.
COPY id_rsa.pub /root/.ssh/authorized_keys

# 3. Korrekte Berechtigungen für das SSH-Verzeichnis und die Schlüsseldatei setzen
RUN chmod 700 /root/.ssh && \
    chmod 600 /root/.ssh/authorized_keys
# --- ENDE: SSH-Server Konfiguration ---

# Python-Pakete installieren und Repository klonen
RUN pip install --break-system-packages must3r@git+https://github.com/naver/must3r.git && \
    git clone --recursive https://github.com/naver/must3r.git /must3r

# Das Arbeitsverzeichnis auf das 'demo' Verzeichnis setzen
WORKDIR /must3r/must3r/demo

# 'max_bs' in der Gradio-Demo anpassen
#RUN sed -i 's/inputs=\[inputfiles, max_bs, num_refinements_iterations/inputs=\[inputfiles, 1, num_refinements_iterations/' gradio.py

# Weitere Abhängigkeiten installieren
WORKDIR /must3r/dust3r
RUN pip install --break-system-packages -r requirements.txt \
&& pip install --break-system-packages -r requirements_optional.txt \
&& pip install --break-system-packages opencv-python==4.8.0.74

WORKDIR /must3r/dust3r/croco/models/curope/
RUN python setup.py build_ext --inplace

WORKDIR /must3r
# Anforderungen installieren und numpy-Version erzwingen
RUN pip install --break-system-packages -r requirements.txt && \
    pip install --break-system-packages numpy==1.26.4 --force-reinstall

# PyTorch für CUDA 12.x neu installieren
RUN pip uninstall -y --break-system-packages torch torchvision torchaudio && \
    pip install --break-system-packages --upgrade torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/cu129

# Checkpoints herunterladen
RUN mkdir -p checkpoints && \
    wget https://download.europe.naverlabs.com/ComputerVision/MUSt3R/MUSt3R_512.pth \
         -O checkpoints/MUSt3R_512.pth && \
    wget https://download.europe.naverlabs.com/ComputerVision/MUSt3R/MUSt3R_512_retrieval_trainingfree.pth \
         -O checkpoints/MUSt3R_512_retrieval_trainingfree.pth

# --- HINZUGEFÜGT: SSH-Port freigeben und Server starten ---
# Standard-SSH-Port 22 freigeben
EXPOSE 22

# SSH-Server im Vordergrund starten, damit der Container aktiv bleibt
CMD ["/usr/sbin/sshd", "-D"]
