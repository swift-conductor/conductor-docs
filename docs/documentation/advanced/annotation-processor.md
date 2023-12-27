# Annotation Processor

This module is strictly for code generation tasks during builds based on annotations.
Currently supports `protogen`

### Usage

This is an actual example of this module which is implemented in common/build.gradle

```groovy
task protogen(dependsOn: jar, type: JavaExec) {
    classpath configurations.annotationsProcessorCodegen
    main = 'com.swiftconductor.conductor.annotationsprocessor.protogen.ProtoGenTask'
    args(
            "conductor.proto",
            "com.swiftconductor.conductor.proto",
            "github.com/swift-conductor/conductor/client/gogrpc/conductor/model",
            "${rootDir}/grpc/src/main/proto",
            "${rootDir}/grpc/src/main/java/com/swiftconductor/conductor/grpc",
            "com.swiftconductor.conductor.grpc",
            jar.archivePath,
            "com.swiftconductor.conductor.common",
    )
}
```

