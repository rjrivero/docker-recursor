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

  - RECURSOR_*N* = *DOMAIN:SERVER:PORT*: Sends queries for *DOMAIN* to the DNS server specified by *SERVER:PORT*.

for instance,

  - RECURSOR_1=my.domain.com:1.2.3.4:53 will forward requests for any name in domain *my.domain.com* to the port 53 of the *1.2.3.4* host.
  - RECURSOR_2=service.consul:consul_agent:8600 will forward requests for any name in domain *service.consul* to the port 8600 of the *consul_agent* host.

If you use a name instead of an IP address for the server, then the name must be present in /etc/hosts. This is handy since the **--link** commandline flag to docker includes the linked container names in /etc/hosts. So you can *--link* a container to an alias, and then use the alias as server name:

```
docker run -d --name resolver --link my_dns_container:my_alias \
    -e RECURSOR_1=my.domain.com:my_alias:53 -p 53:53/udp resolver
```

