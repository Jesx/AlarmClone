//
//  StatusTableViewController.swift
//  AlarmClone
//
//  Created by Jes Yang on 2019/10/23.
//  Copyright © 2019 Jes Yang. All rights reserved.
//

import UIKit

class StatusTableViewController: UITableViewController {
    
    var repeatArray: [(day: DetailInfo.DaysOfWeek, isSelected: Bool)] = DetailInfo.DaysOfWeek.allCases.map { (day: $0, isSelected: false) }

    var setAlarmVC: SetAlarmViewController!
    weak var delegate: SetRepeatDelegate?

    var index: Int!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let repeatStatusArray = setAlarmVC.repeatStatusArray
        
        for day in repeatStatusArray {
            index = repeatArray.firstIndex(where: { $0.day == day })
            print(index!)
            repeatArray[Int(index)].isSelected = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let repeatStatus = repeatArray.filter({ (day) -> Bool in
            day.isSelected
        })
        
        delegate?.setRepeate(days: repeatStatus.map { $0.day })

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
        cell.textLabel?.text = "Every \(repeatArray[indexPath.row].day)"
        
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
