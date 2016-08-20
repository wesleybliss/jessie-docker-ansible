FROM debian:latest

ENV DEBIAN_FRONTEND noninteractive

#EXPOSE 3000 9000

RUN apt-get update
RUN apt-get install -y software-properties-common apt-transport-https
RUN apt-get install -y \
        build-essential \
        software-properties-common \
        curl \
        devscripts \
        equivs \
        git-buildpackage \
        git \
        lsb-release \
        make \
        openssh-client \
        libssl-dev \
        rsync \
        curl \
        man \
        unzip \
        nano \
        tmux \
        wget \
        zsh \
        supervisor \
        python \
        python-boto \
        python-dateutil \
        python-httplib2 \
        python-jinja2 \
        python-paramiko \
        python-pip \
        python-setuptools \
        python-yaml \
        tar

RUN pip install --upgrade pip python-keyczar
RUN pip install ansible
#RUN rm -rf /var/cache/apk/*

#RUN mkdir -p /etc/ansible/ /ansible
RUN mkdir -p /etc/ansible/
RUN echo "[local]" >> /etc/ansible/hosts && \
    echo "localhost" >> /etc/ansible/hosts

#RUN \
#  curl -fsSL https://github.com/ansible/ansible/releases/download/v2.0.0.1-1/ansible-2.0.0.1.tar.gz -o ansible.tar.gz && \
#  tar -xzf ansible.tar.gz -C ansible --strip-components 1 && \
#  rm -fr ansible.tar.gz /ansible/docs /ansible/examples /ansible/packaging

ENV ANSIBLE_GATHERING smart
ENV ANSIBLE_HOST_KEY_CHECKING false
ENV ANSIBLE_RETRY_FILES_ENABLED false
ENV ANSIBLE_ROLES_PATH /ansible/playbooks/roles
ENV ANSIBLE_SSH_PIPELINING True
ENV PATH /ansible/bin:$PATH
ENV PYTHONPATH /ansible/lib

# Copy the Supervisor daemon config
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN mkdir -p /ansible/playbooks
COPY playbook.yml /ansible/playbooks/

WORKDIR /ansible/playbooks

RUN ansible-playbook playbook.yml -c local

# Switch to our working directory
WORKDIR /var/www

# Copy the NPM package info
COPY package.json npm-shrinkwrap.json /var/www/
RUN npm i

COPY src /var/www/src
CMD ["/usr/bin/supervisord", "-n"]