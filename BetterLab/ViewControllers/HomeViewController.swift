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
    
    @IBOutlet var views: [UIView]!
    @IBOutlet var users: [UILabel]!
    @IBOutlet var personImages: [UIImageView]!
    
    lazy var zoneData = NSMutableData()
    
    let urlPath: String = "http://sccug-330-03.lancs.ac.uk/webapp/getzone"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        zoneData = NSMutableData()
        startZoneConnection()
    }
    
    func startZoneConnection(){
        print("Zone Connected")
        let url: NSURL = NSURL(string: urlPath)!
        let request: NSURLRequest = NSURLRequest(url: url as URL)
        let connection: NSURLConnection = NSURLConnection(request: request as URLRequest, delegate: self, startImmediately: false)!
        connection.start()
        
        // same thing again but for zones
    }
    
    func connection(_ connection: NSURLConnection, didReceive mydata: Data){
        self.zoneData = NSMutableData()
        self.zoneData.append(mydata as Data)
    }
    
    func connectionDidFinishLoading(_ connection: NSURLConnection) {
        // Figure out which finished again
        // Restart whichever needs it
        let err: NSError
        // throwing an error on the line below (can't figure out where the error message is)
        let backToString: String = String(data: zoneData as Data, encoding: String.Encoding.utf8) as String!
        switch backToString {
        case "zone1A":
            resetZones()
            users[0].text = "1"
            personImages[0].isHidden = false
        case "zone1B":
            resetZones()
            users[1].text = "1"
            personImages[1].isHidden = false
        case "zone2A":
            resetZones()
            users[2].text = "1"
            personImages[2].isHidden = false
        case "zone2B":
            resetZones()
            users[3].text = "1"
            personImages[3].isHidden = false
        case "zone3A":
            resetZones()
            users[4].text = "1"
            personImages[4].isHidden = false
        case "zone3B":
            resetZones()
            users[5].text = "1"
            personImages[5].isHidden = false
        default:
            print("Format Error")
            resetZones()
        }
        connection.cancel()
        let when = DispatchTime.now() + 1 // change 1 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.zoneData = NSMutableData()
            self.startZoneConnection()
        }
        
    }
    func resetZones(){
        for user in users{
            user.text = "0"
        }
        for x in personImages{
            x.isHidden = true
        }
    }
    
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
