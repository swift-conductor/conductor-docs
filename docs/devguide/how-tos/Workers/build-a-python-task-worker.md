# Build a Python Task Worker

## Install

```sh
pip install swift-conductor-client
```

## Implementing the Worker

To create a worker, implement the `WorkerAbc` interface.

```python
from swift_conductor.http.models import Task, TaskResult
from swift_conductor.http.models.task_result_status import TaskResultStatus
from swift_conductor.worker.worker_interface import WorkerAbc

class SampleWorker(WorkerAbc):
    def execute(self, task: Task) -> TaskResult:
        task_result = self.get_task_result_from_task(task)
        task_result.status = TaskResultStatus.COMPLETED

        task_result.add_output_data('outputKey1', 'value')
        task_result.add_output_data('oddEven', 1)
        task_result.add_output_data('mod', 4)

        return task_result

    def get_polling_interval_in_seconds(self) -> float:
        # poll every 500ms
        return 0.5
```
Worker's core implementation logic goes in the `execute` method. Upon completion, set the `TaskResult` with status as one of the following:

1. **COMPLETED**: If the task has completed successfully.
2. **FAILED**: If there are failures - business or system failures. Based on the task's configuration, when a task fails, it may be retried.

The `get_task_definition_name` method of the `WorkerAbc` class specifies the name of the task for which this worker should run.

## Running Workers via WorkerHost

The `WorkerHost` can be used to register the worker(s) and initialize the polling loop.
It manages the task workers thread pool and server communication (poll and task update).

```python
from multiprocessing import set_start_method
set_start_method('spawn')

from swift_conductor.configuration import Configuration
from swift_conductor.worker.worker import Worker
from swift_conductor.automation.worker_host import WorkerHost

configuration = Configuration(server_api_url='http://localhost:8080/api', debug=True)

workers = [
    SampleWorker(task_definition_name='task_1'),
    SampleWorker(task_definition_name='task_2'),
]

with WorkerHost(workers, configuration) as worker_host:
    worker_host.start_processes()
```

## Worker Configuration

### Using Config File

You can choose to pass an `worker.ini` file for specifying worker arguments like domain and polling_interval. This allows for configuring your workers dynamically and hence provides the flexibility along with cleaner worker code. This file has to be in the same directory as the main.py of your worker application.

#### Format

```ini
[task_definition_name]
domain = <domain>
polling_interval = <polling-interval-in-ms>
```

#### Generic Properties

There is an option for specifying common set of properties which apply to all workers by putting them in the `DEFAULT` section. All workers who don't have a domain or/and polling_interval specified will default to these values.

```ini
[DEFAULT]
domain = <domain>
polling_interval = <polling-interval-in-ms>
```

#### Example File

```
[DEFAULT]
domain = nice
polling_interval = 2000

[python_annotated_task_1]
domain = cool
polling_interval = 500

[python_annotated_task_2]
domain = hot
polling_interval = 300
```

With the presence of the above config file, you don't need to specify domain and poll_interval for any of the workers.

### Using Environment Variables

Workers can also be configured at run time by using environment variables which override configuration files as well.

#### Format

```
conductor_worker_polling_interval=<polling-interval-in-ms>
conductor_worker_domain=<domain>
conductor_worker_<task_definition_name>_polling_interval=<polling-interval-in-ms>
conductor_worker_<task_definition_name>_domain=<domain>
```

#### Example

```
conductor_worker_polling_interval=2000
conductor_worker_domain=nice
conductor_worker_python_annotated_task_1_polling_interval=500
conductor_worker_python_annotated_task_1_domain=cool
conductor_worker_python_annotated_task_2_polling_interval=300
conductor_worker_python_annotated_task_2_domain=hot
```

### Order of Precedence

If the worker configuration is initialized using multiple mechanisms mentioned above then the following order of priority will be considered from highest to lowest:

1. Environment Variables
2. Config File
3. Worker Constructor Arguments

See [Create and run task workers](https://github.com/swift-conductor/conductor-client-python/tree/main/docs/worker.md) for additional information.
