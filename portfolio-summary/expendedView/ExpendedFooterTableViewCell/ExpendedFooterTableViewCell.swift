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
    
    var investementLabelText: String?
    var amountLabelText: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        investementLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        amountLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    }
    
    func bindCellData(){
        investementLabel.text = investementLabelText
        amountLabel.text = amountLabelText
    }
}
