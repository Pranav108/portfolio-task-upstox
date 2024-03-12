//
//  HoldingsViewController.swift
//  portfolio-summary
//
//  Created by Pranav Pratap on 11/03/24.
//

import UIKit

class HoldingsViewController: UIViewController {
    
    @IBOutlet weak var holdingTableView: UITableView!
    @IBOutlet weak var expendableView: CustomExpendedView!
    @IBOutlet weak var expendedViewHeight: NSLayoutConstraint!
    
    var holdingsViewModel: HoldingsViewModel?
    var userHoldings: [UserHolding]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        holdingsViewModel = HoldingsViewModel()
        holdingTableView.delegate = self
        holdingTableView.dataSource = self
        holdingTableView.register(UINib(nibName: "HoldingTableViewCell", bundle: nil), forCellReuseIdentifier: "HoldingTableViewCell")
        
        expendableView.isHidden = true
        expendedViewHeight.constant = 0
        
        holdingsViewModel?.getUserHoldings(completionHandler: { result in
            switch result {
            case .success(let success):
                self.userHoldings = success
                self.expendableViewSetup()
            case .failure(let failure):
                print("ERROR GETTING DATA FROM API")
                print(failure.localizedDescription)
            }
        })
    }
    
    private func expendableViewSetup(){
        guard let investmentResult = holdingsViewModel?.getInvestmentResult() else { return }
        
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width
        let expendedViewHeight : CGFloat = 230
        let shrinkedViewHeight : CGFloat = 80
        
        DispatchQueue.main.async {
            self.holdingTableView.reloadData()
            
            UIView.animate(withDuration: 1) {
                self.expendableView.isHidden = false
                self.expendedViewHeight.constant = expendedViewHeight
//                self.view.layoutIfNeeded()
                self.expendableView.bindDataToExpendedView(for: investmentResult)
               
            }
        }
        
        self.expendableView.animateBottomViewForExpendStatus = { isExpended in
            UIView.animate(withDuration: 1) {
                self.expendedViewHeight.constant = isExpended ? expendedViewHeight : shrinkedViewHeight
                self.expendableView.investmentTableViewheight.constant = isExpended ? 150 : 0
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
        guard let row = tableView.dequeueReusableCell(withIdentifier: "HoldingTableViewCell", for: indexPath) as? HoldingTableViewCell else { return UITableViewCell() }
        if let userHoldingData = userHoldings?[indexPath.row]{
            row.bindCellData(for: userHoldingData)
        }
        return row
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
