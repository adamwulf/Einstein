//
//  SourceViewController.swift
//  Einstein-Scene
//
//  Created by Adam Wulf on 10/23/21.
//  Copyright © 2021 Milestone Made. All rights reserved.
//

import UIKit
import SwiftTex


protocol SourceViewControllerDelegate: AnyObject {
    func didParse(mathAst: [ExprNode])
}

class SourceViewController: UIViewController {
    @IBOutlet var editorView: EditorView!
    weak var delegate: SourceViewControllerDelegate?

    var content: ContentState? {
        didSet {
            self.navigationItem.title = content?.title
            editorView.text = content?.text ?? ""
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        editorView.delegate = self
    }

    func parse() {
        let source = editorView.text
        let lexer = Lexer(input: source)
        let tokens = lexer.tokenize()
        let parser = Parser(tokens: tokens.tokens)

        do {
            let (expressions: ast, errors: errors) = try parser.parse()

            editorView.highlight(errors: errors)
            delegate?.didParse(mathAst: ast)
        } catch {
            Logging.error("error", context: ["error": error])
        }
    }
}

extension SourceViewController: EditorViewDelegate {
    func didBeginEditing(_ editor: EditorView) {

    }

    func didEditText(_ editor: EditorView) {
        parse()
    }
}
