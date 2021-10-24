//
//  RenderViewController.swift
//  Einstein-Scene
//
//  Created by Adam Wulf on 10/23/21.
//  Copyright © 2021 Milestone Made. All rights reserved.
//

import Foundation
import UIKit
import iosMath
import SwiftTex

class RenderViewController: UIViewController {

    let label = MTMathUILabel()
    @IBOutlet private var labelContainer: UIView!

    func appendLabel() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .systemBackground
        label.textColor = .label
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
