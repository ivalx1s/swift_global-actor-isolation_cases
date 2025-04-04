import SwiftUI

// GLOBAL ACTOR ISOLATION ON TYPE FIELD DECLARATION

//protocol IUpdate {
//    func update(date: Date) async
//}
//
//@Observable
//final class LS: IUpdate {
//    var label = "GLOBAL ACTOR ISOLATION ON TYPE FIELD DECLARATION"
//
//    @MainActor
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
// no output, compile time error: Main actor-isolated property 'date' can not be mutated from a nonisolated context

// conclusion:
// "date" field is isolated, and we have to change it in it's isolation context
// "internalUpdate" is not isolated
