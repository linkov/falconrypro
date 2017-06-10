//
//  SDWStatChartViewController.swift
//  falconrypro
//
//  Created by Alex Linkov on 6/1/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import UIKit
import Charts
import SwiftDate

enum ChartTimeFrame: Int {
    case week = 0,month, season, life
}

class SDWStatChartViewController: UIViewController, SDWPageable {

    var index: NSInteger = 0
    var currentChart:CellChartType?
    
    
    var medianDataset:LineChartDataSet?
    var deadDataset:LineChartDataSet?
    var fatDataset:LineChartDataSet?
    
    
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
        
        var startDate:DateInRegion = DateInRegion() - 1.week
        let currentSeasonStart:DateInRegion = (dataStore.currentSeason()?.start?.inDefaultRegion())!
        
        
        switch timeframe {
        case .week:
            
            startDate =  DateInRegion() - 1.week
            break
        case .month:
            startDate =  DateInRegion() - 1.month
            break
        case .season:
            startDate = currentSeasonStart
            break
        case .life:
            startDate = currentSeasonStart
            break


        }
        
        
        switch self.currentChart! {
        case .WeightChart:
            setupTimeframeForLineChart(start: startDate)
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
    
    func setupTimeframeForLineChart(start:DateInRegion) {
        
        self.lineChart.xAxis.axisMinimum = start.absoluteDate.timeIntervalSince1970
        self.lineChart.notifyDataSetChanged()
        
        
        self.lineChart.data?.removeDataSet(self.medianDataset)
        self.lineChart.data?.removeDataSet(self.deadDataset)
        self.lineChart.data?.removeDataSet(self.fatDataset)
        

        
        let hWeght = Double((self.dataStore.currentBird()?.huntingWeight)!)
        let fWeght = Double((self.dataStore.currentBird()?.fatWeight)!)
        let deadWeight = hWeght * 0.66
        
        let mdataPoint10:ChartDataEntry = ChartDataEntry(x: self.lineChart.xAxis.axisMinimum, y: hWeght)
        let mdataPoint20:ChartDataEntry = ChartDataEntry(x: self.lineChart.xAxis.axisMaximum, y: hWeght)
        
        
        self.medianDataset = LineChartDataSet(values: [mdataPoint10,mdataPoint20], label:"hunting weight")
        self.medianDataset?.lineWidth = 2;
        self.medianDataset?.circleRadius = 0.0;
        self.medianDataset?.circleHoleRadius = 0.0;
        self.medianDataset?.setColor( .green)
        
        
        
        
        let deadPoint10:ChartDataEntry = ChartDataEntry(x: self.lineChart.xAxis.axisMinimum, y: deadWeight)
        let deadPoint20:ChartDataEntry = ChartDataEntry(x: self.lineChart.xAxis.axisMaximum, y: deadWeight)
        
        self.deadDataset = LineChartDataSet(values: [deadPoint10,deadPoint20], label:"danger zone")
        self.deadDataset?.lineWidth = 1.0;
        self.deadDataset?.circleRadius = 0.0;
        self.deadDataset?.circleHoleRadius = 0.0;
        self.deadDataset?.setColor( UIColor.red.withAlphaComponent(0.5))
        self.deadDataset?.fillAlpha = 0.4
        self.deadDataset?.fill = Fill.fillWithColor(UIColor.red)
        self.deadDataset?.drawFilledEnabled = true;
        
        
        
        let fatPoint10:ChartDataEntry = ChartDataEntry(x: self.lineChart.xAxis.axisMinimum, y: fWeght)
        let fatPoint20:ChartDataEntry = ChartDataEntry(x: self.lineChart.xAxis.axisMaximum, y: fWeght)
        
        self.fatDataset = LineChartDataSet(values: [fatPoint10,fatPoint20], label:"maximum weight")
        self.fatDataset?.lineWidth = 1.0;
        self.fatDataset?.circleRadius = 0.0;
        self.fatDataset?.circleHoleRadius = 0.0;
        self.fatDataset?.setColor( UIColor.green.withAlphaComponent(0.5))
        
        
        self.lineChart.data?.addDataSet(self.medianDataset)
        self.lineChart.data?.addDataSet(self.deadDataset)
        self.lineChart.data?.addDataSet(self.fatDataset)
    
        self.lineChart.notifyDataSetChanged()

  
    }
    

    func setupWithWeightChart(dataPoints:[ChartDataEntry]) {
        
        self.view.sendSubview(toBack: self.barChart)
        
        self.lineChart.leftAxis.enabled = false;
        self.lineChart.rightAxis.drawAxisLineEnabled = false;
        self.lineChart.rightAxis.drawGridLinesEnabled = false;
        self.lineChart.xAxis.drawAxisLineEnabled = false;
        self.lineChart.xAxis.drawGridLinesEnabled = false;
        
        self.lineChart.drawGridBackgroundEnabled = false;
        self.lineChart.drawBordersEnabled = true;
        self.lineChart.dragEnabled = false;
        self.lineChart.setScaleEnabled(true)
        self.lineChart.pinchZoomEnabled = false;
        self.lineChart.xAxis.drawLabelsEnabled = true
        self.lineChart.rightAxis.drawLabelsEnabled = false
        
        self.lineChart.chartDescription?.enabled = false
        self.lineChart.legend.enabled = false
        
        self.lineChart.xAxis.valueFormatter = SDWChartDateValueFormatter()
        self.lineChart.xAxis.centerAxisLabelsEnabled = true
        self.lineChart.xAxis.granularity = 1
        if(dataPoints.count > 0) {
            self.lineChart.xAxis.axisMinimum = (dataPoints.first?.x)!
            self.lineChart.xAxis.axisMaximum = (Date().timeIntervalSince1970)
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
        
        
        self.medianDataset = LineChartDataSet(values: [mdataPoint10,mdataPoint20], label:"hunting weight")
        self.medianDataset?.lineWidth = 2;
        self.medianDataset?.circleRadius = 0.0;
        self.medianDataset?.circleHoleRadius = 0.0;
        self.medianDataset?.setColor( .green)
        
        
        
        
        let deadPoint10:ChartDataEntry = ChartDataEntry(x: self.lineChart.xAxis.axisMinimum, y: deadWeight)
        let deadPoint20:ChartDataEntry = ChartDataEntry(x: self.lineChart.xAxis.axisMaximum, y: deadWeight)
        
        self.deadDataset = LineChartDataSet(values: [deadPoint10,deadPoint20], label:"danger zone")
        self.deadDataset?.lineWidth = 1.0;
        self.deadDataset?.circleRadius = 0.0;
        self.deadDataset?.circleHoleRadius = 0.0;
        self.deadDataset?.setColor( UIColor.red.withAlphaComponent(0.5))
        self.deadDataset?.fillAlpha = 0.4
        self.deadDataset?.fill = Fill.fillWithColor(UIColor.red)
        self.deadDataset?.drawFilledEnabled = true;
        
        
        
        let fatPoint10:ChartDataEntry = ChartDataEntry(x: self.lineChart.xAxis.axisMinimum, y: fWeght)
        let fatPoint20:ChartDataEntry = ChartDataEntry(x: self.lineChart.xAxis.axisMaximum, y: fWeght)
        
        self.fatDataset = LineChartDataSet(values: [fatPoint10,fatPoint20], label:"maximum weight")
        self.fatDataset?.lineWidth = 1.0;
        self.fatDataset?.fillAlpha = 0.4
        self.fatDataset?.circleRadius = 0.0;
        self.fatDataset?.circleHoleRadius = 0.0;
        self.fatDataset?.fill = Fill.fillWithColor(UIColor.red)
        self.fatDataset?.setColor( UIColor.red.withAlphaComponent(0.5))
        
        
        
        
        let data:LineChartData = LineChartData(dataSets: [dataset,self.medianDataset!,self.deadDataset!,self.fatDataset!])
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
