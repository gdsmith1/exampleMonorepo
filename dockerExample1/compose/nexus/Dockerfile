# Nexus OSS Server
# To run: docker build -t example2 . && docker run -p 8081:8081 example2
# Use docker exec to enter container and grab the initial password
FROM debian:11.9-slim
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y openjdk-11-jdk wget
RUN wget https://download.sonatype.com/nexus/3/nexus-3.69.0-02-java11-unix.tar.gz
RUN tar -xvf nexus-3.69.0-02-java11-unix.tar.gz
EXPOSE 8081



ENTRYPOINT ["./nexus-3.69.0-02/bin/nexus", "run"]