//
//  TempChartViewController.swift
//  BetterLab
//
//  Created by Eduard Schlotter on 23/11/2017.
//  Copyright © 2017 eschlotter. All rights reserved.
//

import UIKit
import InteractiveSideMenu

class TempChartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationItem.hidesBackButton = true
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(TempChartViewController.backButtonTapped))
        navigationItem.leftBarButtonItem?.isEnabled = false
        

    }
    func backButtonTapped() {
        if let navigationViewController = self.navigationController as? SideMenuItemContent {
            navigationViewController.showSideMenu()
        }
    }

}
