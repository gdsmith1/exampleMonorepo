#Why isn’t this possible?
#Alpine is based around libc, unlike the supported versions of linux for runners, which run glibc
#Compatability libraries dont seem to have all of the characters needed
FROM arm64v8/alpine:3.20.0
RUN apk update && apk upgrade &&  adduser -D GHA

#Install dependencies for Github Actions Runner
RUN apk add curl jq bash --no-cache


RUN curl -Lo glibc.apk "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.34-r0/glibc-2.34-r0.apk" \
    && apk add --allow-untrusted --force-overwrite glibc.apk



# Install latest Github Actions Runner
RUN cd /home/GHA && mkdir actions-runner && cd actions-runner \
    && curl -o actions-runner-linux-arm64-2.317.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.317.0/actions-runner-linux-arm64-2.317.0.tar.gz \
    && tar xzf ./actions-runner-linux-arm64-2.317.0.tar.gz

# Install .NET SDK and dependencies
RUN apk add icu-libs libstdc++ libgcc ca-certificates-bundle libssl3 zlib libgdiplus lttng-ust openssl krb5 zlib icu --no-cache

# Install compatability libraries for glibc
RUN apk add --no-cache libc6-compat gcompat
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false


RUN wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh \
    && chmod +x ./dotnet-install.sh \
    && ./dotnet-install.sh --channel 6.0
    


# Install dependencies for Github Actions Runner
#RUN ./home/GHA/actions-runner/bin/installdependencies.sh

# Copy the actionrunner.sh script to the container
COPY actionrunner.sh home/GHA/actionrunner.sh
RUN chmod +x home/GHA/actionrunner.sh

# Change the owner of the actions-runner directory to GHA
RUN chown -R GHA:GHA /home/GHA/actions-runner

# Set the user to GHA and run the actionrunner.sh script
USER GHA
ENTRYPOINT ["./home/GHA/actionrunner.sh"]
