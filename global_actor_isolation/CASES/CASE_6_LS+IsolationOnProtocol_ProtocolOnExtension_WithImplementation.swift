import SwiftUI

// GLOBAL ACTOR ISOLATION ON PROTOCOL
// PROTOCOL CONFORMANCE ON TYPE EXTENSION DECLARATION
// WITH PROTOCOL MEMBERS IMPLEMENTATION


//@MainActor
//protocol IUpdate {
//    func update(date: Date) async
//}
//
//@Observable
//final class LS {
//    var label = "GLOBAL ACTOR ISOLATION ON PROTOCOL, PROTOCOL CONFORMANCE ON TYPE EXTENSION DECLARATION WITH PROTOCOL MEMBERS IMPLEMENTATION"
//
//    var date: Date = .now {
//        didSet {
//            print("didset: ", Thread.current)
//        }
//    }
//}
//
//extension LS: IUpdate {
//    func update(date: Date) async {
//        print("update: ", Thread.current)
//        await internalUpdate(date: date)
//    }
//}
//
//
//extension LS {
//    private func internalUpdate(date: Date) async {
//        print("internalUpdate: ", Thread.current)
//        self.date = date
//    }
//}

// console output:
// update:  <_NSMainThread: 0x600001710040>{number = 1, name = main}
// internalUpdate:  <NSThread: 0x60000174cd40>{number = 6, name = (null)}
// didset:  <NSThread: 0x60000174cd40>{number = 6, name = (null)}

// conclusion:
// ONLY! protocol member "update" is isolated
