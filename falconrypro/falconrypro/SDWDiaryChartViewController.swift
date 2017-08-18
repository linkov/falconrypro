//
//  SDWDiaryChartViewController.swift
//  falconrypro
//
//  Created by Alex Linkov on 8/18/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import UIKit
import Charts
import SwiftDate

class SDWDiaryChartViewController: UIViewController, ChartViewDelegate {

    @IBOutlet weak var lineChart: LineChartView!
    let dataStore: SDWDataStore = SDWDataStore.sharedInstance
    
    var bird:BirdDisplayItem?
    var season:SeasonDisplayItem?
    var existingTodayItem:DiaryItemDisplayItem?
    var lastSelectedItem:DiaryItemDisplayItem?
    
    var medianDataset:LineChartDataSet?
    var deadDataset:LineChartDataSet?
    var fatDataset:LineChartDataSet?
    
    var objects:[DiaryItemDisplayItem]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lineChart.delegate = self
        
//

        self.fetchItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lineChart.layer.anchorPoint = CGPoint(x:0.5,y: 0.5);
        lineChart.transform = CGAffineTransform(rotationAngle: -(CGFloat.pi/2))
        lineChart.frame = CGRect(x: 10, y: 60, width: self.view.frame.width-20, height: self.view.frame.height-40)

    }

    func loadItems() {
        
    
        if (objects?.count == 0) {
            return
        }
        
        var startDate:DateInRegion = DateInRegion() - 1.week
        let currentSeasonStart:DateInRegion = (dataStore.currentSeason()?.start?.inDefaultRegion())!
        
        let allItems = objects
        var points = [ChartDataEntry]()
        
        for itm:DiaryItemDisplayItem in allItems! {
            
            
            let lastDayWeight = Double((itm.weights?.last?.weight)!)
            let time = itm.model.createdAt?.timeIntervalSince1970
            var point:ChartDataEntry = ChartDataEntry(x:time!, y: lastDayWeight)
            points.append(point)
            
        }
        
        
        setupWithWeightChart(dataPoints:points.sorted { $0.x < $1.x });
        setupTimeframeForLineChart(start: currentSeasonStart)

    }
    
    func fetchItems() {
        
        self.dataStore.pullAllDiaryItemsForSeason(seasonID: (self.season?.remoteID)!, currentData: { (objects, error) in
            
            
            guard let data = objects, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            
            
            
            self.objects = data as! [DiaryItemDisplayItem]
            self.objects = self.objects?.sorted { $0.model.createdAt?.compare($1.model.createdAt as! Date) == .orderedDescending }
            self.loadItems()
            
        }) { (fetched, error) in
            
            
            
            guard let data = fetched, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            self.objects = data as! [DiaryItemDisplayItem]
            self.objects = self.objects?.sorted { $0.model.createdAt?.compare($1.model.createdAt as! Date) == .orderedDescending }
            self.loadItems()
            
        }
    }
    
    
    func setupWithWeightChart(dataPoints:[ChartDataEntry]) {
        
      
        self.lineChart.leftAxis.enabled = false;
        self.lineChart.rightAxis.drawAxisLineEnabled = false;
        self.lineChart.rightAxis.drawGridLinesEnabled = false;
        self.lineChart.xAxis.drawAxisLineEnabled = false;
        self.lineChart.xAxis.drawGridLinesEnabled = false;
        
        
        
        self.lineChart.drawGridBackgroundEnabled = false;
        self.lineChart.drawBordersEnabled = false;
        self.lineChart.dragEnabled = true;
        self.lineChart.setScaleEnabled(false)
        self.lineChart.setScaleMinima(1.8, scaleY: 1.0)
        
        self.lineChart.pinchZoomEnabled = false;
        self.lineChart.xAxis.drawLabelsEnabled = true
        self.lineChart.xAxis.labelRotationAngle = 90
        self.lineChart.xAxis.labelTextColor = AppUtility.app_color_lightGray
        
   
        self.lineChart.rightAxis.drawLabelsEnabled = false
        
        self.lineChart.chartDescription?.enabled = false
        self.lineChart.legend.enabled = false
        
        self.lineChart.xAxis.valueFormatter = SDWChartDateValueFormatter()
        self.lineChart.xAxis.centerAxisLabelsEnabled = true
        self.lineChart.xAxis.granularity = 2
        if(dataPoints.count > 0) {
            self.lineChart.xAxis.axisMinimum = (dataPoints.first?.x)!
            self.lineChart.xAxis.axisMaximum = ((dataPoints.last?.x)!+100000)
            self.lineChart.moveViewToX((dataPoints.last?.x)!)
            let yPoints = dataPoints.map{ $0.y }
            
            
            self.lineChart.leftAxis.axisMinimum = yPoints.min()!-250
            self.lineChart.leftAxis.axisMaximum = yPoints.max()!+250
            
        }
        

        
        
        let dataset:LineChartDataSet = LineChartDataSet(values: dataPoints, label:"weight")
        dataset.lineWidth = 2.5;
    
        dataset.circleRadius = 4.0;
        dataset.circleHoleRadius = 2.0;
        dataset.axisDependency = .left
        dataset.mode = .cubicBezier
        
        dataset.cubicIntensity = 0.07
        dataset.setColor(AppUtility.app_color_black)
        dataset.setCircleColor(AppUtility.app_color_black)
        
        
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
        
        
        
        
        let data:LineChartData = LineChartData(dataSets: [dataset])
        self.lineChart.data = data
        
        
    }
    
    func setupTimeframeForLineChart(start:DateInRegion) {
        
        self.lineChart.xAxis.axisMinimum = start.absoluteDate.timeIntervalSince1970
        self.lineChart.notifyDataSetChanged()
        
        
//        self.lineChart.data?.removeDataSet(self.medianDataset)
//        self.lineChart.data?.removeDataSet(self.deadDataset)
//        self.lineChart.data?.removeDataSet(self.fatDataset)
//        
//        
//        
//        let hWeght = Double((self.dataStore.currentBird()?.huntingWeight)!)
//        let fWeght = Double((self.dataStore.currentBird()?.fatWeight)!)
//        let deadWeight = hWeght * 0.66
//        
//        let mdataPoint10:ChartDataEntry = ChartDataEntry(x: self.lineChart.xAxis.axisMinimum, y: hWeght)
//        let mdataPoint20:ChartDataEntry = ChartDataEntry(x: self.lineChart.xAxis.axisMaximum, y: hWeght)
//        
//        
//        self.medianDataset = LineChartDataSet(values: [mdataPoint10,mdataPoint20], label:"hunting weight")
//        self.medianDataset?.lineWidth = 2;
//        self.medianDataset?.circleRadius = 0.0;
//        self.medianDataset?.circleHoleRadius = 0.0;
//        self.medianDataset?.setColor( .green)
//        
//        
//        
//        
//        let deadPoint10:ChartDataEntry = ChartDataEntry(x: self.lineChart.xAxis.axisMinimum, y: deadWeight)
//        let deadPoint20:ChartDataEntry = ChartDataEntry(x: self.lineChart.xAxis.axisMaximum, y: deadWeight)
//        
//        self.deadDataset = LineChartDataSet(values: [deadPoint10,deadPoint20], label:"danger zone")
//        self.deadDataset?.lineWidth = 1.0;
//        self.deadDataset?.circleRadius = 0.0;
//        self.deadDataset?.circleHoleRadius = 0.0;
//        self.deadDataset?.setColor( UIColor.red.withAlphaComponent(0.5))
//        self.deadDataset?.fillAlpha = 0.4
//        self.deadDataset?.fill = Fill.fillWithColor(UIColor.red)
//        self.deadDataset?.drawFilledEnabled = true;
//        
//        
//        
//        let fatPoint10:ChartDataEntry = ChartDataEntry(x: self.lineChart.xAxis.axisMinimum, y: fWeght)
//        let fatPoint20:ChartDataEntry = ChartDataEntry(x: self.lineChart.xAxis.axisMaximum, y: fWeght)
//        
//        self.fatDataset = LineChartDataSet(values: [fatPoint10,fatPoint20], label:"maximum weight")
//        self.fatDataset?.lineWidth = 1.0;
//        self.fatDataset?.circleRadius = 0.0;
//        self.fatDataset?.circleHoleRadius = 0.0;
//        self.fatDataset?.setColor( UIColor.green.withAlphaComponent(0.5))
//        
//        
//        self.lineChart.data?.addDataSet(self.medianDataset)
//        self.lineChart.data?.addDataSet(self.deadDataset)
//        self.lineChart.data?.addDataSet(self.fatDataset)
//        
//        self.lineChart.notifyDataSetChanged()
//        
        
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
        
        
        let object:DiaryItemDisplayItem = (objects?.filter { Double(($0.weights?.last?.weight)!) == entry.y}.first)!
        
        
        
        let diaryController:SDWDiaryItemContainerViewController = storyboard?.instantiateViewController(withIdentifier: "SDWDiaryItemContainerViewController") as! SDWDiaryItemContainerViewController
        
        diaryController.bird = bird
        diaryController.diaryItem = object
        lastSelectedItem = object
        
        self.navigationController?.pushViewController(diaryController, animated: true)
    }
    
 


}
