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
docker run --rm -p 53:53/udp -p 53:53 --name recursor rjrivero/recursor
```

The container exposes **ports 53 TCP and UDP**.

Configuration
-------------

You can provide configuration parameters to the recursor mounting a configuration file as a volume at **/etc/powerdns/recursor.conf**:

```
docker run -d --name recursor -p 53:53/udp -p 53:53 \
    -v /path/to/my/recursor.conf:/etc/powerdns/recursor.conf:ro
```
