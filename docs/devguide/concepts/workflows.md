# Workflows 
We will talk about two concepts, *defining* a workflow and *executing* a workflow.

### Workflow Definition
The Workflow Definition is the Conductor primitive that encompasses the flow of your business logic. Workflow Definition contains all the information necessary to define the behavior of a workflow.

A Workflow Definition contains a collection of **Task Configurations**. This is the blueprint which specifies the order of execution of
these Tasks. It also specifies how data/state is passed from one task to the other (using the input/output parameters). These are then combined to give you the final result. 

Additionally, the Workflow Definition contains metadata regulating runtime behavior workflow, such what input and output parameters are expected, and the workflow's the timeout and retry settings.

### Workflow Execution
If Workflow Definitions are like OOP classes, then Workflows Executions are the instances. Each time a Workflow Definition is invoked with a given input, a new Execution object with a unique ID is created. Definitions to Executions have a 1:N relationship.
