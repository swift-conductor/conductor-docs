# Starting a Workflow

## Workflow Endpoint

When starting a Workflow execution with a registered definition, `/workflow` accepts following parameters:

| Field                           | Description                                                                                                                                           | Notes                                                                                                              |
| :------------------------------ | :---------------------------------------------------------------------------------------------------------------------------------------------------- | :----------------------------------------------------------------------------------------------------------------- |
| name                            | Name of the Workflow. MUST be registered with Conductor before starting workflow                                                                      |                                                                                                                    |
| version                         | Workflow version                                                                                                                                      | defaults to latest available version                                                                               |
| input                           | JSON object with key value params, that can be used by downstream tasks                                                                               | See [Wiring Inputs and Outputs](../documentation/configuration/workerdef.md#wiring-inputs-and-outputs) for details |
| correlationId                   | Unique Id that correlates multiple Workflow executions                                                                                                | optional                                                                                                           |
| taskToDomain                    | See [Task Domains](../documentation/configuration/taskdomains.md) for more information.                                                               | optional                                                                                                           |
| workflowDef                     | An adhoc [Workflow Definition](../documentation/configuration/workerdef.md) to run, without registering. See [Dynamic Workflows](#dynamic-workflows). | optional                                                                                                           |
| externalInputPayloadStoragePath | This is taken care of by Java client. See [External Payload Storage](../documentation/advanced/externalpayloadstorage.md) for more info.              | optional                                                                                                           |
| priority                        | Priority level for the tasks within this workflow execution. Possible values are between 0 - 99.                                                      | optional                                                                                                           |

## Static Workflows

Static workflows must be defined before execution. You start them by passing `name` and `version` to the Conductor API.

To start a predefined static workflow, send a `POST` request to `/workflow` endpoint with a payload like this:

```json
{
  "name": "encode_and_deploy",
  "version": 1,
  "correlationId": "my_unique_correlation_id",
  "input": {
    "param1": "value1",
    "param2": "value2"
  }
}
```

## Dynamic Workflows

Dynamic workflows allow you to provide the workflow definition together with the all task definitions directly in the the `workflowDef` parameter of a `StartWorkflowRequest` thus avoiding the need to create task and workflow definitions before the execution.

To start a dynamic workflow, send a `POST` request to `/workflow` endpoint with a payload like this:

```json
{
  "name": "my_adhoc_unregistered_workflow",
  "workflowDef": {
    "ownerApp": "my_owner_app",
    "ownerEmail": "my_owner_email@test.com",
    "createdBy": "my_username",
    "name": "my_adhoc_unregistered_workflow",
    "description": "Test Workflow setup",
    "version": 1,
    "tasks": [
      {
        "type": "HTTP",
        "name": "fetch_data",
        "taskReferenceName": "fetch_data",
        "inputParameters": {
          "http_request": {
            "connectionTimeOut": "3600",
            "readTimeOut": "3600",
            "uri": "${workflow.input.uri}",
            "method": "GET",
            "accept": "application/json",
            "content-Type": "application/json",
            "headers": {}
          }
        },
        "taskDefinition": {
          "name": "fetch_data",
          "retryCount": 0,
          "timeoutSeconds": 3600,
          "timeoutPolicy": "TIME_OUT_WF",
          "retryLogic": "FIXED",
          "retryDelaySeconds": 0,
          "responseTimeoutSeconds": 3000
        }
      }
    ],
    "outputParameters": {}
  },
  "input": {
    "uri": "http://www.google.com"
  }
}
```
