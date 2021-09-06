//
//  TestVC.swift
//  TODO
//
//  Created by Vit K on 15.08.2021.
//  Copyright © 2021 Alexander Mink. All rights reserved.
//

import UIKit

class TestVC: UIViewController {
    
    let data = DevelopersViewBuilder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let theme = Main.instance.themeService.getTheme()
        view.applyGradient(colours: [theme.backgroundColor, .mainBackground], startX: 0.5, startY: -1.2, endX: 0.5, endY: 0.7)
        
//        MARK: - FIRST
        let fir = Shadow()
        data.makeParentView(view, fir, xDef: 9, yDef: 2, xSE: 7.5, ySE: 3.2)
        let firRound = Rounding()
        data.makeRoundingView(firRound, parent: fir)
        let firIm = UIImageView()
        data.makeImageView(firIm, parent: fir)
        let firBlur = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        data.makeBlurView(firBlur, parent: fir, c: .systemYellow)
        let firStack = UIStackView()
        data.makeMainStack(firStack, parent: fir)
        let firLabel = UILabel()
        let firLabel2 = UILabel()
        data.makeLabels(firLabel, "karl_karlsson@bk.ru")
        data.makeLabels(firLabel2, "https://vk.com/metttwilight")
        let firBStack = UIStackView()
        let firLStack = UIStackView()
        data.makeButtonsStack(firBStack, firLStack, parent: firStack, [data.makeMailButton(0), data.makeVKButton(0)], [firLabel, firLabel2])
        fir.addSubview(data.makeNameLabel(fir, "Виталий Кулагин"))
        
//        MARK: - SECOND
        let sec = Shadow()
        data.makeParentView(view, sec, xDef: 2.1, yDef: 2, xSE: -150, ySE: 1.5)
        sec.center = CGPoint(x: view.frame.width / 2 - 20, y: view.frame.height / 2)
        let secRound = Rounding()
        data.makeRoundingView(secRound, parent: sec)
        let secIm = UIImageView()
        data.makeImageView(secIm, parent: sec)
        let secBlur = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        data.makeBlurView(secBlur, parent: sec, c: .alexeyInterface)
        let secStack = UIStackView()
        data.makeMainStack(secStack, parent: sec)
        let secLabel = UILabel()
        let secLabel2 = UILabel()
        data.makeLabels(secLabel, "marlowe.wind@gmail.com")
        data.makeLabels(secLabel2, "https://vk.com/bloodpyro")
        let secBStack = UIStackView()
        let secLStack = UIStackView()
        data.makeButtonsStack(secBStack, secLStack, parent: secStack, [data.makeMailButton(1), data.makeVKButton(1)], [secLabel, secLabel2])
        sec.addSubview(data.makeNameLabel(sec, "Алексей Мальков"))
        
//        MARK: - THIRD
        let thi = Shadow()
        data.makeParentView(view, thi, xDef: 10, yDef: 0.8, xSE: 10, ySE: 0.95)
        let thiRound = Rounding()
        data.makeRoundingView(thiRound, parent: thi)
        let thiIm = UIImageView()
        data.makeImageView(thiIm, parent: thi)
        let thiBlur = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        data.makeBlurView(thiBlur, parent: thi, c: .red)
        let thiStack = UIStackView()
        data.makeMainStack(thiStack, parent: thi)
        let thiLabel = UILabel()
        let thiLabel2 = UILabel()
        data.makeLabels(thiLabel, "alexander.mink1@gmail.com")
        data.makeLabels(thiLabel2, "https://vk.com/alexandermink")
        let thiBStack = UIStackView()
        let thiLStack = UIStackView()
        data.makeButtonsStack(thiBStack, thiLStack, parent: thiStack, [data.makeMailButton(2), data.makeVKButton(2)], [thiLabel, thiLabel2])
        thi.addSubview(data.makeNameLabel(thi, "Александр Минк"))
        
        let backItem = UIBarButtonItem()
        backItem.title = "Настройки"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backItem
    }
}
