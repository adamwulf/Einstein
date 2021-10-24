//
//  StartupViewController.swift
//  Einstein-Scene
//
//  Created by Adam Wulf on 10/23/21.
//  Copyright © 2021 Milestone Made. All rights reserved.
//

import UIKit

class StartupViewController: UIViewController {

    var picker: UIDocumentPickerViewController?
    var sceneDelegate: SceneDelegate {
        return view.window!.windowScene!.delegate as! SceneDelegate
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func didTapButton() {
        let foo = UIDocumentPickerViewController(documentTypes: ["com.milestonemade.einstein"], in: .open)
        foo.delegate = self
        foo.allowsMultipleSelection = false
        present(foo, animated: true, completion: nil)
        picker = foo
    }
}

extension StartupViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print(urls)
        for url in urls {
            let activity = NSUserActivity(activityType: "document")
            activity.requiredUserInfoKeys = Set(["url"])
            activity.addUserInfoEntries(from: ["url": url.absoluteString])
            activity.needsSave = true
            UIApplication.shared.requestSceneSessionActivation(nil, userActivity: activity, options: nil) { error in
                print(error)
            }
        }
    }
}
