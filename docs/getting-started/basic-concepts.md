# Basic Concepts

## Definitions (aka Metadata or Blueprints)

Conductor definitions are like class definitions in OOP paradigm, or templates. You define this once, and use for each workflow execution. Definitions to Executions have 1:N relationship.

## Tasks

Tasks are the building blocks of Workflow. There must be at least one task in a Workflow.  
Tasks can be categorized into two types: 

 * [System tasks](../reference/systemtasks/index.md) - executed by Conductor server.
 * [Worker tasks](../documentation/configuration/workerdef.md) - executed by your own workers.

## Workflow

A Workflow is the container of your process flow. It could include several different types of Tasks, Sub-Workflows, inputs and outputs connected to each other, to effectively achieve the desired result. The tasks are either control tasks (fork, conditional etc) or application tasks (e.g. encode a file) that are executed on a remote machine.

[Detailed description](../documentation/configuration/workflowdef/index.md)

## Task Definition

Task definitions help define Task level parameters like inputs and outputs, timeouts, retries etc.

* All tasks need to be registered before they can be used by active workflows.
* A task can be re-used within multiple workflows.

[Detailed description](../documentation/configuration/taskdef.md)

## System Tasks

System tasks are executed within the JVM of the Conductor server and managed by Conductor for its execution and scalability.

See [Systems tasks](../reference/systemtasks/index.md) for list of available Task types, and instructions for using them.

!!! Note
	Conductor provides an API to create user defined tasks that are executed in the same JVM as the engine.	See [WorkflowSystemTask](https://github.com/swift-conductor/conductor/blob/main/core/src/main/java/com/netflix/conductor/core/execution/tasks/WorkflowSystemTask.java) interface for details.

## Worker Tasks

Worker tasks are implemented by your application(s) and run in a separate environment from Conductor. The worker tasks can be implemented in any language.  These tasks talk to Conductor server via REST/gRPC to poll for tasks and update its status after execution.

Worker tasks are identified by task type __SIMPLE__ in the blueprint.