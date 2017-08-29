FROM jenkins:alpine

ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"
ENV GIT_GLOBAL_CONFIG_NAME="Tunde Oladipupo"
ENV GIT_GLOBAL_CONFIG_EMAIL="simplytunde"

COPY scripts/security.groovy /usr/share/jenkins/ref/init.groovy.d/security.groovy

COPY files/plugins.txt /usr/share/jenkins/ref/plugins.txt
COPY files/gitconfig /var/jenkins_home/.gitconfig
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
RUN cd ~ && curl -o ~/terraform.zip https://releases.hashicorp.com/terraform/0.10.2/terraform_0.10.2_linux_amd64.zip && unzip ~/terraform.zip
