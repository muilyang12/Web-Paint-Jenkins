FROM jenkins/jenkins:2.479.2-jdk17

# Switch to the root user to install required packages
USER root

# Update package lists and install `lsb-release` to fetch OS details
RUN apt-get update && apt-get install -y lsb-release

# Download the official Docker GPG key and save it for secure package verification
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
    https://download.docker.com/linux/debian/gpg

RUN echo "deb [arch=$(dpkg --print-architecture) \
    signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
    https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

# Update package lists again and install Docker CLI
RUN apt-get update && apt-get install -y docker-ce-cli

USER jenkins

RUN jenkins-plugin-cli --plugins "blueocean docker-workflow"
