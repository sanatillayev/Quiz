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
        XCTAssertEqual(router.routedQuestionCount, 0)
    }
    
    func test_start_withOneQuestion_routeToQuestion() {
        let router = RouterSpy()
        let sut = Flow(questions: ["Q1"], router: router)

        sut.start()

        XCTAssertEqual(router.routedQuestionCount, 1)
    }
    
    func test_start_withOneQuestion_routeToCorrectQuestion() {
        let router = RouterSpy()
        let sut = Flow(questions: ["Q1"], router: router)

        sut.start()

        XCTAssertEqual(router.routedQuestionCount, 1)
    }
    
    class RouterSpy: Router {
        var routedQuestionCount: Int = 0
        var routedQuestion: String? = nil

        
        func routeTo(question: String){
            routedQuestionCount += 1
            routedQuestion = question
        }

    }
}
