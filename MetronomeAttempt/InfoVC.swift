//
//  InfoVC.swift
//  MetronomeAttempt
//
//  Created by Kian Salem on 5/16/17.
//  Copyright © 2017 Kian Salem. All rights reserved.
//

import UIKit

class InfoVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Enables ability to swipe back to home screen by doing the swipe back gesture
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
    }
}
