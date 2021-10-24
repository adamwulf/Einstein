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

    var content: ContentState?
    var file: URL? {
        get {
            return content?.url
        }
        set {
            if let val = newValue {
                content = ContentState(url: val)
            } else {
                content = nil
            }
        }
    }

    var sceneDelegate: SceneDelegate {
        return view.window!.windowScene!.delegate as! SceneDelegate
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        sourceController.content = content
    }
}
