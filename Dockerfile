FROM ubuntu:16.04

LABEL maintainer Steve Belton <stbelton@microsoft.com>

# Latest versions for kubectl, helm and draft
ENV KUBE_LATEST_VERSION="v1.8.0"
ENV HELM_LATEST_VERSION="v2.6.2"
ENV DRAFT_LATEST_VERSION="v0.7.0"
ENV AZ_REPO="xenial"

RUN apt-get update && apt-get install -y curl

# Download and install kubectl
RUN curl -LO  https://storage.googleapis.com/kubernetes-release/release/${KUBE_LATEST_VERSION}/bin/linux/amd64/kubectl && chmod +x ./kubectl && mv ./kubectl /usr/local/bin/kubectl

# Download and install helm
RUN curl -LO  https://storage.googleapis.com/kubernetes-helm/helm-${HELM_LATEST_VERSION}-linux-amd64.tar.gz && tar -xvf helm-${HELM_LATEST_VERSION}-linux-amd64.tar.gz && mv linux-amd64/helm /usr/local/bin 

# Download and install draft
RUN curl -LO https://github.com/Azure/draft/releases/download/${DRAFT_LATEST_VERSION}/draft-${DRAFT_LATEST_VERSION}-linux-amd64.tar.gz && tar -xvf draft-${DRAFT_LATEST_VERSION}-linux-amd64.tar.gz && mv linux-amd64/draft /usr/local/bin 

# Download and install GIT plus some Draft samples
RUN apt-get -y install git && git clone https://github.com/Azure/draft.git

# Download and install AZ CLI
RUN echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ ${AZ_REPO} main" | tee /etc/apt/sources.list.d/azure-cli.list
RUN apt-key adv --keyserver packages.microsoft.com --recv-keys 52E16F86FEE04B979B07E28DB02C46DF417A0893
RUN curl -L https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN apt-get -y install apt-transport-https && apt-get update && apt-get -y install azure-cli && apt-get -y install nano

RUN az aks install-cli

# Download the required K8S YAML files
RUN git clone https://github.com/stevebelton/k8s-yaml.git

# Expose port for kubectl proxy
EXPOSE 8080

ENTRYPOINT ["bash"]
