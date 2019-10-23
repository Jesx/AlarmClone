//
//  SetAlarmViewController.swift
//  AlarmClone
//
//  Created by Jes Yang on 2019/10/22.
//  Copyright © 2019 Jes Yang. All rights reserved.
//

import UIKit

protocol AlarmSetDelegate {
    func alarmSet(mode: Int, alarmString: String, label: String, isOn: Bool, repeatStatus: String, ringTone: String)
}

class SetAlarmViewController: UIViewController {

    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var tableView: UITableView!
    
    
    let cellHeight = CGFloat(50)
    
    var delegate: AlarmSetDelegate?
    
    var modeChoice = 0
    var time: String?
    
    var repeatStatus = "Never"
    var label = "Alarm"
    var ringTone = "Slow Rise"
    
    enum Mode: Int {
        case Add = 0, Edit

        var title: String {
            switch  self {
            case .Add: return "Add Alarm"
            case .Edit: return "Edit Alarm"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mma"
        
        datePicker.datePickerMode = .time
        
        if let date = dateFormatter.date(from: time ?? "") {
            datePicker.setDate(date, animated: true)
        }
        
//        datePicker.setValue(UIColor.white, forKey: "textColor")
        
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
        
        // Set Navigation Title
//        thisNavigationItem.title = navigationTitle
        navigationItem.title = modeChoice == 0 ? Mode.Add.title : Mode.Edit.title
        
        // Add line for delete button
//        let deleteButtonUpBottomLine = CALayer()
//        deleteButtonUpBottomLine.frame = CGRect(x: 0, y: 0.5, width: datePicker.frame.width, height: datePicker.frame.height - 1)
//        deleteButtonUpBottomLine.backgroundColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)

//        datePicker.layer.addSublayer(deleteButtonUpBottomLine)
//        datePicker.backgroundColor = #colorLiteral(red: 0.5704585314, green: 0.5704723597, blue: 0.5704649091, alpha: 1)
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mma"
        delegate?.alarmSet(mode: modeChoice, alarmString:  dateFormatter.string(from: datePicker.date), label: label, isOn: true, repeatStatus: repeatStatus, ringTone: ringTone)
//        print(dateFormatter.string(from: datePicker.date))
        
        dismiss(animated: true, completion: nil)
    }
      
}

extension SetAlarmViewController: UITableViewDelegate, UITableViewDataSource{
    
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
//                performSegue(withIdentifier: "statusSegue", sender: self)
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
