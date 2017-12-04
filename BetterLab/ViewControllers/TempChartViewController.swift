//
//  TempChartViewController.swift
//  BetterLab
//
//  Created by Eduard Schlotter on 23/11/2017.
//  Copyright © 2017 eschlotter. All rights reserved.
//

import UIKit
import Charts
import InteractiveSideMenu

class TempChartViewController: UIViewController, NSURLConnectionDelegate, NSURLConnectionDataDelegate, ChartViewDelegate {
    
    @IBOutlet var chartView: LineChartView!
    lazy var mydata = NSMutableData()
    
    var zone1:[ChartDataEntry] = []
    var zone2:[ChartDataEntry] = []
    var zone3:[ChartDataEntry] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        zone1 = []
        zone2 = []
        zone3 = []
        //chartViews[0].lineData?.removeDataSetByIndex()
        startConnection()
    }
    
    func startConnection(){
        print("Connected")
        let urlPath: String = "http://sccug-330-03.lancs.ac.uk/webapp/getweather"
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
        let lines = backToString.split(separator: "\n", maxSplits: backToString.count, omittingEmptySubsequences: true)
        for line in lines {
            var g = line.split(separator: ",", maxSplits: 10, omittingEmptySubsequences: true)
            //Time and Value
            let x:Double = Double(g[4])! // Time
            let y:Double = Double(g[0])! // Value
            let zone:Int = Int(g[3])!
            print(zone)
            let entry = ChartDataEntry(x: x, y: y)
            print(entry)
            if zone == 1 {
                zone1.append(entry)
            } else if zone == 2 {
                zone2.append(entry)
            } else if zone == 3 {
                zone3.append(entry)
            }
        }
        let colors = [UIColor(red: 137/255, green: 230/255, blue: 81/255, alpha: 1),
                      UIColor(red: 89/255, green: 199/255, blue: 250/255, alpha: 1),
                      UIColor(red: 250/255, green: 104/255, blue: 104/255, alpha: 1)]
        var dataset1 = LineChartDataSet(values: zone1, label: "Zone 1")
        var dataset2 = LineChartDataSet(values: zone2, label: "Zone 2")
        var dataset3 = LineChartDataSet(values: zone3, label: "Zone 3")
        datasetSetting(set: dataset3)
        dataset3.setColor(colors[2])
        datasetSetting(set: dataset2)
        dataset2.setColor(colors[1])
        datasetSetting(set: dataset1)
        dataset1.setColor(colors[0])
        print(dataset1)
        //Setup
        
        
        let data = LineChartData(dataSets: [dataset1, dataset2, dataset3])
        data.setValueTextColor(.black)
        data.setValueFont(.systemFont(ofSize: 9))
        
        chartSetUp(chartData:data)
        
        connection.cancel()
    }
    func datasetSetting(set:LineChartDataSet){
        set.lineWidth = 1
        set.circleRadius = 2.0
        set.circleHoleRadius = 2.0
        set.highlightColor = .black
        set.setCircleColor(.black)
        set.drawValuesEnabled = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Temperature Chart"
        
    }
    
    func chartSetUp(chartData:LineChartData){
        chartView.delegate = self
        
        chartView.chartDescription?.enabled = false
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = true
        
        let l = chartView.legend
        l.form = .line
        l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
        l.textColor = .black
        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        
        let xAxis = chartView.xAxis
        xAxis.labelFont = .systemFont(ofSize: 11)
        xAxis.labelTextColor = .black
        xAxis.drawAxisLineEnabled = false
        xAxis.valueFormatter = DateValueFormatter()
        
        let leftAxis = chartView.leftAxis
        leftAxis.labelTextColor = .black
        leftAxis.axisMaximum = 50
        leftAxis.axisMinimum = 0
        leftAxis.drawGridLinesEnabled = true
        leftAxis.granularityEnabled = true
        
        //let rightAxis = chartView.rightAxis
        //rightAxis.labelTextColor = .red
        //rightAxis.axisMaximum = 900
        //rightAxis.axisMinimum = -200
        //rightAxis.granularityEnabled = false
        
        chartView.animate(xAxisDuration: 1)
        
        chartView.data = chartData
    }
    @IBAction func openMenu(_ sender: Any) {
        if let navigationViewController = self.navigationController as? SideMenuItemContent {
            navigationViewController.showSideMenu()
        }
    }
    @IBAction func backButton(_ sender: Any) {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
