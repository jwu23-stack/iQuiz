//
//  Quiz.swift
//  iQuiz
//
//  Created by Jerry CH Wu on 5/10/22.
//

import Foundation
import UIKit

class Quiz {
    var title : String = ""
    var desc : String = ""
    var image : UIImage = UIImage()
    var questions : [Question] = []
    
    init(title: String, description: String, questions: [Question]) {
        self.title = title
        self.desc = description
        self.image = UIImage(named: "Brain")!
        self.questions = questions
    }
}

protocol QuizRepository {
    func getQuizzes() -> [Quiz]
}
