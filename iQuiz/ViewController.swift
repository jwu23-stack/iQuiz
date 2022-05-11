//
//  ViewController.swift
//  iQuiz
//
//  Created by Jerry CH Wu on 5/10/22.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var quizzes : [Quiz] = []
    
    @IBOutlet weak var subjectTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subjectTable.delegate = self
        subjectTable.dataSource = self
        createQuizzes()
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
    
    func createQuizzes() {
        quizzes = [
            Quiz(title: "Mathematics", description: "Smart enough to answer these math questions?!", image: UIImage(named: "Math")!),
            Quiz(title: "Marvel Super Heroes", description: "Test your superhero knowledge!", image: UIImage(named: "Marvel")!),
            Quiz(title: "Science", description: "Come test your knowledge with these science trivia!", image: UIImage(named: "Science")!)
        ]
    }


}

