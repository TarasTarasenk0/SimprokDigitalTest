//
//  TabBarController.swift
//  SimprokDigitalTest
//
//  Created by md760 on 7/16/19.
//  Copyright © 2019 md760. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //text tint color
        let appearance = UITabBarItem.appearance(whenContainedInInstancesOf: [TabBarController.self])
        appearance.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.darkGray], for: .normal)
        appearance.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
        
    }

}
