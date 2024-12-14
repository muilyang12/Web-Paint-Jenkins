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

# Install AWS CLI V2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip" \
    && unzip /tmp/awscliv2.zip -d /tmp \
    && /tmp/aws/install \
    && rm -rf /tmp/aws /tmp/awscliv2.zip

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && chmod +x kubectl \
    && mv kubectl /usr/local/bin/

USER jenkins

RUN jenkins-plugin-cli --plugins "blueocean docker-workflow"
