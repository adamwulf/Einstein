//
//  EditorView.swift
//  Einstein-Scene
//
//  Created by Adam Wulf on 10/23/21.
//  Copyright © 2021 Milestone Made. All rights reserved.
//

import Foundation
import Sourceful
import SwiftTex
import UIKit

protocol EditorViewDelegate: AnyObject {
    func didBeginEditing(_ editor: EditorView)
    func didEditText(_ editor: EditorView)
}

class EditorView: UIView {
    let editor = SyntaxTextView()

    weak var delegate: EditorViewDelegate?
    var text: String {
        get {
            editor.text
        }
        set {
            editor.text = newValue
        }
    }

    func highlight(errors: [ParseError]) {
        guard !errors.isEmpty else { return }

        for error in errors {
            if let token = error.token {
                Logging.error("syntax_error", context: ["loc": token.loc, "line": token.line, "col": token.col, "token": token.raw])
            } else {
                Logging.error("syntax_error", context: ["error": error.localizedDescription])
            }

            let maxLen = editor.contentTextView.text.utf8.count
            if let token = error.token {
                let range = NSRange(location: token.loc, length: token.raw.utf8.count)

                guard
                    range.lowerBound >= 0,
                    range.upperBound <= maxLen
                else {
                    continue
                }

                editor.contentTextView.textStorage.addAttributes([.underlineStyle: NSUnderlineStyle.thick.rawValue,
                                                                  .underlineColor: UIColor.red,
                                                                  .expansion: -0.0001],
                                                                 range: range)
            } else if maxLen > 0 {
                let range = NSRange(location: maxLen - 1, length: 1)
                editor.contentTextView.textStorage.addAttributes([.underlineStyle: NSUnderlineStyle.thick.rawValue,
                                                                  .underlineColor: UIColor.red,
                                                                  .expansion: -0.0001],
                                                                 range: range)
            }
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

extension EditorView: SyntaxTextViewDelegate {

//    func handleInsertOf(_ syntaxTextView: SyntaxTextView, text: String, selection: NSRange) -> Bool {
//        if text == "(" {
//            let range = syntaxTextView.contentTextView.selectedRange()
//            let selected = (syntaxTextView.contentTextView.string as NSString).substring(with: range)
//            syntaxTextView.contentTextView.undoManager?.beginUndoGrouping()
//            syntaxTextView.contentTextView.insertText("(\(selected))", replacementRange: selection)
//            syntaxTextView.contentTextView.setSelectedRange(_NSRange(location: range.location + 1, length: range.length))
//            syntaxTextView.contentTextView.undoManager?.endUndoGrouping()
//            return true
//        }
//        return false
//    }

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
//        Logging.info("editor", context: ["action": "did_change_selection"])
    }

    func textView(_ syntaxTextView: SyntaxTextView, doCommandBy commandSelector: Selector) -> Bool {
//        Logging.info("editor", context: ["action": "do_command", "command": commandSelector.description])
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
//        Logging.info("editor", context: ["action": "will_change_selection"])
        return newSelectedCharRange
    }

    func textView(_ syntaxTextView: SyntaxTextView, shouldChangeTextIn affectedCharRange: NSRange, replacementString: String?) -> Bool {
        Logging.info("editor", context: ["action": "should_change_text"])
        return true
    }
}
