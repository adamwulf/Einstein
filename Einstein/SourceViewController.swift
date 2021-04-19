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

protocol SourceViewControllerDelegate {
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
            super.representedObject = newValue

            // Pass down the represented object to all of the child view controllers.
            for child in children {
                child.representedObject = representedObject
            }

            refresh()
        }
    }

    @IBOutlet var textEditor: MathEditor!
    var delegate: SourceViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        textEditor.text = ""
        textEditor.delegate = self
        // Do any additional setup after loading the view.

        parse()
    }

    func refresh() {
        textEditor.text = document?.content?.text ?? ""
        textEditor.setNeedsDisplay(textEditor.bounds)
        parse()
    }

    func parse() {
        let source = textEditor.text

        document?.content?.text = source

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
        parse()
    }
}
