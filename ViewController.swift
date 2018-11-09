//
//  ViewController.swift
//  Timer
//
//  Created by Kentarou on 2018/11/08.
//  Copyright © 2018 Kentarou. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var listData: [ListData] = []
    var timer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        listData = createData()
        addNotification()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startTimer()
    }
    
    deinit {
        print("deinit")
        NotificationCenter.default.removeObserver(self)
    }
    
    func addNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(ViewController.onDidBecomeActive(_:)),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    @objc func onDidBecomeActive(_ notification: Notification?) {
        startTimer()
        print("onDidBecomeActive")
    }
    
    func startTimer() {
        if timer.isValid {
            timer.invalidate()
        }
        
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(self.updateTimer),
            userInfo: nil,
            repeats: true)
        RunLoop.current.add(timer, forMode: .tracking) 
    }
    
    @objc func updateTimer() {
        tableView.visibleCells.map { $0 as! CustomCell }.forEach { $0.update() }
    }
}


extension ViewController {
    func createData() -> [ListData] {
        
        let data1 = ListData(targetType: .target1,
                             backColor: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1),
                             target1Date: "2018-11-08T06:25:00+09:00",
                             target2Date: "2018-11-09T07:00:00+09:00")
        
        let data2 = ListData(targetType: .target1,
                             backColor: #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1),
                             target1Date: "2018-11-09T09:00:00+09:00",
                             target2Date: "2018-11-12T12:00:00+09:00")
        
        let data3 = ListData(targetType: .target1,
                             backColor: #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1),
                             target1Date: "2018-11-08T14:00:00+09:00",
                             target2Date: "2018-11-09T12:00:00+09:00")
        
        let data4 = ListData(targetType: .target1,
                             backColor: #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1),
                             target1Date: "2018-11-12T14:00:00+09:00",
                             target2Date: "2018-11-13T12:00:00+09:00")
        
        
        let data5 = ListData(targetType: .target1,
                             backColor: #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1),
                             target1Date: "2018-11-12T14:00:00+09:00",
                             target2Date: "2018-11-13T12:00:00+09:00")
        
        return [data1, data2, data3, data4, data5]
    }
}


class ListData {
    
    var targetType: TargetType = .target1
    var backColor: UIColor = .white
    let target1Date: String?
    let target2Date: String?
    
    enum TargetType: String {
        case target1 = "Target1まで"
        case target2 = "Target2まで"
    }
    
    init(targetType: TargetType,
         backColor: UIColor,
         target1Date: String,
         target2Date: String) {
        
        self.targetType = targetType
        self.backColor = backColor
        self.target1Date = target1Date
        self.target2Date = target2Date
    }
    
    private func diff(date: Date) -> TimeInterval {
        let now = Date()
        let diff = date.timeIntervalSince(now)
        return diff
    }
    
    private func timeString(time:TimeInterval) -> String {
        let day = Int(time) / (3600 * 24)
        let hours = Int(time) / 3600 % 24
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
        if day == 0 {
            return String(format: "%i:%02i:%02i", hours, minutes, seconds)
        } else {
            return String(format: "%i日 %i:%02i:%02i",day, hours, minutes, seconds)
        }
    }
    
    private func convertDate(dateString: String) -> Date? {
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: dateString)
    }
    
    func update() -> String? {
        
        var targetTime = target1Date
        if targetType == .target2 {
            targetTime = target2Date
        }
        
        if let dateString = targetTime,
            let date = convertDate(dateString: dateString
            ) {
            let diffTimeInterval = diff(date: date)
            
            if diffTimeInterval > 0 {
                return timeString(time: diffTimeInterval)
            } else if targetType == .target1 {
                self.targetType = .target2
            }
        }
        return "0:00:00"
    }
    
    func titleText() -> String {
        return targetType.rawValue
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as? CustomCell {
            cell.listData = listData[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
}
