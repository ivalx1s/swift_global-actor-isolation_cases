import SwiftUI

// GLOBAL ACTOR ISOLATION ON PROTOCOL
// PROTOCOL CONFORMANCE ON TYPE EXTENSION DECLARATION
// PROTOCOL MEMBERS IMPLEMENTATION IS IN ANOTHER EXTENSION

//@MainActor
//protocol IUpdate {
//    func update(date: Date) async
//}
//
//@Observable
//final class LS {
//    var label = "GLOBAL ACTOR ISOLATION ON PROTOCOL, PROTOCOL CONFORMANCE ON TYPE EXTENSION DECLARATION, PROTOCOL MEMBERS IMPLEMENTATION IS IN ANOTHER EXTENSION"
//    var date: Date = .now {
//        didSet {
//            print("didset: ", Thread.current)
//        }
//    }
//}
//
//extension LS: IUpdate {
//}
//
//extension LS {
//    func update(date: Date) async {
//        print("update: ", Thread.current)
//        await internalUpdate(date: date)
//    }
//}
//
//extension LS {
//    private func internalUpdate(date: Date) async {
//        print("internalUpdate: ", Thread.current)
//        self.date = date
//    }
//}

// console output:
// update:  <NSThread: 0x600001776880>{number = 8, name = (null)}
// internalUpdate:  <NSThread: 0x600001776880>{number = 8, name = (null)}
// didset:  <NSThread: 0x600001776880>{number = 8, name = (null)}

// conclusion:
// NO ISOLATION
