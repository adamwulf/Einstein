//
//  SourceViewController.swift
//  Einstein
//
//  Created by Adam Wulf on 4/13/21.
//

import Cocoa
import Sourceful
import SwiftTex
import IosMath

@objc protocol SourceViewControllerDelegateObjC { }

protocol SourceViewControllerDelegate: SourceViewControllerDelegateObjC {
    func didParse(mathAst: [ExprNode])
}

class SourceViewController: NSViewController {

    var document: Document? {
        return representedObject as? Document
    }

    override var representedObject: Any? {
        get {
            return super.representedObject
        }
        set {
            assert(newValue is Document)
            // clear out the undo manager from any document we were using before and update our represented object
            document?.undoManager = nil
            super.representedObject = newValue

            // Pass down the represented object to all of the child view controllers.
            for child in children {
                child.representedObject = representedObject
            }

            // setting the document's undo manager let's the window show the correct "Edited" state in the title
            // and prompt to save when closing the window, etc
            document?.undoManager = textEditor.undoManager
            // load the document in to the source editor
            refresh()
            // clear out the undo state from loading it
            textEditor.undoManager?.removeAllActions()
        }
    }

    @IBOutlet var textEditor: MathEditor!
    weak var delegate: SourceViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        textEditor.delegate = self
        // Do any additional setup after loading the view.

        parse()
    }

    func refresh() {
        textEditor.text = document?.text ?? ""
        textEditor.setNeedsDisplay(textEditor.bounds)
        parse()
    }

    func parse() {
        let source = textEditor.text
        let lexer = Lexer(input: source)
        let tokens = lexer.tokenize()
        let parser = Parser(tokens: tokens)

        do {
            let ast = try parser.parse()

            delegate?.didParse(mathAst: ast)
        } catch {
            Logging.error("parse_error", context: ["error": error])
        }
    }
}

extension SourceViewController: MathEditorDelegate {
    func didBeginEditing(_ editor: MathEditor) {
        document?.objectDidBeginEditing(self)
        document?.objectDidEndEditing(self)
    }

    func didEditText(_ editor: MathEditor) {
        document?.text = editor.text
        parse()
    }
}
