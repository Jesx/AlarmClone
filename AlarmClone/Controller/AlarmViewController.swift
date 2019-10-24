//
//  ViewController.swift
//  AlarmClone
//
//  Created by Jes Yang on 2019/10/22.
//  Copyright © 2019 Jes Yang. All rights reserved.
//

// Store: UserDefaults
// Pass data (tableView)

import UIKit

class AlarmViewController: UIViewController {

    let cellHeight = CGFloat(90)
    
    var timeText: String?
    var indexPath: IndexPath?
    
//    let defaults = UserDefaults.standard
    
//    var timeArray = ["8:00AM", "9:00AM", "9:00AM", "9:00AM"]
    
    var timeArray = [TimeElement]()
//    {
//        didSet {
//            setNotification(at: 0)
//        }
//    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editBarButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Allow didSelect method to work
        tableView.allowsSelectionDuringEditing = true
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        // Hiding extra line of empty cell
        tableView.tableFooterView = UIView()
        
        timeArray = AlarmData.loadData()
    }
    
    @IBAction func editAlarm(_ sender: Any) {
       
        if tableView.isEditing {
            tableView.isEditing = false
            editBarButton.title = "Edit"
            editBarButton.style = .plain
            tableView.separatorInset = .init(top: 0, left: 15, bottom: 0, right: 0)
        }
        else {
            tableView.isEditing = true
            editBarButton.title = "Done"
            editBarButton.style = .done
            tableView.separatorInset = .init(top: 0, left: 60, bottom: 0, right: 0)
        }
        
    }
    
    @IBAction func addAlarm(_ sender: UIBarButtonItem) {
        let naviIdentifier = "naviAlarmSetting"
        let naviController = storyboard?.instantiateViewController(withIdentifier: naviIdentifier) as! UINavigationController
        let setAlarmVC = (naviController.viewControllers.first as! SetAlarmViewController)
        
        setAlarmVC.alarmVC = self
        setAlarmVC.modeChoice = 0
        
        present(naviController, animated: true, completion: nil)
    }
    
}

extension AlarmViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AlarmTableViewCell.self), for: indexPath) as! AlarmTableViewCell
        
        cell.timeLabel.text = timeArray[indexPath.row].timeString
        
        let timeTextCount = timeArray[indexPath.row].timeString.count
        let attributedString = NSMutableAttributedString.init(string: cell.timeLabel.text!)
        
        // Set the custom font in string
        attributedString.setAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30)],
                                 range: NSMakeRange(timeTextCount - 2, 2))
        
        // Set the attributed string to the UILabel object
        cell.timeLabel.attributedText = attributedString
        cell.selectionStyle = .none
        
        cell.accessoryView = cell.onOffSwitch
        cell.editingAccessoryView = cell.tailImageView

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
//            let vcIdentifier = "setAlarm"
//            let setAlarmVC = storyboard?.instantiateViewController(identifier: vcIdentifier) as! SetAlarmViewController
            let naviIdentifier = "naviAlarmSetting"
            let naviController = storyboard?.instantiateViewController(withIdentifier: naviIdentifier) as! UINavigationController
            let setAlarmVC = (naviController.viewControllers.first as! SetAlarmViewController)
            setAlarmVC.alarmVC = self
//            setAlarmVC.delegate = self
            setAlarmVC.modeChoice = 1
            setAlarmVC.time = timeArray[indexPath.row].timeString
            
            self.indexPath = indexPath
            
            present(naviController, animated: true) {
                tableView.isEditing = false
                self.editBarButton.title = "Edit"
                self.editBarButton.style = .plain
                tableView.separatorInset = .init(top: 0, left: 15, bottom: 0, right: 0)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            timeArray.remove(at: indexPath.row)
            AlarmData.saveData(timeArray: timeArray)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func setNotification(at index: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Alarm Notification"
        content.body = "This is the \(timeArray[index].textLabel) notificaion."
        content.badge = 1
        content.sound = UNNotificationSound.default
        
    
        let triggerTime = Calendar.current.dateComponents([.hour,.minute], from: timeArray[index].time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerTime, repeats: true)
        
        let request = UNNotificationRequest(identifier: "notification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
            print("Notificaion succeed.")
        })
    }
    
}

//extension AlarmViewController: AlarmSetDelegate {
//    func alarmSet(mode: Int, alarmString: String, time: Date, label: String, isOn: Bool) {
//        if mode == 1 {
//            timeArray[(indexPath?.row)!].timeString = alarmString
//
//            tableView.reloadRows(at: [indexPath!], with: .fade)
//
//            let cell = tableView.cellForRow(at: indexPath!) as! AlarmTableViewCell
//            cell.onOffSwitch.isOn = true
//        } else {
//            let addAlarm = TimeElement(timeString: alarmString, time: time, textLabel: label, isOn: isOn)
//            timeArray.append(addAlarm)
//            tableView.reloadData()
//        }
//    }
//}

