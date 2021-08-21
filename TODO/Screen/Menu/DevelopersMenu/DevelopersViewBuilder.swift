//
//  DevelopersViewBuilder.swift
//  TODO
//
//  Created by Vit K on 21.08.2021.
//  Copyright © 2021 Alexander Mink. All rights reserved.
//

import UIKit

class DevelopersViewBuilder {
    
    func makeParentView(_ superView: UIView, _ v: UIView, xDef: CGFloat, yDef: CGFloat, xSE: CGFloat, ySE: CGFloat) {
        switch UIDevice().type {
        case .iPhoneSE, .iPhoneSE2:
            v.frame = CGRect(x: superView.frame.width / xSE, y: superView.frame.width / ySE, width: superView.frame.width - 60, height: superView.frame.width / 2.2)
        default:
            v.frame = CGRect(x: superView.frame.width / xDef, y: superView.frame.width / yDef, width: superView.frame.width - 60, height: superView.frame.width / 2.2)
        }
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOpacity = 1
        v.layer.shadowRadius = 8
        v.layer.shadowOffset = CGSize(width: -4, height: -8)
        v.layer.borderWidth = 1
        v.layer.borderColor = UIColor.darkGray.cgColor
        v.layer.cornerRadius = 18
        superView.addSubview(v)
    }
    
    func makeRoundingView(_ v: UIView, parent: UIView) {
        v.frame = CGRect(x: 0, y: 0, width: parent.frame.width, height: parent.frame.height)
        v.layer.cornerRadius = 18
        v.backgroundColor = .clear
        v.clipsToBounds = true
        parent.addSubview(v)
    }
    
    func makeImageView(_ v: UIImageView, parent: UIView) {
        v.frame = CGRect(x: 0, y: 0, width: parent.frame.width, height: parent.frame.height)
        v.image = UIImage(named: "first")
        v.layer.cornerRadius = 18
        v.clipsToBounds = true
        parent.addSubview(v)
    }
    
    func makeBlurView(_ v: UIVisualEffectView, parent: UIView, c: UIColor) {
        v.frame = CGRect(x: 0, y: 0, width: parent.frame.width, height: parent.frame.height)
        v.layer.cornerRadius = 18
        v.alpha = 0.75
        v.backgroundColor = c.withAlphaComponent(0.2)
        v.clipsToBounds = true
        parent.addSubview(v)
    }
    
    func makeMainStack(_ v: UIStackView, parent: UIView) {
        v.frame = CGRect(x: 12, y: parent.frame.height / 4.2, width: parent.frame.width, height: parent.frame.height / 2.2)
        v.axis = .horizontal
        v.spacing = 12
        parent.addSubview(v)
    }
    
    func makeButtonsStack(_ vB: UIStackView, _ vL: UIStackView, parent: UIStackView, _ buttons: [UIButton], _ labels: [UILabel]) {
        vB.widthAnchor.constraint(equalToConstant: 46).isActive = true
        vB.axis = .vertical
        vL.axis = .vertical
        vL.alignment = .top
        buttons.forEach {vB.addArrangedSubview($0)}
        labels.forEach {vL.addArrangedSubview($0)}
        parent.addArrangedSubview(vB)
        parent.addArrangedSubview(vL)
        vB.distribution = .fillEqually
        vL.distribution = .fillEqually
    }
    
    func makeLabels(_ v: UILabel, _ text: String) {
        v.text = text
        v.textColor = .lightGray
        v.shadowColor = .black
        v.shadowOffset = CGSize(width: 2, height: 3)
        v.font = UIFont(name: "HelveticaNeue", size: 15)
    }
    
    func makeMailButton(_ tag: Int) -> UIButton {
        let mailButton = UIButton()
        mailButton.tag = tag
        mailButton.tintColor = .lightGray
        mailButton.setImage(UIImage(systemName: "envelope.open"), for: .normal)
        mailButton.addTarget(self, action: #selector(mailToDeveloper), for: .touchUpInside)
        mailButton.backgroundColor = .cyan.withAlphaComponent(0.3)
        return mailButton
    }
    
    func makeVKButton(_ tag: Int) -> UIButton {
        let vkButton = UIButton()
        vkButton.tag = tag
        vkButton.tintColor = .lightGray
        vkButton.setImage(UIImage(systemName: "paperplane"), for: .normal)
        vkButton.addTarget(self, action: #selector(linkToVK), for: .touchUpInside)
        vkButton.backgroundColor = .cyan.withAlphaComponent(0.2)
        return vkButton
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
    
    func makeNameLabel(_ v: UIView, _ text: String) -> UILabel {
        let name = UILabel()
        name.frame = CGRect(x: 18, y: 14, width: v.frame.width, height: 20)
        name.text = text
        name.textColor = .lightGray
        name.shadowColor = .black
        name.shadowOffset = CGSize(width: 2, height: 3)
        let font: UIFont = .systemFont(ofSize: 18, weight: .semibold)
        name.font = font
        return name
    }
}
