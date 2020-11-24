//
//  MainTableViewController.swift
//  TODO
//
//  Created by Александр Минк on 19.10.2020.
//  Copyright © 2020 Alexander Mink. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Main"

class GeneralTableViewController: UITableViewController {
    
    private let main = Main()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        main.addTask(id: 1, name: "Задание1", date: Date())
        main.addTask(id: 2, name: "Задание2", date: Date())
        main.addTask(id: 3, name: "Задание3", date: Date())
        
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return main.userSession?.tasks.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MainTableViewCell

        
        cell.tasksNameLabel.text = main.userSession?.tasks[indexPath.row].name
        cell.tasksIconImageView.image = UIImage()
         

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            main.userSession?.tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}
