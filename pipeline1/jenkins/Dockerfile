FROM jenkins/jenkins:lts

ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"
ENV GIT_GLOBAL_CONFIG_NAME="Tunde Oladipupo"
ENV GIT_GLOBAL_CONFIG_EMAIL="simplytunde"

COPY scripts/security.groovy /usr/share/jenkins/ref/init.groovy.d/security.groovy
COPY files/plugins.txt /usr/share/jenkins/ref/plugins.txt
COPY files/gitconfig /var/jenkins_home/.gitconfig

USER root
RUN apt-get update &&  apt-get install -y ansible && apt-get install -y python-pip && pip install awscli
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
USER jenkins

COPY scripts/terraform /usr/local/bin/
COPY scripts/terraform /usr/bin/
