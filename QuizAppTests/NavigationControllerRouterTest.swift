//
//  NavigationControllerRouterTest.swift
//  QuizAppTests
//
//  Created by Željko Lučić on 7/7/22.
//

import Foundation
import XCTest
@testable import QuizApp 

class NavigationControllerRouterTest: XCTestCase {
    
    let navigationController = FakeNavigationController()
    let factory = ViewControllerFactoryStub()
    
    func test_routeToQuestion_presentsQuestionController() {
        let viewController = UIViewController()
        let secondViewController = UIViewController()
        
        factory.stub(question: "Q1", with: viewController)
        factory.stub(question: "Q2", with: secondViewController)
        
        let sut = NavigationControllerRouter(navigationController, factory: factory)
        
        sut.routeTo(question: "Q1", answerCallback: { _ in })
        sut.routeTo(question: "Q2", answerCallback: { _ in })
        
        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertEqual(navigationController.viewControllers.first, viewController)
        XCTAssertEqual(navigationController.viewControllers.last, secondViewController)
    }
    
    func test_routeToQuestion_presentsQuestionControllerWithRightCallback() {
        let sut = NavigationControllerRouter(navigationController, factory: factory)
        
        var callbackWasFired = false
        sut.routeTo(question: "Q1", answerCallback: { _ in callbackWasFired = true })
        factory.answerCallback["Q1"]!("anything")
        
        XCTAssertTrue(callbackWasFired)
    }
    
    // MARK: - Helpers
    
    class FakeNavigationController: UINavigationController {
        override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            // Since the animation takes about 0.3 seconds, and we want to have animation in our production code, we change the behavior of UINavigationController only for our tests
            super.pushViewController(viewController, animated: false)
        }
    }
    
    class ViewControllerFactoryStub: ViewControllerFactory {
        
        private var stubbedQuestions = [String: UIViewController]()
        var answerCallback = [String: (String) -> Void]()
        
        func stub(question: String, with viewController: UIViewController) {
            stubbedQuestions[question] = viewController
        }
        
        func questionViewController(for question: String, answerCallback: @escaping (String) -> Void) -> UIViewController {
            self.answerCallback[question] = answerCallback
            return stubbedQuestions[question] ?? UIViewController()
        }
        
    }
    
}
