//
//  expendedView.swift
//  portfolio-summary
//
//  Created by Pranav Pratap on 11/03/24.
//

import UIKit

class CustomExpendedView: UIView{
    
    @IBOutlet weak var expendButton: UIButton!
    @IBOutlet weak var investmentTableView: UITableView!
    
    @IBOutlet weak var investmentTableViewheight: NSLayoutConstraint!
    
    @IBOutlet weak var profitAndLossTextLabel: UILabel!
    @IBOutlet weak var profitAndLossValueLable: UILabel!
    
    private var investmentResult: InvestmentResult?
    private var isExpended: Bool = true
    
    var animateBottomViewForExpendStatus: ((_ isExpended: Bool) -> Void)?
    
    init(frame: CGRect, and investmentResult: InvestmentResult) {
        self.investmentResult = investmentResult
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }
    
    private func customInit() {
        
        guard let xib = Bundle.main.loadNibNamed("CustomExpendedView", owner: self)?.first as? UIView else { return }
        
        xib.frame = bounds
        addSubview(xib)
        
        investmentTableView.delegate = self
        investmentTableView.dataSource = self
        investmentTableView.register(UINib(nibName: "ExpendedFooterTableViewCell", bundle: nil), forCellReuseIdentifier: "ExpendedFooterTableViewCell")
        
        expendButton.setImage(UIImage(named: "arrow-down-small"), for: .normal)
        
        profitAndLossTextLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        profitAndLossValueLable.font = UIFont.systemFont(ofSize: 16)
        
        
    }
    
    @IBAction func expendButtonClicked(_ sender: UIButton) {
        if (isExpended) {
            expendButton.setImage(UIImage(named: "arrow-up-small"), for: .normal)
        }else{
            expendButton.setImage(UIImage(named: "arrow-down-small"), for: .normal)
        }
        isExpended = !isExpended
        
        self.animateBottomViewForExpendStatus?(isExpended)
    }
    
    func bindDataToExpendedView(for investmentResult: InvestmentResult){
        
        self.investmentResult = investmentResult
        
        self.profitAndLossTextLabel.text = "Profit & Loss:"
        self.profitAndLossValueLable.text = investmentResult.totalProfitAndLoss
        
        DispatchQueue.main.async {
            self.investmentTableView.reloadData()
        }
    }
    
}

extension CustomExpendedView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30))
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExpendedFooterTableViewCell", for: indexPath) as? ExpendedFooterTableViewCell, let investmentResult else { return UITableViewCell() }
        switch indexPath.row {
        case 0:
            cell.amountLabelText = investmentResult.totalCurrentValue
            cell.investementLabelText = "Current Value:"
        case 1:
            cell.amountLabelText = investmentResult.totalInvestment
            cell.investementLabelText = "Total Investment:"
        case 2:
            cell.amountLabelText = investmentResult.todaysProfitAndLoss
            cell.investementLabelText = "Today's Profit & Loss:"
        default:
            print("INVALID - INDEXPATH")
        }
        cell.bindCellData()
        return  cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
}
//
//extension CustomExpendedView: UITableViewDelegate, UITableViewDataSource {
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if (isExpended) {
//            return section == 0 ? 3 : 1
//        }else{
//            return section == 0 ? 0 : 1
//        }
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpendedFooterTableViewCell", for: indexPath) as! ExpendedFooterTableViewCell
//
//        // set the cell values
//
//        switch indexPath.section {
//        case 0:
//            switch indexPath.row {
//            case 0:
//                cell.amountLabelText = "\(investmentResult.totalCurrentValue)"
//                cell.investementLabelText = "Current Value:"
//            case 1:
//                cell.amountLabelText = "\(investmentResult.totalInvestment)"
//                cell.investementLabelText = "Total Investment:"
//            case 2:
//                cell.amountLabelText = "\(investmentResult.todaysProfitAndLoss)"
//                cell.investementLabelText = "Today's Profit & Loss:"
//            default:
//                print("INVALID - INDEXPATH")
//            }
//        case 1:
//            cell.amountLabelText = "\(investmentResult.totalProfitAndLoss)"
//            cell.investementLabelText = "Profit & Loss:"
//        default:
//            print("INVALID - INDEXPATH")
//        }
//        cell.bindCellData()
//        return  cell
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: section == 0 ? 0 : 30))
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if (isExpended) {
//            return 40
//        }else{
//            return indexPath.section == 0 ? 0 : 40
//        }
//    }
//
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return section == 0 ? 0 : 30
//    }
//}
