import Foundation
import XCTest

extension XCTestCase {
    func waitForTruth(_ expression: @autoclosure @escaping () -> Bool,
                      timeout: TimeInterval,
                      file: String = #fileID,
                      function: String = #function,
                      line: Int = #line) {
        let exp = expectation(for: .init { _, _ in
            expression()
        }, evaluatedWith: nil, handler: nil)
        wait(for: [exp], timeout: timeout)
    }
}
