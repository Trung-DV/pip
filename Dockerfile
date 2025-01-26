##### Install Debian APT-GET  ###################################################3#####
#FROM debian:buster-slim as BASE
FROM ubuntu:focal AS BASE

### Prevent stop interactive
ENV DEBIAN_FRONTEND=noninteractive
FROM ubuntu:focal

#### Timezone as UTC
ARG TZ=Etc/UTC
ENV TZ=${TZ}
RUN apt-get update && apt-get install -y tzdata
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone


##### Config debian
ARG VCS_REF=unspecified
LABEL org.label-schema.vcs-ref "$VCS_REF"


##### APT Get     #####################################################################
RUN apt-get update   && apt-get upgrade -y \
  && apt-get install -y --no-install-recommends  git \
    # libsqlite3-dev \
    # default-libmysqlclient-dev \
    software-properties-common \
    apt-transport-https  ca-certificates \
    wget nano  vim  curl  openssl  zip unzip rsync jq \
    gcc   g++    libc6-dev \
    build-essential  htop procps
    #  gfortran \
    #  libatlas3-base \
    #  libopenblas-base \
    #  libatlas-base-dev \


######## Workdir  #####################################################################
RUN  mkdir -p /opt/work/
WORKDIR /opt/work/




############################################################################################
# Miniconda
ENV CONDA_DIR=/opt/miniconda
ENV PATH=$CONDA_DIR/bin:$PATH
ENV PYTHONDONTWRITEBYTECODE=true

### https://conda.io/projects/continuumio-conda/en/latest/release-notes.html
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh && \
    chmod a+x miniconda.sh && \
    bash ./miniconda.sh -b -p $CONDA_DIR && \
    rm ./miniconda.sh




###### work folder  #################################################
COPY pip.txt  /opt/work/
RUN cat "/opt/work/pip.txt" && \
         pip  install -r  "/opt/work/pip.txt"  --no-cache-dir


#### Playright #######################################################
RUN  playwright install && playwright install-deps

###########
ENTRYPOINT ["tail", "-f", "/dev/null"]
