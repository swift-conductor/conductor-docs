# Build a C# Task Worker

## Install

```sh
dotnet add package swift-conductor-client
```

## Implementing the Worker

To create a worker, implement the `IWorker` interface.

```csharp
public class SampleWorker : IWorker
{
    public string TaskType { get; }
    public WorkerSettings WorkerSettings { get; }

    public SampleWorker()
    {
        TaskType = "task_1";
        WorkerSettings = new WorkerSettings();
    }

    public async Task<WorkerTaskResult> Run(WorkerTask workerTask, CancellationToken token)
    {
        if (token != CancellationToken.None && token.IsCancellationRequested)
            return workerTask.Failed("Cancellation token request");

        return await Task.Run(() => workerTask.Completed());
    }
}
```

The `TaskType` method returns the name of the task for which this worker provides the execution logic.

Worker's core implementation logic goes in the `Run` method. Upon completion, set the `TaskResult` with status as one of the following:

1. **Completed**: If the task has completed successfully.
2. **Failed**: If there are failures - business or system failures. Based on the task's configuration, when a task fails, it may be retried.

## Running Workers via WorkerHost

The `WorkerHost` can be used to register the worker(s) and initialize the polling loop.
It manages the task workers thread pool and server communication (poll and task update).

```csharp
using System;
using System.Threading.Thread;

using SwiftConductor.Client;
using SwiftConductor.Client.Worker;

var configuration = new Configuration();

var host = WorkerHost.Create(configuration, new SampleWorker());

await host.StartAsync();
Thread.Sleep(TimeSpan.FromSeconds(60));

await host.StopAsync();
```

See [Create and run task workers](https://github.com/swift-conductor/conductor-client-dotnet/blob/main/docs/readme/workers.md) for additional information.
