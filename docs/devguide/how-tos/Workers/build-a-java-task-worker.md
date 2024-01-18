# Build a Java Task Worker

## Dependencies

### Maven Dependency

```xml
<dependency>
    <groupId>com.swiftconductor.conductor</groupId>
    <artifactId>conductor-common</artifactId>
    <version>3.16.0</version>
</dependency>
<dependency>
    <groupId>com.swiftconductor.conductor</groupId>
    <artifactId>conductor-client</artifactId>
    <version>3.16.0</version>
</dependency>
<dependency>
    <groupId>com.swiftconductor.conductor</groupId>
    <artifactId>conductor-java-sdk</artifactId>
    <version>3.16.0</version>
</dependency>
```

### Gradle

```groovy
implementation 'com.swiftconductor.conductor:conductor-common:3.16.0'
implementation 'com.swiftconductor.conductor:conductor-client:3.16.0'
implementation 'com.swiftconductor.conductor:conductor-java-sdk:3.16.0'
```

## Implementing the Worker

To create a worker, implement the `AbstractWorker` interface.

```java
public class SampleWorker implements AbstractWorker {

    private final String taskDefName;

    public SampleWorker(String taskDefName) {
        this.taskDefName = taskDefName;
    }

    @Override
    public String getTaskDefName() {
        return taskDefName;
    }

    @Override
    public TaskResult execute(Task task) {
        TaskResult result = new TaskResult(task);
        result.setStatus(Status.COMPLETED);

        // Register the output of the task
        result.getOutputData().put("outputKey1", "value");
        result.getOutputData().put("oddEven", 1);
        result.getOutputData().put("mod", 4);

        return result;
    }
}
```

The `getTaskDefName()` method returns the name of the task for which this worker provides the execution logic.

Worker's core implementation logic goes in the `execute` method. Upon completion, set the `TaskResult` with status as one of the following:

1. **COMPLETED**: If the task has completed successfully.
2. **FAILED**: If there are failures - business or system failures. Based on the task's configuration, when a task fails, it may be retried.

See [SampleWorker.java](https://github.com/swift-conductor/conductor-client-java/blob/main/client/src/test/java/com/swiftconductor/conductor/client/sample/SampleWorker.java) for the complete example.

## Running Workers via WorkerHost

The `WorkerHost` can be used to register the worker(s) and initialize the polling loop.
It manages the task workers thread pool and server communication (poll and task update).

Use the [Builder](https://github.com/swift-conductor/conductor-client-java/blob/main/client/src/main/java/com/swiftconductor/conductor/client/automation/WorkerHost.java) to create an instance of `WorkerHost`. 

```java
// Point this to the server API
TaskClient taskClient = new TaskClient();
taskClient.setRootURI("http://localhost:8080/api");        

// number of threads used to execute workers.  
// To avoid starvation, this should be same or more than number of workers
int threadCount = 2;            

Worker worker1 = new SampleWorker("task_1");
Worker worker2 = new SampleWorker("task_2");

// Create WorkerHost
WorkerHost host = new WorkerHost.Builder(taskClient, Arrays.asList(worker1, worker2))
    .withThreadCount(threadCount)
    .build();

// Start the polling and execution of tasks
host.init();
```

See [Sample](https://github.com/swift-conductor/conductor-client-java/blob/main/client/src/test/java/com/swiftconductor/conductor/client/sample/Main.java) for full example.

## Worker Configuration

Initialize the `Builder` with the following:

| Parameter | Description |
| --- | --- |
| TaskClient | TaskClient used to communicate with the Conductor server |
| Workers | Workers that will be used for polling work and task execution. |

| Parameter | Description | Default |
| --- | --- | --- |
| withEurekaClient | EurekaClient is used to identify if the server is in discovery or not. When the server goes out of discovery, the polling is stopped unless `pollOutOfDiscovery` is set to true. If passed null, discovery check is not done. | provided by platform |
| withThreadCount | Number of threads assigned to the workers. Should be at-least the size of taskWorkers to avoid starvation in a busy system. | Number of registered workers |
| withSleepWhenRetry | Time in milliseconds, for which the thread should sleep when task update call fails, before retrying the operation. | 500 |
| withUpdateRetryCount | Number of attempts to be made when updating task status when update status call fails. | 3 |
| withWorkerNamePrefix | String prefix that will be used for all the workers. | workflow-worker- |

Once an instance is created, call `init()` method to initialize the `WorkerProcess` and begin the polling and execution of tasks.

!!! tip "Note"
    To ensure that the `WorkerHost` stops polling for tasks when the instance becomes unhealthy, call the provided `shutdown()` hook in a `PreDestroy` block.

## Worker Properties

The worker behavior can be further controlled by using these properties:

| Property | Type | Description | Default |
| --- | --- | --- | --- |
| paused | boolean | If set to true, the worker stops polling.| false |
| pollInterval | int | Interval in milliseconds at which the server should be polled for tasks. | 1000 |
| pollOutOfDiscovery | boolean | If set to true, the instance will poll for tasks regardless of the discovery status. This is useful while running on a dev machine. | false |

Further, these properties can be set either by a `AbstractWorker` implementation or by setting the following system properties in the JVM:

| Name | Description |
| --- | --- |
| `conductor.worker.<property>` | Applies to ALL the workers in the JVM. |
| `conductor.worker.<taskDefName>.<property>` | Applies to the specified worker.  Overrides the global property. |
