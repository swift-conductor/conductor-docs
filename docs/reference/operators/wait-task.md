# Wait
The WAIT task is a no-op task that will remain `IN_PROGRESS` until after a certain duration or timestamp, at which point it will be marked as `COMPLETED`.

```json
"type" : "WAIT"
```

## Use Cases

WAIT is used when the workflow needs to wait and pause for an external signal such as a human intervention 
(like manual approval) or an event coming from external source such as Kafka, SQS or Conductor's internal queueing mechanism.

Some use cases where WAIT task is used:

1. Wait for a certain amount of time (e.g. 2 minutes) or until a certain date time (e.g. 12/25/2022 00:00)
2. To wait for and external signal coming from an event queue mechanism supported by Conductor

## Configuration

The `WAIT` task is configured using **either** `duration` **or** `until` in `inputParameters`.

### inputParameters
| name     | type   | description             |
| -------- | ------ | ----------------------- |
| duration | String | Duration to wait for    |
| until    | String | Timestamp to wait until |

### Wait For time duration

Format duration as `XhYmZs`, using the `duration` key.

```json
{
	"type": "WAIT",
	"inputParameters": {
		"duration": "10m20s"
	}
}
```

### Wait until specific date/time

Specify the timestamp using one of the formats, using the `until` key.

1. `yyyy-MM-dd HH:mm`
2. `yyyy-MM-dd HH:mm z`
3. `yyyy-MM-dd`

```json
{
	"type": "WAIT",
	"inputParameters": {
		"until": "2022-12-31 11:59"
	}
}
```
## External Triggers

The task endpoint `POST {{ api_prefix }}/tasks` can be used to update the status of a task to COMPLETED prior to the configured timeout. This is
same technique as prescribed for the [HUMAN](../systemtasks/human-task.md#completing) task.

For cases where no timeout is necessary it is recommended that you use the [HUMAN](../systemtasks/human-task.md) task directly.

