//
//  AnswerViewController.swift
//  iQuiz
//
//  Created by Jerry CH Wu on 5/15/22.
//

import UIKit

class AnswerViewController: UIViewController {
    
    var quizQuestions : [Question] = []
    var questionIndex : Int = -1
    var questionText : String = ""
    var selectedAnswer : String = ""
    var totalCorrectAnswers : Int = 0
    var totalAnsweredQuestions : Int = 0
    var finishQuiz : Bool = false
    
    @IBOutlet weak var correctOrIncorrectLabel: UILabel!
    @IBOutlet weak var questionTextLabel: UILabel!
    @IBOutlet weak var answerTextLabel: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentQuestionInQuiz : Question = quizQuestions[questionIndex]
        let correctAnswer : Int = Int(currentQuestionInQuiz.answer)! - 1 // change it to zero-based index
        
        // set UI elements
        questionTextLabel.text = questionText
        answerTextLabel.text = quizQuestions[questionIndex].answers[correctAnswer]
        
        // update question index in quizQuestions array and total answered questions
        questionIndex += 1
        totalAnsweredQuestions += 1
        
        // update correctOrIncorrectLabel based on selected answer
        if Int(selectedAnswer)! == correctAnswer {
            correctOrIncorrectLabel.text = "Correct"
            correctOrIncorrectLabel.textColor = UIColor.green
            totalCorrectAnswers += 1
        } else {
            correctOrIncorrectLabel.text = "Incorrect"
            correctOrIncorrectLabel.textColor = UIColor.red
        }
        
        // check if user has finished quiz
        if questionIndex == quizQuestions.count {
            finishQuiz = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToQuestionSegue" {
            let questionVC = segue.destination as! QuestionViewController
            questionVC.quizQuestions = self.quizQuestions
            questionVC.questionIndex = self.questionIndex
            questionVC.totalCorrectAnswers = self.totalCorrectAnswers
            questionVC.totalAnsweredQuestions = self.totalAnsweredQuestions
        } else if segue.identifier == "finishedSegue" {
            let finishedVC = segue.destination as! FinishedViewController
            finishedVC.totalCorrectAnswers = self.totalCorrectAnswers
            finishedVC.totalAnsweredQuestions = self.totalAnsweredQuestions
        }
    }
    
    @IBAction func nextBtnPressed(_ sender: Any) {
        if !finishQuiz {
            performSegue(withIdentifier: "backToQuestionSegue", sender: self)
        } else {
            performSegue(withIdentifier: "finishedSegue", sender: self)
        }
    }

}
