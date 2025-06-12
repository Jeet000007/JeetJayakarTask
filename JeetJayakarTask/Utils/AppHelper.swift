
import UIKit

class AppHelper: NSObject {
    
    static var loader: UIAlertController?
    
    class func formatWithCommas(_ input: String) -> String {
        if let number = Double(input) {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.groupingSeparator = ","
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 2
            return formatter.string(from: NSNumber(value: number)) ?? input
        }
        return input
    }
    
    class func formatNumberWithCommas(_ input: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return formatter.string(from: input as NSNumber) ?? "0"
    }
    
    class func addLoader(controller: UIViewController)  {
        loader = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.large
        loadingIndicator.startAnimating()
        loader?.view.addSubview(loadingIndicator)
        controller.present(loader!, animated: true)
    }
    
    class func removeLoader()  {
        DispatchQueue.main.async {
            loader!.dismiss(animated: false) {
                loader = nil
            }
        }
    }
    
    class func showDataAlert(title: String, message: String, controller: UIViewController)  {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async { controller.present(alert, animated: true, completion: nil) }
    }
}
