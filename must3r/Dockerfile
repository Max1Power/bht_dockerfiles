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

#RUN pip install --break-system-packages -U xformers --index-url https://download.pytorch.org/whl/nightly/cu129
RUN pip install --break-system-packages must3r@git+https://github.com/naver/must3r.git
RUN git clone --recursive https://github.com/naver/must3r.git /must3r

RUN sed -i "s/demo.launch(share=False, server_name=server_name, server_port=server_port)/demo.launch(share=False, server_name='0.0.0.0', server_port=7860)/g" must3r/must3r/demo/gradio.py


# Das Arbeitsverzeichnis auf das 'demo' Verzeichnis setzen, um den Pfad für 'gradio.py' zu vereinfachen.
WORKDIR /must3r/must3r/demo

# Den 'sed' Befehl im neuen Arbeitsverzeichnis ausführen.
# Hier wird 'max_bs' durch '1' ersetzt.
#RUN sed -i 's/inputs=\[inputfiles, max_bs, num_refinements_iterations/inputs=\[inputfiles, 1, num_refinements_iterations/' gradio.py


WORKDIR /must3r/dust3r
RUN pip install --break-system-packages -r requirements.txt \
&& pip install --break-system-packages -r requirements_optional.txt \
&& pip install --break-system-packages opencv-python==4.8.0.74

WORKDIR /must3r/dust3r/croco/models/curope/
RUN python setup.py build_ext --inplace

WORKDIR /must3r
RUN pip install --break-system-packages -r requirements.txt 
RUN pip install --break-system-packages numpy==1.26.4 --force-reinstall

RUN pip uninstall -y --break-system-packages torch torchvision torchaudio
RUN pip install --break-system-packages --upgrade torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/cu129

#WORKDIR /app
RUN mkdir -p checkpoints && \
    wget https://download.europe.naverlabs.com/ComputerVision/MUSt3R/MUSt3R_512.pth \
         -O checkpoints/MUSt3R_512.pth && \
    wget https://download.europe.naverlabs.com/ComputerVision/MUSt3R/MUSt3R_512_retrieval_trainingfree.pth \
         -O checkpoints/MUSt3R_512_retrieval_trainingfree.pth

#ENTRYPOINT ["python", "demo.py", "--weights", "checkpoints/MUSt3R_512.pth", "--device", "cuda", "--local_network"]
ENTRYPOINT ["python", "demo.py", "--weights", "checkpoints/MUSt3R_512.pth", "--retrieval", "checkpoints/MUSt3R_512_retrieval_trainingfree.pth", "--image_size", "512", "--viser"]
