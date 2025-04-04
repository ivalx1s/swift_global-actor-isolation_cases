import SwiftUI

// GLOBAL ACTOR ISOLATION ON TYPE FUNCTION DECLARATION

//protocol IUpdate {
//    func update(date: Date) async
//}
//
//@Observable
//final class LS: IUpdate {
//    var label = "GLOBAL ACTOR ISOLATION ON TYPE FUNCTION DECLARATION"
//
//    var date: Date = .now {
//        didSet {
//            print("didset: ", Thread.current)
//        }
//    }
//
//    @MainActor
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
// update:  <_NSMainThread: 0x60000170c000>{number = 1, name = main}
// internalUpdate:  <NSThread: 0x600001779380>{number = 8, name = (null)}
// didset:  <NSThread: 0x600001779380>{number = 8, name = (null)}

// conclusion:
// only function "update" is isolated,
// "internalUpdate" is not isolated due to it's async nature
// "didset" is also not isolated, due to it's sync call from internalUpdate
