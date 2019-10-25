//
//  StatusTableViewController.swift
//  AlarmClone
//
//  Created by Jes Yang on 2019/10/23.
//  Copyright © 2019 Jes Yang. All rights reserved.
//

import UIKit

class StatusTableViewController: UITableViewController {
    
    var repeatArray: [(day: String, isSelected: Bool)] = AlarmDetailDataSource.repeatArray.map { (day: $0, isSelected: false) }
    
    var repeatStatusArray = [String]()
    
    weak var delegate: SetRepeatDelegate?
    var repeatDay: String!
    var index: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadRepeatStatus()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        saveRepeatStatus()
        delegate?.setRepeate(day: repeatDay)
    }
    
    func saveRepeatStatus() {
        
        repeatStatusArray = [String]()
        for day in repeatArray {
            if day.isSelected {
                let dayShortName = day.day.prefix(3)
                repeatStatusArray.append(String(dayShortName))
            }
        }
        
        if repeatStatusArray.count == 0 {
            repeatDay = AlarmDetailDataSource.repeatAdditionalArray[0]
        } else if repeatStatusArray.count == 7 {
            repeatDay = AlarmDetailDataSource.repeatAdditionalArray[1]
        } else {
            if repeatStatusArray[0] == repeatArray[0].day.prefix(3) && repeatStatusArray[1] == repeatArray[6].day.prefix(3) {
                repeatDay = AlarmDetailDataSource.repeatAdditionalArray[2]
            } else {
                for index in 0..<repeatStatusArray.count {
                    if index == 0 {
                        repeatDay = repeatStatusArray[index]
                    } else {
                        repeatDay += " " + repeatStatusArray[index]
                    }
                }
            }
        }
        
        AlarmData.saveRepeatStatus(repeatStatusArray: repeatStatusArray)
    }
    
    func loadRepeatStatus() {
        repeatStatusArray = AlarmData.loadRepeatStatus()
        for day in repeatStatusArray {
            index = repeatArray.firstIndex(where: { $0.day.prefix(3) == day })
            repeatArray[Int(index)].isSelected = true
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return repeatArray.count
    }

    // MARK: - cellForRowAt
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "StatusCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
        cell.textLabel?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        cell.accessoryType = repeatArray[indexPath.row].isSelected ? .checkmark : .none
        cell.textLabel?.text = "Every " + repeatArray[indexPath.row].day
//        cell.accessoryType = .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            
            if cell.accessoryType == .none {
                cell.accessoryType = .checkmark
                repeatArray[indexPath.row].isSelected = true
            } else {
                cell.accessoryType = .none
                repeatArray[indexPath.row].isSelected = false
            }
        }
    
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
