//
//  RingToneTableViewController.swift
//  AlarmClone
//
//  Created by Jes Yang on 2019/10/24.
//  Copyright © 2019 Jes Yang. All rights reserved.
//

import UIKit

class RingToneTableViewController: UITableViewController {

    var ringArray: [(ringTone: String, isSelect: Bool)] = DetailInfo.ringTone.map { (ringTone: $0, isSelect: false) }
    
    var index: Int!
    var ringTone: String!
    
    var cell: RingToneTableViewCell?
    weak var delegate: RingToneSelectedDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "RingToneTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "RingToneCell")
        
        tableView.tableFooterView = UIView()
        
        index = ringArray.firstIndex(where: { $0.ringTone == ringTone })
        ringArray[index].isSelect = true

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ringArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "RingToneCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RingToneTableViewCell
        
        cell.thisTextLabel.text = ringArray[indexPath.row].ringTone
        cell.thisImageView.image = ringArray[indexPath.row].isSelect ? UIImage(named: "checkmark") : nil
        
        if ringArray[indexPath.row].isSelect {
            self.cell = cell
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "RINGTONES"
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let textLabel = UILabel()
        textLabel.frame = CGRect(x: 20, y: 36, width: 300, height: 10)
        textLabel.font = UIFont.systemFont(ofSize: 12)
        textLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        textLabel.textColor = #colorLiteral(red: 0.5704585314, green: 0.5704723597, blue: 0.5704649091, alpha: 1)
        
        let headerView = UIView()
        headerView.addSubview(textLabel)

        return headerView
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) as? RingToneTableViewCell {
            ringArray[indexPath.row].isSelect = true
            cell.thisImageView.image = ringArray[indexPath.row].isSelect ? UIImage(named: "checkmark") : nil
            self.cell?.thisImageView.image = nil
            self.cell = cell
        }
        
        index = indexPath.row
        delegate?.ringToneSelected(index: index)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
