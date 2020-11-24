//
//  GeneralTableViewController.swift
//  TODO
//
//  Created by Александр Минк on 19.10.2020.
//  Copyright © 2020 Alexander Mink. All rights reserved.
//

import UIKit
import RealmSwift

private let reuseIdentifier = "GeneralCell"

class GeneralTableViewController: UITableViewController {
    
    private let main = Main()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        main.addTask(id: 1, name: "Задание1", date: Date())
//        main.addTask(id: 2, name: "Задание2", date: Date())
//        main.addTask(id: 3, name: "Задание3", date: Date())
        self.main.getTasksFromRealm()
        self.tableView.reloadData()
        
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.main.userSession.tasks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! GeneralTableViewCell
        
        
        cell.selectedBackgroundView = {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: cell.frame.size.width, height: cell.frame.size.height))
            view.backgroundColor = hexStringToUIColor(hex: "#fcdab7")
            return view
        }()
        cell.tasksNameLabel.text = main.userSession.tasks[indexPath.row].name
        cell.tasksIconImageView.image = UIImage(systemName: "pencil.circle.fill")
         

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.main.deleteTask(indexPathTask: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    @IBAction func addNewTask(_ sender: UIBarButtonItem) {
        main.addTask(id: main.userSession.tasks.count, name: "Задание по плюсику id:\(main.userSession.tasks.count + 1)", date: Date())
        self.tableView.reloadData()
    }
    
    
    
    
    //Функция для преобразования hex кода в UIColor
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

}
