//
//  GeneralTableViewCell.swift
//  TODO
//
//  Created by Александр Минк on 19.10.2020.
//  Copyright © 2020 Alexander Mink. All rights reserved.
//

import UIKit

class GeneralTableViewCell: UITableViewCell {
    
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var notificationLabel: UILabel!
    
    var styleEditing = true
}
