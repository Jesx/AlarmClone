//
//  StatusTableViewController.swift
//  AlarmClone
//
//  Created by Jes Yang on 2019/10/23.
//  Copyright © 2019 Jes Yang. All rights reserved.
//

import UIKit



class StatusTableViewController: UITableViewController {
    
    var repeatStatusArray = AlarmDetailDataSource.repeatStatus
    
    weak var delegate: SetRepeatDelegate?
    var repeatDay: String!
    var index: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        for index in repeatStatusArray {
//            if index.isSelected {
//                if repeatDay == "Never" {
//                    repeatDay = ""
//                    repeatDay.append(index.shortName)
//                } else {
//                    repeatDay.append(" " + index.shortName)
//                }
//            }
//        }

        delegate?.setRepeate(day: repeatDay)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return repeatStatusArray.count
    }

    // MARK: - cellForRowAt
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "StatusCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
        cell.textLabel?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        cell.accessoryType = repeatStatusArray[indexPath.row].isSelected ? .checkmark : .none
        cell.textLabel?.text = repeatStatusArray[indexPath.row].fullName
//        cell.accessoryType = .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            
            if cell.accessoryType == .none {
                cell.accessoryType = .checkmark
                repeatStatusArray[indexPath.row].isSelected = true
            } else {
                cell.accessoryType = .none
                repeatStatusArray[indexPath.row].isSelected = false
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
