//
//  QuizDataSource.swift
//  iQuiz
//
//  Created by Jerry CH Wu on 5/19/22.
//

import UIKit

class QuizDataSource: NSObject, UITableViewDataSource {
    var data : [Quiz] = []
    init(_ elements : [Quiz]) {
        data = elements
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Subject Cell") as! SubjectTableViewCell
        let currentData = data[indexPath.row]
        cell.titleLabel.text = currentData.title
        cell.textDescriptionLabel.text = currentData.desc
        cell.imageLabel.image = currentData.image
        return cell
    }
    

}
