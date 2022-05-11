//
//  Quiz.swift
//  iQuiz
//
//  Created by Jerry CH Wu on 5/10/22.
//

import Foundation
import UIKit

class Quiz {
    var title = ""
    var description = ""
    var image = UIImage()
    
    init(title: String, description: String, image: UIImage) {
        self.title = title
        self.description = description
        self.image = image
    }
}
