# Factory CLI docker file

FROM centos:7 as first

RUN mkdir /out

RUN yum install -y unzip

# terraform
ENV TERRAFORM_VERSION 1.5.0
RUN echo using gh version ${TERRAFORM_VERSION} && \
  curl -LO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
  unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
  chmod +x terraform && \
  mv terraform /out && \
  rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# gh cli
ENV GH_VERSION 2.30.0
RUN echo using gh version ${GH_VERSION} && \
  curl -f -L https://github.com/cli/cli/releases/download/v${GH_VERSION}/gh_${GH_VERSION}_linux_amd64.tar.gz  | tar xzv && \
  mv gh_${GH_VERSION}_linux_amd64/bin/gh /out/gh  && \
  chmod +x /out/gh

# jx
ENV JX_VERSION 3.10.83
RUN echo using jx version ${JX_VERSION} && \
  mkdir -p /home/.jx3 && \
  curl -L https://github.com/jenkins-x/jx/releases/download/v${JX_VERSION}/jx-linux-amd64.tar.gz | tar xzv && \
  chmod +x jx && \
  mv jx /out/


FROM google/cloud-sdk:latest as second
# TODO: use a multi stage image (slim) so we don't include all the build tools

# copy over applications from first image
COPY --from=first /out /usr/bin

# Update jx plugins
RUN jx upgrade plugins --mandatory