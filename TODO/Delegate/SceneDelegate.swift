//
//  SceneDelegate.swift
//  TODO
//
//  Created by Александр Минк on 19.10.2020.
//  Copyright © 2020 Alexander Mink. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let mainViewContoller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "GeneralTableViewController") as! GeneralTableViewController
        
        let baseRouter = BaseRouter(viewController: mainViewContoller)
        mainViewContoller.router = baseRouter
        
        let theme = Main.instance.themeService.getTheme()
        let navigationController = CustomNavigationController(rootViewController: mainViewContoller)
        navigationController.navigationBar.tintColor = theme.interfaceColor
                
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        window!.applyGradient(colours: [theme.backgroundColor, .mainBackground], startX: 0.5, startY: -1.2, endX: 0.5, endY: 0.7)
        
        
        
//        Main.instance.state = "1"
//        switch Main.instance.themeService {
//        case "1":
//            window!.applyGradient(colours: [.interfaceColor, .mainBackground], startX: 0.5, startY: -1.2, endX: 0.5, endY: 0.7)
//        case "2":
//            window!.applyGradient(colours: [.alexeyFog, .mainBackground], startX: 0.5, startY: -1.2, endX: 0.5, endY: 0.7)
//        case "3":
//            window!.applyGradient(colours: [.alexRed, .mainBackground], startX: 0.5, startY: -1.2, endX: 0.5, endY: 0.7)
//        default:
//            break
//        }
    }
    
    

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

//func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//
//    guard let windowScene = (scene as? UIWindowScene) else { return }
//
////        let mainViewContoller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "GeneralTableViewController") as! GeneralTableViewController
//
//    let containerVC = ContainerViewController()
//
//    let baseRouter = BaseRouter(viewController: containerVC)
//    containerVC.router = baseRouter
//
////        let navigationController = UINavigationController(rootViewController: containerVC)
//
//    window = UIWindow(windowScene: windowScene)
//    window?.rootViewController = containerVC
//    window?.makeKeyAndVisible()
//}
