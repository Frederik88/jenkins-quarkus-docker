FROM jenkins/jenkins:lts-jdk11
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

USER root
RUN apt update && \
    apt install -y --no-install-recommends gnupg curl ca-certificates apt-transport-https wget maven && \
    apt update && apt install -y 

# Install GraalVM and native image
RUN  wget -c https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-22.3.0/graalvm-ce-java11-linux-amd64-22.3.0.tar.gz -O - | tar -xz -C /opt/java
ENV GRAALVM_HOME=/opt/java/graalvm-ce-java11-22.3.0
RUN GRAALVM_HOME/bin/gu install native-image
ENV PATH=${GRAALVM_HOME}/bin:$PATH
ENV JAVA_HOME=${GRAALVM_HOME}
RUN grep VERSION $GRAALVM_HOME/release

USER jenkins