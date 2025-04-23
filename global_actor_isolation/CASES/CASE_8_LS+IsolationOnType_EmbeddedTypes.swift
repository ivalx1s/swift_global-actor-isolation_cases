import SwiftUI

// GLOBAL ACTOR ISOLATION ON TYPE DECLARATION
// TYPE CONTAINS EMBEDDED_TYPE
// NO ISOLATION ON EMBEDDED_TYPE

protocol IUpdate {
    func update(date: Date) async
}

@MainActor
@Observable
final class LS {
    var label = "GLOBAL ACTOR ISOLATION ON TYPE WITH EMBEDDED TYPES"
    var date: Date = .now {
        didSet {
            print("didset: ", Thread.current)
        }
    }
}

extension LS {
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
}

extension LS {
    private func internalUpdate(date: Date) async {
        print("internalUpdate: ", Thread.current)
        self.date = date
    }
}

// console output:
// update:  <_NSMainThread: 0x600001700040>{number = 1, name = main}
// internalUpdate:  <_NSMainThread: 0x600001700040>{number = 1, name = main}
// didset:  <_NSMainThread: 0x600001700040>{number = 1, name = main}
// embedded type sync call:  <_NSMainThread: 0x600001700040>{number = 1, name = main}
// embedded type async call:  <NSThread: 0x60000177af00>{number = 7, name = (null)}

// conclusion:
// Isolation spreads on TYPE and doesn't affect any embedded type
// it's obvious that embedded type SYNC call executes on the same thread where it's called
// embedded type ASYNC call executes with no isolation
// note: it doesn't matter where embedded type located, in the type declaration or in the extension
