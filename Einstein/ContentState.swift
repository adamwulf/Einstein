//
//  ContentState.swift
//  Einstein
//
//  Created by Adam Wulf on 4/18/21.
//  Copyright © 2021 Milestone Made. All rights reserved.
//

import Foundation

class ContentState: NSCoding {

    var url: URL?
    var text: String

    var title: String {
        return url?.lastPathComponent ?? "Untitled"
    }

    init?(url: URL) {
        guard
            url.isFileURL,
            url.startAccessingSecurityScopedResource()
        else { return nil }
        self.url = url
        if let data = FileManager.default.contents(atPath: url.path),
           let txt = String(data: data, encoding: .utf16) {
            self.text = txt
        } else {
            self.text = ""
        }
        url.stopAccessingSecurityScopedResource()
    }

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
