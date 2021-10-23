//
//  AppDelegate.swift
//  Einstein-Scene
//
//  Created by Adam Wulf on 10/23/21.
//  Copyright © 2021 Milestone Made. All rights reserved.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        if let activity = options.userActivities.first,
           let userInfo = activity.userInfo,
           let urlStr = userInfo["url"] as? String,
           let url = URL(string: urlStr),
           url.isFileURL {
            if url.startAccessingSecurityScopedResource() {
                let data = FileManager.default.contents(atPath: url.path)
                url.stopAccessingSecurityScopedResource()
            }
            return UISceneConfiguration(name: "Document Configuration", sessionRole: connectingSceneSession.role)
        } else {
            return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
        }
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}
