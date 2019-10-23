//
// CurrencyTableViewController.swift
// Exchange
//
// Created by R on 04.09.2019.
// Copyright © 2019 R. All rights reserved.
//

import UIKit

final class CurrencyTableViewController: UITableViewController {
    
    var currencies: [String]!
    var code: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencies = code == nil ? DataService.currencies : DataService.currencies.filter { $0 != code }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Currency", for: indexPath) as! CurrencyCell
        cell.prepare(with: currencies[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let code = code {
            DataService.addExchange(first: code, second: currencies[indexPath.row])
            dismiss(animated: true)
            return nil
        } else {
            code = currencies[indexPath.row]
            return indexPath
        }
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! CurrencyTableViewController
        vc.code = code
    }
    
}

