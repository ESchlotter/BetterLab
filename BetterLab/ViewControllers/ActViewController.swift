//
//  ActViewController.swift
//  BetterLab
//
//  Created by Eduard Schlotter on 01/12/2017.
//  Copyright © 2017 eschlotter. All rights reserved.
//

import UIKit
import InteractiveSideMenu

class ActViewController: UIViewController, NSURLConnectionDelegate, NSURLConnectionDataDelegate {
    @IBOutlet var cups: UILabel!
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
        
        // same thing again but for zones
    }
    func connection(_ connection: NSURLConnection, didReceive mydata: Data){
        // check which connection
        // connection.currentRequest == original?
        // if cup then mydata
        // else if zone then differentData
        self.mydata = NSMutableData()
        self.mydata.append(mydata as Data)
    }
    
    func connectionDidFinishLoading(_ connection: NSURLConnection) {
        // Figure out which finished again
        // Restart whichever needs it
        
        
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
        
    }
    @IBAction func openMenu(_ sender: Any) {
        if let navigationViewController = self.navigationController as? SideMenuItemContent {
            navigationViewController.showSideMenu()
        }
    }
}
