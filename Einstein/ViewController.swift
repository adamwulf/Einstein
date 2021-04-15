//
//  ViewController.swift
//  Einstein
//
//  Created by Adam Wulf on 4/13/21.
//

import Cocoa
import Sourceful
import SwiftTex
import IosMath

class ViewController: NSViewController {

    let label = MTMathUILabel()
    @IBOutlet var textEditor: MathEditor!
    @IBOutlet private var labelContainer: NSView!
    var source = "(a_2b_1 - b_2a_1)(a_1b_0 - b_1a_0) - (a_2b_0 - b_2a_0)^2"

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

        textEditor.contentTextView.string = source
        textEditor.theme = DarkTheme()
        textEditor.delegate = self
        // Do any additional setup after loading the view.

        appendLabel()

        parse()
    }

    func parse() {
        let source = textEditor.contentTextView.string
        let lexer = Lexer(input: source)
        let tokens = lexer.tokenize()
        let parser = Parser(tokens: tokens)

        do {
            let ast = try parser.parse()
            let printVisitor = PrintVisitor()
            printVisitor.ignoreSubscripts = false
            let maths = ast.accept(visitor: printVisitor)

            label.latex = maths.joined(separator: "\\")
        } catch {
            // ignore
        }
    }

    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
}

extension ViewController: SyntaxTextViewDelegate {
    func didChangeText(_ syntaxTextView: SyntaxTextView) {
        Logging.info("editor", context: ["action": "change"])
        parse()
    }

    func textViewDidBeginEditing(_ syntaxTextView: SyntaxTextView) {
        Logging.info("editor", context: ["action": "begin"])
    }

    func lexerForSource(_ source: String) -> Sourceful.Lexer {
        return TexLexer()
    }
}
