# Redis

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

Start Redis container:

```bash
podman pull docker.io/redis
podman run -d --name redis-conductor -p 6379:6379 redis
```



