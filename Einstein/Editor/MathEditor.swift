//
//  MathEditor.swift
//  Einstein
//
//  Created by Adam Wulf on 4/14/21.
//  Copyright © 2021 Milestone Made. All rights reserved.
//

import Foundation
import AppKit
import Sourceful

protocol MathEditorDelegate: class {
    func didBeginEditing(_ editor: MathEditor)
    func didEditText(_ editor: MathEditor)
}

class MathEditor: NSView {
    let editor = SyntaxTextView()

    weak var delegate: MathEditorDelegate?
    var text: String {
        get {
            editor.text
        }
        set {
            editor.text = newValue
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        editor.theme = DarkTheme()

        editor.translatesAutoresizingMaskIntoConstraints = false
        addSubview(editor)
        editor.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        editor.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        editor.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        editor.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true

        editor.delegate = self
    }
}

extension MathEditor: SyntaxTextViewDelegate {

    func handleInsertOf(_ syntaxTextView: SyntaxTextView, text: String, selection: NSRange) -> Bool {
        if text == "(" {
            syntaxTextView.contentTextView.insertText("()", replacementRange: selection)
            syntaxTextView.contentTextView.moveLeft(nil)
            return true
        }
        return false
    }

    func didChangeText(_ syntaxTextView: SyntaxTextView) {
        Logging.info("editor", context: ["action": "change"])
        delegate?.didEditText(self)
    }

    func textViewDidBeginEditing(_ syntaxTextView: SyntaxTextView) {
        Logging.info("editor", context: ["action": "begin"])
        delegate?.didBeginEditing(self)
    }

    func lexerForSource(_ source: String) -> Sourceful.Lexer {
        Logging.info("editor", context: ["action": "lexer"])
        return TexLexer()
    }

    func didChangeSelectedRange(_ syntaxTextView: SyntaxTextView, selectedRange: NSRange) {
        Logging.info("editor", context: ["action": "did_change_selection"])
    }

    func textView(_ syntaxTextView: SyntaxTextView, doCommandBy commandSelector: Selector) -> Bool {
        Logging.info("editor", context: ["action": "do_command", "command": commandSelector.description])
        delegate?.didBeginEditing(self)
        return false
    }

    func textView(_ syntaxTextView: SyntaxTextView,
                  completions words: [String],
                  forPartialWordRange charRange: NSRange,
                  indexOfSelectedItem index: UnsafeMutablePointer<Int>?) -> [String] {
        Logging.info("editor", context: ["action": "completions"])
        return ["asdfasdf"]
    }

    func textView(_ syntaxTextView: SyntaxTextView,
                  willChangeSelectionFromCharacterRange oldSelectedCharRange: NSRange,
                  toCharacterRange newSelectedCharRange: NSRange) -> NSRange {
        Logging.info("editor", context: ["action": "will_change_selection"])
        return newSelectedCharRange
    }

    func textView(_ syntaxTextView: SyntaxTextView, shouldChangeTextIn affectedCharRange: NSRange, replacementString: String?) -> Bool {
        Logging.info("editor", context: ["action": "should_change_text"])
        return true
    }
}
