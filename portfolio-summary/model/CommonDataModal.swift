//
//  dataModal.swift
//  portfolio-summary
//
//  Created by Pranav Pratap on 13/03/24.
//

import Foundation

enum RequestError: String, Error {
    case invalidUrl = "Invalid URL"
    case failedRequest = "Request failed"
    case errorDecode = "Error decoding"
    case unknownError = "Something went wrong"
}

// MARK: JSON DataModals
struct UserHolding: Codable {
    let symbol: String
    let quantity: Int
    let ltp, avgPrice: Double
    let close: Int
    
    var currentValue: Double {
        return ltp * Double(quantity)
    }
    var investmentValue: Double {
        return avgPrice * Double(quantity)
    }
    var profitAndLoss: Double {
        return currentValue - investmentValue
    }
}

struct HoldingResponse: Codable {
    var userHolding: [UserHolding]
}

// MARK: Local DataModals
struct InvestmentResult {
    let totalCurrentValue: String
    let totalInvestment: String
    let totalProfitAndLoss: String
    let todaysProfitAndLoss: String
}

// MARK: Constants to be used throught the project
enum Constants {
    enum HeightConstant {
        static let expendedBottomViewHeight: CGFloat = 230
        static let shrinkedBottomViewHeight: CGFloat = 80
        
        static let expendedBottomtableViewHeight: CGFloat = 150
    }
    enum XibName {
        static let holdingTableViewCell = "HoldingTableViewCell"
        static let expendedFooterTableViewCell = "ExpendedFooterTableViewCell"
        static let bottomInvestmentView = "BottomInvestmentView"
    }
    
    enum ImageName {
        static let upTriangleArrow = "arrowtriangle.up.fill"
        static let downTriangleArrow = "arrowtriangle.down.fill"
    }
    
    enum FontConstant {
        static let commonFontHeight: CGFloat = 16
    }
    
    enum CustomStringFormats {
        static let rupeeSign = "\u{20B9}"
        static let formattedValueString = "%.2f"
    }
}
