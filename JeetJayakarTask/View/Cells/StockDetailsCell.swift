
import UIKit

class StockDetailsCell: UITableViewCell {
    
    let stockNameLabel = UILabel()
    let ltpValueLabel = UILabel()
    let netQtyLabel = UILabel()
    let profitLossLabel = UILabel()

    private var isConfigured = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCellLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

//MARK: CONFIGURE CELL LAYOUT
extension StockDetailsCell{
    
    func configureCellLayout() {
        guard !isConfigured else { return }
                isConfigured = true
        
        let parentStackView = UIStackView()
        parentStackView.axis = .vertical
        parentStackView.spacing = 16.0
        parentStackView.distribution = .equalSpacing
        self.contentView.addSubview(parentStackView)
        parentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        parentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        parentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        parentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        parentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
        
        let firstStackView = UIStackView()
        firstStackView.axis = .horizontal
        firstStackView.spacing = 16.0
        firstStackView.distribution = .equalSpacing
        parentStackView.addArrangedSubview(firstStackView)

        stockNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        stockNameLabel.textAlignment = .left
        firstStackView.addArrangedSubview(stockNameLabel)
        
        ltpValueLabel.font = UIFont.boldSystemFont(ofSize: 16)
        ltpValueLabel.textAlignment = .right
        ltpValueLabel.textColor = .lightGray
        firstStackView.addArrangedSubview(ltpValueLabel)
        
        let secondStackView = UIStackView()
        secondStackView.axis = .horizontal
        secondStackView.spacing = 16.0
        secondStackView.distribution = .equalSpacing
        parentStackView.addArrangedSubview(secondStackView)

        
        netQtyLabel.font = UIFont.boldSystemFont(ofSize: 16)
        netQtyLabel.textAlignment = .left
        secondStackView.addArrangedSubview(netQtyLabel)
        
        profitLossLabel.font = UIFont.boldSystemFont(ofSize: 16)
        profitLossLabel.textAlignment = .right
        profitLossLabel.textColor = .lightGray
        secondStackView.addArrangedSubview(profitLossLabel)
    }
    
    
}

//MARK: SET CELL DATA
extension StockDetailsCell{
    
    func setStockName(stockName: String)  {
        stockNameLabel.text = stockName
    }
    
    func setNetQty(qty: String)  {
        let netQtyAttrString = NSMutableAttributedString(string: "NET QTY: ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11),NSAttributedString.Key.foregroundColor: UIColor.gray])
        let netQtyValueAttrString = NSMutableAttributedString(string: qty, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.black])
        let finalAttributedString = NSMutableAttributedString()
        finalAttributedString.append(netQtyAttrString)
        finalAttributedString.append(netQtyValueAttrString)
        netQtyLabel.attributedText = finalAttributedString
    }
    
    func setLtp(ltp: String)  {
        let ltpAttrString = NSMutableAttributedString(string: "LTP: ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11),NSAttributedString.Key.foregroundColor: UIColor.gray])
        let ltpValueAttrString = NSMutableAttributedString(string: ltp, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.black])
        let finalAttributedString = NSMutableAttributedString()
        finalAttributedString.append(ltpAttrString)
        finalAttributedString.append(ltpValueAttrString)
        ltpValueLabel.attributedText = finalAttributedString
    }
    
    func setProfitAndLoss(profitLoss: String, isprofit: Bool)  {
        let profitLossIndicator = isprofit ? "" : "-"
        
        let profitLossAttrString = NSMutableAttributedString(string: "P&L: ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11),NSAttributedString.Key.foregroundColor: UIColor.gray])
        let profitLossValueAttrString = NSMutableAttributedString(string: "\(profitLossIndicator)\(profitLoss.replacingOccurrences(of: "-", with: ""))", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: isprofit ? UIColor.getAppColor(colorString: UIColor.greenTextColor) : UIColor.red])
        let finalAttributedString = NSMutableAttributedString()
        finalAttributedString.append(profitLossAttrString)
        finalAttributedString.append(profitLossValueAttrString)
        profitLossLabel.attributedText = finalAttributedString
    }
}
