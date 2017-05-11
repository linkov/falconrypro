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
    case WeightChart = 1, QuerryChart
}

class SDWStatsItemCell: UITableViewCell {
    
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
    
    public func setupWithChartType(type:CellChartType, label:String,dataPoints:[ChartDataEntry]) {
    
        self.mainTitleLabel.text = label
        
        switch type {
        case .WeightChart:
            self.setupWithLineChart(dataPoints: dataPoints)
        break
            
        case .QuerryChart:
            self.setupWithBarChart(dataPoints: dataPoints)
        break
            
        default: break
            
        }
    }
    
    
    func setupWithLineChart(dataPoints:[ChartDataEntry]) {
        
        self.contentView.sendSubview(toBack: self.chartViewBarHorizontal)
        
        
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
        

        
        let dataset:LineChartDataSet = LineChartDataSet(values: dataPoints, label:"weight")
        dataset.lineWidth = 2.5;
        dataset.circleRadius = 4.0;
        dataset.circleHoleRadius = 2.0;
        dataset.setColor(UIColor.black)
        dataset.setCircleColor(UIColor.black)
        
        
        let data:LineChartData = LineChartData(dataSets: [dataset])
        self.chartViewLineHorizontal.data = data


    }
    
    func setupWithBarChart(dataPoints:[ChartDataEntry]) {
        
        self.contentView.sendSubview(toBack: self.chartViewLineHorizontal)
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
        self.chartViewBarHorizontal.legend.font = UIFont.systemFont(ofSize: 10, weight: 0.2)
        self.chartViewBarHorizontal.legend.xEntrySpace = 4.0
        
        self.chartViewBarHorizontal.fitBars = true
        
        self.chartViewBarHorizontal.animate(yAxisDuration: 0.5)
        
        

        
        let legend1:LegendEntry = LegendEntry(label: "Rabbit", form: .square, formSize: 10, formLineWidth: 1.0, formLineDashPhase: 0.0, formLineDashLengths: [], formColor: UIColor.red)
        let legend2:LegendEntry = LegendEntry(label: "Rabbit", form: .square, formSize: 10, formLineWidth: 1.0, formLineDashPhase: 0.0, formLineDashLengths: [], formColor: UIColor.red)
        let legend3:LegendEntry = LegendEntry(label: "Rabbit", form: .square, formSize: 10, formLineWidth: 1.0, formLineDashPhase: 0.0, formLineDashLengths: [], formColor: UIColor.red)
        
        self.chartViewBarHorizontal.legend.entries = [legend1,legend2,legend3]
        
        let dataSet:BarChartDataSet = BarChartDataSet(values: [dataPoints[0]], label: "Rabbit")
        dataSet.setColor(UIColor.lightGray)
        let dataSet1:BarChartDataSet = BarChartDataSet(values: [dataPoints[1]], label: "Mice")
        dataSet1.setColor(UIColor.gray)
        let dataSet2:BarChartDataSet = BarChartDataSet(values: [dataPoints[2]], label: "Rats")
        dataSet2.setColor(UIColor.black)


        
        let data:BarChartData = BarChartData(dataSets: [dataSet,dataSet1,dataSet2])
        data.barWidth = 9.0
        
        self.chartViewBarHorizontal.data = data
        
        


        
        
    }

}
