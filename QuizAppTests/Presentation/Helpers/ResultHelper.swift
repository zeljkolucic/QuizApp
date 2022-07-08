//
//  ResultHelper.swift
//  QuizAppTests
//
//  Created by Željko Lučić on 7/8/22.
//

import Foundation
@testable import QuizEngine

extension Result: Hashable {
    
    public var hashValue: Int {
        return 1
    }
    
    public static func ==(lhs: Result, rhs: Result) -> Bool {
        return lhs.score == rhs.score
    }
}
