FROM ubuntu:20.04

# Set working directory
WORKDIR /scratch

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/New_York

# Install dependencies, including liblzma and other previously mentioned packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    wget \
    less \
    unzip \
    gzip \
    make \
    zstd \
    bash \
    git \
    python3 \
    python3-pip \
    python3-dev \
    samtools \
    bcftools \
    gcc \
    g++ \
    libc-dev \
    libbz2-dev \
    zlib1g-dev \
    liblzma-dev \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Download and extract BBTools
RUN wget https://sourceforge.net/projects/bbmap/files/latest/download -O bbmap.tar.gz && \
    tar -xzf bbmap.tar.gz && \
    rm bbmap.tar.gz

# Add BBTools to PATH
ENV PATH="/bbmap:${PATH}"

# Install seqtk
RUN git clone https://github.com/lh3/seqtk.git && \
    cd seqtk && \
    make && \
    mv seqtk /usr/local/bin && \
    cd .. && \
    rm -rf seqtk

# Change working directory
WORKDIR /app

# Copy the script into the container
COPY mf_amplicon_extract.sh /app/

# Add pip install pysam