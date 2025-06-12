
import UIKit

protocol HoldingsVMProtocol: NSObjectProtocol {
    
    func holdingDataFetchSuccess()
    func holdingDataFetchError(error: String)
}


class HoldingsViewModel: NSObject {
    
    weak var delegate: HoldingsVMProtocol?
    var holdingsData: Holding?
    
    init(delegate: HoldingsVMProtocol) {
        self.delegate = delegate
    }

    
    
}

//MARK: DATA FETCH
extension HoldingsViewModel{
    
    func performHoldingDataFetch()  {
        
        NetworkService.shared.fetchData(from: ApiEndpoints.holdingsUrl) { [weak self] result  in
            switch result {
            case .success(let data):
                
                do {
                    self?.holdingsData = try JSONDecoder().decode(Holding.self, from: data)
                    self?.delegate?.holdingDataFetchSuccess()
                    self?.saveHoldingsDataOffline(data: data)
                }catch{
//                    print("Decoding error: \(error)")
                    self?.delegate?.holdingDataFetchError(error: ApiError.somethingWentWrong)
                }
            case .failure(let error):
                guard self?.checkForHoldingsOfflineData() ?? false else {
                    self?.delegate?.holdingDataFetchError(error: error.localizedDescription)
                    return
                }
                self?.delegate?.holdingDataFetchSuccess()
            }
        }
    }
    
    
}

//MARK: OFFLINE DATA STORAGE METHODS
extension HoldingsViewModel{
    
    func saveHoldingsDataOffline(data: Data)  {
        guard let offlineData = String(data: data, encoding: .utf8) else { return }
        NetworkService.saveOfflineData(apiData: offlineData, apiKey: ApiEndpoints.holdingsUrl)
    }
    
    func checkForHoldingsOfflineData() -> Bool {
        guard let holdingsOfflineDataString = NetworkService.getOfflineData(apiKey: ApiEndpoints.holdingsUrl), let holdingsOfflineData = holdingsOfflineDataString.data(using: .utf8)  else { return false }
        do {
            self.holdingsData = try JSONDecoder().decode(Holding.self, from: holdingsOfflineData)
            return true
        }catch{
//            print("Decoding error: \(error)")
            self.delegate?.holdingDataFetchError(error: ApiError.somethingWentWrong)
        }
        
        return false
    }
}

//MARK: DATA GETTERS
extension HoldingsViewModel{
    
    func getHoldingsCount() -> Int {
        holdingsData?.data.userHolding.count ?? 0
    }
    
    func getStockName(index: Int) -> String {
        holdingsData?.data.userHolding[index].symbol ?? ""
    }
    
    func getStockQuantity(index: Int) -> Int {
        let qty = holdingsData?.data.userHolding[index].quantity ?? 0
        return qty
    }
    
    func getLtp(index: Int) -> Double {
        let ltp =  holdingsData?.data.userHolding[index].ltp ?? 0
        return ltp
    }
    
    func calculateAndGetStockProfitLoss(index: Int) -> Double {
        let closeStockValue =  getClosingStockValue(index: index)
        let quantity = getStockQuantity(index: index)
        let ltp = getLtp(index: index)
        
        let stockWiseProfitAndLoss = (closeStockValue - ltp) * Double(quantity)
        return stockWiseProfitAndLoss
    }
    
    func getClosingStockValue(index: Int) -> Double {
        let closeStockValue =  holdingsData?.data.userHolding[index].close ?? 0
        return closeStockValue
    }
    
    func getCurrentPortFolioValue() -> Double {
        var currentValue = 0.0
        holdingsData?.data.userHolding.forEach({ userHolding in
            currentValue += (Double(userHolding.quantity) * userHolding.ltp)
        })
        return currentValue
    }
    
    func getTotalInvestmentValue() -> Double {
        var totalInvestmentValue = 0.0
        holdingsData?.data.userHolding.forEach({ userHolding in
            totalInvestmentValue += (Double(userHolding.quantity) * userHolding.avgPrice)
        })
        return totalInvestmentValue
    }
    
    func getTodaysProfitLoss() -> Double {
        var todayProfitAndLossValue = 0.0
        holdingsData?.data.userHolding.forEach({ userHolding in
            todayProfitAndLossValue += (userHolding.close - userHolding.ltp) * Double(userHolding.quantity)
        })
        return todayProfitAndLossValue
    }
    
    func getTotalProfitLoss() -> Double {
        var totalProfitAndLossValue = 0.0
        totalProfitAndLossValue = getCurrentPortFolioValue() - getTotalInvestmentValue()
        return totalProfitAndLossValue
    }
}
