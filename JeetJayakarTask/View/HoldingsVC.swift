//
//  HoldingsVC.swift
//  JeetJayakarTask
//
//  Created by Jeet Jayakar on 10/06/25.
//

import UIKit

class HoldingsVC: UIViewController {
    
    //MARK: VIEW PROPERTIES
    let headerView = UIView()
    let holdingsTableView = UITableView()
    
    let currentValueStackView = UIStackView()
    let currentValueDataLabel = UILabel()
    
    let totalInvestementStackView = UIStackView()
    let totalInvestementDataLabel = UILabel()

    let todayProfitLossStackView = UIStackView()
    let todayProfitLossDataLabel = UILabel()
    
    let summarySeperatorView = UIView()
    
    let profitLossLabel = UILabel()
    let profitLossDataLabel = UILabel()

    //MARK: PROPERTIES
    var isPortFolioViewHidden: Bool = false
    var holdingsVM: HoldingsViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureViewModel()
        configureHeaderView()
        configureHoldingsTableView()
        configurePortfolioSummaryView()
        profitLossViewTapped()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        performDataFetch()
    }
}



//MARK: HEADER VIEW BUILDER
extension HoldingsVC{
    
    func configureHeaderView()  {
        headerView.backgroundColor = UIColor.getAppColor(colorString: UIColor.barBgColor)
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 0).isActive = true
        headerView.leadingAnchor.constraint(equalTo: view.safeLeftAnchor, constant: 0).isActive = true
        headerView.trailingAnchor.constraint(equalTo: view.safeRightAnchor, constant: 0).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        let headerLabel = UILabel()
        headerLabel.textColor = .white
        headerLabel.text = "Holdings"
        headerLabel.font = UIFont.boldSystemFont(ofSize: 22)
        headerView.addSubview(headerLabel)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor, constant: 0).isActive = true
        headerLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor, constant: 0).isActive = true
        
        let underLineView = UIView()
        underLineView.backgroundColor = .white
        headerView.addSubview(underLineView)

        underLineView.translatesAutoresizingMaskIntoConstraints = false
        underLineView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 4).isActive = true
        underLineView.leadingAnchor.constraint(equalTo: headerLabel.leadingAnchor, constant: 0).isActive = true
        underLineView.trailingAnchor.constraint(equalTo: headerLabel.trailingAnchor, constant: 0).isActive = true
        underLineView.heightAnchor.constraint(equalToConstant: 0.8).isActive = true
    }
}

//MARK: TABLE VIEW BUILDER
extension HoldingsVC{
    
    func configureHoldingsTableView()  {
        view.addSubview(holdingsTableView)
        holdingsTableView.translatesAutoresizingMaskIntoConstraints = false
        holdingsTableView.leadingAnchor.constraint(equalTo: view.safeLeftAnchor, constant: 0).isActive = true
        holdingsTableView.trailingAnchor.constraint(equalTo: view.safeRightAnchor, constant: 0).isActive = true
        holdingsTableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 0).isActive = true
//        holdingsTableView.bottomAnchor.constraint(equalTo: view.safeBottomAnchor, constant: 0).isActive = true
        
        holdingsTableView.register(StockDetailsCell.self, forCellReuseIdentifier: "StockDetailsCell")
        holdingsTableView.delegate = self
        holdingsTableView.dataSource = self
        holdingsTableView.estimatedRowHeight = 100
        holdingsTableView.rowHeight = UITableView.automaticDimension
        holdingsTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

    }
    
}

//MARK: SUMMARY VIEW BUILDER
extension HoldingsVC{
    func configurePortfolioSummaryView()  {
        let parentView = UIView()
        parentView.backgroundColor = UIColor.getAppColor(colorString: UIColor.greyBgColor)
        parentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(parentView)
        parentView.leadingAnchor.constraint(equalTo: view.safeLeftAnchor, constant: 0).isActive = true
        parentView.trailingAnchor.constraint(equalTo: view.safeRightAnchor, constant: 0).isActive = true
        parentView.bottomAnchor.constraint(equalTo: view.safeBottomAnchor, constant: 0).isActive = true
        parentView.topAnchor.constraint(equalTo: holdingsTableView.bottomAnchor, constant: 0).isActive = true
        
        parentView.clipsToBounds = true
        parentView.layer.cornerRadius = 8
        parentView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]

        
        let parentStackView = UIStackView()
        parentStackView.axis = .vertical
        parentStackView.spacing = 16.0
        parentStackView.distribution = .equalSpacing
        parentStackView.backgroundColor = UIColor.getAppColor(colorString: UIColor.greyBgColor)
        parentView.addSubview(parentStackView)
        parentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        parentStackView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 16).isActive = true
        parentStackView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -16).isActive = true
        parentStackView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: -8).isActive = true
        parentStackView.topAnchor.constraint(equalTo: parentView.topAnchor, constant: 16).isActive = true
        
        // Current Portfolio Value View
        currentValueStackView.axis = .horizontal
        currentValueStackView.spacing = 16.0
        currentValueStackView.distribution = .equalSpacing
        parentStackView.addArrangedSubview(currentValueStackView)

        let currentValueLabel = UILabel()
        currentValueLabel.text = "Current Value*"
        currentValueLabel.font = UIFont.boldSystemFont(ofSize: 15)
        currentValueLabel.textAlignment = .left
        currentValueStackView.addArrangedSubview(currentValueLabel)
        
        currentValueDataLabel.text = "\(AppConstants.rupee) 0"
        currentValueDataLabel.font = UIFont.boldSystemFont(ofSize: 15)
        currentValueDataLabel.textAlignment = .right
        currentValueStackView.addArrangedSubview(currentValueDataLabel)
        
        // Total Investment Value View
        totalInvestementStackView.axis = .horizontal
        totalInvestementStackView.spacing = 16.0
        totalInvestementStackView.distribution = .equalSpacing
        parentStackView.addArrangedSubview(totalInvestementStackView)

        let totalInvestementLabel = UILabel()
        totalInvestementLabel.text = "Total Investment*"
        totalInvestementLabel.font = UIFont.boldSystemFont(ofSize: 15)
        totalInvestementLabel.textAlignment = .left
        totalInvestementStackView.addArrangedSubview(totalInvestementLabel)
        
        totalInvestementDataLabel.text = "\(AppConstants.rupee) 0"
        totalInvestementDataLabel.font = UIFont.boldSystemFont(ofSize: 15)
        totalInvestementDataLabel.textAlignment = .right
        totalInvestementStackView.addArrangedSubview(totalInvestementDataLabel)
        
        
        // Today Profit & Loss View
        todayProfitLossStackView.axis = .horizontal
        todayProfitLossStackView.spacing = 16.0
        todayProfitLossStackView.distribution = .equalSpacing
        parentStackView.addArrangedSubview(todayProfitLossStackView)

        let todayProfitLossLabel = UILabel()
        todayProfitLossLabel.text = "Today's P&L*"
        todayProfitLossLabel.font = UIFont.boldSystemFont(ofSize: 15)
        todayProfitLossLabel.textAlignment = .left
        todayProfitLossStackView.addArrangedSubview(todayProfitLossLabel)
        
        todayProfitLossDataLabel.text = "\(AppConstants.rupee) 0"
        todayProfitLossDataLabel.font = UIFont.boldSystemFont(ofSize: 15)
        todayProfitLossDataLabel.textAlignment = .right
        todayProfitLossStackView.addArrangedSubview(todayProfitLossDataLabel)
        
        summarySeperatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        summarySeperatorView.backgroundColor = UIColor.darkGray
        parentStackView.addArrangedSubview(summarySeperatorView)
        
        // Overall Profit & Loss View
        let overallProfitLossStackView = UIStackView()
        overallProfitLossStackView.axis = .horizontal
        overallProfitLossStackView.spacing = 16.0
        overallProfitLossStackView.distribution = .equalSpacing
        parentStackView.addArrangedSubview(overallProfitLossStackView)
        overallProfitLossStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profitLossViewTapped)))

        profitLossLabel.text = "Profit & Loss*"
        profitLossLabel.font = UIFont.boldSystemFont(ofSize: 15)
        profitLossLabel.textAlignment = .left
        overallProfitLossStackView.addArrangedSubview(profitLossLabel)
        
        profitLossDataLabel.text = "\(AppConstants.rupee) 0"
        profitLossDataLabel.font = UIFont.boldSystemFont(ofSize: 15)
        profitLossDataLabel.textAlignment = .right
        overallProfitLossStackView.addArrangedSubview(profitLossDataLabel)
        
    }
    
    func togglePortfolioView(isHide: Bool)  {
        UIView.animate(withDuration: 0.35,
                       delay: 0.0,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 1,
                       options: [],
                       animations: { [weak self] in
            self?.summarySeperatorView.isHidden = isHide
            self?.currentValueStackView.isHidden = isHide
            self?.totalInvestementStackView.isHidden = isHide
            self?.todayProfitLossStackView.isHidden = isHide
        },
                       completion: nil)
    }
    
    @objc func profitLossViewTapped() {
        isPortFolioViewHidden.toggle()
        togglePortfolioView(isHide: isPortFolioViewHidden)
        
        let collapseIndicator = isPortFolioViewHidden ? "↑" : "↓"
        profitLossLabel.text = "Profit Loss * \(collapseIndicator)"
    }
    
    func setCurrentPortFolioValue()  {
        let currentPortFolioValue = AppHelper.formatNumberWithCommas(holdingsVM?.getCurrentPortFolioValue() ?? 0)
        currentValueDataLabel.text = "\(AppConstants.rupee) \(currentPortFolioValue)"
    }
    
    func setTotalInvestmentValue()  {
        let totalInvestementValue = AppHelper.formatNumberWithCommas(holdingsVM?.getTotalInvestmentValue() ?? 0)
        totalInvestementDataLabel.text = "\(AppConstants.rupee) \(totalInvestementValue)"
    }
    
    func setTodaysProfitAndLoss()  {
        let todaysProfitLossValue = AppHelper.formatNumberWithCommas(holdingsVM?.getTodaysProfitLoss() ?? 0)
        todayProfitLossDataLabel.text = "\(AppConstants.rupee) \(todaysProfitLossValue)"
        
        if holdingsVM?.getTodaysProfitLoss() ?? 0 <= 0{
            todayProfitLossDataLabel.textColor = .red
        }else{
            todayProfitLossDataLabel.textColor = UIColor.getAppColor(colorString: UIColor.greenTextColor)
        }
    }
    
    func setTotalProfitAndLoss()  {
        let totalProfitLossValue = AppHelper.formatNumberWithCommas(holdingsVM?.getTotalProfitLoss() ?? 0)
        profitLossDataLabel.text = "\(AppConstants.rupee) \(totalProfitLossValue)"
        
        if holdingsVM?.getTotalProfitLoss() ?? 0 <= 0{
            profitLossDataLabel.textColor = .red
        }else{
            profitLossDataLabel.textColor = UIColor.getAppColor(colorString: UIColor.greenTextColor)
        }
    }
}

//MARK: TABLE VIEW DELEGATES & DATASOURCE
extension HoldingsVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        holdingsVM?.getHoldingsCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let stockDetailsCell = tableView.dequeueReusableCell(withIdentifier: "StockDetailsCell") as? StockDetailsCell else { return UITableViewCell() }
        stockDetailsCell.setStockName(stockName: holdingsVM?.getStockName(index: indexPath.row) ?? "")
        
        if let stockQuantity = holdingsVM?.getStockQuantity(index: indexPath.row){
            stockDetailsCell.setNetQty(qty: "\(stockQuantity)")
        }else{
            stockDetailsCell.setNetQty(qty: "0")
        }
        
        if let stockLtp = holdingsVM?.getLtp(index: indexPath.row){
            stockDetailsCell.setLtp(ltp: "\(AppConstants.rupee) \(AppHelper.formatWithCommas("\(stockLtp)"))")
        }else{
            stockDetailsCell.setLtp(ltp: "0")
        }
        
        if let stockProfitLoss = holdingsVM?.calculateAndGetStockProfitLoss(index: indexPath.row){
            
            stockDetailsCell.setProfitAndLoss(profitLoss: "\(AppConstants.rupee) \((AppHelper.formatWithCommas("\(stockProfitLoss)")))", isprofit: stockProfitLoss < 0 ? false : true)
        }else{
            stockDetailsCell.setProfitAndLoss(profitLoss: "0", isprofit: true)
        }
        
        return stockDetailsCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

//MARK: RELOAD TABLE VIEW
extension HoldingsVC{
    func reloadTableData()  {
        DispatchQueue.main.async { [weak self] in
            self?.holdingsTableView.reloadData()
        }
    }
}

//MARK: VIEW MODEL COMMUNICATION
extension HoldingsVC{
    func performDataFetch()  {
        AppHelper.addLoader(controller: self)
        holdingsVM?.performHoldingDataFetch()
    }
    
    func configureViewModel()  {
        holdingsVM = HoldingsViewModel(delegate: self)
    }
}

//MARK: VIEW MODEL PROTOCOL METHODS
extension HoldingsVC: HoldingsVMProtocol{
    
    func holdingDataFetchSuccess() {
        AppHelper.removeLoader()
        reloadTableData()
        DispatchQueue.main.async { [weak self] in
            self?.setCurrentPortFolioValue()
            self?.setTotalInvestmentValue()
            self?.setTodaysProfitAndLoss()
            self?.setTotalProfitAndLoss()
        }
    }
    
    func holdingDataFetchError(error: String) {
        AppHelper.removeLoader()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            AppHelper.showDataAlert(title: error, message: "", controller: self)
        }
        reloadTableData()
    }
}
