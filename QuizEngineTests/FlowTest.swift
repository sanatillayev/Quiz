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
    
    let router = RouterSpy()

    
    func test_start_withNoQuestion_doesNotRouteToQuestion() {
        makeSUT(forQ:[]).start()

        XCTAssertTrue(router.routedQuestions.isEmpty)
    }
    
    func test_start_withOneQuestion_routeToCorrectQuestion() {
        makeSUT(forQ:["Q1"]).start()

        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    func test_start_withTwoQuestions_routeToFirstQuestion() {
        makeSUT(forQ: ["Q1","Q2"]).start()

        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    func test_startTwice_withTwoQuestions_routeToFirstQuestionTwice() {
        makeSUT(forQ: ["Q1","Q2"]).start()
        makeSUT(forQ: ["Q1","Q2"]).start()

        XCTAssertEqual(router.routedQuestions, ["Q1", "Q1"])
    }
    
    func test_startAndAnswerFirstAndSecondQuestion_withThreeQuestions_routeToSecondAndThirdQuestion() {
        let sut = Flow(questions: ["Q1","Q2", "Q3"], router: router)

        sut.start()
        router.answerCallBack("A1")
        router.answerCallBack("A2")


        XCTAssertEqual(router.routedQuestions, ["Q1", "Q2", "Q3"])
    }
    
    func test_startAndAnswerFirstQuestion_withOneQuestions_doesNotRouteToAnotherQuestion() {
        makeSUT(forQ: ["Q1"]).start()
        router.answerCallBack("A1")

        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    func test_start_withNoQuestion_routesToResult() {
        makeSUT(forQ:[]).start()

        XCTAssertEqual(router.routedResult!, [:])
    }
    
    func test_start_withOneQuestion_doesNotRouteToResult() {
        makeSUT(forQ: ["Q1"]).start()
        // result must be nil when user not answered
        XCTAssertNil(router.routedResult)
    }
    
    func test_startAndAnswerFirstQuestion_withTwoQuestion_doesNotRouteToResult() {
        let sut = makeSUT(forQ: ["Q1", "Q2"])
        sut.start()
        
        router.answerCallBack("A1")

        XCTAssertNil(router.routedResult)
    }
    
    func test_startAndAnswerFirstAndSecondQuestion_withTwoQuestion_routesToResult() {
        let sut = makeSUT(forQ: ["Q1", "Q2"])
        sut.start()
        
        router.answerCallBack("A1")
        router.answerCallBack("A2")

        XCTAssertEqual(router.routedResult, ["Q1":"A1","Q2":"A2"])
    }
    
    
    // MARK: - Helpers
    func makeSUT(forQ questions: [String]) -> Flow {
        // sut - "system under test" or out - object under test
        return Flow(questions: questions, router: router)
    }
    
    class RouterSpy: Router {
        var routedQuestions: [String] = []
        var answerCallBack: Router.AnswerCallBack = { _ in }
        var routedResult: [String:String]? = nil
        
        func routeTo(question: String, answerCallBack: @escaping Router.AnswerCallBack){
            routedQuestions.append(question)
            self.answerCallBack = answerCallBack
        }
        
        func routeTo(result: [String : String]) {
            routedResult = result
            print(result)
        }

    }
}
