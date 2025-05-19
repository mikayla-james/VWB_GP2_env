FROM ubuntu:20.04

# Environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC
ENV PLINK2_VERSION=2.3
ENV PLINK2_URL=https://s3.amazonaws.com/plink2-assets/alpha6/plink2_linux_x86_64_20241114.zip
ENV PLINK2_INSTALL_DIR=/opt/plink2
ENV PLINK1_VERSION=1.9
ENV PLINK1_URL=https://s3.amazonaws.com/plink1-assets/plink_linux_x86_64.zip
ENV PLINK1_INSTALL_DIR=/opt/plink1

# Install base dependencies
RUN apt-get update && \
    apt-get install -y \
        curl unzip git build-essential \
        autoconf automake libtool pkg-config \
        zlib1g-dev libbz2-dev libhts-dev \
        python3 python3-pip python3-dev \
        wget ca-certificates \
        cmake libboost-all-dev \
        libssl-dev libcurl4-openssl-dev \
        libncurses5-dev libncursesw5-dev \
        r-base r-base-dev libxml2-dev \
        libssl-dev libcurl4-openssl-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create installation directories
RUN mkdir -p ${PLINK2_INSTALL_DIR} ${PLINK1_INSTALL_DIR}

# Install PLINK2
WORKDIR ${PLINK2_INSTALL_DIR}
RUN curl -L ${PLINK2_URL} -o plink2.zip && \
    unzip plink2.zip && \
    rm plink2.zip

# Install PLINK1
WORKDIR ${PLINK1_INSTALL_DIR}
RUN curl -L ${PLINK1_URL} -o plink1.zip && \
    unzip plink1.zip && \
    rm plink1.zip

# Install bcftools
WORKDIR /opt
RUN git clone --recurse-submodules https://github.com/samtools/bcftools.git && \
    cd bcftools && \
    make && \
    make install

# Install vcftools
WORKDIR /opt
RUN git clone https://github.com/vcftools/vcftools.git && \
    cd vcftools && \
    ./autogen.sh && \
    ./configure && \
    make && \
    make install

# Install GenoTools
WORKDIR /opt
RUN git clone https://github.com/dvitale199/GenoTools.git && \
    cd GenoTools && \
    pip3 install .

# Install RVTests
WORKDIR /opt
RUN git clone https://github.com/zhanxw/rvtests.git && \
    cd rvtests && \
    make

# Install SAIGE (R package)
RUN Rscript -e "install.packages('remotes', repos='https://cloud.r-project.org')" && \
    Rscript -e "remotes::install_github('weizhouUMICH/SAIGE')"

# Install GenoML
RUN pip3 install genoml

# Set PATH
ENV PATH="${PLINK2_INSTALL_DIR}:${PLINK1_INSTALL_DIR}:/opt/rvtests/executables:/usr/local/bin:${PATH}"

# Default command
CMD ["bash"]