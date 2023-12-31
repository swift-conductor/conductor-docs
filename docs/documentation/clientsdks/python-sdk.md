# Python Client SDK

The code for the Python Client SDK is available on [Github](https://github.com/swift-conductor/conductor-client-python). Please feel free to file PRs, issues, etc. there.

## Quick Guide

1. Create a virtual environment

    ```sh
    virtualenv conductor
    source conductor/bin/activate
    python3 -m pip list
    ```

2. Install latest version of `conductor-client-python` from pypi

    ```sh
    python3 -m pip install conductor-client-python
    ```

3. Create a worker capable of executing a `Task`. Example:

    ```python
    from conductor.client.worker.worker_interface import WorkerInterface

    class SimplePythonWorker(WorkerInterface):
        def execute(self, task):
            task_result = self.get_task_result_from_task(task)
            task_result.add_output_data('key', 'value')
            task_result.status = 'COMPLETED'
            return task_result
    ```

    * The `add_output_data` is the most relevant part, since you can store information in a dictionary, which will be sent within `TaskResult` as your execution response to Conductor

4. Create a main method to start polling tasks to execute with your worker. Example:

    ```python
    from conductor.client.automator.task_handler import TaskHandler
    from conductor.client.configuration.configuration import Configuration
    from conductor.client.worker.sample.faulty_execution_worker import FaultyExecutionWorker
    from conductor.client.worker.sample.simple_python_worker import SimplePythonWorker


    def main():
        configuration = Configuration(debug=True)
        task_definition_name = 'python_example_task'
        workers = [
            SimplePythonWorker(task_definition_name),
            FaultyExecutionWorker(task_definition_name)
        ]
        with TaskHandler(workers, configuration) as task_handler:
            task_handler.start()


    if __name__ == '__main__':
        main()
    ```
    
    * This example contains two workers, each with a different execution method, capable of running the same `task_definition_name`

5. Now that you have implemented the example, you can start the Conductor server locally:
      1. Clone [Conductor repository](https://github.com/swift-conductor/conductor):
        ```sh
        git clone https://github.com/swift-conductor/conductor.git
        ```
        
      2. Start the Conductor server:
        ```sh
        cd conductor/
        ./gradlew server
        ```
        
      3. Start Conductor UI:

        ```sh
        cd ui/
        yarn install
        yarn run start
        ```

      You should be able to access:
      * Conductor API:
        * http://localhost:8080/swagger-ui/index.html
      * Conductor UI:
        * http://localhost:5000

6. Create a `Task` within `Conductor`. Example:
    ```sh
    curl -X 'POST' \
            '{{ server_host }}{{ api_prefix }}/metadata/taskdefs' \
            -H 'accept: */*' \
            -H 'Content-Type: application/json' \
            -d '[
            {
                "name": "python_task_example",
                "description": "Python task example",
                "retryCount": 3,
                "retryLogic": "FIXED",
                "retryDelaySeconds": 10,
                "timeoutSeconds": 300,
                "timeoutPolicy": "TIME_OUT_WF",
                "responseTimeoutSeconds": 180,
                "ownerEmail": "example@example.com"
            }
            ]'
    ```

7. Create a `Workflow` within `Conductor`. Example:
    ```sh
    curl -X 'POST' \
            '{{ server_host }}{{ api_prefix }}/metadata/workflow' \
            -H 'accept: */*' \
            -H 'Content-Type: application/json' \
            -d '{
            "createTime": 1634021619147,
            "updateTime": 1630694890267,
            "name": "workflow_with_python_task_example",
            "description": "Workflow with Python Task example",
            "version": 1,
            "tasks": [
                {
                "name": "python_task_example",
                "taskReferenceName": "python_task_example_ref_1",
                "inputParameters": {},
                "type": "SIMPLE"
                }
            ],
            "inputParameters": [],
            "outputParameters": {
                "workerOutput": "${python_task_example_ref_1.output}"
            },
            "schemaVersion": 2,
            "restartable": true,
            "ownerEmail": "example@example.com",
            "timeoutPolicy": "ALERT_ONLY",
            "timeoutSeconds": 0
            }'
    ```

8. Start a new workflow:
    ```sh
    curl -X 'POST' \
            '{{ server_host }}{{ api_prefix }}/workflow/workflow_with_python_task_example' \
            -H 'accept: text/plain' \
            -H 'Content-Type: application/json' \
            -d '{}'
    ```

    You should receive a *Workflow ID* at the *Response body*
    * *Workflow ID* example: `8ff0bc06-4413-4c94-b27a-b3210412a914`
    
    Now you must be able to see its execution through the UI.
    * Example: `http://localhost:5000/execution/8ff0bc06-4413-4c94-b27a-b3210412a914`

9. Run your Python file with the `main` method

### Unit Tests

#### Simple validation

```sh
cd /conductor-client-python/src 
python3 -m unittest -v
```

#### Run with code coverage

```sh
cd /conductor-client-python/src 
python3 -m coverage run --source=conductor/ -m unittest
```

Report:

```shell
cd /conductor-client-python/src 
python3 -m coverage report
```

Visual coverage results:

```sh
cd /conductor-client-python/src 
python3 -m coverage html
```
