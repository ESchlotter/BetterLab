//
//  HumViewController.swift
//  BetterLab
//
//  Created by Eduard Schlotter on 23/11/2017.
//  Copyright © 2017 eschlotter. All rights reserved.
//

import UIKit
import Charts
import InteractiveSideMenu

class HumViewController: UIViewController, NSURLConnectionDelegate, NSURLConnectionDataDelegate, ChartViewDelegate {
    @IBOutlet var chartViews: [LineChartView]!
    @IBOutlet var button: UIButton!
    
    var menu: UIViewController?
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
        mydata = NSMutableData()
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
            let y:Double = Double(g[1])! // Value
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
                      UIColor(red: 250/255, green: 104/255, blue: 104/255, alpha: 1),
                      UIColor(red: 240/255, green: 240/255, blue: 30/255, alpha: 1)]
        var dataset1 = LineChartDataSet(values: zone1, label: "Zone 1")
        var dataset2 = LineChartDataSet(values: zone2, label: "Zone 2")
        var dataset3 = LineChartDataSet(values: zone3, label: "Zone 3")
        datasetSetting(set: dataset3)
        datasetSetting(set: dataset2)
        datasetSetting(set: dataset1)
        print(dataset1)
        //Setup
        
        
        for (i, chartView) in chartViews.enumerated() {
            var data:LineChartData
            if i == 0 {
                data = LineChartData(dataSet: dataset1)
            } else if i == 1 {
                data = LineChartData(dataSet: dataset2)
            } else {
                data = LineChartData(dataSet: dataset3)
            }
            
            //let data = dataWithCount(36, range: 100)
            data.setValueFont(UIFont(name: "HelveticaNeue", size: 7)!)
            
            setupChart(chartView, data: data, color: colors[i % colors.count])
        }
        connection.cancel()
    }
    func datasetSetting(set:LineChartDataSet){
        set.lineWidth = 1
        set.circleRadius = 5.0
        set.circleHoleRadius = 5.0
        set.setColor(.white)
        set.setCircleColor(.white)
        set.highlightColor = .white
        set.drawValuesEnabled = true
    }
    
    //@IBAction func unwindToTempVC(_ sender: UIStoryboardSegue) {
    //}
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(getJSON(urlToRequest: "http://sccug-330-03.lancs.ac.uk/webapp/gettemp"))
        
        self.title = "Humidity Zones"
        
        
        
    }
    
    func setupChart(_ chartView: LineChartView, data: LineChartData, color: UIColor) {
        (data.getDataSetByIndex(0) as! LineChartDataSet).circleHoleColor = color
        chartView.delegate = self
        chartView.chartDescription?.enabled = false
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = true
        
        chartView.backgroundColor = color
        
        /*
         // x-axis limit line
         let llXAxis = ChartLimitLine(limit: 10, label: "Index 10")
         llXAxis.lineWidth = 4
         llXAxis.lineDashLengths = [10, 10, 0]
         llXAxis.labelPosition = .rightBottom
         llXAxis.valueFont = .systemFont(ofSize: 10)
         */
        
        chartView.xAxis.gridLineWidth = 0
        chartView.xAxis.gridLineDashLengths = [10, 10]
        chartView.xAxis.gridLineDashPhase = 0
        chartView.xAxis.valueFormatter = DateValueFormatter()
        
        /*let ll1 = ChartLimitLine(limit: 150, label: "Upper Limit")
         ll1.lineWidth = 4
         ll1.lineDashLengths = [5, 5]
         ll1.labelPosition = .rightTop
         ll1.valueFont = .systemFont(ofSize: 10)
         
         let ll2 = ChartLimitLine(limit: -30, label: "Lower Limit")
         ll2.lineWidth = 4
         ll2.lineDashLengths = [5,5]
         ll2.labelPosition = .rightBottom
         ll2.valueFont = .systemFont(ofSize: 10)
         */
        
        let leftAxis = chartView.leftAxis
        leftAxis.removeAllLimitLines()
        //leftAxis.addLimitLine(ll1)
        //leftAxis.addLimitLine(ll2)
        //leftAxis.axisMaximum = 200
        //leftAxis.axisMinimum = -50
        leftAxis.gridLineWidth = 0
        leftAxis.gridLineDashLengths = [5, 5]
        leftAxis.drawLimitLinesBehindDataEnabled = true
        
        chartView.rightAxis.enabled = false
        
        //[_chartView.viewPortHandler setMaximumScaleY: 2.f];
        //[_chartView.viewPortHandler setMaximumScaleX: 2.f];
        
        chartView.legend.form = .line
        
        chartView.data = data
        
        chartView.animate(xAxisDuration: 1)
        
    }
    
    func dataWithCount(_ count: Int, range: UInt32) -> LineChartData {
        let yVals = (0..<count).map { i -> ChartDataEntry in
            let val = Double(arc4random_uniform(range)) + 3
            return ChartDataEntry(x: Double(i), y: val)
        }
        
        let set1 = LineChartDataSet(values: yVals, label: "DataSet 1")
        //set1.lineDashLengths = [5, 2.5]
        
        set1.lineWidth = 1
        set1.circleRadius = 5.0
        set1.circleHoleRadius = 2.5
        set1.setColor(.white)
        set1.setCircleColor(.white)
        set1.highlightColor = .white
        set1.drawValuesEnabled = true
        
        return LineChartData(dataSet: set1)
    }
    
    @IBAction func openMenu(_ sender: Any) {
        if let navigationViewController = self.navigationController as? SideMenuItemContent {
            navigationViewController.showSideMenu()
        }
    }
    /*func getJSON(urlToRequest: String) -> NSData{
     return try! NSData(contentsOf: URL(string: urlToRequest)!)
     }*/
    
    /*func parseJSON(inputData: NSData) -> NSDictionary{
     var error: NSError?
     var boardsDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers, error: &error) as NSDictionary
     
     return boardsDictionary
     }*/
}
