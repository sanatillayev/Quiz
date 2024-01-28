//
//  FlowTest.swift
//  QuizEngineTests
//
//  Created by Bilol Sanatillayev on 28/01/24.
//

import Foundation
import XCTest

@testable import QuizEngine // giving access to all internal types

// Naming Structure: test_UnitofWork_StateUnderTest_ExpectedBehavior
// Naming Structure: test_[struct or class]_[variable or function]_[expected result]
// Testing Structure: Given, When, Then

class FlowTest: XCTestCase {
    func test_start_withNoQuestion_doesNotRouteToQuestion() {
        // given
        // sut - "system under test" or out - object under test
        let router = RouterSpy()
        let sut = Flow(questions: [], router: router)
        
        // when
        sut.start()

        // then
        XCTAssertTrue(router.routedQuestions.isEmpty)
    }
    
    func test_start_withOneQuestion_routeToCorrectQuestion() {
        let router = RouterSpy()
        let sut = Flow(questions: ["Q1"], router: router)

        sut.start()

        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    func test_start_withTwoQuestions_routeToFirstQuestion() {
        let router = RouterSpy()
        let sut = Flow(questions: ["Q1","Q2"], router: router)

        sut.start()

        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    func test_startTwice_withTwoQuestions_routeToFirstQuestionTwice() {
        let router = RouterSpy()
        let sut = Flow(questions: ["Q1","Q2"], router: router)

        sut.start()
        sut.start()

        XCTAssertEqual(router.routedQuestions, ["Q1", "Q1"])
    }
    
    func test_startAndAnswerFirstQuestion_withTwoQuestions_routeToSecondQuestion() {
        let router = RouterSpy()
        let sut = Flow(questions: ["Q1","Q2"], router: router)

        sut.start()
        router.answerCallBack("A1")

        XCTAssertEqual(router.routedQuestions, ["Q1", "Q2"])
    }
    
    class RouterSpy: Router {
        var routedQuestions: [String] = []
        var answerCallBack: ((String) -> Void) = { _ in }
        
        func routeTo(question: String, answerCallBack: @escaping (String) -> Void){
            routedQuestions.append(question)
            self.answerCallBack = answerCallBack
        }

    }
}
