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
import PKHUD

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
    @IBOutlet weak var birdEditButton: UIButton!
    

    var objects:[DiaryItemDisplayItem]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lineChart.delegate = self
         PKHUD.sharedHUD.contentView = PKHUDProgressView()
//

        self.fetchItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lineChart.layer.anchorPoint = CGPoint(x:0.5,y: 0.5);
        lineChart.transform = CGAffineTransform(rotationAngle: -(CGFloat.pi/2))
        lineChart.frame = CGRect(x: 10, y: 60, width: self.view.frame.width-20, height: self.view.frame.height-40)
        
        self.birdEditButton.setTitle(self.title, for: .normal)
        self.birdEditButton.contentMode = .center
        self.birdEditButton.imageView?.contentMode = .scaleAspectFit

    }

    func loadItems() {
        
    
        if (objects?.count == 0) {
            return
        }
        
        var startDate:DateInRegion = DateInRegion() // - 1.week
        let currentSeasonStart:DateInRegion = (dataStore.currentSeason()?.start?.inDefaultRegion())!
        
        let allItems = objects
        var points = [ChartDataEntry]()
        var foodPoints = [ChartDataEntry]()
        
        var huntingWeightPoints = [ChartDataEntry]()
        
        
        
        
        
        
        
        
        
        var date = currentSeasonStart.date // first date
        let endDate = Date() // last date
        let calendar = Calendar.current
        // Formatter for printing the date, adjust it according to your needs:
        let fmt = DateFormatter()
        fmt.dateFormat = "dd/MM/yyyy"
        
        while date <= endDate {
           // print(fmt.string(from: date))
            date = calendar.date(byAdding: .day, value: 1, to: date)!
            let point:ChartDataEntry = ChartDataEntry(x:date.timeIntervalSince1970, y: Double( (dataStore.currentBird()?.huntingWeight)!) )
            huntingWeightPoints.append(point)
            
            
            let weightItem = allItems?.filter { ($0.model.createdAt! as Date) == date }.first
            
            if (weightItem != nil) {
                let lastDayWeight = Double((weightItem?.weights?.last?.weight)!)
                let bla:Date = (weightItem!.model.createdAt as Date?)!
                let time = bla.timeIntervalSince1970
                let point:ChartDataEntry = ChartDataEntry(x:time, y: lastDayWeight)
                point.icon = #imageLiteral(resourceName: "disc_blue_fill")
                points.append(point)

//                print("got weight item for \(weightItem?.model.createdAt)")
            } else {
                let point:ChartDataEntry = ChartDataEntry()
                point.x = date.timeIntervalSince1970
                point.y = Double( (dataStore.currentBird()?.huntingWeight)!)
                point.icon = #imageLiteral(resourceName: "disc_blue_stoke")
                points.append(point)
            }
            
            
        }
        
        
    
//        for f in stride(from: from, through: to, by: hourSeconds) {
//            print(f)
//            let point:ChartDataEntry = ChartDataEntry(x:f, y: Double( (dataStore.currentBird()?.huntingWeight)!) )
//            huntingWeightPoints.append(point)
//        } // 0 2 4 6 8 10
//        
//        NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
//        NSTimeInterval hourSeconds = 3600.0;
//        
//        NSMutableArray *values = [[NSMutableArray alloc] init];
//        
//        NSTimeInterval from = now - (count / 2.0) * hourSeconds;
//        NSTimeInterval to = now + (count / 2.0) * hourSeconds;
//        
//        for (NSTimeInterval x = from; x < to; x += hourSeconds)
//        {
//            double y = arc4random_uniform(range) + 50;
//            [values addObject:[[ChartDataEntry alloc] initWithX:x y:y]];
//        }
        
        
        
//        for itm:DiaryItemDisplayItem in allItems! {
//            
//            if (itm.weights != nil && itm.weights?.last != nil) {
//                let lastDayWeight = Double((itm.weights?.last?.weight)!)
//                let bla:Date = (itm.model.createdAt as Date?)!
//                let time = bla.startOfDay.timeIntervalSince1970
//                let point:ChartDataEntry = ChartDataEntry(x:time, y: lastDayWeight)
//                points.append(point)
//
//            }
//            
//
//            
//        }
//        
        
        for itm1:DiaryItemDisplayItem in allItems! {
            
            
            let lastDayGramms = itm1.foods?.reduce(0) { $0 + ($1.amountEaten ?? 0) }
            let bla:Date = (itm1.model.createdAt as Date?)!
            let time = bla.timeIntervalSince1970
            let FoodPoint:ChartDataEntry = ChartDataEntry(x:time, y: Double(lastDayGramms!))
            foodPoints.append(FoodPoint)

            
        }
        
        
        setupWithWeightChart(dataPoints:points.sorted { $0.x < $1.x }, foodPoints: foodPoints.sorted { $0.x < $1.x }, huntingWeightPoints: huntingWeightPoints.sorted { $0.x < $1.x });
        setupTimeframeForLineChart(start: currentSeasonStart)
        
        PKHUD.sharedHUD.hide()

    }
    
    func fetchItems() {
        
        PKHUD.sharedHUD.show()
        
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
    
    
    func setupWithWeightChart(dataPoints:[ChartDataEntry],foodPoints:[ChartDataEntry],huntingWeightPoints:[ChartDataEntry]) {
        
      
        self.lineChart.leftAxis.enabled = false;
        self.lineChart.rightAxis.drawAxisLineEnabled = false;
        self.lineChart.rightAxis.drawGridLinesEnabled = false;
        self.lineChart.xAxis.drawAxisLineEnabled = false;
        self.lineChart.xAxis.drawGridLinesEnabled = false;

        
        self.lineChart.drawGridBackgroundEnabled = false;
        self.lineChart.drawBordersEnabled = false;
        self.lineChart.dragEnabled = true;
        self.lineChart.setScaleEnabled(false)
        self.lineChart.setScaleMinima(CGFloat(8), scaleY: 1.0)
        

        
        self.lineChart.pinchZoomEnabled = false;
        self.lineChart.xAxis.drawLabelsEnabled = true
//        self.lineChart.xAxis.labelRotationAngle = 90
        self.lineChart.xAxis.labelTextColor = AppUtility.app_color_lightGray
        
   
        self.lineChart.rightAxis.drawLabelsEnabled = false
        self.lineChart.chartDescription?.enabled = false
        self.lineChart.legend.enabled = false
        
        self.lineChart.xAxis.valueFormatter = SDWChartDateValueFormatter()
        self.lineChart.xAxis.centerAxisLabelsEnabled = false
        self.lineChart.xAxis.granularity = 2
        
        if(dataPoints.count > 0) {
            self.lineChart.xAxis.axisMinimum = (huntingWeightPoints.first?.x)!
            self.lineChart.xAxis.axisMaximum = ((huntingWeightPoints.last?.x)!+100000)
            self.lineChart.moveViewToAnimated(xValue: (huntingWeightPoints.last?.x)!, yValue: 0, axis: .left, duration: 0.3)
            let yPoints = huntingWeightPoints.map{ $0.y }
            
            
            self.lineChart.leftAxis.axisMinimum = yPoints.min()!-250
            self.lineChart.leftAxis.axisMaximum = yPoints.max()!+250
            
        }
        

//        if(foodPoints.count > 0) {
//            let fPoints = foodPoints.map{ $0.y }
//            self.lineChart.leftAxis.axisMinimum = fPoints.min()!-20
//            
//        }
        
        
        let dataset:LineChartDataSet = LineChartDataSet(entries: dataPoints, label:"weights")
        dataset.lineWidth = 2.5;
  
        dataset.drawValuesEnabled = false
        dataset.circleRadius = 4.0;
//        dataset.circleHoleRadius = 2.0;
        dataset.axisDependency = .left
        dataset.mode = .cubicBezier
        
//        dataset.cubicIntensity = 0.05
        dataset.setColor(AppUtility.app_color_linkBlue)
        dataset.setCircleColor(UIColor.clear)

        
        
        let foodDataset:LineChartDataSet = LineChartDataSet(entries: foodPoints, label:"foods")
        foodDataset.lineWidth = 2.5;
    
        foodDataset.circleRadius = 4.0;
//        foodDataset.circleHoleRadius = 2.0;
        foodDataset.axisDependency = .left
        foodDataset.mode = .cubicBezier
        
        foodDataset.cubicIntensity = 0.05
        foodDataset.setColor(AppUtility.app_color_green)
        foodDataset.setCircleColor(AppUtility.app_color_green)
        
        

        let hwDataset:LineChartDataSet = LineChartDataSet(entries: huntingWeightPoints, label:"hw")
        hwDataset.lineWidth = 1.5;
        hwDataset.drawValuesEnabled = false
        hwDataset.circleRadius = 0.0;
        //        foodDataset.circleHoleRadius = 2.0;
        hwDataset.axisDependency = .left
        hwDataset.mode = .cubicBezier
        
        hwDataset.cubicIntensity = 0.05
        hwDataset.setColor(AppUtility.app_color_green)
        hwDataset.setCircleColor(AppUtility.app_color_green)
        
        
        let data:LineChartData = LineChartData(dataSets: [hwDataset,dataset])
        self.lineChart.data = data
        
        
    }
    
    func setupTimeframeForLineChart(start:DateInRegion) {
        
        self.lineChart.xAxis.axisMinimum = start.timeIntervalSince1970
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
        
        
        let diaryController:SDWDiaryItemContainerViewController = storyboard?.instantiateViewController(withIdentifier: "SDWDiaryItemContainerViewController") as! SDWDiaryItemContainerViewController
        diaryController.bird = bird
        
        let object:DiaryItemDisplayItem? = ((objects?.filter { Double(($0.weights?.last?.weight)!) == entry.y}.first) ?? nil)
        
        if (object != nil) {
            
            diaryController.diaryItem = object
            lastSelectedItem = object
        }
        
        self.navigationController?.pushViewController(diaryController, animated: true)
    }
    
    
    @IBAction func didTapBirdEdit(_ sender: Any) {
        
        let controller:UINavigationController = storyboard?.instantiateViewController(withIdentifier: "BirdProfileEdit") as! UINavigationController
        let birdEditVC = controller.viewControllers[0] as? SDWBirdViewController
        birdEditVC?.bird = self.dataStore.currentBird()
        
        self.present(controller, animated: true, completion: nil)
    }
    
    

    
 


}
