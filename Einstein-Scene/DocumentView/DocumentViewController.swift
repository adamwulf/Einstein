//
//  DocumentViewController.swift
//  Einstein-Scene
//
//  Created by Adam Wulf on 10/23/21.
//  Copyright © 2021 Milestone Made. All rights reserved.
//

import UIKit
import SwiftTex

class DocumentViewController: UIViewController {

    var sourceController: SourceViewController? {
        return children.compactMap({ $0 as? SourceViewController }).first
    }

    var renderController: RenderViewController? {
        return children.compactMap({ $0 as? RenderViewController }).first
    }

    var content: ContentState?
    var file: URL? {
        get {
            return content?.url
        }
        set {
            if let val = newValue {
                content = ContentState(url: val)
                renderController?.render(mathAst: [])
                sourceController?.content = content
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
        sourceController?.delegate = self
        sourceController?.content = content
    }
}

extension DocumentViewController: SourceViewControllerDelegate {
    func didParse(mathAst: [ExprNode]) {
        renderController?.render(mathAst: mathAst)
    }
}
