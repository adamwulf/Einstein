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

    var environmentViewController: EnvironmentViewController {
        return splitViewItems.compactMap({ $0.viewController as? EnvironmentViewController }).first!
    }

    override func splitView(_ splitView: NSSplitView, canCollapseSubview subview: NSView) -> Bool {
        return splitViewItems.reduce(into: 0, { $0 = $0 + ($1.isCollapsed ? 0 : 1)}) > 1
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

    // MARK: - Actions

    func isVisible(controller: NSViewController) -> Bool {
        guard let splitItem = splitViewItems.first(where: { $0.viewController == controller }) else { return false }
        return !splitItem.isCollapsed
    }

    @discardableResult func toggle(controller: NSViewController) -> Bool {
        guard let splitItem = splitViewItems.first(where: { $0.viewController == controller }) else { return false }
        splitItem.isCollapsed = !splitItem.isCollapsed
        return splitItem.isCollapsed
    }

    @IBAction func toggleSourceView(_ sender: NSToolbarItem) {
        guard !isVisible(controller: sourceViewController) || splitView(splitView, canCollapseSubview: sourceViewController.view) else { return }
        let hidden = toggle(controller: sourceViewController)
        if hidden {
            sender.image = NSImage(systemSymbolName: "scroll", accessibilityDescription: nil)
        } else {
            sender.image = NSImage(systemSymbolName: "scroll.fill", accessibilityDescription: nil)
        }
    }

    @IBAction func toggleEnvView(_ sender: NSToolbarItem) {
        guard !isVisible(controller: environmentViewController) || splitView(splitView, canCollapseSubview: environmentViewController.view) else { return }
        let hidden = toggle(controller: environmentViewController)
        if hidden {
            sender.image = NSImage(systemSymbolName: "leaf", accessibilityDescription: nil)
        } else {
            sender.image = NSImage(systemSymbolName: "leaf.fill", accessibilityDescription: nil)
        }
    }

    @IBAction func toggleRenderedView(_ sender: NSToolbarItem) {
        guard !isVisible(controller: renderedViewController) || splitView(splitView, canCollapseSubview: renderedViewController.view) else { return }
        let hidden = toggle(controller: renderedViewController)
        if hidden {
            sender.image = NSImage(systemSymbolName: "doc.richtext", accessibilityDescription: nil)
        } else {
            sender.image = NSImage(systemSymbolName: "doc.richtext.fill", accessibilityDescription: nil)
        }
    }
}

extension PrimaryViewController: SourceViewControllerDelegate {
    func didParse(mathAst: [ExprNode]) {
        renderedViewController.render(mathAst: mathAst)
    }
}
