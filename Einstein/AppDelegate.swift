//
//  AppDelegate.swift
//  Einstein
//
//  Created by Adam Wulf on 4/13/21.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        Logging.initialize()
        Logging.info("asdfadfs")
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

