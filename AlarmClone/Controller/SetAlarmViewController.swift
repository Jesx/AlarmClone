//
//  SetAlarmViewController.swift
//  AlarmClone
//
//  Created by Jes Yang on 2019/10/22.
//  Copyright © 2019 Jes Yang. All rights reserved.
//
// cellForRowAt

import UIKit

class SetAlarmViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var tableView: UITableView!
    
    let cellHeight = CGFloat(50)
    
    var alarmVC: AlarmViewController!
    var indexPath: IndexPath!
    
    var modeChoice = Mode.Add
    var timeString: String?
    
    var repeatStatus: String!
    var ringTone: String!
    var label: String!
    
    enum Mode {
        case Add, Edit

        var title: String {
            switch self {
            case .Add: return "Add Alarm"
            case .Edit: return "Edit Alarm"
            }
        }
    }
    
    fileprivate func datePickerSetting() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mma"
        
        datePicker.datePickerMode = .time
        
        if let date = dateFormatter.date(from: timeString ?? "") {
            datePicker.setDate(date, animated: true)
        }
    }
    
    fileprivate func datePickerColorSetting() {
        // Set datePicker's color setting
        if let pickerView = datePicker.subviews.first {
            
            for subview in pickerView.subviews {
                
                if subview.frame.height <= 5 {
                    
                    subview.backgroundColor = UIColor.gray
                    subview.tintColor = UIColor.gray
                    subview.layer.borderColor = UIColor.gray.cgColor
                    subview.layer.borderWidth = 0.5
                }
            }
            // This line may have a problem
            datePicker.setValue(UIColor.white, forKey: "textColor")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePickerSetting()
        datePickerColorSetting()
        
        let title = modeChoice.title
        navigationItem.title = title
        
        tableView.delegate = self
        tableView.dataSource = self
        
        alarmVC.timeArray = AlarmData.loadData()
        
        //
        switch modeChoice {
        case .Add:
            ringTone = "Slow Rise"
            label = "Alarm"
            repeatStatus = "Never"
        case .Edit:
            ringTone = alarmVC.timeArray[indexPath.row].ringTone
            label = alarmVC.timeArray[indexPath.row].textLabel
            repeatStatus = alarmVC.timeArray[indexPath.row].repeatStatus
        }
        
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - didTapSave
    @IBAction func save(_ sender: UIBarButtonItem) {
        
        let timeString = changeDateToString()
        let time = datePicker.date
        let uuid = UUID().uuidString
        
        switch modeChoice {
        case .Add:
            let timeElement = TimeElement(uuid: uuid,
                                          timeString: timeString,
                                          time: time,
                                          textLabel: label,
                                          ringTone: ringTone,
                                          repeatStatus: repeatStatus,
                                          isOn: true)
            alarmVC.timeArray.append(timeElement)
            
//            let notificationPush = NotificationPush(uuid: uuid,
//                                                    time: time,
//                                                    label: label,
//                                                    sound: ringTone)

            let notificationPush = NotificationPush()
            notificationPush.setNotification(uuid: uuid, time: time, label: label, sound: ringTone)
            
        case .Edit:
            let index = indexPath.row
            alarmVC.timeArray[index].timeString = timeString
            alarmVC.timeArray[index].textLabel = label
            alarmVC.timeArray[index].time = time
            alarmVC.timeArray[index].ringTone = ringTone
            alarmVC.timeArray[index].repeatStatus = repeatStatus
        }
        
        alarmVC.timeArray.sort {  $0.time.compare($1.time) == .orderedAscending }
        
//        setNotification()
        AlarmData.saveData(timeArray: alarmVC.timeArray)
        alarmVC.timeArray = AlarmData.loadData()
        alarmVC.tableView.reloadData()
        
        dismiss(animated: true, completion: nil)
    }

    func changeDateToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mma"
        let timeString = dateFormatter.string(from: datePicker.date)
        
        return timeString
    }
    
    @IBAction func deleteAlarm(_ sender: UIButton) {
        alarmVC.timeArray.remove(at: indexPath.row)
        AlarmData.saveData(timeArray: alarmVC.timeArray)
        alarmVC.tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
//    func setNotification() {
//
//        let content = UNMutableNotificationContent()
//        content.title = "Alarm Notification"
//
//        var notificationLabel = ""
//        var settingTime = Date()
//
//        switch modeChoice {
//        case .Add:
//            notificationLabel = self.label
//            settingTime = datePicker.date
//        case .Edit:
//            notificationLabel = alarmVC.timeArray[indexPath.row].textLabel
//            settingTime = alarmVC.timeArray[indexPath.row].time
//
//        }
//
//        content.body = "This is the \(notificationLabel) notificaion."
//        content.sound = UNNotificationSound.init(named: UNNotificationSoundName(rawValue:  "Ripples.mp3"))
//
//        let triggerTime = Calendar.current.dateComponents([.hour,.minute], from: settingTime)
//        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerTime, repeats: true)
//
//        let request = UNNotificationRequest(identifier: "notification", content: content, trigger: trigger)
//
//        UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
//            print("Notificaion succeed.")
//        })
//    }
    
}

extension SetAlarmViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return modeChoice == .Add ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return section == 0 ? 4 : 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0...2:
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SetAlarmTableViewCell.self), for: indexPath) as! SetAlarmTableViewCell
                
                //
                if indexPath.row == 0 {
                    cell.itemLabel.text = "Repeat"
                    cell.statusLabel.text = repeatStatus
                    cell.accessoryView = cell.tailImageView
                    
                } else if indexPath.row == 1 {
                    cell.itemLabel.text = "Label"
                    cell.statusLabel.text = label
                    cell.accessoryView = cell.tailImageView
                    
                } else if indexPath.row == 2 {
                    cell.itemLabel.text = "Sound"
                    cell.statusLabel.text = ringTone
                    
                }
                
                cell.accessoryView = cell.tailImageView
                cell.selectionStyle = .none
                
                return cell
            
            case 3:

                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SnoozeTableViewCell.self), for: indexPath) as! SnoozeTableViewCell

                cell.itemLabel.text = "Snooze"
                cell.selectionStyle = .none

                return cell

            default:
                fatalError()
            }
            case 1:
            
                let cellIndentifier = "DeleteTableViewCell"
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIndentifier, for: indexPath)
                
                cell.selectionStyle = .none
            
                return cell
        
        default:
            fatalError()
        }

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let vc = storyboard?.instantiateViewController(withIdentifier: String(describing: StatusTableViewController.self)) as! StatusTableViewController
                vc.delegate = self
                vc.repeatDay = repeatStatus
                navigationController?.pushViewController(vc, animated: true)
            
            case 1:
                let vc = storyboard?.instantiateViewController(withIdentifier: String(describing: LabelViewController.self)) as! LabelViewController
                vc.delegate = self
                vc.text = label
                navigationController?.pushViewController(vc, animated: true)
              
            case 2:
                let vc = storyboard?.instantiateViewController(withIdentifier: String(describing: RingToneTableViewController.self)) as! RingToneTableViewController
                vc.delegate = self
                vc.ringTone = ringTone
                navigationController?.pushViewController(vc, animated: true)
                
            default:
                break
            }
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
}

extension SetAlarmViewController: LabelSettingDelegate {
    
    func labelSetting(label: String) {
        self.label = label
    }
}

extension SetAlarmViewController: RingToneSelectedDelegate {
    
    func ringToneSelected(index: Int) {
        self.ringTone = ModelData.ringTone[index]
    }
}

extension SetAlarmViewController: SetRepeatDelegate {
    
    func setRepeate(day: String) {
        self.repeatStatus = day
    }
}
