//
//  FinishedViewController.swift
//  iQuiz
//
//  Created by Jerry CH Wu on 5/15/22.
//

import UIKit

class FinishedViewController: UIViewController {
    
    var totalCorrectAnswers : Int = 0
    var totalAnsweredQuestions : Int = 0

    @IBOutlet weak var descriptiveText: UILabel!
    @IBOutlet weak var userScore: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userScore.text = "\(totalCorrectAnswers) of \(totalAnsweredQuestions) correct"
        var userResult : String = ""
        print(totalCorrectAnswers)
        switch totalAnsweredQuestions - totalCorrectAnswers {
        case 0:
            userResult = "Perfect!"
        case 1:
            userResult = "Almost!"
        default:
            userResult = "Not Bad"
        }
        descriptiveText.text = userResult
    }
}
