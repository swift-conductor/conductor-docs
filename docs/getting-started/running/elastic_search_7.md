# Elastic Search 7

Install Podman:

```shell
brew install podman
```

Start Podman machine:

```bash
podman machine init --cpus 2 --disk-size 100 --memory 4096
podman machine set --rootful

podman machine start
```

Start Elastic Search 7 container on port 9300:

```bash
podman pull docker.io/elasticsearch:7.17.16
podman run -d --name es7-conductor -p 9200:9200 -p 9300:9300 -e "ES_JAVA_OPTS=-Xms512m -Xmx1024m" -e "xpack.security.enabled=false" -e "discovery.type=single-node" elasticsearch:7.17.16
```

