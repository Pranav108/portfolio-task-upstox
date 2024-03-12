//
//  HoldingTableViewCell.swift
//  portfolio-summary
//
//  Created by Pranav Pratap on 11/03/24.
//

import UIKit

class HoldingTableViewCell: UITableViewCell {

    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var ltpLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var profitAndLossLabel: UILabel!
    
//    var dataForCurrentCell: UserHolding?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bindCellData(for dataForCurrentCell: UserHolding) {
        symbolLabel.text = dataForCurrentCell.symbol
        ltpLabel.text = "\(dataForCurrentCell.ltp)"
        quantityLabel.text = "\(dataForCurrentCell.quantity)"
        profitAndLossLabel.text = "\(dataForCurrentCell.profitAndLoss)"
    }
    
}
