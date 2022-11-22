FROM jenkins/jenkins:lts-jdk11

# Env
ENV GRAALVM_HOME=/opt/java/graalvm-ce-java11-22.3.0
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
ENV CASC_JENKINS_CONFIG /var/jenkins_home/casc.yaml
ENV PATH=${GRAALVM_HOME}/bin:$PATH
ENV JAVA_HOME=${GRAALVM_HOME}

# Setup Jenkins
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt
COPY casc.yaml /var/jenkins_home/casc.yaml

# Setup Linux
USER root
RUN apt update && \
    apt install -y --no-install-recommends gnupg curl ca-certificates apt-transport-https wget maven && \
    apt update && apt install -y 

# Install GraalVM and native image
RUN  wget -c https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-22.3.0/graalvm-ce-java11-linux-amd64-22.3.0.tar.gz -O - | tar -xz -C /opt/java
RUN ${GRAALVM_HOME}/bin/gu install native-image
RUN grep VERSION $GRAALVM_HOME/release

USER jenkins