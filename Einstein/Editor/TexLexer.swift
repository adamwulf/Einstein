//
//  TexLexer.swift
//  Einstein
//
//  Created by Adam Wulf on 4/14/21.
//  Copyright © 2021 Milestone Made. All rights reserved.
//

import Foundation
import Sourceful

public class TexLexer: SourceCodeRegexLexer {

    public init() {

    }

    lazy var generators: [TokenGenerator] = {

        var generators = [TokenGenerator?]()

        // identifiers for variables/functions/etc
        generators.append(regexGenerator("(?<![a-zA-Z])[a-zA-Z]+(?=[\\W_])", tokenType: .identifier))
        generators.append(regexGenerator("\\b[a-zA-Z]+\\b", tokenType: .identifier))

        // numbers
        generators.append(regexGenerator("[\\-]?[0-9]+\\.?[0-9]*", tokenType: .number))

        // TeX tags
        generators.append(regexGenerator("\\\\[a-zA-Z]+\\b", tokenType: .keyword))
        generators.append(regexGenerator("\\\\\\\\", tokenType: .plain))

        // comments
        generators.append(regexGenerator("%[^\n]*", tokenType: .comment))

        return generators.compactMap({ $0 })
    }()

    public func generators(source: String) -> [TokenGenerator] {

        return generators
    }

}
