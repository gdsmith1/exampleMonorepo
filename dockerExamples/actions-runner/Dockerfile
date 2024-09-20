# Assumes an actionsrunner is already downloaded and unzipped to ./actions-runner, with a custom token being put in this file.  Installs go and go-releaser for go projects
# Use the official Ubuntu image as the base image
FROM ubuntu:20.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

# Install dependencies
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y golang \
    curl \
    git \
    jq \
    vim \
    iputils-ping \
    libicu66 \
    libkrb5-3 \
    libssl1.1 \
    libunwind8 \
    netcat \
    wget \
    unzip \
    make && \
    rm -rf /var/lib/apt/lists/*

# Install goreleaser
RUN curl -sL https://github.com/goreleaser/goreleaser/releases/download/v1.10.3/goreleaser_Linux_arm64.tar.gz | tar -xz -C /usr/local/bin

# Create a user for the runner
RUN useradd -m runner

# Set the working directory
WORKDIR /home/runner

# Copy the pre-installed GitHub Actions runner from your machine
COPY actions-runner /home/runner

# Make the entrypoint script executable
RUN chmod +x /home/runner/run.sh
RUN chmod +x /home/runner/config.sh

# Switch to the runner user
USER runner

RUN ./config.sh --url https://github.com/gdsmith1/kubernetes --token CUSTOM-TOKEN-HERE --replace --unattended --name go-runner1

# Set the entrypoint
ENTRYPOINT ["/home/runner/run.sh"]
