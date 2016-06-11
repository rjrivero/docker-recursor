PowerDNS recursor server
========================

Recursor DNS server based on powerdns. To build the container:

```
git clone https://github.com/rjrivero/docker-recursor.git
cd docker-recursor

docker build -t rjrivero/recursor .
```

To run:

```
docker run --rm -p 53:53/udp --name rjrivero/recursor recursor
```

The container exposes **ports 53 TCP and UDP**.

Configuration
-------------

The recursor server can be configured using environment variables to send queries for different domains to different authoritative DNS servers. The container recognizes the following environment variables patterns:

  - RECURSOR_*N* = *DOMAIN:PORT*: Sends queries for *DOMAIN* to the port specified by *PORT* in the default gateway.

for instance,

  - RECURSOR_1=my.domain.com:10053 will forward requests for any name in domain *my.domain.com* to the port 10053 of the default gateway.
  - RECURSOR_2=service.consul:8600 will forward requests for any name in domain *service.consul* to the port 8600 of the default gateway.

The reason to always forward to the default gateway is because it is the best well-known IP address available to all containers. Forwarders cannot be specified by name, so unless their IP address is well known and static, forwarding can fail.

Previous versions of the container allowed forwarding by name, provided the name was in /etc/hosts. This was intended to support linked containers, which have the names stored there by docker. However, restarting a container breaks the link, so if you need to reset a container for any reason, you will have to reset all the containers that depend on it.

Forcing the IP address of the forwarded to be always the default gateway supports a more robust scenario where the service ports of DNS container can be published to a fixed port of the **docker0** interface, which is the default gateway of your containers.

This way, suppose you have:

  - Your [consul](https://www.consul.io/) container publishing DNS service at port 8600,
  - A custom DNS resolving some particular domain at port 10053,
  - Your recursor listining at port 53.

You can expose all these ports in the **docker0** interface, and have the recursor forward queries to the other services:

```
# Bind your consul DNS port to docker0 interface
docker run -d --name consul -p 172.17.0.1:8600:8600/udp consul

# Bind your custom DNS server port too
docker run -d --name custom-dns -p 172.17.0.1:10053:10053/udp custom-dns

# Run your recursor, bind it to port 53, and have it forward
# queries for the other two
docker run -d --name recursor -p 172.17.0.1:53:53/udp \
    -e RECURSOR_1=service.consul:8600 \
    -e RECURSOR_2:my.custom.domain:10053 \
    recursor
```

Now you are able to restart any container independently, without affecting the other two.
