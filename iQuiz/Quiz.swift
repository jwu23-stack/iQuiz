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
    var description : String = ""
    var image : UIImage = UIImage()
    var questions : [Question] = []
    
    init(title: String, description: String, image: UIImage, questions: [Question]) {
        self.title = title
        self.description = description
        self.image = image
        self.questions = questions
    }
}
