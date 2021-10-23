//
//  DocumentViewController.swift
//  Einstein-Scene
//
//  Created by Adam Wulf on 10/23/21.
//  Copyright © 2021 Milestone Made. All rights reserved.
//

import UIKit

class DocumentViewController: UISplitViewController {

    var sourceController: SourceViewController {
        return viewControllers.compactMap({ $0 as? SourceViewController }).first!
    }

    var file: URL?
    var sceneDelegate: SceneDelegate {
        return view.window!.windowScene!.delegate as! SceneDelegate
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        if let file = file,
           file.startAccessingSecurityScopedResource() {
            guard let data = FileManager.default.contents(atPath: file.path) else { return }
            file.stopAccessingSecurityScopedResource()

            guard let str = String(data: data, encoding: .utf8) else { return }

            sourceController.editorView.text = str
        }
    }

    @IBAction func didTapButton() {
        print("foo")
    }
}
