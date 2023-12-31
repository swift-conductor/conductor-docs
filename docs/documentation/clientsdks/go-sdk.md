# Go Client SDK

The code for the Go Client SDK is available on [Github](https://github.com/swift-conductor/conductor-client-golang). Please feel free to file PRs, issues, etc. there.


## Quick Start

1. [Setup conductor-client-golang package](#Setup-conductor-client-golang-package)
2. [Create and run Task Workers](https://github.com/swift-conductor/conductor-client-golang/blob/main/workers_sdk.md)
3. [Create workflows using Code](https://github.com/swift-conductor/conductor-client-golang/blob/main/workflow_sdk.md)
4. [API Documentation](https://github.com/swift-conductor/conductor-client-golang/blob/main/docs/)
   
### Setup conductor go package

Create a folder to build your package:
```shell
mkdir quickstart/
cd quickstart/
go mod init quickstart
```

Get Swift Conductor Go Client SDK

```shell
go get github.com/swift-conductor/conductor-client-golang
```
## Configuration

### Configure API Client

```go
apiClient := client.NewAPIClient(
    settings.NewHttpSettings(
        "http://localhost:8080/api",
    ),
)
	
```

### Setup Logging

The Go Client SDK uses [logrus](https://github.com/sirupsen/logrus) for logging.

```go
func init() {
	log.SetFormatter(&log.TextFormatter{})
	log.SetOutput(os.Stdout)
	log.SetLevel(log.DebugLevel)
}
```

### Next: [Create and run Task Workers](https://github.com/swift-conductor/conductor-client-golang/blob/main/workers_sdk.md)