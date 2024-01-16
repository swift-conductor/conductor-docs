# Metadata API
 
## Workflow Metadata
| Endpoint                                 | Description                      | Input                                                          |
|------------------------------------------|----------------------------------|----------------------------------------------------------------|
| `GET {{ api_prefix }}/metadata/workflowdef`                 | Get all the workflow definitions | n/a                                                            |
| `POST {{ api_prefix }}/metadata/workflowdef`                | Register new workflow            | [Workflow Definition](../../documentation/configuration/workflowdef/index.md)         |
| `PUT {{ api_prefix }}/metadata/workflowdef`                 | Register/Update new workflows    | List of [Workflow Definition](../../documentation/configuration/workflowdef/index.md) |
| `GET {{ api_prefix }}/metadata/workflowdef/{name}?version=` | Get the workflow definitions     | workflow name, version (optional)                              |

## Task Metadata
| Endpoint                                 | Description                      | Input                                                          |
|------------------------------------------|----------------------------------|----------------------------------------------------------------|
| `GET {{ api_prefix }}/metadata/taskdef`                 | Get all the task definitions     | n/a                                                            |
| `GET {{ api_prefix }}/metadata/taskdef/{taskType}`      | Retrieve task definition         | Task Name                                                      |
| `POST {{ api_prefix }}/metadata/taskdef`                | Register new task definitions    | List of [Task Definitions](../../documentation/configuration/taskdef.md)        |
| `PUT {{ api_prefix }}/metadata/taskdef`                 | Update a task definition         | A [Task Definition](../../documentation/configuration/taskdef.md)               |
| `DELETE {{ api_prefix }}/metadata/taskdef/{taskType}`   | Delete a task definition         | Task Name                                                      |
