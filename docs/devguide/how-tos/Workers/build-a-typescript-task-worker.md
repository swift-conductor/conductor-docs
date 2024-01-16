# Build a TypeScript Task Worker

## Install

```sh
npm install @swift-conductor/conductor-client
```
or

```sh
yarn add @swift-conductor/conductor-client
```

## Implementing the Worker

To create a worker, implement the `WorkerInterface` interface.

```typescript
import { WorkerInterface, Task } from "@swift-conductor/conductor-client";

const sampleWorker: WorkerInterface = {
    taskDefName: "task_1",
    execute: async (task: Task) => {
        // Sample output
        return {
            outputData: { hello: "From your worker" },
            status: TaskResultStatusEnum.Completed,
        };
    },
};
```

Worker's core implementation logic goes in the `execute` method. Upon completion, set the `TaskResult` with status as one of the following:

1. **TaskResultStatusEnum.Completed**: If the task has completed successfully.
2. **TaskResultStatusEnum.Failed**: If there are failures - business or system failures. Based on the task's configuration, when a task fails, it may be retried.

The `taskDefName` property of the `WorkerInterface` class specifies the name of the task for which this worker should run.

## Running Workers via WorkerHost

The `WorkerHost` can be used to register the worker(s) and initialize the polling loop.
It manages the task workers thread pool and server communication (poll and task update).

```typescript
import { ConductorClient, WorkerHost } from "@swift-conductor/conductor-client";

const client = new ConductorClient();

// Worker options will take precedence over the options defined in the host
const host = new WorkerHost(client, [sampleWorker], {
  options: { pollInterval: 100, concurrency: 1 },
});

host.startPolling();

await host.stopPolling();
```

See [Create and run task workers](https://github.com/swift-conductor/conductor-client-typescript/blob/main/docs/workers.md) for additional information.
