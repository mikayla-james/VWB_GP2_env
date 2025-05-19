# Use a base image with necessary tools pre-installed
FROM ubuntu:latest
 
# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PLINK1_URL=https://s3.amazonaws.com/plink1-assets/plink_linux_x86_64_20241022.zip
ENV PLINK2_URL=https://s3.amazonaws.com/plink2-assets/alpha6/plink2_linux_x86_64_20241114.zip
ENV PLINK1_INSTALL_DIR=/opt/plink1
ENV PLINK2_INSTALL_DIR=/opt/plink2
 
# Install necessary dependencies
RUN apt-get update && \
    apt-get install -y curl unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
 
# Install PLINK1
RUN mkdir -p ${PLINK1_INSTALL_DIR} && \
    curl -L ${PLINK1_URL} -o plink1.zip && \
    unzip plink1.zip -d ${PLINK1_INSTALL_DIR} && \
    rm plink1.zip
 
# Install PLINK2
RUN mkdir -p ${PLINK2_INSTALL_DIR} && \
    curl -L ${PLINK2_URL} -o plink2.zip && \
    unzip plink2.zip -d ${PLINK2_INSTALL_DIR} && \
    rm plink2.zip
 
# install genotools
pip install the-real-genotools
 
# Update PATH environment variable
ENV PATH="${PLINK1_INSTALL_DIR}:${PLINK2_INSTALL_DIR}:${PATH}"
 
# Set default command
CMD ["bash"]
 
wb gcloud artifacts repositories create c --repository-format=docker \
--location=us-central1
 
wb gcloud artifacts repositories list
 
wb gcloud builds submit \
    --timeout 2h --region=us-central1 \
    --gcs-source-staging-dir \${WORKBENCH_ws_files}/cloudbuild_source \
    --gcs-log-dir \${WORKBENCH_ws_files}/cloudbuild_logs \
    --tag us-central1-docker.pkg.dev/\$GOOGLE_CLOUD_PROJECT/atypical/test1:`date +'%Y%m%d'`