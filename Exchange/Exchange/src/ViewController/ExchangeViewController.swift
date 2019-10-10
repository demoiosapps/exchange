//
// ExchangeViewController.swift
// Exchange
//
// Created by R on 04.09.2019.
// Copyright © 2019 R. All rights reserved.
//

import UIKit
import CoreData

class ExchangeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var headerAddView: UIView!
    
    lazy var resultsController = DataService.exchangeResultsController(self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 16)!]
        tableView.tableHeaderView = headerAddView
        do {
            try resultsController.performFetch()
        } catch {
            #if DEBUG
            print("data - \(error.localizedDescription)")
            #endif
        }
        updateView()
    }
    
    // MARK: - Update
    
    func updateView() {
        if DataService.exchangeCount > 0 {
            hideAddView()
        } else {
            showAddView()
        }
    }
    
    func showAddView() {
        addView.isHidden = false
    }
    
    func hideAddView() {
        addView.isHidden = true
    }

    func updateCells(isWait: Bool = false) {
        DispatchQueue.main.asyncAfter(deadline: .now() + (isWait ? 0.5 : 0)) { [weak self] in
            guard let self = self else { return }
            self.tableView.visibleCells.forEach { cell in
                guard let superview = cell.superview as? UITableView,
                    let indexPath = superview.indexPath(for: cell),
                    let cell = cell as? ExchangeCell else {
                        return
                }
                let note = self.resultsController.object(at: indexPath)
                cell.prepare(with: note)
            }
        }
    }
    
    // MARK: - Add Currency
    
    @IBAction func addCurrency(_ sender: Any) {
        performSegue(withIdentifier: "Currency", sender: nil)
    }
}

extension ExchangeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return resultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Exchange", for: indexPath) as! ExchangeCell
        let exchange = resultsController.object(at: indexPath)
        cell.prepare(with: exchange)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return NSLocalizedString("Delete", comment: "")
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let exchange = resultsController.object(at: indexPath)
            DataService.remove(exchange)
            self.updateView()
        }
    }
}

extension ExchangeViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.beginUpdates()
                tableView.insertRows(at: [indexPath], with: .fade)
                tableView.endUpdates()
                updateCells(isWait: true)
                updateView()
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.endUpdates()
                updateView()
            }
        case .update:
            if let indexPath = indexPath,
                let cell = tableView.cellForRow(at: indexPath) as? ExchangeCell {
                let exchange = resultsController.object(at: indexPath)
                cell.prepare(with: exchange)
            }
        case .move:
            updateCells()
        default: break
        }
    }
}
