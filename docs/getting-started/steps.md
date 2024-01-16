
# High Level Steps

Steps required for a new workflow to be created and executed

1. Define any `CUSTOM` tasks 
2. Define a workflow
1. Start the workflow
1. Create worker(s) for the `CUSTOM` tasks

## Start the workflow

```
POST /workflow/{name}
{
    ... //json payload as workflow input
}
```

## Create worker(s) for `CUSTOM` tasks

### Poll for tasks

```
GET /task/poll/batch/{taskType}
```
	
### Update task status
	
```
POST /task
{
    "outputData": {
        "encodeResult":"success",
        "location": "http://cdn.example.com/file/location.png"
        //any task specific output
    },
    "status": "COMPLETED"
}
```
