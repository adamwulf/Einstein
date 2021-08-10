//
//  PrimaryWindowController.swift
//  Einstein
//
//  Created by Adam Wulf on 4/18/21.
//  Copyright © 2021 Milestone Made. All rights reserved.
//

import Cocoa

class PrimaryWindowController: NSWindowController, NSWindowDelegate {

    var primaryViewController: PrimaryViewController {
        return contentViewController as! PrimaryViewController
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        /** NSWindows loaded from the storyboard will be cascaded
         based on the original frame of the window in the storyboard.
         */
        shouldCascadeWindows = true
    }


    // MARK: - Actions

    @IBAction func toggleSourceView(_ sender: NSToolbarItem) {
        primaryViewController.toggleSourceView(sender)
    }

    @IBAction func toggleEnvView(_ sender: NSToolbarItem) {
        primaryViewController.toggleEnvView(sender)
    }

    @IBAction func toggleRenderedView(_ sender: NSToolbarItem) {
        primaryViewController.toggleRenderedView(sender)
    }
}
