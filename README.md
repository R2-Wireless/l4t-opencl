# [l4t-opencl](https://hub.docker.com/r/unimonkiez/l4t-opencl)
## Usage
- Check if image works and detects both CPU and GPU as OpenCL devices
  ```bash
  docker run --rm -it --entrypoint clinfo --gpus all unimonkiez/l4t-opencl:r32.7.1
  ```
## Push
- Build
  ```bash
  docker build -t unimonkiez/l4t-opencl:r32.7.1 .
  ```
- Push
  ```bash
  docker push unimonkiez/l4t-opencl:r32.7.1
  ```