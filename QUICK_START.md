# Quick Start Guide - Wire-Pod with Whisper

This fork of wire-pod enables OpenAI Whisper speech-to-text by default and includes CUDA support for GPU acceleration.

## 🚀 Get Started in 3 Steps

### 1. **Fork and Clone**
```bash
# Fork this repository on GitHub, then clone your fork
git clone https://github.com/YOUR_USERNAME/wire-pod.git
cd wire-pod
```

### 2. **Build and Run with Docker**
```bash
# Build the Docker image
./build-docker.sh

# Run the container
docker-compose up -d

# Check logs
docker-compose logs -f wire-pod
```

### 3. **Access the Web Interface**
- **Main Interface**: http://localhost:8080
- **HTTPS**: https://localhost:443
- **HTTP**: http://localhost:80

## 🔧 What's Different from Original

| Feature | Original | This Fork |
|---------|----------|-----------|
| **STT Service** | VOSK (default) | OpenAI Whisper (default) |
| **GPU Support** | None | CUDA 11.8 + GPU acceleration |
| **Base Image** | Ubuntu | NVIDIA CUDA Ubuntu |
| **Model** | VOSK models | Whisper models (tiny/base/small/medium/large) |
| **Performance** | CPU only | CPU + GPU acceleration |

## 🐳 Docker Images

### Automatic Publishing
- **GitHub Actions** automatically build and publish images
- **Daily builds** at 22:25 UTC
- **Release tags** (v1.0.0) trigger new images
- **Multi-platform** (linux/amd64, linux/arm64)

### Pull Pre-built Images
```bash
# Latest development version
docker pull ghcr.io/YOUR_USERNAME/wire-pod:main

# Specific release (when you create tags)
docker pull ghcr.io/YOUR_USERNAME/wire-pod:v1.0.0
```

## 🎯 Use Cases

### **Development & Testing**
- CPU-only Whisper (works everywhere)
- Fast iteration and testing
- No GPU requirements

### **Production Deployment**
- GPU acceleration with CUDA
- Better transcription performance
- Support for larger Whisper models

### **Edge Devices**
- ARM64 support (Raspberry Pi, ARM servers)
- Optimized for resource-constrained environments

## 📊 Performance Comparison

| Model | Size | Speed | Accuracy | Use Case |
|-------|------|-------|----------|----------|
| **tiny** | ~39MB | ⚡⚡⚡ | ⭐⭐ | Development, testing |
| **base** | ~74MB | ⚡⚡ | ⭐⭐⭐ | Balanced production |
| **small** | ~244MB | ⚡ | ⭐⭐⭐⭐ | High accuracy needed |
| **medium** | ~769MB | 🐌 | ⭐⭐⭐⭐⭐ | Best accuracy |

## 🛠️ Customization

### Change Whisper Model
```bash
# Build with different model
docker build --build-arg WHISPER_MODEL=base .

# Or modify Dockerfile
ENV WHISPER_MODEL=base
```

### Environment Variables
```bash
# In docker-compose.yml
environment:
  - WHISPER_MODEL=base
  - STT_SERVICE=whisper.cpp
```

## 🔍 Troubleshooting

### Common Issues

**Build Fails**
```bash
# Check Docker is running
docker info

# Verify sufficient disk space
df -h

# Check build logs
docker-compose build --no-cache
```

**CUDA Not Working**
```bash
# Verify NVIDIA drivers
nvidia-smi

# Check NVIDIA Container Toolkit
docker run --rm --gpus all nvidia/cuda:11.8-base-ubuntu22.04 nvidia-smi
```

**Port Already in Use**
```bash
# Check what's using the ports
sudo netstat -tulpn | grep :8080

# Use different ports in docker-compose.yml
ports:
  - "8081:8080"  # Map host port 8081 to container port 8080
```

## 📚 Documentation

- **[Docker Setup](DOCKER_README.md)** - Detailed Docker configuration
- **[GitHub Actions](GITHUB_ACTIONS_README.md)** - CI/CD workflows
- **[Original Wire-Pod](https://github.com/kercre123/wire-pod)** - Base project

## 🤝 Contributing

1. **Fork** this repository
2. **Create** a feature branch
3. **Make** your changes
4. **Test** with Docker
5. **Submit** a pull request

## 📞 Support

- **Issues**: Create GitHub issues for bugs/problems
- **Discussions**: Use GitHub Discussions for questions
- **Wiki**: Check the repository wiki for additional info

## 🎉 What's Next?

- **Try different Whisper models** for your use case
- **Experiment with CUDA acceleration** on supported hardware
- **Customize the setup** for your specific needs
- **Contribute improvements** back to the community

---

**Happy coding! 🚀**
