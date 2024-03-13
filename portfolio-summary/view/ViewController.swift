//
//  ViewController.swift
//  portfolio-summary
//
//  Created by Pranav Pratap on 11/03/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func viewHoldingsClicked(_ sender: UIButton) {
        let holdingsViewController = HoldingsViewController()
        holdingsViewController.modalPresentationStyle = .overFullScreen
        present(holdingsViewController, animated: true)
    }
    
}

