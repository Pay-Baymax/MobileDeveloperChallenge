//
//  RateTableViewCell.swift
//  ExchangeRates
//
//  Created by Aim on 20/01/21.
//

import UIKit
class RateTableViewCell: UITableViewCell {

    @IBOutlet weak var labelCurrencyName: UILabel!
    @IBOutlet weak var labelAmount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
