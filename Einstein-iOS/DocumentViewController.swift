//
//  DocumentViewController.swift
//  Einstein-iOS
//
//  Created by Adam Wulf on 10/23/21.
//  Copyright © 2021 Milestone Made. All rights reserved.
//

import UIKit

class DocumentViewController: UIViewController {

    @IBOutlet weak var documentNameLabel: UILabel!

    var document: UIDocument?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Access the document
        document?.open(completionHandler: { (success) in
            if success {
                // Display the content of the document, e.g.:
                self.documentNameLabel.text = self.document?.fileURL.lastPathComponent
            } else {
                // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
            }
        })
    }

    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
    }

    @IBAction func dismissDocumentViewController() {
        dismiss(animated: true) {
            self.document?.close(completionHandler: nil)
        }
    }
}
