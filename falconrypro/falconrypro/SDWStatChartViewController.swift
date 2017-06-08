//
//  SDWStatChartViewController.swift
//  falconrypro
//
//  Created by Alex Linkov on 6/1/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import UIKit
import Charts

enum ChartTimeFrame: Int {
    case week = 0,month, season, year, life
}

class SDWStatChartViewController: UIViewController, SDWPageable {

    var index: NSInteger = 0
    var currentChart:CellChartType?
    
    @IBOutlet weak var mainLabel: UILabel!
    var mainLabelText:String?
    let dataStore:SDWDataStore = SDWDataStore.sharedInstance
    @IBOutlet weak var barChart: HorizontalBarChartView!
    @IBOutlet weak var lineChart: LineChartView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.mainLabel.text = self.mainLabelText;
    }
    
    public func setupWithChartType(type:CellChartType, label:String,dataPoints:[ChartDataEntry]) {
        
        self.mainLabelText = label
        self.currentChart = type;
        
        switch type {
        case .WeightChart:
            self.setupWithWeightChart(dataPoints: dataPoints)
            break
            
        case .FoodWeight:
            self.setupWithWeightChart(dataPoints: dataPoints)
            break
            
        case .QuerryChart:
            self.setupWithBarChart(dataPoints: dataPoints)
            break
            
        default: break
            
        }
    }
    
    func changeTimeframe(timeframe:ChartTimeFrame) {
        
        switch self.currentChart! {
        case .WeightChart:
            //
            break
            
        case .FoodWeight:
            //
            break
            
        case .QuerryChart:
            //
            break
            
        default: break
            
        }

        
    }
    

    func setupWithWeightChart(dataPoints:[ChartDataEntry]) {
        
        self.view.sendSubview(toBack: self.barChart)
        
        self.lineChart.leftAxis.enabled = true;
        self.lineChart.rightAxis.drawAxisLineEnabled = true;
        self.lineChart.rightAxis.drawGridLinesEnabled = true;
        self.lineChart.xAxis.drawAxisLineEnabled = true;
        self.lineChart.xAxis.drawGridLinesEnabled = true;
        
        self.lineChart.drawGridBackgroundEnabled = true;
        self.lineChart.drawBordersEnabled = true;
        self.lineChart.dragEnabled = false;
        self.lineChart.setScaleEnabled(true)
        self.lineChart.pinchZoomEnabled = false;
        self.lineChart.xAxis.drawLabelsEnabled = true
        self.lineChart.rightAxis.drawLabelsEnabled = false
        
        self.lineChart.chartDescription?.enabled = true
        self.lineChart.legend.enabled = true
        
        self.lineChart.xAxis.valueFormatter = SDWChartDateValueFormatter()
        self.lineChart.xAxis.centerAxisLabelsEnabled = true
        self.lineChart.xAxis.granularity = 1
        if(dataPoints.count > 0) {
            self.lineChart.xAxis.axisMinimum = (dataPoints.first?.x)!
            self.lineChart.xAxis.axisMaximum = (dataPoints.last?.x)!
        }

        
        let dataset:LineChartDataSet = LineChartDataSet(values: dataPoints, label:"weight")
        dataset.lineWidth = 2.5;
        dataset.circleRadius = 4.0;
        dataset.circleHoleRadius = 2.0;
        dataset.axisDependency = .left
        dataset.mode = .cubicBezier
        dataset.setColor(UIColor.black)
        dataset.setCircleColor(UIColor.black)
        
        
        let hWeght = Double((self.dataStore.currentBird()?.huntingWeight)!)
        let fWeght = Double((self.dataStore.currentBird()?.fatWeight)!)
        let deadWeight = hWeght * 0.66
        
        let mdataPoint10:ChartDataEntry = ChartDataEntry(x: self.lineChart.xAxis.axisMinimum, y: hWeght)
        let mdataPoint20:ChartDataEntry = ChartDataEntry(x: self.lineChart.xAxis.axisMaximum, y: hWeght)
        
        
        let medianDataset:LineChartDataSet = LineChartDataSet(values: [mdataPoint10,mdataPoint20], label:"hunting weight")
        medianDataset.lineWidth = 1.5;
        medianDataset.circleRadius = 0.0;
        medianDataset.circleHoleRadius = 0.0;
        medianDataset.setColor( UIColor.blue.withAlphaComponent(0.5))
        medianDataset.setCircleColor(UIColor.blue)
        
        
        
        
        let deadPoint10:ChartDataEntry = ChartDataEntry(x: self.lineChart.xAxis.axisMinimum, y: deadWeight)
        let deadPoint20:ChartDataEntry = ChartDataEntry(x: self.lineChart.xAxis.axisMaximum, y: deadWeight)
        
        let deadDataset:LineChartDataSet = LineChartDataSet(values: [deadPoint10,deadPoint20], label:"danger zone")
        deadDataset.lineWidth = 1.0;
        deadDataset.circleRadius = 0.0;
        deadDataset.circleHoleRadius = 0.0;
        deadDataset.setColor( UIColor.red.withAlphaComponent(0.5))
        deadDataset.fillAlpha = 0.4
        deadDataset.fill = Fill.fillWithColor(UIColor.red)
        deadDataset.drawFilledEnabled = true;
        
        
        
        let fatPoint10:ChartDataEntry = ChartDataEntry(x: self.lineChart.xAxis.axisMinimum, y: fWeght)
        let fatPoint20:ChartDataEntry = ChartDataEntry(x: self.lineChart.xAxis.axisMaximum, y: fWeght)
        
        let fatDataset:LineChartDataSet = LineChartDataSet(values: [fatPoint10,fatPoint20], label:"maximum weight")
        fatDataset.lineWidth = 1.0;
        fatDataset.circleRadius = 0.0;
        fatDataset.circleHoleRadius = 0.0;
        fatDataset.setColor( UIColor.green.withAlphaComponent(0.5))
        
        
        
        let data:LineChartData = LineChartData(dataSets: [dataset,medianDataset,deadDataset,fatDataset])
        self.lineChart.data = data
        
        
    }
    
    func setupWithBarChart(dataPoints:[ChartDataEntry]) {
        
        
        self.view.sendSubview(toBack: self.lineChart)
        self.barChart.chartDescription?.enabled = false
        self.barChart.drawBarShadowEnabled = false
        
        self.barChart.drawBordersEnabled = false;
        self.barChart.dragEnabled = false;
        self.barChart.setScaleEnabled(true)
        self.barChart.pinchZoomEnabled = false;
        
        self.barChart.drawValueAboveBarEnabled = true
        self.barChart.maxVisibleCount = 60
        
        
        self.barChart.xAxis.labelPosition = .bottom
        self.barChart.xAxis.labelFont = UIFont.systemFont(ofSize: 10)
        self.barChart.xAxis.drawAxisLineEnabled = false
        self.barChart.xAxis.drawGridLinesEnabled = false
        self.barChart.xAxis.granularity = 10
        self.barChart.xAxis.enabled = false
        
        
        self.barChart.leftAxis.enabled = false;
        self.barChart.leftAxis.labelFont = UIFont.systemFont(ofSize: 10)
        self.barChart.leftAxis.drawAxisLineEnabled = false
        self.barChart.leftAxis.drawGridLinesEnabled = false
        
        
        
        
        self.barChart.rightAxis.axisMinimum = 0.0
        self.barChart.rightAxis.labelFont = UIFont.systemFont(ofSize: 10)
        self.barChart.rightAxis.drawAxisLineEnabled = false
        self.barChart.rightAxis.drawGridLinesEnabled = false
        self.barChart.rightAxis.enabled = false
        
        
        self.barChart.legend.horizontalAlignment = .left
        self.barChart.legend.verticalAlignment = .bottom
        self.barChart.legend.orientation = .horizontal
        self.barChart.legend.drawInside = false
        self.barChart.legend.form = .square
        self.barChart.legend.formSize = 8.0
        self.barChart.legend.font = UIFont.systemFont(ofSize: 10, weight: 0.2)
        self.barChart.legend.xEntrySpace = 4.0
        
        self.barChart.fitBars = true
        
        self.barChart.animate(yAxisDuration: 0.5)
        
        
        
        
        let legend1:LegendEntry = LegendEntry(label: "Rabbit", form: .square, formSize: 10, formLineWidth: 1.0, formLineDashPhase: 0.0, formLineDashLengths: [], formColor: UIColor.red)
        let legend2:LegendEntry = LegendEntry(label: "Rabbit", form: .square, formSize: 10, formLineWidth: 1.0, formLineDashPhase: 0.0, formLineDashLengths: [], formColor: UIColor.red)
        let legend3:LegendEntry = LegendEntry(label: "Rabbit", form: .square, formSize: 10, formLineWidth: 1.0, formLineDashPhase: 0.0, formLineDashLengths: [], formColor: UIColor.red)
        
        self.barChart.legend.entries = [legend1,legend2,legend3]
        
        let dataSet:BarChartDataSet = BarChartDataSet(values: [dataPoints[0]], label: "Rabbit")
        dataSet.setColor(UIColor.lightGray)
        let dataSet1:BarChartDataSet = BarChartDataSet(values: [dataPoints[1]], label: "Mice")
        dataSet1.setColor(UIColor.gray)
        let dataSet2:BarChartDataSet = BarChartDataSet(values: [dataPoints[2]], label: "Rats")
        dataSet2.setColor(UIColor.black)
        
        
        
        let data:BarChartData = BarChartData(dataSets: [dataSet,dataSet1,dataSet2])
        data.barWidth = 9.0
        
        self.barChart.data = data
        
        
        
        
        
        
    }


}
