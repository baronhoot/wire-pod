FROM nvidia/cuda:12.9.1-devel-ubuntu22.04

# Set environment variables for CUDA
ENV CUDA_HOME=/usr/local/cuda
ENV PATH=${CUDA_HOME}/bin:${PATH}
ENV LD_LIBRARY_PATH=${CUDA_HOME}/lib64:${LD_LIBRARY_PATH}

# Install system dependencies
RUN apt-get update && apt-get install -y \
    wget \
    openssl \
    net-tools \
    libsox-dev \
    libopus-dev \
    make \
    iproute2 \
    xz-utils \
    libopusfile-dev \
    pkg-config \
    gcc \
    curl \
    g++ \
    unzip \
    avahi-daemon \
    avahi-autoipd \
    git \
    libasound2-dev \
    libsodium-dev \
    cmake \
    dos2unix \
    && rm -rf /var/lib/apt/lists/*

# Copy the wire-pod source
COPY . .

# Set permissions and convert line endings
RUN chmod +x /setup.sh && dos2unix /setup.sh

# Set environment variable to use whisper instead of vosk
ENV STT=whisper

# Set default whisper model
ENV WHISPER_MODEL=tiny

# Run setup with whisper STT service
RUN ["/bin/sh", "-c", "STT=whisper ./setup.sh"]

# Set permissions for start script
RUN chmod +x /chipper/start.sh && dos2unix /chipper/start.sh

# Expose necessary ports
EXPOSE 8080 8081 8082

# Start the service
CMD ["/bin/sh", "-c", "./chipper/start.sh"]
