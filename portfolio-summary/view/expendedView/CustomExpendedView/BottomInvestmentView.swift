//
//  BottomInvestmentView.swift
//  portfolio-summary
//
//  Created by Pranav Pratap on 11/03/24.
//

import UIKit

class BottomInvestmentView: UIView{
    
    @IBOutlet weak var expendButton: UIButton!
    @IBOutlet weak var investmentTableView: UITableView!
    @IBOutlet weak var investmentTableViewheight: NSLayoutConstraint!
    @IBOutlet weak var profitAndLossTextLabel: UILabel!
    @IBOutlet weak var profitAndLossValueLable: UILabel!
    
    private var investmentResult: InvestmentResult?
    private var isExpended: Bool = false
    
    // This callback will be used to animate the BottomInvestmentView
    var animateBottomViewForExpendStatus: ((_ isExpended: Bool) -> Void)?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }
    
    private func customInit() {
        
        guard let xib = Bundle.main.loadNibNamed(Constants.XibName.bottomInvestmentView, owner: self)?.first as? UIView else { return }
        
        xib.frame = bounds
        addSubview(xib)
        
        investmentTableView.delegate = self
        investmentTableView.dataSource = self
        investmentTableView.register(UINib(nibName: Constants.XibName.expendedFooterTableViewCell, bundle: nil), forCellReuseIdentifier: Constants.XibName.expendedFooterTableViewCell)
        
        expendButton.setImage(UIImage(systemName: Constants.ImageName.upTriangleArrow), for: .normal)
        profitAndLossTextLabel.font = UIFont.systemFont(ofSize: Constants.FontConstant.commonFontHeight, weight: .bold)
        profitAndLossValueLable.font = UIFont.systemFont(ofSize: Constants.FontConstant.commonFontHeight)
        expendButton.imageView?.tintColor = .purple
        
    }
    
    @IBAction func expendButtonClicked(_ sender: UIButton) {
        if (isExpended) {
            expendButton.setImage(UIImage(systemName: Constants.ImageName.upTriangleArrow), for: .normal)
        }else{
            expendButton.setImage(UIImage(systemName: Constants.ImageName.downTriangleArrow), for: .normal)
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

extension BottomInvestmentView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30))
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.XibName.expendedFooterTableViewCell, for: indexPath) as? ExpendedFooterTableViewCell, let investmentResult else { return UITableViewCell() }
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
        return  cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
}
