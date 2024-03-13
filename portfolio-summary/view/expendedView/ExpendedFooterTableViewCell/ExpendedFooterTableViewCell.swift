//
//  ExpendedFooterTableViewCell.swift
//  portfolio-summary
//
//  Created by Pranav Pratap on 11/03/24.
//

import UIKit

class ExpendedFooterTableViewCell: UITableViewCell {

    @IBOutlet weak var investementLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    // will bin the data in UI when it will be set from BottomInvestmentView
    var investementLabelText: String? {
        didSet { investementLabel.text = investementLabelText }
    }
    var amountLabelText: String? {
        didSet { amountLabel.text = amountLabelText }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        investementLabel.font = UIFont.systemFont(ofSize: Constants.FontConstant.commonFontHeight, weight: .bold)
        amountLabel.font = UIFont.systemFont(ofSize: Constants.FontConstant.commonFontHeight, weight: .regular)
    }
}
