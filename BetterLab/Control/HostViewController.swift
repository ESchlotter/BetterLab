//
// HostViewController.swift
//
// Copyright 2017 Handsome LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import UIKit
import InteractiveSideMenu

/*
 HostViewController is container view controller, contains menu controller and the list of relevant view controllers.

 Responsible for creating and selecting menu items content controlers.
 Has opportunity to show/hide side menu.
 */
class HostViewController: MenuContainerViewController, NSURLConnectionDelegate, NSURLConnectionDataDelegate {
    
    override var prefersStatusBarHidden: Bool {
        return false
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let screenSize: CGRect = UIScreen.main.bounds
        self.transitionOptions = TransitionOptions(duration: 0.4, visibleContentWidth: screenSize.width / 6)

        // Instantiate menu view controller by identifier
        self.menuViewController = self.storyboard!.instantiateViewController(withIdentifier: "menuVC") as! MenuViewController

        // Gather content items controllers
        self.contentViewControllers = contentControllers()

        // Select initial content controller. It's needed even if the first view controller should be selected.
        self.selectContentViewController(contentViewControllers.first!)
        
        mydata = NSMutableData()
        startConnection()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        /*
         Options to customize menu transition animation.
         */
        var options = TransitionOptions()

        // Animation duration
        options.duration = size.width < size.height ? 0.4 : 0.6

        // Part of item content remaining visible on right when menu is shown
        options.visibleContentWidth = size.width / 6
        self.transitionOptions = options
    }

    private func contentControllers() -> [UIViewController] {
        let controllersIdentifiers = ["HomeNav","TempNav","HumNav","LightNav"]
        var contentList = [UIViewController]()

        /*
         Instantiate items controllers from storyboard.
         */
        for identifier in controllersIdentifiers {
            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: identifier) {
                contentList.append(viewController)
            }
        }

        return contentList
    }
    
    lazy var mydata = NSMutableData()
    
    func startConnection(){
        print("Connected")
        let urlPath: String = "http://sccug-330-03.lancs.ac.uk/webapp/getzone"
        let url: NSURL = NSURL(string: urlPath)!
        let request: NSURLRequest = NSURLRequest(url: url as URL)
        let connection: NSURLConnection = NSURLConnection(request: request as URLRequest, delegate: self, startImmediately: false)!
        connection.start()
    }
    func connection(_ connection: NSURLConnection, didReceive mydata: Data){
        self.mydata.append(mydata as Data)
    }
    
    func connectionDidFinishLoading(_ connection: NSURLConnection) {
        let err: NSError
        // throwing an error on the line below (can't figure out where the error message is)
        let backToString: String = String(data: mydata as Data, encoding: String.Encoding.utf8) as String!
        //cupPercentage.text = backToString
        print(backToString)
        NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil)
        connection.cancel()
        let when = DispatchTime.now() + 1 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.mydata = NSMutableData()
            self.startConnection()
        }
    }
}
