//
//  DevelopersMenuVC.swift
//  TODO
//
//  Created by Vit K on 15.08.2021.
//  Copyright © 2021 Alexander Mink. All rights reserved.
//

import UIKit

class DevelopersMenuVC: UIViewController {

    
    @IBOutlet weak var rootView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var vitalyButtonsStackView: UIStackView!
    @IBOutlet weak var alexeyButtonsStackView: UIStackView!
    @IBOutlet weak var alexanderButtonsStackView: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let theme = Main.instance.themeService.getTheme()
        view.applyGradient(colours: [theme.backgroundColor, .mainBackground], startX: 0.5, startY: -1.2, endX: 0.5, endY: 0.7)
        rootView.layer.cornerRadius = 16
        stackView.layer.cornerRadius = 16
        rootView.layer.borderWidth = 2
        rootView.layer.borderColor = theme.interfaceColor.cgColor
        
//        MARK: - Vitaly
        let mailButton0 = UIButton()
        mailButton0.tag = 0
        mailButton0.setImage(UIImage(systemName: "envelope.open"), for: .normal)
        mailButton0.addTarget(self, action: #selector(mailToDeveloper), for: .touchUpInside)
        
        let vkButton0 = UIButton()
        vkButton0.tag = 0
        vkButton0.setImage(UIImage(systemName: "paperplane"), for: .normal)
        vkButton0.addTarget(self, action: #selector(linkToVK), for: .touchUpInside)
      
//        MARK: - Alexey
        let mailButton1 = UIButton()
        mailButton1.tag = 1
        mailButton1.setImage(UIImage(systemName: "envelope.open"), for: .normal)
        mailButton1.addTarget(self, action: #selector(mailToDeveloper), for: .touchUpInside)
        
        let vkButton1 = UIButton()
        vkButton1.tag = 1
        vkButton1.setImage(UIImage(systemName: "paperplane"), for: .normal)
        vkButton1.addTarget(self, action: #selector(linkToVK), for: .touchUpInside)
        
//        MARK: - Alexander
        let mailButton2 = UIButton()
        mailButton2.tag = 2
        mailButton2.setImage(UIImage(systemName: "envelope.open"), for: .normal)
        mailButton2.addTarget(self, action: #selector(mailToDeveloper), for: .touchUpInside)
        
        let vkButton2 = UIButton()
        vkButton2.tag = 2
        vkButton2.setImage(UIImage(systemName: "paperplane"), for: .normal)
        vkButton2.addTarget(self, action: #selector(linkToVK), for: .touchUpInside)
        
        
        vitalyButtonsStackView.addArrangedSubview(mailButton0)
        alexeyButtonsStackView.addArrangedSubview(mailButton1)
        alexanderButtonsStackView.addArrangedSubview(mailButton2)
        
        vitalyButtonsStackView.addArrangedSubview(vkButton0)
        alexeyButtonsStackView.addArrangedSubview(vkButton1)
        alexanderButtonsStackView.addArrangedSubview(vkButton2)
        
        vitalyButtonsStackView.layer.borderWidth = 1
        vitalyButtonsStackView.layer.borderColor = UIColor.blue.cgColor
        
    }
    
    @objc func mailToDeveloper(sender: UIButton) {
        var email = ""
        switch sender.tag {
        case 0:
            email = "karl_karlsson@bk.ru"
        case 1:
            email = "marlowe.wind@gmail.com"
        case 2:
            email = "alexander.mink1@gmail.com"
        default:
            break
        }
        if let url = URL(string: "mailto:\(email)") {
            UIApplication.shared.open(url)
        }
    }
    
    @objc func linkToVK(sender: UIButton) {
        var link = ""
        switch sender.tag {
        case 0:
            link = "https://vk.com/metttwilight"
        case 1:
            link = "https://vk.com/bloodpyro"
        case 2:
            link = "https://vk.com/alexandermink"
        default:
            break
        }
        guard let url = URL(string: link) else { return }
        UIApplication.shared.open(url)
    }
}
