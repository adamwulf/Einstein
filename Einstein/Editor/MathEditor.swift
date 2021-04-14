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

class MathEditor: SyntaxTextView {
    override func textView(_ textView: NSTextView, shouldChangeTextIn affectedCharRange: NSRange, replacementString: String?) -> Bool {
        if replacementString?.contains("\t") ?? false {
            Logging.info("textview", context: ["action": "ignore_tab", "range": affectedCharRange])

            let num = 5 - affectedCharRange.location % 5

            contentTextView.replaceCharacters(in: affectedCharRange, with: String(repeating: " ", count: num))

            return false
        }

        Logging.info("textview", context: ["range": affectedCharRange, "replacement": replacementString ?? "[null]"])
        return super.textView(textView, shouldChangeTextIn: affectedCharRange, replacementString: replacementString)
    }

    override func textViewDidChangeSelection(_ notification: Notification) {
        Logging.info("textview", context: ["selection": contentTextView.selectedRanges.first?.rangeValue ?? NSRange.init(location: Int.min,
                                                                                                                         length: Int.max)])
    }
}
