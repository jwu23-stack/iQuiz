//
//  ViewController.swift
//  iQuiz
//
//  Created by Jerry CH Wu on 5/10/22.
//

import UIKit
import SystemConfiguration

struct Category: Codable {
    let title: String
    let desc: String
    let questions: [Question]
}

class Question: Codable {
    var text : String
    var answer : String
    var answers : [String]
    
    init(text: String, answer: String, answers: [String]) {
        self.text = text
        self.answer = answer
        self.answers = answers
    }
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate {
    var quizzes : [Quiz] = []
    
    var dataSource : QuizDataSource? = nil
    var defaultURLString = UserDefaults.standard.string(forKey: "fetch_url") ?? "http://tednewardsandbox.site44.com/questions.json"
    
    @IBOutlet weak var subjectTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subjectTable.delegate = self
        subjectTable.dataSource = self
        if UserDefaults.standard.string(forKey: "data") == nil {
            UserDefaults.standard.set("https://tednewardsandbox.site44.com/questions.json", forKey: "question_url")
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Reachability.isConnectedToNetwork(){
            fetchQuizzes(defaultURLString)
        } else {
            if UserDefaults().object(forKey: "data") == nil {
                self.showDownloadFailed()
            } else {
                // Get data from saved userdefaults
                let data = UserDefaults().object(forKey: "data") as! Data
                let categories = try! JSONDecoder().decode([Category].self, from: data)
                let fetchedQuizzes : [Quiz] = self.convertJSONToQuizzes(categories)
                DispatchQueue.main.async{
                    self.quizzes = fetchedQuizzes
                    self.dataSource = QuizDataSource(self.quizzes)
                    self.subjectTable.dataSource = self.dataSource
                    self.subjectTable.reloadData()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let categoryPath = subjectTable.indexPathForSelectedRow {
            let categoryIndex = categoryPath.row
            let questionVC = segue.destination as! QuestionViewController
            questionVC.quizQuestions = quizzes[categoryIndex].questions
            questionVC.questionIndex = 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizzes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : SubjectTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Subject Cell") as! SubjectTableViewCell
        cell.titleLabel.text = quizzes[indexPath.row].title
        cell.textDescriptionLabel.text = quizzes[indexPath.row].desc
        cell.imageLabel.image = quizzes[indexPath.row].image
        return cell
    }
    
    func fetchQuizzes(_ fetchURLString : String) {
        guard let url = URL.init(string: fetchURLString) else {
            return
        }
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            if response == nil {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error", message: "No response received!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(_) in
                        self.subjectTable.refreshControl?.endRefreshing()
                    }))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
            }
            if response != nil {
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode != 200 {
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Error", message: "Connection error: \(httpResponse.statusCode)", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(_) in
                                self.subjectTable.refreshControl?.endRefreshing()
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                        return
                    }
                }
            }
            guard let data = data else {
                self.showURLFailed()
                return
            }
            guard let categories = try? JSONDecoder().decode([Category].self, from: data) else {
                self.showURLFailed()
                return
            }
            UserDefaults.standard.set(data, forKey: "data") // Saved for offline use
            let fetchedQuizzes : [Quiz] = self.convertJSONToQuizzes(categories)
            DispatchQueue.main.async{
                self.quizzes = fetchedQuizzes
                self.dataSource = QuizDataSource(self.quizzes)
                self.subjectTable.dataSource = self.dataSource
                self.subjectTable.reloadData()
            }
        }
        session.resume()
    }
    
    func convertJSONToQuizzes (_ categories: [Category]) -> [Quiz] {
        var result : [Quiz] = []
        for category in categories {
            var questionList : [Question] = []
            for question in category.questions {
                questionList.append(Question(text: question.text, answer: question.answer, answers: question.answers))
            }
            result.append(Quiz(title: category.title, description: category.desc, questions: questionList))
        }
        return result
    }
    
    @objc private func refreshData(_ sender : Any) {
            defaultURLString = UserDefaults().object(forKey: "fetch_url") as? String ?? "https://tednewardsandbox.site44.com/questions.json"
            if !Reachability.isConnectedToNetwork(){
                showDownloadFailed()
            } else {
               fetchQuizzes(defaultURLString)
        }
    }
    
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue) {
        print("Unwinding Segue")
    }
    
    @IBAction func displaySettings(_ sender: Any) {
        let alert = UIAlertController(title: "Settings", message: "Grab data from URL", preferredStyle: .alert)
        alert.addTextField {(textField) in
            textField.placeholder = "Enter new URL to retrieve data"
        }
        alert.addAction(UIAlertAction(title: "Check now", style: .default, handler: { [weak alert] (_) in
            self.fetchQuizzes(alert!.textFields![0].text!)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in return }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Error handling / Error messages
    func showURLFailed() {
        let alert = UIAlertController(title: "Download Failed", message: "Please enter a URL that has a valid quiz database.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showDownloadFailed() {
        let alert = UIAlertController(title: "Download Failed", message: "Please check your internet connection and try again later.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
   
}

