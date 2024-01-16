# Build a Go Task Worker

## Install

```sh
go get github.com/swift-conductor/conductor-client-golang
```

## Implementing the Worker

To create a worker, implement the `WorkerTaskFunction` function:

```go
type WorkerTaskFunction func(t *WorkerTask) (interface{}, error)
```

Worker returns a struct as the output of the task execution.  The struct MUST be serializable to a JSON map. If an `error` is returned, the task is marked as `FAILED`

#### Task worker that returns a struct

```go

// TaskOutput struct that represents the output of the task execution
type TaskOutput struct {
    Keys    []string
    Message string
    Value   float64
}

// SampleWorker function accepts Task as input and returns TaskOutput as result
// If there is a failure, error can be returned and the task will be marked as FAILED
func SampleWorker(t *model.WorkerTask) (interface{}, error) {
	taskResult := model.NewTaskResultFromTask(t)
	taskResult.Status = model.CompletedTask

	taskResult.OutputData = map[string]interface{}{
		"outputKey1":  "value",
		"oddEven": 1,
		"mod": 4,
	}

	return taskResult, nil
}
```

Upon completion, set the `TaskResult` with status as one of the following:

1. **CompletedTask**: If the task has completed successfully.
2. **FailedTask** or return error: If there are failures - business or system failures. Based on the task's configuration, when a task fails, it may be retried.

## Running Workers via WorkerHost

The `WorkerHost` can be used to register the worker(s) and initialize the polling loop.
It manages the task workers thread pool and server communication (poll and task update).

The `taskName` parameter of the `WorkerHost.StartWorker` method specifies the name of the task which the worker should handle.

```go
httpSettings := settings.NewHttpSettings("http://localhost:8080/api")
apiClient := client.NewAPIClient(httpSettings)

workerHost := worker.NewWorkerHostWithApiClient(apiClient)

// start polling for a task by name "task_1", with a batch size of 1 and 1 second interval
workerHost.StartWorker("task_1", SampleWorker, 1, 1*time.Second)
workerHost.StartWorker("task_2", SampleWorker, 1, 1*time.Second)

// block
workerHost.WaitWorkers()
```


See [Create and run task workers](https://github.com/swift-conductor/conductor-client-golang/blob/main/docs/readme/workers.md) for additional information.

