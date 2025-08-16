# Wire-Pod Docker Setup with OpenAI Whisper and CUDA Support

This Docker setup enables OpenAI's Whisper speech-to-text service by default and includes CUDA drivers for GPU acceleration.

## Prerequisites

### For CUDA Support (Linux):
1. Install NVIDIA drivers
2. Install NVIDIA Container Toolkit:
   ```bash
   # Ubuntu/Debian
   distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
   curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
   curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
   
   sudo apt-get update
   sudo apt-get install -y nvidia-docker2
   sudo systemctl restart docker
   ```

### For macOS:
- CUDA is not supported on macOS, but the container will still work with CPU-only Whisper
- GPU acceleration will use Metal on ARM-based Macs (M1/M2/M3)

## Building and Running

1. **Build the Docker image:**
   ```bash
   docker-compose build
   ```

2. **Run the container:**
   ```bash
   docker-compose up -d
   ```

3. **Check logs:**
   ```bash
   docker-compose logs -f wire-pod
   ```

## Configuration

The container is pre-configured with:
- **STT Service**: OpenAI Whisper (whisper.cpp)
- **Model**: tiny (fastest, recommended for most use cases)
- **CUDA Support**: Enabled when NVIDIA GPU is detected
- **Ports**: 80, 443, 8080, 8084

## Customization

### Change Whisper Model
To use a different Whisper model, modify the Dockerfile:
```dockerfile
ENV WHISPER_MODEL=base  # Options: tiny, base, small, medium, large-v3, large-v3-q5_0
```

### Environment Variables
You can override these environment variables in the compose.yaml:
- `WHISPER_MODEL`: Whisper model to use
- `STT_SERVICE`: Speech-to-text service (automatically set to whisper.cpp)

## Performance

- **CPU-only**: Suitable for development and testing
- **CUDA acceleration**: Significantly faster transcription, especially with larger models
- **Model size impact**: 
  - `tiny`: ~39MB, fastest, good accuracy
  - `base`: ~74MB, balanced speed/accuracy
  - `small`: ~244MB, better accuracy, slower
  - `medium`: ~769MB, high accuracy, slower
  - `large-v3`: ~1550MB, best accuracy, slowest

## Troubleshooting

### CUDA Issues
1. Verify NVIDIA drivers are installed: `nvidia-smi`
2. Check NVIDIA Container Toolkit: `docker run --rm --gpus all nvidia/cuda:11.8-base-ubuntu22.04 nvidia-smi`
3. Ensure Docker has access to GPU: `docker run --rm --gpus all nvidia/cuda:11.8-base-ubuntu22.04 nvidia-smi`

### Build Issues
1. Ensure sufficient disk space (whisper models can be large)
2. Check internet connection for downloading models
3. Verify Docker has sufficient memory allocation

### Runtime Issues
1. Check container logs: `docker-compose logs wire-pod`
2. Verify ports are not already in use
3. Check volume permissions

## Architecture

- **Base Image**: NVIDIA CUDA 11.8 development image
- **STT Engine**: whisper.cpp with Go bindings
- **GPU Support**: CUDA 11.8 compatible
- **OS**: Ubuntu 22.04 LTS

## Security Notes

- The container runs as root (required for audio processing)
- Exposed ports should be protected in production
- Consider using Docker secrets for sensitive configuration
