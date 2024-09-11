FROM ubuntu:20.04
RUN apt-get update && apt-get upgrade -y && apt-get install -y curl jq

# Create new user and install latest Github Actions Runner
RUN adduser --disabled-password --home /home/gha --gecos '' gha\
    && cd /home/gha && mkdir actions-runner && cd actions-runner \
    && curl -o actions-runner-linux-arm64-2.317.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.317.0/actions-runner-linux-arm64-2.317.0.tar.gz \
    && tar xzf ./actions-runner-linux-arm64-2.317.0.tar.gz \
    && rm actions-runner-linux-arm64-2.317.0.tar.gz

# Install missing dependencies
RUN ./home/gha/actions-runner/bin/installdependencies.sh

# Copy the actionrunner.sh script to the container
COPY actionrunner.sh /home/gha/actionrunner.sh


# Change the owner of the actions-runner directory to gha
RUN chmod +x /home/gha/actionrunner.sh \
    && chown -R gha:gha /home/gha/actions-runner


# Set the user to gha and run the actionrunner.sh script
USER gha
ENTRYPOINT ["./home/gha/actionrunner.sh"]
