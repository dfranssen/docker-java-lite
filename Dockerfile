FROM progrium/busybox

MAINTAINER Dirk Franssen "dirk.franssen@gmail.com"

ENV REFRESHED_AT 2014-10-16

# Java Version
ENV JAVA_VERSION_MAJOR 8
ENV JAVA_VERSION_MINOR 20
ENV JAVA_VERSION_BUILD 26
ENV JAVA_PACKAGE       jdk

ENV JAVA_HOME /opt/jdk

# Maven version and options
ENV MAVEN_VERSION 3.2.2
ENV MAVEN_ROOT    /var/lib/maven
ENV MAVEN_HOME    ${MAVEN_ROOT}/apache-maven-${MAVEN_VERSION}
ENV MAVEN_OPTS    -Xms1m -Xmx512m

# Install cURL
RUN opkg-install curl git dropbear

# Download and unarchive Java
RUN curl -kLOH "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie"\
  http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-b${JAVA_VERSION_BUILD}/${JAVA_PACKAGE}-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.tar.gz &&\
    echo "ec7f89dc3697b402e2c851d0488f6299  ${JAVA_PACKAGE}-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.tar.gz" | md5sum -c && \
    gunzip ${JAVA_PACKAGE}-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.tar.gz &&\
    tar -xf ${JAVA_PACKAGE}-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.tar -C /opt &&\
    rm ${JAVA_PACKAGE}-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.tar* &&\
    ln -s /opt/jdk1.${JAVA_VERSION_MAJOR}.0_${JAVA_VERSION_MINOR} /opt/jdk &&\
    rm -rf /opt/jdk/*src.zip \
           /opt/jdk/lib/missioncontrol \
           /opt/jdk/lib/visualvm \
           /opt/jdk/lib/*javafx* \
           /opt/jdk/jre/lib/plugin.jar \
           /opt/jdk/jre/lib/ext/jfxrt.jar \
           /opt/jdk/jre/bin/javaws \
           /opt/jdk/jre/lib/javaws.jar \
           /opt/jdk/jre/lib/desktop \
           /opt/jdk/jre/plugin \
           /opt/jdk/jre/lib/deploy* \
           /opt/jdk/jre/lib/*javafx* \
           /opt/jdk/jre/lib/*jfx* \
           /opt/jdk/jre/lib/amd64/libdecora_sse.so \
           /opt/jdk/jre/lib/amd64/libprism_*.so \
           /opt/jdk/jre/lib/amd64/libfxplugins.so \
           /opt/jdk/jre/lib/amd64/libglass.so \
           /opt/jdk/jre/lib/amd64/libgstreamer-lite.so \
           /opt/jdk/jre/lib/amd64/libjavafx*.so \
           /opt/jdk/jre/lib/amd64/libjfx*.so

# Download and unarchive Maven
RUN curl -kLO http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz && \
    echo "87e5cc81bc4ab9b83986b3e77e6b3095  apache-maven-$MAVEN_VERSION-bin.tar.gz" | md5sum -c && \
    mkdir -p $MAVEN_ROOT && \
    gunzip apache-maven-$MAVEN_VERSION-bin.tar.gz &&\
    tar -xf apache-maven-$MAVEN_VERSION-bin.tar -C $MAVEN_ROOT &&\
    rm -f apache-maven-$MAVEN_VERSION-bin.tar*

ENV PATH ${JAVA_HOME}/bin:${MAVEN_HOME}/bin:${PATH}

RUN mkdir .ssh
ADD ./private_key .ssh/id_rsa
ADD ./ssh-git.sh ssh-git.sh
RUN chmod 744 ssh-git.sh && export GIT_SSH=~/ssh-git.sh

CMD ["/bin/bash"]
