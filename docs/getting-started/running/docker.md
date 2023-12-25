
# Running Conductor using Docker

In this article we will explore how you can set up Conductor on your local machine using Docker compose.
The docker compose will bring up the following:

1. Conductor API Server
2. Conductor UI
3. Elasticsearch for searching workflows

## Prerequisites

1. Docker: [https://docs.docker.com/get-docker/](https://docs.docker.com/get-docker/)
2. Recommended host with CPU and RAM to be able to run multiple docker containers (at-least 16GB RAM)

## Steps

### 1. Clone the Conductor Code

```sh
git clone https://github.com/swift-conductor/conductor.git
```

### 2. Build the Docker Compose

```sh
cd conductor/docker
docker-compose build
```

### 3. Run Docker Compose

```sh
docker-compose up
```

Once up and running, you will see the following in your Docker dashboard:

1. Elasticsearch
2. Conductor UI
3. Conductor Server

You can access the UI & Server on your browser to verify that they are running correctly:

#### Conductor Server URL

[http://localhost:8080](http://localhost:8080)

![swagger](swagger.png)

#### Conductor UI URL

[http://localhost:5000/](http://localhost:5000)

![conductor ui](conductorUI.png)


### 4. Exiting Compose

`Ctrl + C` will exit docker compose.

To ensure images are stopped execute: `docker-compose down`.

## Alternative Persistence Engines

By default `docker-compose.yaml` uses `docker/server/config/config-redis.properties`. 

A selection of `docker-compose-*.yaml` and `docker/server/config/config-*.properties` files are provided demonstrating the use of alternative persistence engines.

| File                           | Containers                                                                              |
|--------------------------------|-----------------------------------------------------------------------------------------|
| docker-compose.yaml            | <ol><li>In Memory Conductor Server</li><li>Elasticsearch</li><li>UI</li></ol>           |
| docker-compose-dynomite.yaml   | <ol><li>Conductor Server</li><li>Elasticsearch</li><li>UI</li><li>Dynomite Redis for persistence</li></ol> |
| docker-compose-postgres.yaml   | <ol><li>Conductor Server</li><li>Elasticsearch</li><li>UI</li><li>Postgres persistence</li></ol> |
| docker-compose-prometheus.yaml | Brings up Prometheus server                                                             |    

For example this will start the server instance backed by a PostgreSQL DB.
```
docker-compose -f docker-compose.yaml -f docker-compose-postgres.yaml up
```

## Standalone Server Image

To build and run the server image, without using `docker-compose`, from the `docker` directory execute:

```sh
docker build -t conductor:server -f server/Dockerfile ../
docker run -p 8080:8080 -d --name conductor_server conductor:server
```

This builds the image `conductor:server` and runs it in a container named `conductor_server`. The API should now be accessible at `localhost:8080`.

To 'login' to the running container, use the command:

```sh
docker exec -it conductor_server /bin/sh
```

## Standalone UI Image

From the `docker` directory, 

```sh
docker build -t conductor:ui -f ui/Dockerfile ../
docker run -p 5000:5000 -d --name conductor_ui conductor:ui
```

This builds the image `conductor:ui` and runs it in a container named `conductor_ui`. The UI should now be accessible at `localhost:5000`.

### Note

* In order for the UI to do anything useful the Conductor Server must already be running on port 8080, either in a Docker container (see above), or running directly in the local JRE.

* Additionally, significant parts of the UI will not be functional without ElasticSearch being available. Using the `docker-compose` approach alleviates these considerations.

## Monitoring with Prometheus

Start Prometheus with:

```sh
docker-compose -f docker-compose-prometheus.yaml up -d
```

Go to [http://127.0.0.1:9090](http://127.0.0.1:9090).

## Potential problem when using Docker Images

#### Not enough memory

1. You will need at least 16 GB of memory to run everything. You can modify the docker compose to skip using
   Elasticsearch if you have no option to run this with your memory options.

2. To disable Elasticsearch using Docker Compose - follow the steps listed here: **TODO LINK**

#### Elasticsearch fails to come up in arm64 based CPU machines

1. As of writing this article, Conductor relies on 6.8.x version of Elasticsearch. This version doesn't have an
   arm64 based Docker image. You will need to use Elasticsearch 7.x which requires a bit of customization to get up
   and running

#### Elasticsearch remains in yellow health state

When you run Elasticsearch, sometimes the health remains in the *yellow* state. Conductor server by default requires
*green* state to run when indexing is enabled. To work around this, you can use the following property: `conductor.elasticsearch.clusterHealthColor=yellow`.

Reference: [Issue 2262][issue2262]

#### Elasticsearch timeout

By default, a standalone (single node) Elasticsearch has a *yellow* status which will cause timeout (`java.net.SocketTimeoutException`) for Conductor server (required status is *green*).
Spin up a cluster (more than one node) to prevent the timeout or use config option `conductor.elasticsearch.clusterHealthColor=yellow`.

Reference: [Issue 2262][issue2262]

#### Changes in config-*.properties do not take effect
Config is copy into image during docker build. You have to rebuild the image or better, link a volume to it to reflect new changes.

#### To troubleshoot a failed startup

Check the log of the server, which is located at `/app/logs` (default directory in dockerfile)

#### Unable to access to conductor:server API on port 8080

It may takes some time for conductor server to start. Please check server log for potential error.

#### Elasticsearch

Elasticsearch is optional, please be aware that disable it will make most of the conductor UI not functional.

##### How to enable Elasticsearch

* Set `conductor.indexing.enabled=true` in your_config.properties

* Add config related to elasticsearch
  E.g.: `conductor.elasticsearch.url=http://es:9200`

##### How to disable Elasticsearch

* Set `conductor.indexing.enabled=false` in your_config.properties

* Comment out all the config related to elasticsearch
E.g.: `conductor.elasticsearch.url=http://es:9200`

[issue2262]: https://github.com/swift-conductor/conductor/issues/2262
