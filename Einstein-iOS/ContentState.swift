//
//  ContentState.swift
//  Einstein
//
//  Created by Adam Wulf on 4/18/21.
//  Copyright © 2021 Milestone Made. All rights reserved.
//

import Foundation

class ContentState: NSCoding {

    var text: String

    init(text: String) {
        self.text = text
    }

    init(data: Data) {
        if data.count > 0 {
            text = String(data: data, encoding: .utf16) ?? ""
        } else {
            text = ""
        }
    }

    private enum CodingKeys: String {
        case content
    }

    // MARK: - NSCoding

    func data() -> Data {
        return text.data(using: .utf16) ?? Data()
    }

    func encode(with coder: NSCoder) {
        coder.encode(text, forKey: CodingKeys.content.rawValue)
    }

    required init?(coder: NSCoder) {
        text = (coder.decodeObject(of: NSString.self, forKey: CodingKeys.content.rawValue) as String?) ?? ""
    }
}
