//
//  SetAlarmViewController.swift
//  AlarmClone
//
//  Created by Jes Yang on 2019/10/22.
//  Copyright © 2019 Jes Yang. All rights reserved.
// 

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
    var repeatStatusArray = [DetailInfo.DaysOfWeek]()
    
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
    
    // MARK: - DatePickerSetting
    fileprivate func datePickerSetting() {
        let dateFormatter = DateFormatter()

        datePicker.datePickerMode = .time
        dateFormatter.dateFormat = "h:mma"
        
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
        
        alarmVC.alarmArray = AlarmData.loadData()
        
        //
        switch modeChoice {
        case .Add:
            ringTone = "Slow Rise"
            label = "Alarm"
            repeatStatus = "Never"
        case .Edit:
            ringTone = alarmVC.alarmArray[indexPath.row].ringTone
            label = alarmVC.alarmArray[indexPath.row].textLabel
            repeatStatusArray = alarmVC.alarmArray[indexPath.row].repeatStatus
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
        
        let date = datePicker.date
        let time: DateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)
        guard let hour = time.hour else { fatalError() }
        guard let min = time.minute  else { fatalError() }

        let uuid = UUID().uuidString
        
        switch modeChoice {
        case .Add:
            let alarm = Alarm(uuid: uuid,
                                          time: Time(hour: hour, min: min),
                                          textLabel: label,
                                          ringTone: ringTone,
                                          repeatStatus: repeatStatusArray,
                                          isOn: true,
                                          onSnooze: true)
            alarmVC.alarmArray.append(alarm)

            let notificationPush = NotificationPush()
            notificationPush.scheduleNotification(alarm: alarm)
            
        case .Edit:
            let index = indexPath.row
            alarmVC.alarmArray[index].time = Time(hour: hour, min: min)
            alarmVC.alarmArray[index].textLabel = label
            alarmVC.alarmArray[index].ringTone = ringTone
            alarmVC.alarmArray[index].repeatStatus = repeatStatusArray
        }
        
        alarmVC.alarmArray.sort { $0.time.date.compare($1.time.date) == .orderedAscending }
        
        AlarmData.saveData(alarmArray: alarmVC.alarmArray)
        alarmVC.alarmArray = AlarmData.loadData()
        alarmVC.tableView.reloadData()        
        alarmVC.viewChange()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteAlarm(_ sender: UIButton) {
        NotificationPush().deleteNotification(alarm: alarmVC.alarmArray[indexPath.row])
        alarmVC.alarmArray.remove(at: indexPath.row)
        AlarmData.saveData(alarmArray: alarmVC.alarmArray)
        alarmVC.tableView.reloadData()
        alarmVC.viewChange()
        dismiss(animated: true, completion: nil)
    }
    
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
                vc.setAlarmVC = self
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
        self.ringTone = DetailInfo.ringTone[index]
    }
}

extension SetAlarmViewController: SetRepeatDelegate {
    
    func setRepeate(days: [DetailInfo.DaysOfWeek]) {
        self.repeatStatus = days.uiString
        self.repeatStatusArray = days
    }
}
