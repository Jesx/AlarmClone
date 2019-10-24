//
//  SetAlarmViewController.swift
//  AlarmClone
//
//  Created by Jes Yang on 2019/10/22.
//  Copyright © 2019 Jes Yang. All rights reserved.
//

import UIKit

protocol AlarmSetDelegate {
    func alarmSet(mode: Int, alarmString: String, time: Date, label: String, isOn: Bool)
}

class SetAlarmViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var tableView: UITableView!
    
    let cellHeight = CGFloat(50)
    
    var alarmVC: AlarmViewController!
    
    var delegate: AlarmSetDelegate?
    let defaults = UserDefaults.standard
    
    var modeChoice = 0
    var time: String?
    
    var repeatStatus = "Never" {
        didSet {
            tableView.reloadData()
        }
    }
    
    var ringTone = "Slow Rise" {
        didSet {
            tableView.reloadData()
        }
    }
    
    var label = "Alarm" {
        didSet {
            tableView.reloadData()
        }
    }
    
    enum Mode: Int {
        case Add = 0, Edit

        var title: String {
            switch  self {
            case .Add: return "Add Alarm"
            case .Edit: return "Edit Alarm"
            }
        }
    }
    
    fileprivate func datePickerSetting() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mma"
        
        datePicker.datePickerMode = .time
        
        if let date = dateFormatter.date(from: time ?? "") {
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
            
            datePicker.setValue(UIColor.white, forKey: "textColor")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePickerSetting()
        datePickerColorSetting()
        
        // Set Navigation Title
        navigationItem.title = modeChoice == 0 ? Mode.Add.title : Mode.Edit.title
        
        tableView.delegate = self
        tableView.dataSource = self
        
        alarmVC.timeArray = AlarmData.loadData()
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        
        let timeString = changeDateToString()
        let time = datePicker.date
        
        if modeChoice == 0 {
            
            let timeElement = TimeElement(timeString: timeString, time: time, textLabel: label, isOn: true)
            alarmVC.timeArray.append(timeElement)
            
        } else {

            alarmVC.timeArray[(alarmVC.indexPath?.row)!].timeString = timeString
            alarmVC.timeArray[(alarmVC.indexPath?.row)!].textLabel = label
            alarmVC.timeArray[(alarmVC.indexPath?.row)!].time = time
        }
        
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
//        delegate?.alarmSet(mode: modeChoice, alarmString:  dateFormatter.string(from: datePicker.date), time: datePicker.date, label: label, isOn: true)
        //        print(dateFormatter.string(from: datePicker.date))
    }
    @IBAction func deleteAlarm(_ sender: UIButton) {
        alarmVC.timeArray.remove(at: (alarmVC.indexPath?.row)!)
        AlarmData.saveData(timeArray: alarmVC.timeArray)
        alarmVC.tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
}

extension SetAlarmViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return modeChoice == 0 ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return section == 0 ? 4 : 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SetAlarmTableViewCell.self), for: indexPath) as! SetAlarmTableViewCell
                
                cell.itemLabel.text = "Repeat"
                cell.statusLabel.text = repeatStatus
                
                cell.accessoryView = cell.tailImageView
                cell.selectionStyle = .none
                
                return cell
            
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SetAlarmTableViewCell.self), for: indexPath) as! SetAlarmTableViewCell
                
                cell.itemLabel.text = "Label"
                cell.statusLabel.text = label
                
                cell.accessoryView = cell.tailImageView
                cell.selectionStyle = .none
                
                return cell
            
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SetAlarmTableViewCell.self), for: indexPath) as! SetAlarmTableViewCell
                
                cell.itemLabel.text = "Sound"
                cell.statusLabel.text = ringTone
                
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
            
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DeleteTableViewCell.self), for: indexPath) as! DeleteTableViewCell
                
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
                let vc = storyboard?.instantiateViewController(withIdentifier: "StatusTableViewController") as! StatusTableViewController
                
                navigationController?.pushViewController(vc, animated: true)
            case 1:
                let vc = storyboard?.instantiateViewController(withIdentifier: "LabelViewController") as! LabelViewController
                vc.delegate = self
                vc.text = label
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
