## Minimal Docker image with Java, Maven and git

Basic [Docker](https://www.docker.com/) image to run [Java](https://www.java.com/) applications.
This is based on `progrium/busybox`; [Busybox](http://www.busybox.net/) to keep the size minimal (about 175MB).

### Versions
Currently no tags as only following versions are needed:
> Java: jdk1.8_u20 build 26
> Maven: 3.2.2
> Git: 2.1.0

This image uses dbclient as ssh client.
Git has been setup to use the ssh-git.sh script via the GIT_SSH environment variable.

### Extend the Dockerfile with your own private key

    From dfranssen/docker-java-lite
    ADD ./private_key .ssh/id_rsa

### Usage

Example:

    docker run -it --rm dfranssen/docker-java-lite mvn -version
