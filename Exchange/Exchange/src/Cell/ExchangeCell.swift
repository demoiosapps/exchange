//
// ExchangeCell.swift
// Exchange
//
// Created by R on 05.09.2019.
// Copyright © 2019 R. All rights reserved.
//

import UIKit

final class ExchangeCell: UITableViewCell {
    
    @IBOutlet weak var firstValueLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var secondValueLabel: UILabel!
    @IBOutlet weak var secondNameLabel: UILabel!
    @IBOutlet weak var secondCodeLabel: UILabel!
    
    func update(value: Double) {
        if value > 0 {
            let first = (value * 100).rounded(.down) / 100
            let last = Int(((value * 100).truncatingRemainder(dividingBy: 1) * 100).rounded(.toNearestOrEven))
            let string = NSMutableAttributedString(string: String(format: "%.2f", first), attributes: [NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 20)!])
            string.append(NSAttributedString(string: String(format: "%02d", last), attributes: [NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 14)!]))
            secondValueLabel.attributedText = string
        } else {
            secondValueLabel.text = ""
        }
    }
    
    func prepare(with exchange: Exchange) {
        firstValueLabel.text = "1 " + exchange.first!
        firstNameLabel.text = NSLocalizedString(exchange.first!, comment: "")
        secondCodeLabel.text = exchange.second!
        secondNameLabel.text = NSLocalizedString(exchange.second!, comment: "")
        update(value: exchange.value)
    }
}

