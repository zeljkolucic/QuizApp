//
//  ViewControllerFactory.swift
//  QuizApp
//
//  Created by Željko Lučić on 7/8/22.
//

import UIKit
import QuizEngine

protocol ViewControllerFactory {
    func questionViewController(for question: Question<String>, answerCallback: @escaping ([String]) -> Void) -> UIViewController
    
    func resultsViewController(for result: Result<Question<String>, [String]>) -> UIViewController
}
