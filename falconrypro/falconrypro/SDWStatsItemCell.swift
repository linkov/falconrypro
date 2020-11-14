//
//  SDWStatsItemCell.swift
//  falconrypro
//
//  Created by Alex Linkov on 5/11/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import UIKit
import Charts

enum CellChartType: Int {
    case WeightChart = 1,FoodWeight, QuerryChart
}

class SDWStatsItemCell: UITableViewCell {
    
    
    @IBOutlet weak var centeredLabel: UILabel!
    let dataStore:SDWDataStore = SDWDataStore.sharedInstance
    var dataSets:Array<Any>?
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var chartViewLineHorizontal: LineChartView!
    @IBOutlet weak var chartViewBarHorizontal: HorizontalBarChartView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    public func setupWithLink(text:String) {
        self.centeredLabel.isHidden = false
        self.centeredLabel.text = text
        
        self.mainTitleLabel.isHidden = true
        self.chartViewBarHorizontal.isHidden = true
        self.chartViewLineHorizontal.isHidden = true
    }
    
    public func setupWithChartType(type:CellChartType, label:String,dataPoints:[ChartDataEntry]) {
    
        self.mainTitleLabel.text = label
        self.centeredLabel.isHidden = true
        
        switch type {
        case .WeightChart:
            self.setupWithWeightChart(dataPoints: dataPoints)
        break
            
        case .FoodWeight:
            self.setupWithFoodWeightChart(dataPoints: dataPoints)
            break
            
        case .QuerryChart:
            self.setupWithBarChart(dataPoints: dataPoints)
        break
            
        default: break
            
        }
    }
    
    
    func setupWithWeightChart(dataPoints:[ChartDataEntry]) {
        
        self.contentView.sendSubviewToBack(self.chartViewBarHorizontal)
        
        
        self.chartViewLineHorizontal.leftAxis.enabled = false;
        self.chartViewLineHorizontal.rightAxis.drawAxisLineEnabled = false;
        self.chartViewLineHorizontal.rightAxis.drawGridLinesEnabled = false;
        self.chartViewLineHorizontal.xAxis.drawAxisLineEnabled = false;
        self.chartViewLineHorizontal.xAxis.drawGridLinesEnabled = false;
        
        self.chartViewLineHorizontal.drawGridBackgroundEnabled = false;
        self.chartViewLineHorizontal.drawBordersEnabled = false;
        self.chartViewLineHorizontal.dragEnabled = false;
        self.chartViewLineHorizontal.setScaleEnabled(true)
        self.chartViewLineHorizontal.pinchZoomEnabled = false;
        self.chartViewLineHorizontal.xAxis.drawLabelsEnabled = false
        self.chartViewLineHorizontal.rightAxis.drawLabelsEnabled = false
        
        self.chartViewLineHorizontal.chartDescription?.enabled = false
        self.chartViewLineHorizontal.legend.enabled = false
        

        
        let dataset:LineChartDataSet = LineChartDataSet(entries: dataPoints, label:"weight")
        dataset.lineWidth = 2.5;
        dataset.circleRadius = 4.0;
        dataset.circleHoleRadius = 2.0;
        dataset.mode = .cubicBezier
        dataset.setColor(AppUtility.app_color_black)
        dataset.setCircleColor(AppUtility.app_color_black)
        
        
        let hWeght = Double((self.dataStore.currentBird()?.huntingWeight)!)
        let fWeght = Double((self.dataStore.currentBird()?.fatWeight)!)
        let deadWeight = hWeght * 0.66
        
        let mdataPoint10:ChartDataEntry = ChartDataEntry(x: 1, y: hWeght)
        let mdataPoint20:ChartDataEntry = ChartDataEntry(x: 30, y: hWeght)

        
        let medianDataset:LineChartDataSet = LineChartDataSet(entries: [mdataPoint10,mdataPoint20], label:"median")
        medianDataset.lineWidth = 1.5;
        medianDataset.circleRadius = 0.0;
        medianDataset.circleHoleRadius = 0.0;
        medianDataset.setColor( UIColor.blue.withAlphaComponent(0.5))
        medianDataset.setCircleColor(UIColor.blue)
        
        
        
        
        let deadPoint10:ChartDataEntry = ChartDataEntry(x: 1, y: deadWeight)
        let deadPoint20:ChartDataEntry = ChartDataEntry(x: 30, y: deadWeight)
        
        let deadDataset:LineChartDataSet = LineChartDataSet(entries: [deadPoint10,deadPoint20], label:"median")
        deadDataset.lineWidth = 1.0;
        deadDataset.circleRadius = 0.0;
        deadDataset.circleHoleRadius = 0.0;
        deadDataset.setColor( UIColor.red.withAlphaComponent(0.5))
        deadDataset.fillAlpha = 0.4
        deadDataset.fill = Fill.fillWithColor(UIColor.red)
        deadDataset.drawFilledEnabled = true;
        
        
        
        let fatPoint10:ChartDataEntry = ChartDataEntry(x: 1, y: fWeght)
        let fatPoint20:ChartDataEntry = ChartDataEntry(x: 30, y: fWeght)
        
        let fatDataset:LineChartDataSet = LineChartDataSet(entries: [fatPoint10,fatPoint20], label:"median")
        fatDataset.lineWidth = 1.0;
        fatDataset.circleRadius = 0.0;
        fatDataset.circleHoleRadius = 0.0;
        fatDataset.setColor( UIColor.green.withAlphaComponent(0.5))

        
        
        let data:LineChartData = LineChartData(dataSets: [dataset,medianDataset,deadDataset,fatDataset])
        self.chartViewLineHorizontal.data = data


    }
    
    func setupWithFoodWeightChart(dataPoints:[ChartDataEntry]) {
    }
    
    func setupWithBarChart(dataPoints:[ChartDataEntry]) {
        
        self.contentView.sendSubviewToBack(self.chartViewLineHorizontal)
        self.chartViewBarHorizontal.chartDescription?.enabled = false
        self.chartViewBarHorizontal.drawBarShadowEnabled = false
        
        self.chartViewBarHorizontal.drawBordersEnabled = false;
        self.chartViewBarHorizontal.dragEnabled = false;
        self.chartViewBarHorizontal.setScaleEnabled(true)
        self.chartViewBarHorizontal.pinchZoomEnabled = false;
        
        self.chartViewBarHorizontal.drawValueAboveBarEnabled = true
        self.chartViewBarHorizontal.maxVisibleCount = 60
        
        
        self.chartViewBarHorizontal.xAxis.labelPosition = .bottom
        self.chartViewBarHorizontal.xAxis.labelFont = UIFont.systemFont(ofSize: 10)
        self.chartViewBarHorizontal.xAxis.drawAxisLineEnabled = false
        self.chartViewBarHorizontal.xAxis.drawGridLinesEnabled = false
        self.chartViewBarHorizontal.xAxis.granularity = 10
        self.chartViewBarHorizontal.xAxis.enabled = false
        
        
        self.chartViewBarHorizontal.leftAxis.enabled = false;
        self.chartViewBarHorizontal.leftAxis.labelFont = UIFont.systemFont(ofSize: 10)
        self.chartViewBarHorizontal.leftAxis.drawAxisLineEnabled = false
        self.chartViewBarHorizontal.leftAxis.drawGridLinesEnabled = false
        
        
        
        
        self.chartViewBarHorizontal.rightAxis.axisMinimum = 0.0
        self.chartViewBarHorizontal.rightAxis.labelFont = UIFont.systemFont(ofSize: 10)
        self.chartViewBarHorizontal.rightAxis.drawAxisLineEnabled = false
        self.chartViewBarHorizontal.rightAxis.drawGridLinesEnabled = false
        self.chartViewBarHorizontal.rightAxis.enabled = false

        
        self.chartViewBarHorizontal.legend.horizontalAlignment = .left
        self.chartViewBarHorizontal.legend.verticalAlignment = .bottom
        self.chartViewBarHorizontal.legend.orientation = .horizontal
        self.chartViewBarHorizontal.legend.drawInside = false
        self.chartViewBarHorizontal.legend.form = .square
        self.chartViewBarHorizontal.legend.formSize = 8.0
        self.chartViewBarHorizontal.legend.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight(rawValue: 0.2))
        self.chartViewBarHorizontal.legend.xEntrySpace = 4.0
        
        self.chartViewBarHorizontal.fitBars = true
        
        self.chartViewBarHorizontal.animate(yAxisDuration: 0.5)
        
        

        
        let legend1:LegendEntry = LegendEntry(label: "Rabbit", form: .square, formSize: 10, formLineWidth: 1.0, formLineDashPhase: 0.0, formLineDashLengths: [], formColor: UIColor.red)
        let legend2:LegendEntry = LegendEntry(label: "Rabbit", form: .square, formSize: 10, formLineWidth: 1.0, formLineDashPhase: 0.0, formLineDashLengths: [], formColor: UIColor.red)
        let legend3:LegendEntry = LegendEntry(label: "Rabbit", form: .square, formSize: 10, formLineWidth: 1.0, formLineDashPhase: 0.0, formLineDashLengths: [], formColor: UIColor.red)
        
        self.chartViewBarHorizontal.legend.entries = [legend1,legend2,legend3]
        
        let dataSet:BarChartDataSet = BarChartDataSet(entries: [dataPoints[0]], label: "Rabbit")
        dataSet.setColor(UIColor.lightGray)
        let dataSet1:BarChartDataSet = BarChartDataSet(entries: [dataPoints[1]], label: "Mice")
        dataSet1.setColor(UIColor.gray)
        let dataSet2:BarChartDataSet = BarChartDataSet(entries: [dataPoints[2]], label: "Rats")
        dataSet2.setColor(AppUtility.app_color_black)


        
        let data:BarChartData = BarChartData(dataSets: [dataSet,dataSet1,dataSet2])
        data.barWidth = 9.0
        
        self.chartViewBarHorizontal.data = data
        
        


        
        
    }

}
