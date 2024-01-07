# Running Conductor using Docker

In this article we will explore how you can set up Conductor on your local machine using Docker compose.
The docker compose will bring up the following:

1. Conductor API Server
2. Conductor UI
3. Elasticsearch for searching workflows

## Prerequisites

1. Docker: [https://docs.docker.com/get-docker/](https://docs.docker.com/get-docker/)
2. Recommended host with CPU and RAM to be able to run multiple docker containers (at-least 16GB RAM)

## Swift Conductor CE (Community Edition)

### Clone

```sh
git clone https://github.com/swift-conductor/conductor-community.git
```

### Build Docker image

```sh
cd conductor-community/docker

docker-compose --file docker-compose-redis.yaml build
```

### Run

#### Use `docker-compose` to bring up the local server:

| Docker Compose               | Description                                                                      |
| ---------------------------- | -------------------------------------------------------------------------------- |
| docker-compose-redis.yaml    | Redis + Elasticsearch 7, Redis database, Redis queue, ElasticSearch index        |
| docker-compose-postgres.yaml | Postgres + Elasticsearch 7, Postgress database, Redis queue, ElasticSearch index |
| docker-compose-mysql.yaml    | Mysql + Elasticsearch 7, MySql database, Redis queue, ElasticSearch index        |

For example this will start the server instance backed by a Redis database, Redis queue, and ElasticSearch index.

```sh
docker-compose --file docker-compose-redis.yaml up --detach
```

You can open the Server and UI URLs in your browser to verify that they are running correctly:

- Server: [http://localhost:8080](http://localhost:8080)
- UI: [http://localhost:5000](http://localhost:5000)

## Monitoring with Prometheus

Start Prometheus only with:

```sh
docker-compose --file docker-compose-prometheus.yaml up --detach
```

Open Prometheus ([http://localhost:9090](http://localhost:9090)) in your browser:

(Optionally) Start Prometheus and Grafana with:

```sh
docker-compose --file docker-compose-prometheus-grafana.yaml up --detach
```

Open Prometheus - [http://localhost:9090](http://localhost:9090) and Grafana - [http://localhost:3000](http://localhost:3000) in your browser (use admin / admin to login to Grafana).
