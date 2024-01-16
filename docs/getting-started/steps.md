
# High Level Steps

Steps required for a new workflow to be created and executed

1. Define `CUSTOM` task 
2. Define workflow
1. Start workflow
1. Simulate worker

## Define `CUSTOM` task 

```bash
curl -X POST 
    http://localhost:8080/api/metadata/taskdef \
    -H 'Content-Type: application/json' \
    -d '[
        {
            "name": "curl_custom_task",
            "retryCount": 3,
            "retryLogic": "FIXED",
            "retryDelaySeconds": 10,
            "timeoutSeconds": 300,
            "timeoutPolicy": "TIME_OUT_WF",
            "responseTimeoutSeconds": 180,
            "ownerEmail": "type.your@email.here"
        }
    ]'
```

## Define workflow

```bash
curl -X POST \
    http://localhost:8080/api/metadata/workflowdef \
    -H 'Content-Type: application/json' \
    -d '{
        "name": "curl_workflow",
        "description": "Simple 1 task workflow create via curl",
        "version": 1,
        "schemaVersion": 2,
        "ownerEmail": "type.your@email.here",
        "tasks": [
            {
                "type": "CUSTOM",
                "name": "curl_custom_task",
                "taskReferenceName": "first_task"
            }
        ]
    }'
```

## Start the workflow

```bash
curl -X POST \
    http://localhost:8080/api/workflow/curl_workflow \
    -H 'Content-Type: application/json' \
    -d '{}'
```

## Simulate worker

### Poll for task

```bash
curl -X GET \
    http://localhost:8080/api/task/poll/curl_custom_task
```
	
### Finish task
	
```bash
curl -X POST \
  http://localhost:8080/api/task \
  -H 'Content-Type: application/json' \
  -d '{
    "workflowInstanceId": "d90aa6af-a3d2-4946-90f8-ac5180f31fbf",
    "taskId": "be1609e8-82c0-49c0-973c-4c552c0e1513",
    "reasonForIncompletion": "",
    "callbackAfterSeconds": 0,
    "workerId": "curl_worker",
    "status": "COMPLETED"
  }'
```
