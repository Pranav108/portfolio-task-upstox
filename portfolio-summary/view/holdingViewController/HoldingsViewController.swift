//
//  HoldingsViewController.swift
//  portfolio-summary
//
//  Created by Pranav Pratap on 11/03/24.
//

import UIKit

class HoldingsViewController: UIViewController {
    
    @IBOutlet weak var holdingTableView: UITableView!
    @IBOutlet weak var expendableView: BottomInvestmentView!
    @IBOutlet weak var expendedViewHeight: NSLayoutConstraint!
    
    var holdingsViewModel: HoldingsViewModel?
    var userHoldings: [UserHolding]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        holdingsViewModel = HoldingsViewModel()
        holdingTableView.delegate = self
        holdingTableView.dataSource = self
        holdingTableView.register(UINib(nibName: Constants.XibName.holdingTableViewCell, bundle: nil), forCellReuseIdentifier: Constants.XibName.holdingTableViewCell)
        
        expendedViewHeight.constant = Constants.HeightConstant.shrinkedBottomViewHeight
        
        holdingsViewModel?.getUserHoldings(completionHandler: { result in
            switch result {
            case .success(let success):
                self.userHoldings = success
                self.expendableViewSetup()
            case .failure(let failure):
                print("Error: \(failure.rawValue)")
            }
        })
    }
    
    private func expendableViewSetup(){
        guard let investmentResult = holdingsViewModel?.getInvestmentResult() else { return }
        
        DispatchQueue.main.async {
            self.holdingTableView.reloadData()
            self.expendableView.bindDataToExpendedView(for: investmentResult)
        }
        
        self.expendableView.animateBottomViewForExpendStatus = { isExpended in
            UIView.animate(withDuration: 0.4) {
                if (isExpended) {
                    self.expendedViewHeight.constant = Constants.HeightConstant.expendedBottomViewHeight
                    self.expendableView.investmentTableViewheight.constant = Constants.HeightConstant.expendedBottomtableViewHeight
                }else{
                    self.expendedViewHeight.constant = Constants.HeightConstant.shrinkedBottomViewHeight
                    self.expendableView.investmentTableViewheight.constant = 0
                }
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @IBAction func dismissHoldingsView(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}

extension HoldingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userHoldings?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = tableView.dequeueReusableCell(withIdentifier: Constants.XibName.holdingTableViewCell, for: indexPath) as? HoldingTableViewCell else { return UITableViewCell() }
        row.userHoldingdata = userHoldings?[indexPath.row]
        return row
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
