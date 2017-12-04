//
//  HomeViewController.swift
//  BetterLab
//
//  Created by Eduard Schlotter on 23/11/2017.
//  Copyright © 2017 eschlotter. All rights reserved.
//

import UIKit
import InteractiveSideMenu

class HomeViewController: UIViewController,NSURLConnectionDelegate, NSURLConnectionDataDelegate {
    
    @IBOutlet var cups: UILabel!
    @IBOutlet var views: [UIView]!
    @IBOutlet var users: [UILabel]!
    @IBOutlet var cupPercentage: UILabel!
    var lastPercentage:String = ""
    var numOfCups = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let colors = [UIColor(red: 137/255, green: 230/255, blue: 81/255, alpha: 1),
                      UIColor(red: 137/255, green: 230/255, blue: 81/255, alpha: 1),
                      UIColor(red: 89/255, green: 199/255, blue: 250/255, alpha: 1),
                      UIColor(red: 89/255, green: 199/255, blue: 250/255, alpha: 1),
                      UIColor(red: 250/255, green: 104/255, blue: 104/255, alpha: 1),
                      UIColor(red: 250/255, green: 104/255, blue: 104/255, alpha: 1)]
        for (i, currentView) in views.enumerated() {
            currentView.backgroundColor = colors[i]
        }
        // Do any additional setup after loading the view.
        NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func openMenu(_ sender: Any) {
        if let navigationViewController = self.navigationController as? SideMenuItemContent {
            navigationViewController.showSideMenu()
        }
    }
    

}
