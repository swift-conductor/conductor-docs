# Elastic Search 6

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

Start Elastic Search 6 container on port 9200:

```bash
podman pull docker.io/elasticsearch:6.8.23
podman run -d --name es6-conductor -p 9200:9200 -p 9300:9300 -e "ES_JAVA_OPTS=-Xms512m -Xmx1024m" -e "xpack.security.enabled=false" -e "discovery.type=single-node" elasticsearch:6.8.23
```

