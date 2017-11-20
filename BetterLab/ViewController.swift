//
//  ViewController.swift
//  BetterLab
//
//  Created by Eduard Schlotter on 18/11/2017.
//  Copyright © 2017 eschlotter. All rights reserved.
//

import UIKit
import Charts

class ViewController: UIViewController {
    @IBOutlet var chartViews: [LineChartView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Colored Line Chart"
        
        let colors = [UIColor(red: 137/255, green: 230/255, blue: 81/255, alpha: 1),
                      UIColor(red: 240/255, green: 240/255, blue: 30/255, alpha: 1),
                      UIColor(red: 89/255, green: 199/255, blue: 250/255, alpha: 1),
                      UIColor(red: 250/255, green: 104/255, blue: 104/255, alpha: 1)]
        
        for (i, chartView) in chartViews.enumerated() {
            let data = dataWithCount(36, range: 100)
            data.setValueFont(UIFont(name: "HelveticaNeue", size: 7)!)
            
            setupChart(chartView, data: data, color: colors[i % colors.count])
        }
        
        
    }
    
    func setupChart(_ chartView: LineChartView, data: LineChartData, color: UIColor) {
        (data.getDataSetByIndex(0) as! LineChartDataSet).circleHoleColor = color
        
        //chart.delegate = self
        chartView.chartDescription?.enabled = false
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = true
        
        chartView.backgroundColor = color
        
        // x-axis limit line
        let llXAxis = ChartLimitLine(limit: 10, label: "Index 10")
        llXAxis.lineWidth = 4
        llXAxis.lineDashLengths = [10, 10, 0]
        llXAxis.labelPosition = .rightBottom
        llXAxis.valueFont = .systemFont(ofSize: 10)
        
        chartView.xAxis.gridLineWidth = 0
        chartView.xAxis.gridLineDashLengths = [10, 10]
        chartView.xAxis.gridLineDashPhase = 0
        
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
        
        chartView.animate(xAxisDuration: 2.5)
    
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
}


