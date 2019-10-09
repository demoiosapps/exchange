//
// CurrencyCell.swift
// Exchange
//
// Created by R on 05.09.2019.
// Copyright © 2019 R. All rights reserved.
//

import UIKit

class CurrencyCell: UITableViewCell {
    
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        flagImageView.layer.cornerRadius = flagImageView.frame.width / 2
    }
    
    func prepare(with code: String) {
        flagImageView.image = UIImage(named: code.lowercased())
        codeLabel.text = code
        nameLabel.text = NSLocalizedString(code, comment: "")
    }
}

