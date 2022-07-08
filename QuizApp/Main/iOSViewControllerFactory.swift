//
//  iOSViewControllerFactory.swift
//  QuizApp
//
//  Created by Željko Lučić on 7/8/22.
//

import UIKit
import QuizEngine

class iOSViewControllerFactory: ViewControllerFactory {
    
    private let options: [Question<String>: [String]]
    
    init(options: [Question<String>: [String]]) {
        self.options = options
    }
    
    func questionViewController(for question: Question<String>, answerCallback: @escaping ([String]) -> Void) -> UIViewController {
        guard let options = options[question] else {
            fatalError("Couldn't find options for question: \(question)")
        }
        
        return questionViewController(for: question, options: options, answerCallback: answerCallback)
    }
    
    private func questionViewController(for question: Question<String>, options: [String], answerCallback: @escaping ([String]) -> Void) -> UIViewController {
        switch question {
        case .singleAnswer(let value):
            return QuestionViewController(question: value, options: options) { _ in }
        case .multipleAnswer(let value):
            let viewController = QuestionViewController(question: value, options: options) { _ in }
            let _ = viewController.view
            viewController.tableView.allowsMultipleSelection = true
            return viewController
        }
    }
    
    func resultsViewController(for result: Result<Question<String>, [String]>) -> UIViewController {
        return UIViewController()
    }
    
}
