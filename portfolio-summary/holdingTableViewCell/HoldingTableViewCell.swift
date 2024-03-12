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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        symbolLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        ltpLabel.font = UIFont.systemFont(ofSize: 16)
        quantityLabel.font = UIFont.systemFont(ofSize: 16,weight: .regular)
        profitAndLossLabel.font = UIFont.systemFont(ofSize: 16)
        
    }
    
    func bindCellData(for dataForCurrentCell: UserHolding) {
        symbolLabel.text = dataForCurrentCell.symbol.uppercased()
        ltpLabel.attributedText = getAttributedText(with: "LTP", and: dataForCurrentCell.ltp)
        quantityLabel.text = "\(dataForCurrentCell.quantity)"
        profitAndLossLabel.attributedText = getAttributedText(with: "P/L", and: dataForCurrentCell.profitAndLoss)
    }
    
    
    private func getAttributedText(with prefix: String, and amount: Double) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: "\(prefix): ")
        let roundedAmountString = String(format: "%.2f", amount)
        let boldedString = NSAttributedString(string: "\u{20B9} \(roundedAmountString)",attributes: [.font: UIFont.systemFont(ofSize: 16,weight: .semibold)])
        attributedString.append(boldedString)
        
        return attributedString
    }
    
}
