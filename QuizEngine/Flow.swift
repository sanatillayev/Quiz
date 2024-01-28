//
//  Flow.swift
//  QuizEngine
//
//  Created by Bilol Sanatillayev on 28/01/24.
//

import Foundation

protocol Router {
    func routeTo(question: String, answerCallBack: @escaping (String) -> Void)
}
class Flow {
    let router: Router
    let questions: [String]
    
    init(questions: [String], router: Router) {
        self.questions = questions
        self.router = router
    }
    
    func start() {
        if let firstQuestion = questions.first {
            router.routeTo(question: firstQuestion) { [weak self] _ in
                guard let stronSelf = self else { return }
                guard let firstQuestionIndex = stronSelf.questions.firstIndex(of: firstQuestion) else { return }
                let secondQuestion = stronSelf.questions[firstQuestionIndex+1]
                stronSelf.router.routeTo(question: secondQuestion){ _ in}
            }
        }
    }
}
