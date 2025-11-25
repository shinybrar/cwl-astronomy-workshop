# SKA CWL Workshop - Astronomy Tools Docker Image
# Base image for all workshop exercises

FROM ubuntu:22.04

LABEL maintainer="SKA Observatory"
LABEL description="Astronomy tools for CWL workshop exercises"
LABEL version="1.0"

# Prevent interactive prompts during build
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python3-dev \
    build-essential \
    wget \
    curl \
    git \
    vim \
    && rm -rf /var/lib/apt/lists/*

# Install Python packages for astronomy
RUN pip3 install --no-cache-dir \
    astropy>=5.0 \
    numpy>=1.21 \
    scipy>=1.7 \
    matplotlib>=3.5 \
    pandas>=1.3 \
    cwltool>=3.1 \
    pyyaml>=6.0 \
    jsonschema>=4.0 \
    pillow>=9.0

# Install additional astronomy packages
RUN pip3 install --no-cache-dir \
    reproject \
    photutils \
    spectral-cube \
    astroquery

# Create non-root user for running tools
RUN useradd -m -s /bin/bash cwluser
USER cwluser
WORKDIR /home/cwluser

# Set up environment
ENV PATH="/home/cwluser/.local/bin:${PATH}"
ENV PYTHONUNBUFFERED=1

# Default command
CMD ["/bin/bash"]
