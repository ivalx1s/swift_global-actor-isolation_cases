# Swift Concurrency: Global Actors and Isolation with `@MainActor`

This project demonstrates various approaches to using global actors in Swift Concurrency, specifically using the `@MainActor` annotation. Each case provides clear examples of how actor isolation affects code execution.

## Contents

The project includes the following scenarios (cases):

### 1. CASE_1_LS+NoGlobalActor — No Global Actor Isolation

```swift
protocol IUpdate {
    func update(date: Date) async
}

@Observable
final class LS: IUpdate {
    // No isolation
}
```

**Conclusion:**
No actor isolation is applied. Operations may run on any thread, potentially causing data races.

### 2. CASE_2_LS+IsolationOnTypeDeclaration — Isolation on Type Declaration

```swift
@MainActor
protocol IUpdate {
    func update(date: Date) async
}

@MainActor
@Observable
final class LS: IUpdate {
    // Complete isolation
}
```

**Conclusion:**
Complete isolation; all methods and properties run on the main actor (main thread). Isolation is complete regardless of whether protocol conformance is implemented in the type declaration or extension.

### 3. CASE_3_LS+IsolationOnTypeFunction — Isolation on Method Declaration

```swift
@Observable
final class LS: IUpdate {
    @MainActor
    func update(date: Date) async {
        // isolated method
    }
}
```

**Conclusion:**
Only the annotated method `update` is isolated, while other methods remain non-isolated.

### 4. CASE_4_LS+IsolationOnTypeField — Isolation on Property Declaration

```swift
@Observable
final class LS: IUpdate {
    @MainActor
    var date: Date = .now
}
```

**Conclusion:**
The property `date` is actor-isolated. It cannot be modified from a non-isolated context.

### 5. CASE_5_LS+IsolationOnProtocol_ProtocolOnTypeDeclaration — Full Isolation via Protocol

```swift
@MainActor
protocol IUpdate {
    func update(date: Date) async
}

@Observable
final class LS: IUpdate {
    func update(date: Date) async {
        // fully isolated
    }
}
```

**Conclusion:**
Full isolation through protocol conformance; all methods in the protocol run on the main actor.

### 6. CASE_6_LS+IsolationOnProtocol_ProtocolOnExtension_WithImplementation — Partial Isolation via Protocol Extension

```swift
@MainActor
protocol IUpdate {
    func update(date: Date) async
}

@Observable
final class LS {}

extension LS: IUpdate {
    func update(date: Date) async {
        // isolated method implementation
    }
}
```

**Conclusion:**
Only protocol methods implemented within the extension are isolated. Other methods are not isolated.

### 7. CASE_7_LS+IsolationOnProtocol_ProtocolOnExtension_ImplementationInAnotherExt — No Isolation (Implementation in Another Extension)

```swift
@MainActor
protocol IUpdate {
    func update(date: Date) async
}

@Observable
final class LS {}

extension LS: IUpdate {}

extension LS {
    func update(date: Date) async {
        // not isolated
    }
}
```

**Conclusion:**
No isolation occurs, as the protocol conformance and method implementation are separated into different extensions.

### 8. CASE_8_LS+IsolationOnType_EmbeddedTypeNotIsolated — Embedded Types Are Not Isolated

```swift
@MainActor
@Observable
final class LS {
    var label = "Embedded"
    var date: Date = .now {
        didSet {
            print("didset: ", Thread.current)
        }
    }

    enum EmbeddedType {
        static func printEmbeddedTypeThread() {
            print("embedded type sync call: ", Thread.current)
        }

        static func printEmbeddedTypeThreadAsync() async {
            print("embedded type async call: ", Thread.current)
        }
    }
}

extension LS: IUpdate {
    func update(date: Date) async {
        print("update: ", Thread.current)
        await internalUpdate(date: date)
        EmbeddedType.printEmbeddedTypeThread()
        await EmbeddedType.printEmbeddedTypeThreadAsync()
    }

    private func internalUpdate(date: Date) async {
        print("internalUpdate: ", Thread.current)
        self.date = date
    }
}
```

**Conclusion:**
Actor isolation applies only to the type itself. Static members of embedded types are not actor-isolated:
- Synchronous calls on embedded types run on the caller’s thread.
- Asynchronous calls are not automatically isolated.
- The location of the embedded type (inside the class body or in an extension) does not affect this behavior.

## How to Use

- Open the project in Xcode.
- Navigate to the `CASES` folder.
- Uncomment the case you wish to test.
- Run the application.
- Check the console output for execution context and thread behavior.

## Console Output
Each scenario includes comments about the console output, illustrating thread execution and isolation behavior.

## Final Thoughts

- Full isolation ensures all code runs on the main thread.
- Partial isolation provides flexibility but requires careful implementation.
- Lack of isolation can lead to data races.
- Embedded types are not automatically isolated, so be cautious when invoking async code from them.

Use this project as a clear guide for working with global actors in Swift Concurrency.

