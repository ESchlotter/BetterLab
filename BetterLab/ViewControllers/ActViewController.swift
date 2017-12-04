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
    @IBOutlet var labUsers: UILabel!
    var lastPercentage:String = ""
    var numOfCups = -1
    
    lazy var cupData = NSMutableData()
    lazy var peopleData = NSMutableData()
    
    let doorUrlPath: String = "http://sccug-330-03.lancs.ac.uk/webapp/getdoor"
    let cupUrlPath: String = "http://sccug-330-03.lancs.ac.uk/webapp/getper"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cupData = NSMutableData()
        startCupConnection()
        peopleData = NSMutableData()
        startDoorConnection()
    }
    
    func startCupConnection(){
        print("Cup Connected")
        
        let url: NSURL = NSURL(string: cupUrlPath)!
        let request: NSURLRequest = NSURLRequest(url: url as URL)
        let connection: NSURLConnection = NSURLConnection(request: request as URLRequest, delegate: self, startImmediately: false)!
        connection.start()
        
        // same thing again but for zones
    }
    
    func startDoorConnection(){
        print("Door Connected")
        let url: NSURL = NSURL(string: doorUrlPath)!
        let request: NSURLRequest = NSURLRequest(url: url as URL)
        let connection: NSURLConnection = NSURLConnection(request: request as URLRequest, delegate: self, startImmediately: false)!
        connection.start()
        // same thing again but for zones
    }
    func connection(_ connection: NSURLConnection, didReceive mydata: Data){
        //print(connection.currentRequest)
        if(connection.currentRequest.description == cupUrlPath){
            self.cupData = NSMutableData()
            self.cupData.append(mydata as Data)
        } else {
            self.peopleData = NSMutableData()
            self.peopleData.append(mydata as Data)
        }
        // check which connection
        // connection.currentRequest == original?
        // if cup then mydata
        // else if zone then differentData
    }
    
    func connectionDidFinishLoading(_ connection: NSURLConnection) {
        // Figure out which finished again
        // Restart whichever needs it
        let err: NSError
        // throwing an error on the line below (can't figure out where the error message is)
        if(connection.currentRequest.description == cupUrlPath){
            let backToString: String = String(data: cupData as Data, encoding: String.Encoding.utf8) as String!
            cupPercentage.text = backToString
            if(backToString == lastPercentage){
                print("Percentage Equal")
                
            } else if(backToString == "100%"){
                print("100%")
                numOfCups = numOfCups + 1
                cups.text = String(numOfCups)
            }
            lastPercentage = backToString
            connection.cancel()
            let when = DispatchTime.now() + 1 // change 2 to desired number of seconds
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.cupData = NSMutableData()
                self.startCupConnection()
            }
        }else{
            let backToString: String = String(data: peopleData as Data, encoding: String.Encoding.utf8) as String!
            labUsers.text = backToString
            connection.cancel()
            let when = DispatchTime.now() + 1 // change 1 to desired number of seconds
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.peopleData = NSMutableData()
                self.startDoorConnection()
            }
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
