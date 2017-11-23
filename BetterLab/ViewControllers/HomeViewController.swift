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
    lazy var mydata = NSMutableData()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mydata = NSMutableData()
        startConnection()
    }
    
    func startConnection(){
        print("Connected")
        let urlPath: String = "http://sccug-330-03.lancs.ac.uk/webapp/getper"
        let url: NSURL = NSURL(string: urlPath)!
        let request: NSURLRequest = NSURLRequest(url: url as URL)
        let connection: NSURLConnection = NSURLConnection(request: request as URLRequest, delegate: self, startImmediately: false)!
        connection.start()
    }
    func connection(_ connection: NSURLConnection, didReceive mydata: Data){
        self.mydata = NSMutableData()
        self.mydata.append(mydata as Data)
    }
    
    func connectionDidFinishLoading(_ connection: NSURLConnection) {
        let err: NSError
        // throwing an error on the line below (can't figure out where the error message is)
        let backToString: String = String(data: mydata as Data, encoding: String.Encoding.utf8) as String!
        cupPercentage.text = backToString
        if(backToString == lastPercentage){
            print("equal")
            
        } else if(backToString == "100%"){
            print("100%")
            numOfCups = numOfCups + 1
            cups.text = String(numOfCups)
        }
        lastPercentage = backToString
        connection.cancel()
        let when = DispatchTime.now() + 1 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.mydata = NSMutableData()
            self.startConnection()
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.zoneChange(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)

        // Do any additional setup after loading the view.
    }
    func zoneChange(notification: Notification){
        users[5].text = "1"
        //Take Action on Notification
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
