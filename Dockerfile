ARG BUILDKIT_SBOM_SCAN_CONTEXT=true
ARG BUILDKIT_SBOM_SCAN_STAGE=true

# Use an official CUDA runtime with Ubuntu as a parent image
ARG BASE_IMAGE
FROM docker.io/nvidia/cuda:${BASE_IMAGE} as build-000

ARG GIT_REPO=https://github.com/theroyallab/tabbyAPI
ARG DO_PULL=true
ENV DO_PULL $DO_PULL

# Set the working directory in the container
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    ca-certificates \
    python3.11 \
    python3-pip \
    git \
    ssh \
    7zip \
    iputils-ping \
    git-lfs \
    less \
    nano \
    neovim \
    net-tools \
    nvi \
    nvtop \
    rsync \
    tldr \
    tmux \
    unzip \
    vim \
    wget \
    zip \
    zsh \
    && rm -rf /etc/ssh/ssh_host_*

# Set locale
RUN apt-get install -y locales && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

# Upgrade
RUN apt-get upgrade -y

# Install dumb-init
RUN apt-get install -y dumb-init

# Change global Python
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1 \
    && apt-get install -y --no-install-recommends python-is-python3 \
    && rm -rf /var/lib/apt/lists/* 

# Upgrade pip
RUN pip install --no-cache-dir --upgrade pip

# Set up git to support LFS, and to cache credentials; useful for Huggingface Hub
RUN git config --global credential.helper cache && \
    git lfs install

# Update repo
RUN if [ ${DO_PULL} ]; then \
    git init && \
    git remote add origin $GIT_REPO && \
    git fetch origin && \
    git pull origin main && \
    echo "Pull finished"; fi

# Install packages specified in pyproject.toml cu121
RUN pip install --no-cache-dir .[cu121]

# Create a config.yml
RUN cp -av config_sample.yml config.yml

# Make port 5000 and 22 available to the world outside this container
EXPOSE 5000 22

# Install Huggingface tools
RUN pip install --no-cache-dir hf_transfer huggingface-hub[cli]

# RunPod specific settings
WORKDIR /
COPY --chmod=755 runpod.sh /runpod.sh
COPY --chmod=755 restart.sh /app/restart.sh

# Make tabbyAPI available for Cloudflare access
# FIXME: Get rid of sed, use something else.

# RUN apt-get update && apt-get install -y yp
# RUN yp set /app/config.yml host 0.0.0.0

# RUN apt-get update && apt-get install -y yq
# RUN yq e '.host = "0.0.0.0"' -i /app/config.yml

# RUN docker run --rm -v $(pwd)/config.yml:/app/config.yml ubuntu:yq yq e '.host = "0.0.0.0"' -i /app/config.yml

# RUN python -c "import yaml; with open('/app/config.yml', 'r') as f: config = yaml.safe_load(f); config['host'] = '0.0.0.0'; with open('/app/config.yml', 'w') as f: yaml.safe_dump(config, f, default_flow_style=False)"
RUN sed -i 's|^  host: 127.0.0.1$|  host: 0.0.0.0|g' /app/config.yml

# Set the entry point
ENTRYPOINT ["/usr/bin/dumb-init", "--"]

# Run when the container launches
CMD ["bash", "-c", "/runpod.sh"]
