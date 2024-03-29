//
//  HoldingsViewModel.swift
//  portfolio-summary
//
//  Created by Pranav Pratap on 12/03/24.
//

import Foundation

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
            
            if error != nil {
                result = .failure(.failedRequest)
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
        let totalProfitAndLoss: Double = totalCurrentValue - totalInvestment
        
        let investmentValueFormat = Constants.CustomStringFormats.rupeeSign + Constants.CustomStringFormats.formattedValueString
        let totalCurrentValueStr = String(format: investmentValueFormat, totalCurrentValue)
        let totalInvestmentStr = String(format: investmentValueFormat, totalInvestment)
        let todaysProfitAndLossStr = String(format: investmentValueFormat, todaysProfitAndLoss)
        let totalProfitAndLossStr = String(format: investmentValueFormat, totalProfitAndLoss)
        
        return InvestmentResult(totalCurrentValue: totalCurrentValueStr, totalInvestment: totalInvestmentStr, totalProfitAndLoss: todaysProfitAndLossStr, todaysProfitAndLoss: totalProfitAndLossStr)
    }
    
}
