//
//  QuestionViewController.swift
//  iQuiz
//
//  Created by Jerry CH Wu on 5/12/22.
//

import UIKit

class OptionTableViewCell:  UITableViewCell {
    @IBOutlet weak var optionLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            contentView.backgroundColor = UIColor.systemPurple
            optionLabel.textColor = UIColor.white
            optionLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        } else {
            contentView.backgroundColor = UIColor.white
            optionLabel.textColor = UIColor.black
            optionLabel.font = UIFont(name: "Charter", size: 15.0)
        }
    }
}

class QuestionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var quizQuestions : [Question] = []
    var questionIndex : Int = -1
    var options : [String] = []
    var selected : Int = -1
    var totalCorrectAnswers : Int = 0
    var totalAnsweredQuestions : Int = 0
    
    @IBOutlet weak var questionTitleLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var questionsTable: UITableView!
    @IBOutlet weak var submitBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionsTable.delegate = self
        questionsTable.dataSource = self
        questionTitleLabel.text = quizQuestions[questionIndex].text
        progressLabel.text = "\(questionIndex + 1) out of \(quizQuestions.count)"
        options = quizQuestions[questionIndex].answers
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let answerVC = segue.destination as! AnswerViewController
        answerVC.quizQuestions = quizQuestions
        answerVC.questionIndex = questionIndex
        answerVC.questionText = questionTitleLabel.text!
        answerVC.selectedAnswer = String(selected)
        answerVC.totalAnsweredQuestions = totalAnsweredQuestions
        answerVC.totalCorrectAnswers = totalCorrectAnswers
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selected = (tableView.indexPathForSelectedRow?.row)!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : OptionTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Option Cell") as! OptionTableViewCell
        cell.optionLabel.text = options[indexPath.row]
        return cell
    }
    
    @IBAction func submitBtnPressed(_ sender: Any) {
        if selected == -1 {
            let alertMessage = UIAlertController(title: "Error", message: "Please select answer", preferredStyle: .alert)
            alertMessage.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alertMessage, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "answerSegue", sender: self)
        }
    }
}
