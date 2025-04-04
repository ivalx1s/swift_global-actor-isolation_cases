import SwiftUI

// GLOBAL ACTOR ISOLATION ON PROTOCOL
// PROTOCOL CONFORMANCE ON TYPE DECLARATION

//@MainActor
//protocol IUpdate {
//    func update(date: Date) async
//}
//
//@Observable
//final class LS: IUpdate {
//    var label = "GLOBAL ACTOR ISOLATION ON PROTOCOL, PROTOCOL CONFORMANCE ON TYPE DECLARATION"
//
//    var date: Date = .now {
//        didSet {
//            print("didset: ", Thread.current)
//        }
//    }
//
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
// update:  <_NSMainThread: 0x600001700000>{number = 1, name = main}
// internalUpdate:  <_NSMainThread: 0x600001700000>{number = 1, name = main}
// didset:  <_NSMainThread: 0x600001700000>{number = 1, name = main}

// conclusion:
// completely isolated
