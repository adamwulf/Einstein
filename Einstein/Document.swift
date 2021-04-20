//
//  Document.swift
//  Einstein
//
//  Created by Adam Wulf on 4/13/21.
//

import Cocoa

class Document: NSDocument {

    private var lastSaved: ContentState?
    private var content: ContentState?

    var text: String {
        get {
            return content?.text ?? ""
        }
        set {
            content?.text = newValue
            windowControllers.forEach({ $0.setDocumentEdited(lastSaved?.text != newValue) })
        }
    }

    weak var contentViewController: PrimaryViewController?

    override class var autosavesInPlace: Bool {
        return true
    }

    // This enables asynchronous-writing.
    override func canAsynchronouslyWrite(to url: URL, ofType typeName: String, for saveOperation: NSDocument.SaveOperationType) -> Bool {
        return true
    }

    override func makeWindowControllers() {
        // Returns the Storyboard that contains your Document window.
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let scene = NSStoryboard.SceneIdentifier("Document Window Controller")
        let windowController = storyboard.instantiateController(withIdentifier: scene) as! PrimaryWindowController
        windowController.primaryViewController.representedObject = self
        self.contentViewController = windowController.primaryViewController

        self.addWindowController(windowController)
    }

    override func data(ofType typeName: String) throws -> Data {
        // Insert code here to write your document to data of the specified type, throwing an error in case of failure.
        // Alternatively, you could remove this method and override fileWrapper(ofType:), write(to:ofType:), or write(to:ofType:for:originalContentsURL:) instead.
        lastSaved = content
        return content?.data() ?? Data()
    }

    override func read(from data: Data, ofType typeName: String) throws {
        // Insert code here to read your document from the given data of the specified type, throwing an error in case of failure.
        // Alternatively, you could remove this method and override read(from:ofType:) instead.
        // If you do, you should also override isEntireFileLoaded to return false if the contents are lazily loaded.
        content = ContentState(data: data)
        lastSaved = content

        contentViewController?.representedObject = self
    }
}
