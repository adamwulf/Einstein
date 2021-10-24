//
//  RenderedViewController.swift
//  Einstein
//
//  Created by Adam Wulf on 4/18/21.
//  Copyright © 2021 Milestone Made. All rights reserved.
//

import Foundation
import SwiftTex
import iosMath

class RenderedViewController: NSViewController {

    var document: Document? {
        return representedObject as? Document
    }

    override var representedObject: Any? {
        get {
            return super.representedObject
        }
        set {
            assert(newValue is Document)
            super.representedObject = newValue

            // Pass down the represented object to all of the child view controllers.
            for child in children {
                child.representedObject = representedObject
            }
        }
    }

    let label = MTMathUILabel()
    @IBOutlet private var labelContainer: NSView!

    func appendLabel() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .textBackgroundColor
        label.textColor = .textColor
        label.textAlignment = .center
        labelContainer.addSubview(label)

        label.leadingAnchor.constraint(equalTo: labelContainer.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: labelContainer.trailingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: labelContainer.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: labelContainer.bottomAnchor).isActive = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        appendLabel()
    }

    func render(mathAst: [ExprNode]) {
        let printVisitor = PrintVisitor()
        let maths = mathAst.accept(visitor: printVisitor)

        label.latex = maths.joined(separator: "\\\\\n")
    }
}
