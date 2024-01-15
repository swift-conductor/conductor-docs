# Basic Concepts

## Workflow Definition

A Workflow Definition is the container that describes your process. It contains tasks, sub-workflows, with inputs and outputs connected to each other in order to achieve the desired action. The tasks are either System Operators (e.g. fork, join, wait, switch, conditional, etc), System Tasks (e.g. HTTP, Inline, Human) or Custom Tasks (e.g. encode a file). The system operators and tasks are executed by the Swift Conductor server. The custom tasks are executed by a dedicated Worker on a remote machine.

[Detailed description](../documentation/configuration/workflowdef/index.md)

## Task Definition

Task definitions help define task level parameters like inputs and outputs, timeouts, retries etc.

* All tasks need to be registered before they can be used by active workflows.
* A task can be re-used within multiple workflows.

[Detailed description](../documentation/configuration/taskdef.md)

## Task Types

Tasks are the building blocks of Workflow. There must be at least one task in a Workflow.  
Tasks can be categorized into two types: 

 * [System tasks](../reference/systemtasks/index.md) - executed by Conductor server.
 * [Custom tasks](../documentation/configuration/workerdef.md) - executed by your own workers.


## System Tasks

System tasks are executed within the JVM of the Conductor server and managed by Conductor for its execution and scalability.

See [Systems tasks](../reference/systemtasks/index.md) for list of available Task types, and instructions for using them.

!!! Note
	Conductor provides an API to add system tasks that are executed in the same JVM as the engine.	See [WorkflowSystemTask](https://github.com/swift-conductor/conductor/blob/main/core/src/main/java/com/swiftconductor/conductor/core/execution/tasks/WorkflowSystemTask.java) interface for details.

## Custom Tasks

Custom tasks are implemented by your application(s) and run in a separate environment from Swift Conductor. The custom tasks can be implemented in any language.  These tasks talk to Conductor server via REST/gRPC to poll for tasks and update its status after execution.

Custom tasks are identified by task type __CUSTOM__ in the blueprint.
