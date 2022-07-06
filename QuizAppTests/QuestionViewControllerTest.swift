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
    
    func test_viewDidLoad_rendersOptions() {
        XCTAssertEqual(makeSut(options: []).tableView.numberOfRows(inSection: 0), 0)
        XCTAssertEqual(makeSut(options: ["A1"]).tableView.numberOfRows(inSection: 0), 1)
        XCTAssertEqual(makeSut(options: ["A1", "A2"]).tableView.numberOfRows(inSection: 0), 2)
    }
    
    func test_viewDidLoad_rendersOptionsText() {
        XCTAssertEqual(makeSut(options: ["A1", "A2"]).tableView.title(at: 0), "A1")
        XCTAssertEqual(makeSut(options: ["A1", "A2"]).tableView.title(at: 1), "A2")
    }
    
    func test_optionSelected_withSingleSelection_notifiesDelegateWithLastSelection() {
        var receivedAnswers = [String]()
        let sut = makeSut(options: ["A1", "A2"]) {
            receivedAnswers = $0
        }
        
        sut.tableView.select(row: 0)
        XCTAssertEqual(receivedAnswers, ["A1"])
        
        sut.tableView.select(row: 1)
        XCTAssertEqual(receivedAnswers, ["A2"])
    }
    
    func test_optionDeselected_withSingleSelection_doesNotNotifyDelegateWithEmptySelection() {
        var callbackCount = 0
        let sut = makeSut(options: ["A1", "A2"]) { _ in
            callbackCount += 1
        }
        
        sut.tableView.select(row: 0)
        XCTAssertEqual(callbackCount, 1)
        
        sut.tableView.deselect(row: 0)
        XCTAssertEqual(callbackCount, 1)
    }
    
    func test_optionSelected_withMultipleSelectionEnabled_notifiesDelegateSelection() {
        var receivedAnswers = [String]()
        let sut = makeSut(options: ["A1", "A2"]) {
            receivedAnswers = $0
        }

        sut.tableView.allowsMultipleSelection = true 
        
        sut.tableView.select(row: 0)
        XCTAssertEqual(receivedAnswers, ["A1"])

        sut.tableView.select(row: 1)
        XCTAssertEqual(receivedAnswers, ["A1", "A2"])
    }
    
    func test_optionDeselected_withMultipleSelectionEnabled_notifiesDelegate() {
        var receivedAnswers = [String]()
        let sut = makeSut(options: ["A1", "A2"]) {
            receivedAnswers = $0
        }

        sut.tableView.allowsMultipleSelection = true
        
        sut.tableView.select(row: 0)
        XCTAssertEqual(receivedAnswers, ["A1"])

        sut.tableView.deselect(row: 0)
        XCTAssertEqual(receivedAnswers, [])
    }
    
    // MARK: - Helpers
    
    private func makeSut(question: String = "", options: [String] = [], selection: @escaping ([String]) -> Void = { _ in }) -> QuestionViewController {
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
        selectRow(at: indexPath, animated: false, scrollPosition: .none)
        delegate?.tableView?(self, didSelectRowAt: indexPath)
    }
    
    func deselect(row: Int) {
        let indexPath = IndexPath(row: row, section: 0)
        deselectRow(at: indexPath, animated: false)
        delegate?.tableView?(self, didDeselectRowAt: indexPath)
    }
    
}
