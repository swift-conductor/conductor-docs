# Worker Tasks

A worker is responsible for executing a worker task (`type=SIMPLE`). Operator and System Tasks are handled by the Conductor server, while user defined tasks (`type=SIMPLE`) need to have a worker created that awaits the work to be scheduled by the server for it to be executed.

Worker implementation should follow these basic design principles:

1. Workers are stateless and do not implement a workflow specific logic.  
2. Each worker executes a very specific task and produces well defined output given specific inputs.
3. Workers are meant to be idempotent (or should handle cases where the task that partially executed gets rescheduled due to timeouts etc.)
4. Workers do not implement the logic to handle retries etc, that is taken care by the Conductor server.

Workers can be implemented in any language, and Conductor comes with Python, Java, and Golang [clients](../clientsdks/index.md) that make creating workers easy by providing features such as polling threads, metrics and server communication.
 