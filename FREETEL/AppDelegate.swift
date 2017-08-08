//
//  AppDelegate.swift
//  FREETEL
//
//  Created by Kazuya Ueoka on 2017/08/05.
//  Copyright © 2017 fromKK. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    lazy var tabBarController: UITabBarController = UITabBarController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.rootViewController = self.tabBarController
        window?.makeKeyAndVisible()
        
        self.requestAuthorization(with: CNContactStore.authorizationStatus(for: .contacts))
        
        return true
    }
    
    private func requestAuthorization(with status: CNAuthorizationStatus) {
        switch status {
        case .authorized:
            self.createViewControllers()
        case .denied, .restricted:
            break
        case .notDetermined:
            let store = CNContactStore()
            store.requestAccess(for: CNEntityType.contacts, completionHandler: { [weak self] (_, _) in
                DispatchQueue.main.async {
                    self?.requestAuthorization(with: CNContactStore.authorizationStatus(for: .contacts))
                }
            })
        }
    }
    
    private func createViewControllers() {
        
        let historyViewController = HistoryViewController()
        let historyNavigationController = UINavigationController(rootViewController: historyViewController)
        historyNavigationController.tabBarItem.title = "History"
        
        let dialViewController = DialViewController()
        let dialNavigationController = UINavigationController(rootViewController: dialViewController)
        dialNavigationController.tabBarItem.title = "Dial"
        
        self.tabBarController.viewControllers = [historyNavigationController, dialNavigationController]
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}
