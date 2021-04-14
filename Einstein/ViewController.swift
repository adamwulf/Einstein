//
//  ViewController.swift
//  Einstein
//
//  Created by Adam Wulf on 4/13/21.
//

import Cocoa
import Sourceful

class ViewController: NSViewController {

    @IBOutlet var textEditor: SyntaxTextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        textEditor.theme = DarkTheme()
        textEditor.delegate = self
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}

extension ViewController: SyntaxTextViewDelegate {
    func lexerForSource(_ source: String) -> Lexer {
        return SwiftLexer()
    }
}
