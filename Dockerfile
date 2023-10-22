ARG BASE_IMAGE=nvcr.io/nvidia/l4t-base:r32.7.1

FROM ${BASE_IMAGE} as build

ARG DEBIAN_FRONTEND=noninteractive
ENV LLVM_VERSION 16
RUN apt-get update && \
    apt install -y ca-certificates wget && \
    echo "deb http://apt.llvm.org/focal/ llvm-toolchain-focal-16 main" >> /etc/apt/sources.list && \
    wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
    apt-get update && \
    apt install -y \
    python3-dev libpython3-dev build-essential ocl-icd-libopencl1 \
    cmake git pkg-config libclang-${LLVM_VERSION}-dev clang-${LLVM_VERSION} \
    llvm-${LLVM_VERSION} make ninja-build ocl-icd-libopencl1 ocl-icd-dev \
    ocl-icd-opencl-dev libhwloc-dev zlib1g zlib1g-dev clinfo dialog apt-utils \
    libxml2-dev libclang-cpp${LLVM_VERSION}-dev libclang-cpp${LLVM_VERSION} \
    llvm-${LLVM_VERSION}-dev \
    && rm -rf /var/lib/apt/lists/*
RUN cd $HOME && git clone --depth 1 --branch v4.0 https://github.com/pocl/pocl.git 
RUN mkdir $HOME/pocl/build
RUN cd $HOME/pocl/build && cmake -DCMAKE_INSTALL_PREFIX=/usr/local/pocl/ -DLLC_HOST_CPU=cortex-a57 -DENABLE_CUDA=ON ..
RUN cd $HOME/pocl/build && make
RUN cd $HOME/pocl/build && make install

RUN mkdir -p /etc/OpenCL/vendors/ && echo "/usr/local/pocl/lib/libpocl.so" > /etc/OpenCL/vendors/pocl.icd
