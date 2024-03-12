//
//  HoldingsViewModel.swift
//  portfolio-summary
//
//  Created by Pranav Pratap on 12/03/24.
//

import Foundation

enum RequestError: Error {
    case invalidUrl
    case failedRequest(error: Error?)
    case errorDecode
    case unknownError
}

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

struct InvestmentResult {
    let totalCurrentValue: String
    let totalInvestment: String
    let totalProfitAndLoss: String
    let todaysProfitAndLoss: String
}

struct HoldingResponse: Codable {
    var userHolding: [UserHolding]
}

class HoldingsViewModel {
    private let apiString = "https://run.mocky.io/v3/bde7230e-bc91-43bc-901d-c79d008bddc8"
    private var userHoldings: [UserHolding]?
    
    func getUserHoldings(completionHandler: @escaping ((Result<[UserHolding],RequestError>) -> Void)){
        guard let apiURL = URL(string: apiString) else {
            completionHandler(.failure(.invalidUrl))
            return
        }
        URLSession.shared.dataTask(with: apiURL) { apiData, urlResponse, error in
            var result : Result<[UserHolding],RequestError> = .failure(.unknownError)
            defer {
                completionHandler(result)
            }
            
            if let error {
                result = .failure(.failedRequest(error: error))
            }
            
            guard let apiData else {
                completionHandler(.failure(.unknownError))
                return
            }
            
            do {
                let holdingResponse = try JSONDecoder().decode(HoldingResponse.self, from: apiData)
                self.userHoldings = holdingResponse.userHolding
                result = .success(holdingResponse.userHolding)
            }catch {
                result = .failure(.errorDecode)
            }
            
        }.resume()
    }
    
    func getInvestmentResult() -> InvestmentResult? {
        guard let userHoldings else { return nil }
        var totalCurrentValue: Double = 0
        var totalInvestment: Double = 0
        var todaysProfitAndLoss: Double = 0
        
        for userHolding in userHoldings {
            totalCurrentValue += userHolding.currentValue
            totalInvestment += userHolding.investmentValue
            todaysProfitAndLoss += (Double(userHolding.close) - userHolding.ltp ) * Double(userHolding.quantity)
        }
        
        var totalProfitAndLoss: Double = totalCurrentValue - totalInvestment
        
        let totalCurrentValueStr = String(format: "\u{20B9}%.2f", totalCurrentValue)
        let totalInvestmentStr = String(format: "\u{20B9}%.2f", totalInvestment)
        let todaysProfitAndLossStr = String(format: "\u{20B9}%.2f", todaysProfitAndLoss)
        let totalProfitAndLossStr = String(format: "\u{20B9}%.2f", totalProfitAndLoss)
        
        return InvestmentResult(totalCurrentValue: totalCurrentValueStr, totalInvestment: totalInvestmentStr, totalProfitAndLoss: todaysProfitAndLossStr, todaysProfitAndLoss: totalProfitAndLossStr)
    }
    
}
