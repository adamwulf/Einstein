//
//  PrimaryViewController.swift
//  Einstein
//
//  Created by Adam Wulf on 4/18/21.
//  Copyright © 2021 Milestone Made. All rights reserved.
//

import AppKit
import SwiftTex

class PrimaryViewController: NSSplitViewController {

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

    override func viewDidLoad() {
        super.viewDidLoad()

        sourceViewController.delegate = self
    }

    var sourceViewController: SourceViewController {
        return splitViewItems.compactMap({ $0.viewController as? SourceViewController }).first!
    }

    var renderedViewController: RenderedViewController {
        return splitViewItems.compactMap({ $0.viewController as? RenderedViewController }).first!
    }

    override func splitView(_ splitView: NSSplitView, canCollapseSubview subview: NSView) -> Bool {
        return super.splitView(splitView, canCollapseSubview: subview)
    }

    override func splitView(_ splitView: NSSplitView, shouldHideDividerAt dividerIndex: Int) -> Bool {
        return false
    }

    override func splitView(_ splitView: NSSplitView,
                            effectiveRect proposedEffectiveRect: NSRect,
                            forDrawnRect drawnRect: NSRect,
                            ofDividerAt dividerIndex: Int) -> NSRect {
        return super.splitView(splitView, effectiveRect: proposedEffectiveRect, forDrawnRect: drawnRect, ofDividerAt: dividerIndex)
    }

    override func splitView(_ splitView: NSSplitView, additionalEffectiveRectOfDividerAt dividerIndex: Int) -> NSRect {
        return super.splitView(splitView, additionalEffectiveRectOfDividerAt: dividerIndex)
    }
}

extension PrimaryViewController: SourceViewControllerDelegate {
    func didParse(mathAst: [ExprNode]) {
        renderedViewController.render(mathAst: mathAst)
    }
}
