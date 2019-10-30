//
//  ViewController.swift
//  AlarmClone
//
//  Created by Jes Yang on 2019/10/22.
//  Copyright © 2019 Jes Yang. All rights reserved.
//

import UIKit

class AlarmViewController: UIViewController {

    let cellHeight = CGFloat(90)
    
    var timeArray = [TimeElement]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var textLabel: UILabel!
    
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
        AlarmData.mainViewChange(self)
    }
    
    @IBAction func editAlarm(_ sender: UIBarButtonItem) {
       
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
        
        if tableView.isEditing {
            tableView.isEditing = false
            editBarButton.title = "Edit"
            editBarButton.style = .plain
            tableView.separatorInset = .init(top: 0, left: 15, bottom: 0, right: 0)
        }
        
        let naviIdentifier = "naviAlarmSetting"
        let naviController = storyboard?.instantiateViewController(withIdentifier: naviIdentifier) as! UINavigationController
        let setAlarmVC = (naviController.viewControllers.first as! SetAlarmViewController)
        
        setAlarmVC.alarmVC = self
        setAlarmVC.modeChoice = .Add
        
        present(naviController, animated: true, completion: nil)
    }
}

extension AlarmViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AlarmTableViewCell.self), for: indexPath) as! AlarmTableViewCell
        
        cell.timeLabel.text = timeArray[indexPath.row].time.timeString
  
        // Set the custom font in string
        let timeTextCount = timeArray[indexPath.row].time.timeString.count
        let attributedString = NSMutableAttributedString.init(string: cell.timeLabel.text!)
        
        attributedString.setAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30)],
                                 range: NSMakeRange(timeTextCount - 2, 2))
        
        // Set the attributed string to the UILabel object
        cell.timeLabel.attributedText = attributedString
        
        cell.selectionStyle = .none
        
        cell.accessoryView = cell.onOffSwitch
        
        //
        cell.onOffSwitch.isOn = timeArray[indexPath.row].isOn
        cell.onOffSwitch.tag = indexPath.row
        cell.onOffSwitch.addTarget(self, action: #selector(didChangeValue(_:)), for: .valueChanged)
        cell.editingAccessoryView = cell.tailImageView
        
        cell.alarmNameLabel.text = timeArray[indexPath.row].textLabel
        
        cell.repeatStatusLabel.text = timeArray[indexPath.row].repeatStatus.uiStringMain
        
        cell.timeLabel.textColor = timeArray[indexPath.row].isOn ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        
        return cell
    }
    
    @objc func didChangeValue(_ sender: UISwitch) {
        
        let index = sender.tag
        let uuid = timeArray[index].uuid
        let time = timeArray[index].time
        let label = timeArray[index].textLabel
        let sound = timeArray[index].ringTone

        if sender.isOn {
            timeArray[index].isOn = true
            NotificationPush().setNotification(uuid: uuid, time: time, label: label, sound: sound)
        } else {
            timeArray[index].isOn = false
            NotificationPush().deleteNotification(uuid: uuid)
        }
        
        tableView.reloadRows(at: [[0, index]], with: .fade)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {

            let naviIdentifier = "naviAlarmSetting"
            let naviController = storyboard?.instantiateViewController(withIdentifier: naviIdentifier) as! UINavigationController
            let setAlarmVC = (naviController.viewControllers.first as! SetAlarmViewController)
            
            setAlarmVC.alarmVC = self
            setAlarmVC.modeChoice = .Edit
            
            setAlarmVC.timeString = timeArray[indexPath.row].time.timeString
            setAlarmVC.repeatStatus = timeArray[indexPath.row].repeatStatus.uiString
            setAlarmVC.indexPath = indexPath

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

    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        editBarButton.title = "Done"
        editBarButton.style = .done

    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        editBarButton.title = "Edit"
        editBarButton.style = .plain
        AlarmData.mainViewChange(self)
    }
}


