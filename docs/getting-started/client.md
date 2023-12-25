# Using the Client

Conductor tasks that are executed by remote workers communicate over HTTP endpoints/gRPC to poll for the task and update the status of the execution.

## Client APIs

Conductor provides the following java clients to interact with the various APIs

| Client          | Usage                                                                     |
|-----------------|---------------------------------------------------------------------------|
| Metadata Client | Register / Update workflow and task definitions                           |
| Workflow Client | Start a new workflow / Get execution status of a workflow                 |
| Task Client     | Poll for task / Update task result after execution / Get status of a task |

## SDKs

* [Python](../documentation/clientsdks/python-sdk.md)
* [Java](../documentation/clientsdks/java-sdk.md)
* [C#](../documentation/clientsdks/csharp-sdk.md)
* [Go](../documentation/clientsdks/go-sdk.md)
* [Clojure](../documentation/clientsdks/clojure-sdk.md)

The non-Java Conductor SDKs are hosted on a separate GitHub repository: [github.com/conductor-sdk](https://github.com/conductor-sdk).  Contributions from the community are encouraged!
