import SwiftUI

// NO GLOBAL ACTOR ISOLATION

protocol IUpdate {
    func update(date: Date) async
}


@Observable
final class LS: IUpdate {
    var label = "NO GLOBAL ACTOR ISOLATION"
    var date: Date = .now {
        didSet {
            print("didset: ", Thread.current)
        }
    }

    func update(date: Date) async {
        print("update: ", Thread.current)
        await internalUpdate(date: date)
    }
}


extension LS {
    private func internalUpdate(date: Date) async {
        print("internalUpdate: ", Thread.current)
        self.date = date
    }
}

// console output:
// update:  <NSThread: 0x600001767e80>{number = 8, name = (null)}
// internalUpdate:  <NSThread: 0x600001767e80>{number = 8, name = (null)}
// didset:  <NSThread: 0x600001767e80>{number = 8, name = (null)}

// conclusion:
// no isolation
