//
//  Flow.swift
//  QuizEngine
//
//  Created by Bilol Sanatillayev on 28/01/24.
//

import Foundation

protocol Router {
    typealias AnswerCallBack = (String) -> Void
    func routeTo(question: String, answerCallBack: @escaping (String) -> Void)
    func routeTo(result: [String:String])
}
class Flow {
    private let router: Router
    private let questions: [String]
    private var result: [String:String] = [:]
    
    init(questions: [String], router: Router) {
        self.questions = questions
        self.router = router
    }
    
    func start() {
        if let firstQuestion = questions.first {
            router.routeTo(question: firstQuestion, answerCallBack: nextCallback(from: firstQuestion))
        } else {
            router.routeTo(result: result)
        }
    }
    
    private func nextCallback(from question: String) -> Router.AnswerCallBack  {
        return { [weak self]  in self?.routeNext(question, $0) }
    }
    
    private func routeNext(_ question: String,_ answer: String) {
        guard let currentIndex = questions.firstIndex(of: question) else { return }
        result[question] = answer
        
        let nextQuestionIndex = currentIndex + 1
        if nextQuestionIndex < questions.count {
            let nextQuestion = questions[nextQuestionIndex]
            router.routeTo(question: nextQuestion, answerCallBack: nextCallback(from: nextQuestion))
        } else {
            router.routeTo(result: result)
        }
    }
}
