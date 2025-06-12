
import UIKit

extension UIView {

  var safeTopAnchor: NSLayoutYAxisAnchor {
    if #available(iOS 11.0, *) {
      return safeAreaLayoutGuide.topAnchor
    }
    return topAnchor
  }

  var safeLeftAnchor: NSLayoutXAxisAnchor {
    if #available(iOS 11.0, *){
        return safeAreaLayoutGuide.leadingAnchor
    }
    return leftAnchor
  }

  var safeRightAnchor: NSLayoutXAxisAnchor {
    if #available(iOS 11.0, *){
        return safeAreaLayoutGuide.trailingAnchor
    }
    return rightAnchor
  }

  var safeBottomAnchor: NSLayoutYAxisAnchor {
    if #available(iOS 11.0, *) {
      return safeAreaLayoutGuide.bottomAnchor
    }
    return bottomAnchor
  }
}

extension UIColor {
    
    static let barBgColor = "BarBgColor"
    static let greenTextColor = "GreenTextColor"
    static let greyBgColor = "GreyBgColor"
    
    static func getAppColor(colorString: String) -> UIColor {
        UIColor(named: colorString)!
    }
}
