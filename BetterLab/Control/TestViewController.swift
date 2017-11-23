//
//  TestViewController.swift
//  BetterLab
//
//  Created by Eduard Schlotter on 20/11/2017.
//  Copyright © 2017 eschlotter. All rights reserved.
//

import UIKit
import InteractiveSideMenu

class TestViewController: MenuViewController {
    @IBOutlet var backButton: UIButton!
    @IBOutlet var temp: UIButton!
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //guard let menuContainerViewController = self.menuContainerViewController else {
          //  return
        //}
        //menuContainerViewController.selectContentViewController(menuContainerViewController.contentViewControllers[0])
       // menuContainerViewController.hideSideMenu()
    }
    
    
    @IBAction func homeButton(_ sender: Any) {
        guard let menuContainerViewController = self.menuContainerViewController else {
            return
        }
        menuContainerViewController.selectContentViewController(menuContainerViewController.contentViewControllers[0])
        menuContainerViewController.hideSideMenu()
    }
    
    @IBAction func tempButton(_ sender: Any) {
        guard let menuContainerViewController = self.menuContainerViewController else {
            return
        }
        
        menuContainerViewController.selectContentViewController(menuContainerViewController.contentViewControllers[1])
        menuContainerViewController.hideSideMenu()
    }
    @IBAction func humButton(_ sender: Any) {
        guard let menuContainerViewController = self.menuContainerViewController else {
            return
        }
        
        menuContainerViewController.selectContentViewController(menuContainerViewController.contentViewControllers[2])
        menuContainerViewController.hideSideMenu()
    }
    @IBAction func lightButton(_ sender: Any) {
        guard let menuContainerViewController = self.menuContainerViewController else {
            return
        }
        
        menuContainerViewController.selectContentViewController(menuContainerViewController.contentViewControllers[3])
        menuContainerViewController.hideSideMenu()
    }
    
}
