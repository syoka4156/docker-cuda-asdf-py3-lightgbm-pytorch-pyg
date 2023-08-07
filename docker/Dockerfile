FROM nvidia/cuda:11.7.1-cudnn8-runtime-ubuntu20.04
WORKDIR /root
ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y \
    sudo \
    build-essential \
    tzdata \
    git \
    vim \
    nano \
    wget \
    zsh \
    curl \
    libbz2-dev \
    libffi-dev \
    liblzma-dev \
    libncursesw5-dev \
    libreadline-dev \
    libsqlite3-dev \
    libssl-dev \
    libxml2-dev \
    libxmlsec1-dev \
    llvm \
    make \
    tk-dev \
    xz-utils \
    zlib1g-dev \
    && apt-get install -y --no-install-recommends \
    libglib2.0-0 \
    libxext6 \
    libsm6 \
    libxrender1 \
    mercurial \
    subversion \
    cmake \
    libboost-dev \
    libboost-system-dev \
    libboost-filesystem-dev \
    gcc \
    g++ \
    ocl-icd-opencl-dev \
    && apt-get upgrade -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Add asdf install
SHELL ["/bin/bash", "-c"]
RUN git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.11.3
RUN echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.bashrc \
&& echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.bashrc 
ENV PATH="/root/.asdf/shims:/root/.asdf/bin:${PATH}"

COPY requirements.txt /root/ws/

# Python
RUN source ~/.bashrc \
&& asdf plugin add python \
&& asdf install python 3.10.0 \
&& asdf global python 3.10.0 \
&& pip install -U pip \
&& pip install --no-cache-dir torch==1.13.1+cu117 torchvision==0.14.1+cu117 --extra-index-url https://download.pytorch.org/whl/cu117 \
&& pip install --no-cache-dir torch_geometric \
&& pip install --no-cache-dir pyg_lib torch_scatter torch_sparse torch_cluster torch_spline_conv -f https://data.pyg.org/whl/torch-1.13.0+cu117.html \
&& pip install --no-cache-dir -r ./ws/requirements.txt

# LightGBM for GPU
RUN mkdir -p /etc/OpenCL/vendors && \
    echo "libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia.icd
RUN cd /usr/local/src && mkdir lightgbm && cd lightgbm && \
    git clone --recursive --branch stable --depth 1 https://github.com/microsoft/LightGBM && \
    cd LightGBM && mkdir build && cd build && \
    cmake -DUSE_GPU=1 -DOpenCL_LIBRARY=/usr/local/cuda/lib64/libOpenCL.so.1 -DOpenCL_INCLUDE_DIR=/usr/local/cuda/include/ .. && \
    make OPENCL_HEADERS=/usr/local/cuda-11.7/targets/x86_64-linux/include LIBOPENCL=/usr/local/cuda-11.7/targets/x86_64-linux/lib
ENV PATH /usr/local/src/lightgbm/LightGBM:${PATH}
RUN /bin/bash -c "cd /usr/local/src/lightgbm/LightGBM && sh ./build-python.sh install --precompile"

CMD ["/bin/bash"]

# Reference
# https://zenn.dev/fastsnowy/articles/adc106a4a03dc1
# https://pytorch-geometric.readthedocs.io/en/latest/notes/installation.html
# https://nykergoto.hatenablog.jp/entry/2020/07/25/%E6%A9%9F%E6%A2%B0%E5%AD%A6%E7%BF%92%E3%81%AAdockerfile%E3%82%92%E6%9B%B8%E3%81%8F%E3%81%A8%E3%81%8D%E3%81%AB%E6%B0%97%E3%82%92%E3%81%A4%E3%81%91%E3%81%A8%E3%81%8F%E3%81%A8%E8%89%AF%E3%81%84%E3%81%93
# https://github.com/microsoft/LightGBM/blob/master/docker/gpu/dockerfile.gpu