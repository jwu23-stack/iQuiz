//
//  ViewController.swift
//  iQuiz
//
//  Created by Jerry CH Wu on 5/10/22.
//

import UIKit

class Question {
    var questionTitle : String = ""
    var option1 : String = ""
    var option2 : String = ""
    var option3 : String = ""
    var answer : String = ""
    
    init(questionTitle: String, option1: String, option2: String, option3: String, answer: String) {
        self.questionTitle = questionTitle
        self.option1 = option1
        self.option2 = option2
        self.option3 = option3
        self.answer = answer
    }
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var quizzes : [Quiz] = []
    
    @IBOutlet weak var subjectTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subjectTable.delegate = self
        subjectTable.dataSource = self
        createQuizzes()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let categoryPath = subjectTable.indexPathForSelectedRow {
            let categoryIndex = categoryPath.row
            let questionVC = segue.destination as! QuestionViewController
            questionVC.quizQuestions = quizzes[categoryIndex].questions
            questionVC.questionIndex = 0
        }
    }
    
    @IBAction func settingsAlert(_sender: Any) {
        let alertMessage = UIAlertController(title: "Settings", message: "Settings go here", preferredStyle: .alert)
        alertMessage.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alertMessage, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizzes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : SubjectTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Subject Cell") as! SubjectTableViewCell
        cell.titleLabel.text = quizzes[indexPath.row].title
        cell.textDescriptionLabel.text = quizzes[indexPath.row].description
        cell.imageLabel.image = quizzes[indexPath.row].image
        return cell
    }
    
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue) {
        print("Unwinding Segue")
    }
    
    func createQuizzes() {
        quizzes = [
            Quiz(title: "Mathematics", description: "Smart enough to answer these math questions?!", image: UIImage(named: "Math")!, questions: [Question(questionTitle: "What is 3 times 3?", option1: "6", option2: "33", option3: "8", answer: "9"), Question(questionTitle: "What is 4 plus 8", option1: "48", option2: "11", option3: "13", answer: "12")]),
            Quiz(title: "Marvel Super Heroes", description: "Test your superhero knowledge!", image: UIImage(named: "Marvel")!, questions: [Question(questionTitle: "Who is Iron Man?", option1: "George Washington", option2: "Ted Neward", option3: "Jeff", answer: "Tony Stark")]),
            Quiz(title: "Science", description: "Come test your knowledge with these science trivia!", image: UIImage(named: "Science")!, questions: [Question(questionTitle: "Which of these is the heaviest metal", option1: "Iron", option2: "Gold", option3: "Copper", answer: "Osmium")])
        ]
    }
}

