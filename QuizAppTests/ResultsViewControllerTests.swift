//
//  ResultsViewControllerTests.swift
//  QuizAppTests
//
//  Created by Željko Lučić on 7/7/22.
//

import Foundation
import XCTest
@testable import QuizApp

class ResultsViewControllerTests: XCTestCase {
    
    func test_viewDidLoad_renderSummary() {
        let sut = makeSut(summary: "Summary", answers: [])
        XCTAssertEqual(sut.headerLabel.text, "Summary")
    }
    
    func test_viewDidLoad_withoutAnswers_doesNotRenderAnswers() {
        let sut = makeSut(summary: "Summary", answers: [])
        
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 0)
    }
    
    func test_viewDidLoad_withOneAnswer_rendersOneAnswer() {
        let sut = makeSut(summary: "Summary", answers: ["A1"])
        
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 1)
    }
    
    // MARK: - Helpers
    
    private func makeSut(summary: String, answers: [String]) -> ResultsViewController {
        let sut = ResultsViewController(summary: summary, answers: answers)
        _ = sut.view
        return sut
    }
    
}
