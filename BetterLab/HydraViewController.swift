//
//  HydraViewController.swift
//  BetterLab
//
//  Created by Eduard Schlotter on 07/12/2017.
//  Copyright © 2017 eschlotter. All rights reserved.
//

import UIKit
import Charts
import InteractiveSideMenu

class HydraViewController: UIViewController, NSURLConnectionDelegate, NSURLConnectionDataDelegate, ChartViewDelegate {

    @IBOutlet var barChartView: BarChartView!
    
    var bars:[ChartDataEntry] = []
    
    lazy var mydata = NSMutableData()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mydata = NSMutableData()
        //chartViews[0].lineData?.removeDataSetByIndex()
        startConnection()
    }
    
    func startConnection(){
        print("Connected")
        let urlPath: String = "http://sccug-330-03.lancs.ac.uk/webapp/gethy"
        let url: NSURL = NSURL(string: urlPath)!
        let request: NSURLRequest = NSURLRequest(url: url as URL)
        let connection: NSURLConnection = NSURLConnection(request: request as URLRequest, delegate: self, startImmediately: false)!
        connection.start()
    }
    func connection(_ connection: NSURLConnection, didReceive mydata: Data){
        //print(mydata)
        self.mydata.append(mydata as Data)
    }
    
    func connectionDidFinishLoading(_ connection: NSURLConnection) {
        let err: NSError
        // throwing an error on the line below (can't figure out where the error message is)
        //var jsonResult: NSDictionary = try! JSONSerialization.jsonObject(with: mydata as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
        //print(jsonResult)
        let backToString: String = String(data: mydata as Data, encoding: String.Encoding.utf8) as String!
        print(backToString)
        //backToString.split("a:b::c:", {$0 == ":"}, maxSplit: Int.max)
        let lines = backToString.split(separator: ",", maxSplits: backToString.count, omittingEmptySubsequences: true)
        for i in stride(from: 0, to: lines.count, by: 2) {
            //Time and Value
            let x:Double = Double(lines[i+1])! // Time
            let y:Double = Double(lines[i])! // Value
            let entry = ChartDataEntry(x: x, y: y)
            print(entry)
            bars.append(entry)
        }
        var dataset1 = BarChartDataSet(values: bars, label: "Daily Water Intake")
        print(dataset1)
        //Setup
        var data:BarChartData
        data = BarChartData(dataSet: dataset1)
        data.setValueFont(UIFont(name: "HelveticaNeue", size: 7)!)
        
        barChartView.delegate = self
        
        barChartView.drawBarShadowEnabled = false
        barChartView.drawValueAboveBarEnabled = false
        
        barChartView.maxVisibleCount = 60
        
        let xAxis = barChartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.granularity = 1
        xAxis.labelCount = 7
        xAxis.valueFormatter = DayAxisValueFormatter(chart: barChartView)
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.minimumFractionDigits = 0
        leftAxisFormatter.maximumFractionDigits = 1
        leftAxisFormatter.negativeSuffix = " $"
        leftAxisFormatter.positiveSuffix = " $"
        
        let leftAxis = barChartView.leftAxis
        leftAxis.labelFont = .systemFont(ofSize: 10)
        leftAxis.labelCount = 8
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
        leftAxis.labelPosition = .outsideChart
        leftAxis.spaceTop = 0.15
        leftAxis.axisMinimum = 0 // FIXME: HUH?? this replaces startAtZero = YES
        
        let rightAxis = barChartView.rightAxis
        rightAxis.enabled = true
        rightAxis.labelFont = .systemFont(ofSize: 10)
        rightAxis.labelCount = 8
        rightAxis.valueFormatter = leftAxis.valueFormatter
        rightAxis.spaceTop = 0.15
        rightAxis.axisMinimum = 0
        
        let l = barChartView.legend
        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        l.form = .circle
        l.formSize = 9
        l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
        l.xEntrySpace = 4
        //        chartView.legend = l
        connection.cancel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Hydration Zones"
        
    }
    
    @IBAction func openMenu(_ sender: Any) {
        if let navigationViewController = self.navigationController as? SideMenuItemContent {
            navigationViewController.showSideMenu()
        }
    }
}
