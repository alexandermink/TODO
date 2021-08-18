//
//  TestVC.swift
//  TODO
//
//  Created by Vit K on 15.08.2021.
//  Copyright © 2021 Alexander Mink. All rights reserved.
//

import UIKit

class TestVC: UIViewController {

    @IBOutlet weak var first: UIView!
    @IBOutlet weak var second: UIView!
    @IBOutlet weak var third: UIView!
    
    @IBOutlet weak var firstIm: UIImageView!
    @IBOutlet weak var firstSh: UIView!
    @IBOutlet weak var firstBlur: UIVisualEffectView!
    @IBOutlet weak var secondSh: Rounding!
    @IBOutlet weak var thirdSh: Rounding!
    @IBOutlet weak var secondIm: UIImageView!
    @IBOutlet weak var thirdIm: UIImageView!
    @IBOutlet weak var secondBlur: UIVisualEffectView!
    @IBOutlet weak var thirdBlur: UIVisualEffectView!
    @IBOutlet weak var vitalyButtonStack: UIStackView!
    
    
    @IBOutlet weak var firstX: NSLayoutConstraint!
    @IBOutlet weak var firstY: NSLayoutConstraint!
    @IBOutlet weak var firstW: NSLayoutConstraint!
    @IBOutlet weak var firstH: NSLayoutConstraint!
    
    
    
    
    @IBOutlet weak var secondX: NSLayoutConstraint!
    @IBOutlet weak var secondY: NSLayoutConstraint!
    @IBOutlet weak var thirdY: NSLayoutConstraint!
    @IBOutlet weak var thirdX: NSLayoutConstraint!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let theme = Main.instance.themeService.getTheme()
        view.applyGradient(colours: [theme.backgroundColor, .mainBackground], startX: 0.5, startY: -1.2, endX: 0.5, endY: 0.7)
        
        firstIm.layer.cornerRadius = 16
        firstSh.layer.cornerRadius = 16
        firstBlur.layer.cornerRadius = 16
        firstIm.alpha = 0.8
        
        secondIm.layer.cornerRadius = 16
        secondSh.layer.cornerRadius = 16
        secondBlur.layer.cornerRadius = 16
        secondIm.alpha = 0.8
        
        thirdIm.layer.cornerRadius = 16
        thirdSh.layer.cornerRadius = 16
        thirdBlur.layer.cornerRadius = 16
        thirdIm.alpha = 0.8
        
        first.layer.cornerRadius = 16
        second.layer.cornerRadius = 16
        third.layer.cornerRadius = 16
        
        first.layer.borderWidth = 1
        second.layer.borderWidth = 1
        third.layer.borderWidth = 1
        
        first.layer.borderColor = UIColor.darkGray.cgColor
        second.layer.borderColor = UIColor.darkGray.cgColor
        third.layer.borderColor = UIColor.darkGray.cgColor
        
        first.layer.shadowColor = UIColor.black.cgColor
        second.layer.shadowColor = UIColor.black.cgColor
        third.layer.shadowColor = UIColor.black.cgColor
        
        first.layer.shadowRadius = 8
        second.layer.shadowRadius = 8
        third.layer.shadowRadius = 8
        
        first.layer.shadowOffset = CGSize(width: -6, height: -6)
        second.layer.shadowOffset = CGSize(width: -6, height: -6)
        third.layer.shadowOffset = CGSize(width: -6, height: -6)
        
        first.layer.shadowOpacity = 1
        second.layer.shadowOpacity = 1
        third.layer.shadowOpacity = 1
        
        first.backgroundColor = UIColor.systemYellow.withAlphaComponent(0.7)
        second.backgroundColor = UIColor.alexeyInterface.withAlphaComponent(0.7)
        third.backgroundColor = UIColor.red.withAlphaComponent(0.7)
        
        
        
//        MARK: - Vitaly
        let mailButton0 = UIButton()
        mailButton0.tag = 0
        mailButton0.tintColor = .lightGray
        mailButton0.setImage(UIImage(systemName: "envelope.open"), for: .normal)
        mailButton0.addTarget(self, action: #selector(mailToDeveloper), for: .touchUpInside)
        
        let vkButton0 = UIButton()
        vkButton0.tag = 0
        vkButton0.tintColor = .lightGray
        vkButton0.setImage(UIImage(systemName: "paperplane"), for: .normal)
        vkButton0.addTarget(self, action: #selector(linkToVK), for: .touchUpInside)
        
        vitalyButtonStack.addArrangedSubview(mailButton0)
//        alexeyButtonsStackView.addArrangedSubview(mailButton1)
//        alexanderButtonsStackView.addArrangedSubview(mailButton2)
        
        vitalyButtonStack.addArrangedSubview(vkButton0)
//        alexeyButtonsStackView.addArrangedSubview(vkButton1)
//        alexanderButtonsStackView.addArrangedSubview(vkButton2)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        let width = view.frame.size.width
        let height = view.frame.size.height
        
        firstX.constant = 20
        firstY.constant = -width / 2
        firstW.constant = width - 60
        firstH.constant = width / 2
        
        
        
        
        
        second.frame = CGRect(x: 0, y: 0, width: width / 2, height: width / 1.7)
        second.center = view.center
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
        guard let url = URL(string: "mailto:\(email)") else { return }
        UIApplication.shared.open(url)
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
