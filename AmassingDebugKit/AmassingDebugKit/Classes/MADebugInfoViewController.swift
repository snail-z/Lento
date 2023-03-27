//
//  MADebugInfoViewController.swift
//  Lento
//
//  Created by zhang on 2023/3/16.
//

import UIKit
import MADebugMagic

class MADebugInfoViewController: MADebugBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .random(.fairy)
        self.navigationItem.title = "App基本信息/设备信息"
        let sd = MADebugLogManager.shared()
        sd.disableNetworkLog = false
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
