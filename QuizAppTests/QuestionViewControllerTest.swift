//
//  QuestionViewControllerTest.swift
//  QuizAppTests
//
//  Created by Željko Lučić on 7/6/22.
//

import Foundation
import XCTest
@testable import QuizApp

class QuestionViewControllerTest: XCTestCase {
    
    func test_viewDidLoad_rendersQuestionHeaderText() {
        XCTAssertEqual(makeSut(question: "Q1").headerLabel.text, "Q1")
    }
    
    func test_viewDidLoad_withNoOptions_rendersOptions() {
        XCTAssertEqual(makeSut(options: []).tableView.numberOfRows(inSection: 0), 0)
        XCTAssertEqual(makeSut(options: ["A1"]).tableView.numberOfRows(inSection: 0), 1)
        XCTAssertEqual(makeSut(options: ["A1", "A2"]).tableView.numberOfRows(inSection: 0), 2)
    }
    
    func test_viewDidLoad_withOneOption_rendersOptionsText() {
        XCTAssertEqual(makeSut(options: ["A1", "A2"]).tableView.title(at: 0), "A1")
        XCTAssertEqual(makeSut(options: ["A1", "A2"]).tableView.title(at: 1), "A2")
    }
    
    func test_optionSelected_withTwoOptions_notifiesDelegateWithLastSelection() {
        var receivedAnswer = ""
        let sut = makeSut(options: ["A1", "A2"]) {
            receivedAnswer = $0
        }
        
        sut.tableView.select(row: 0)
        XCTAssertEqual(receivedAnswer, "A1")
        
        sut.tableView.select(row: 1)
        XCTAssertEqual(receivedAnswer, "A2")
    }
    
//    func test_optionSelected_withMultipleSelectionEnabled_notifiesDelegateSelection() {
//        var receivedAnswer = ""
//        let sut = makeSut(options: ["A1", "A2"]) {
//            receivedAnswer = $0
//        }
//
//        sut.tableView.select(row: 0)
//
//        sut.tableView.select(row: 1)
//    }
    
    // MARK: - Helpers
    
    private func makeSut(question: String = "", options: [String] = [], selection: @escaping (String) -> Void = { _ in }) -> QuestionViewController {
        let sut = QuestionViewController(question: question, options: options, selection: selection)
        _ = sut.view // viewDidLoad will be triggered when viewController's view is reffered
        return sut
    }
    
}

private extension UITableView {
    
    func cell(at row: Int) -> UITableViewCell? {
        let indexPath = IndexPath(row: row, section: 0)
        return dataSource?.tableView(self, cellForRowAt: indexPath)
    }
    
    func title(at row: Int) -> String? {
        return cell(at: row)?.textLabel?.text
    }
    
    func select(row: Int) {
        let indexPath = IndexPath(row: row, section: 0)
        delegate?.tableView?(self, didSelectRowAt: indexPath)
    }
    
}
