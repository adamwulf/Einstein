//
//  Document.swift
//  Einstein-iOS
//
//  Created by Adam Wulf on 10/23/21.
//  Copyright © 2021 Milestone Made. All rights reserved.
//

import UIKit

class Document: UIDocument {

    private var lastSaved: ContentState?
    private var content: ContentState?

    var text: String {
        get {
            return content?.text ?? ""
        }
        set {
            content?.text = newValue
        }
    }

    override func contents(forType typeName: String) throws -> Any {
        lastSaved = content
        return content?.data() ?? Data()
    }

    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        // Load your document from contents
        guard let contents = contents as? Data else { return }
        content = ContentState(data: contents)
        lastSaved = content
    }
}
