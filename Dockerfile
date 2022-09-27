FROM jenkins/jenkins:2.332.3-lts
USER root

# Pipeline
RUN /usr/local/bin/install-plugins.sh workflow-aggregator && \
    /usr/local/bin/install-plugins.sh github && \
    /usr/local/bin/install-plugins.sh ws-cleanup && \
    /usr/local/bin/install-plugins.sh greenballs && \
    /usr/local/bin/install-plugins.sh simple-theme-plugin && \
    /usr/local/bin/install-plugins.sh kubernetes && \
    /usr/local/bin/install-plugins.sh docker-workflow && \
    /usr/local/bin/install-plugins.sh kubernetes-cli && \
    /usr/local/bin/install-plugins.sh github-branch-source

# install Maven, Java, AWS
RUN apt-get update &&  apt-get install -y \
    maven \
    openjdk-11-jdk \
    gettext \
    wget

# Kubectl
RUN wget https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && chmod +x ./kubectl && mv ./kubectl /usr/local/bin/kubectl

# Docker
RUN apt-get update && \
    apt-get -y install apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common && \
    curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
    add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
    $(lsb_release -cs) \
    stable" && \
    apt-get update && \
    apt-get -y install docker-ce

# Need to ensure the gid here matches the gid on the host node. We ASSUME (hah!) this
# will be stable....keep an eye out for unable to connect to docker.sock in the builds
# RUN delgroup ping && delgroup docker && addgroup -g 999 docker && addgroup jenkins docker

# See https://github.com/kubernetes/minikube/issues/956.
# THIS IS FOR MINIKUBE TESTING ONLY - it is not production standard (we're running as root!)
RUN chown -R root "$JENKINS_HOME" /usr/share/jenkins/ref