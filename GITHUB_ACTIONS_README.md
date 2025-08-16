# GitHub Actions for Wire-Pod Docker Images

This repository includes GitHub Actions workflows that automatically build and publish Docker images for wire-pod with OpenAI Whisper support.

## Workflows Overview

### 1. **Docker Build and Publish** (`.github/workflows/docker-publish.yml`)
- **Purpose**: Builds and publishes production Docker images
- **Triggers**: 
  - Daily at 22:25 UTC (automated)
  - Push to `main` branch
  - Git tags (v*.*.*)
  - Manual workflow dispatch
- **Output**: Published images to GitHub Container Registry (ghcr.io)

### 2. **Docker Test Build** (`.github/workflows/docker-test.yml`)
- **Purpose**: Tests Docker builds without publishing
- **Triggers**:
  - Pull requests to `main` branch
  - Push to development branches (`dev`, `develop`, `feature/*`, `hotfix/*`)
  - Manual workflow dispatch
- **Output**: Build verification and testing

## How It Works

### Automatic Image Publishing
1. **Daily Builds**: Every day at 22:25 UTC, the workflow automatically builds and publishes the latest image
2. **Release Tags**: When you create a git tag (e.g., `v1.2.3`), it automatically publishes a release image
3. **Main Branch**: Every push to the `main` branch triggers a new image build

### Image Naming Convention
Images are published to: `ghcr.io/YOUR_USERNAME/wire-pod:tag`

- **Latest**: `ghcr.io/YOUR_USERNAME/wire-pod:main`
- **Releases**: `ghcr.io/YOUR_USERNAME/wire-pod:v1.2.3`
- **Specific commits**: `ghcr.io/YOUR_USERNAME/wire-pod:sha-abc123`

## Using the Published Images

### Pull and Run
```bash
# Pull the latest image
docker pull ghcr.io/YOUR_USERNAME/wire-pod:main

# Run with NVIDIA runtime (for CUDA support)
docker run --rm --gpus all \
  -p 8080:8080 \
  -p 443:443 \
  -p 80:80 \
  -p 8084:8084 \
  ghcr.io/YOUR_USERNAME/wire-pod:main
```

### Use in docker-compose
```yaml
services:
  wire-pod:
    image: ghcr.io/YOUR_USERNAME/wire-pod:main
    runtime: nvidia
    environment:
      - NVIDIA_VISIBLE_DEVICES=all
    ports:
      - "8080:8080"
      - "443:443"
      - "80:80"
      - "8084:8084"
```

## Configuration Options

### Environment Variables
The workflows use these environment variables that you can customize:

```yaml
env:
  WHISPER_MODEL: tiny  # Options: tiny, base, small, medium, large-v3, large-v3-q5_0
```

### Build Arguments
The Docker build process accepts these build arguments:

```bash
# Build with custom Whisper model
docker build --build-arg WHISPER_MODEL=base .

# Build with custom STT service
docker build --build-arg STT=whisper .
```

## Customization

### Change Whisper Model
To use a different default Whisper model, edit the workflow file:

```yaml
# In .github/workflows/docker-publish.yml
env:
  WHISPER_MODEL: base  # Change from 'tiny' to your preferred model
```

### Add Custom Build Arguments
To pass additional build arguments, modify the build step:

```yaml
- name: Build and push Docker image
  uses: docker/build-push-action@v5
  with:
    build-args: |
      WHISPER_MODEL=${{ env.WHISPER_MODEL }}
      CUSTOM_ARG=value
      ANOTHER_ARG=value
```

### Modify Build Platforms
The workflows build for multiple platforms by default:

```yaml
platforms: linux/amd64,linux/arm64
```

You can modify this to support additional architectures or remove unsupported ones.

## Security Features

### Image Signing
All published images are automatically signed using Cosign and the Sigstore transparency log:

```bash
# Verify image signature
cosign verify ghcr.io/YOUR_USERNAME/wire-pod:main

# Check transparency log
cosign verify --rekor-url https://rekor.sigstore.dev ghcr.io/YOUR_USERNAME/wire-pod:main
```

### Permissions
The workflows use minimal required permissions:
- `contents: read` - Read repository content
- `packages: write` - Publish packages (only for main branch)
- `id-token: write` - Sign images with Sigstore

## Monitoring and Debugging

### Workflow Status
- Check workflow status in the "Actions" tab of your repository
- View detailed logs for each step
- Monitor build times and success rates

### Build Cache
The workflows use GitHub Actions cache for faster builds:
- Docker layer caching
- BuildKit cache
- Cross-platform build optimization

### Troubleshooting
Common issues and solutions:

1. **Build Failures**:
   - Check workflow logs for specific error messages
   - Verify Dockerfile syntax
   - Ensure all dependencies are available

2. **Permission Issues**:
   - Verify repository has Actions enabled
   - Check package permissions in repository settings
   - Ensure GITHUB_TOKEN has required permissions

3. **Image Publishing Issues**:
   - Verify workflow triggered on correct events
   - Check package registry permissions
   - Ensure repository is not private (for transparency logs)

## Best Practices

### 1. **Branch Strategy**
- Use `main` branch for production releases
- Use feature branches for development
- Tag releases with semantic versioning (v1.2.3)

### 2. **Image Management**
- Regularly clean up old images
- Monitor image sizes and build times
- Use specific tags for production deployments

### 3. **Security**
- Keep base images updated
- Review workflow permissions regularly
- Monitor for security vulnerabilities

### 4. **Performance**
- Use appropriate Whisper models for your use case
- Leverage build caching
- Consider multi-stage builds for optimization

## Integration with Other Tools

### Docker Hub
To also publish to Docker Hub, add a second workflow or modify the existing one:

```yaml
- name: Log into Docker Hub
  uses: docker/login-action@v3
  with:
    username: ${{ secrets.DOCKERHUB_USERNAME }}
    password: ${{ secrets.DOCKERHUB_TOKEN }}
```

### Kubernetes
Use the published images in Kubernetes deployments:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: wire-pod
spec:
  template:
    spec:
      containers:
      - name: wire-pod
        image: ghcr.io/YOUR_USERNAME/wire-pod:main
        ports:
        - containerPort: 8080
```

## Support and Contributing

### Issues
- Report workflow issues in the repository issues
- Include workflow run logs and error messages
- Specify your environment and requirements

### Contributions
- Fork the repository
- Create feature branches for changes
- Submit pull requests with detailed descriptions
- Ensure workflows pass before submitting

### Resources
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Docker Build Action](https://github.com/docker/build-push-action)
- [Sigstore/Cosign](https://docs.sigstore.dev/)
- [GitHub Container Registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry)
