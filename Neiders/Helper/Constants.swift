//
//  Constants.swift
//  TCS Transit
//
//  Created by Palash Das, Appsbee LLC on 28/09/20.
//  Copyright © 2020 Intelebee LLC. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Environment

// Set environment to staging or production
public let environment: Environment = .staging

//var cartDataModel:[CartDataForUIModel]?


public enum Environment {
    case production
    case staging
}

extension Environment {
    var baseURL : String {
        switch self {
            case .production:
                return "https://marcsales.com"
            case .staging:
                return "https://marcsales.com"
        }
    }
    
    var mxMerchantURL : String {
        switch self {
            case .production:
                return "https://api.mxmerchant.com"
            case .staging:
                return "https://sandbox.api.mxmerchant.com"
        }
    }
    
    var mxMarchentBasicAuth: String {
        switch self {
            case .production:
                return "Basic dG9kZGdAaHNnaW5jLmNvbTpLWFlMJmNiXlk3blo="
            case .staging:
                return "Basic dG9kZGdAaHNnaW5jLmNvbTpLWFlMJmNiXlk3blo="
        }
    }
}

// MARK: - App Constants

struct AppConstant {
    static let appTitle = "Open content for development"
        //Bundle.main.object(forInfoDictionaryKey:"CFBundleName") as! String
    
    static let appDel = UIApplication.shared.delegate as! AppDelegate
    static let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    static let defaultToolbarHeight:CGFloat = 45
    static let cartFileName = "CartSession"
    static let profileDetails = "UserSession"
    static let profileImageFileName = "profile.jpeg"
    static let offLineStorage = "OfflineTicketSession"
    
    // Timezone and locale
    static let mstTimeZone = TimeZone.init(abbreviation:"MST")
    static let usLocale = Locale.init(identifier: "en_US_POSIX")
    
    //MX Marchent
    static let mxMarchentId = "516163463"
}



// MARK: - Custom Fonts

enum FontName: String {
    case latoBlack = "Lato-Black"
    case latoBlackItalic = "Lato-BlackItalic"
    case latoBold = "Lato-Bold"
    case latoBoldItalic = "Lato-BoldItalic"
    case latItalic = "Lato-Italic"
    case latoLight = "Lato-Light"
    case latoLightItalic = "Lato-LightItalic"
    case latoRegular = "Lato-Regular"
}

//MARK:- card name

enum CardName: String {
    
    case AmericanExpress = "American Express"
    case Dankort = "Dankort"
    case DinersClub = ""
    case Discover = "Discover"
    case JCB = "JCB"
    case Maestro = "Maestro"
    case MasterCard = "MasterCard"
    case UnionPay = "UnionPay"
    case VisaElectron = "VisaElectron"
    case Visa = "Visa"
    case NotRecognized = "Default"
    
   
}


// MARK: - Keychain Constants

struct KeyChainConfig {
    static let login = Bundle.main.object(forInfoDictionaryKey:"CFBundleName") as! String
}

struct ScreenSize {
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}


// MARK: - Error Messages

enum NeidersError: Error {
    case noNetwork
    case sessionExpired
    case locationService
    case customMessage(String)
    case networkError
    case defaultMessage
}

extension NeidersError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noNetwork:
            return "Please check the internet connection.".localized()
        case .sessionExpired:
            return "Your session has been expired, please login to continue.".localized()
        case .locationService:
            return "Please turn on your Location Services to enable accurate map services."
        case .customMessage(let message):
            return message
        case .networkError:
            return "Internet Connection not Available".localized()
        case .defaultMessage:
            return "Unknown error. There was no error message to display, please contact support.".localized()
        }
    }
}


//MARK: - UITableViewCells

struct TableViewCell {
    static let serviceCell = "ServiceTableViewCell"
    static let baltimoreCell = "BaltimorePassTableViewCell"
    static let cartCell = "CartTableViewCell"
    static let AddPaymentCell = "AddPaymentMethodTableViewCell"
    static let PaymentOptionCell = "PaymentOptionTableCell"
    static let myTicketCell = "MyTicketTableViewCell"
    static let profileCell = "ProfileTableViewCell"
    static let NotificationCell = "NotificationTableViewCell"
    static let Discountcell = "DiscountTableViewCell"
    static let searchLocationcell = "searchLocationTableCell"
    static let selectCell = "SelectOptionTableViewCell"
    static let cardCell = "CardTableViewCell"
    static let UploadImgCell = "UploadIdImgTableViewCell"
    static let splitCell = "SplitPaymentTableViewCell"
    static let smartBenefitcell = "SmartBenefitTableViewCell"
    static let AddcardDoneCell = "AddCardDoneTableViewCell"
}


//MARK: - UICollectionViewCells

struct CollectionViewCell {
    static let collectionCell = "CollectionCell"
}



//MARK: - Save file to directory

func saveFileToDocumentDirectory(content: Data, fileName: String, fileDirectory: URL?) throws  {
    
    // create the destination file url to save your file
    if var fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(fileName){
        
        if let fDir = fileDirectory{
            fileURL = fDir.appendingPathComponent(fileName)
        }
        
        do{
            try content.write(to: fileURL, options: .completeFileProtection)
            print("Write path: \(fileURL)")
        }
        catch {
            print("Error saving file:", error.localizedDescription)
            throw error
        }
    }
    else{
        print("Can't fetch document directory")
        throw NeidersError.customMessage("Error while your fetching directory. Contact support.")
    }
}


//MARK: - Check directory for file existance

func fileExitsInDocumentDiretory(fileName:String) -> Data? {
    let fileManager = FileManager.default
    if let documentDirectory = fileManager.urls(for: .documentDirectory,
                                                in: .userDomainMask).first{
        // Construct a URL with desired folder name
        let folderURL = documentDirectory.appendingPathComponent(fileName)
        if fileManager.fileExists(atPath: folderURL.path) {
            print(folderURL.path)
            var returnData:Data? = nil
            do{
                returnData = try Data(contentsOf: folderURL)
            }
            catch let err {
                print("Data conversion error: \(err.localizedDescription)")
            }
            return returnData
        }
        else{
            return nil
        }
    }
    else{
        return nil
    }
}


//MARK: - Remove directory
@discardableResult
func removeFileOrDirectory(name: String) -> Bool {
    
    let fileManager = FileManager.default
    
    if let documentDirectory = fileManager.urls(for: .documentDirectory,
                                                in: .userDomainMask).first {
        // Construct a URL with desired folder name
        let folderURL = documentDirectory.appendingPathComponent(name)
        if fileManager.fileExists(atPath: folderURL.path) {
            do{
                try fileManager.removeItem(atPath: folderURL.path)
                return true
                
            } catch let error {
                print("Can't remove file: \(error.localizedDescription)")
                return false
            }
        }
        else{
            return false
        }
    }
    else{
        print("Can't fetch document directory")
        return false
    }
}

//var listView = ListPickerView()
////var shadowView = UIView()
//let deviceBounds:CGRect! = UIScreen.main.bounds
//class Basicsfunc: NSObject {
//    class func showListDropDown(Items:Array<String>, ParentViewC:UIViewController) {
//
//
//           let tapGes = UITapGestureRecognizer(target: self, action: #selector(hideListView))
//           tapGes.numberOfTapsRequired = 1
//
//            // listView = Bundle.main.loadNibNamed("ListPickerView", owner: ParentViewC, options: nil)?.first as! ListPickerView
//        let bundle = Bundle(for: type(of: listView))
//        //let bundle = Bundle(for: type(of: ParentViewC) )
//        listView = bundle.loadNibNamed("ListPickerView", owner: listView, options: nil)?.first as! ListPickerView
//           listView.frame = CGRect(x: 0, y: deviceBounds.size.height, width: deviceBounds.size.width, height: 227.0)
//
//           ParentViewC.view.addSubview(listView)
//           ParentViewC.view.endEditing(true)
//           listView.myDelegate = ParentViewC as? CustomPickerListDelegate
//           listView.ReloadPickerView(dataArray: Items)
//           UIView.animate(withDuration: 0.3, animations: {
//
//
//               listView.frame = CGRect(x: 0, y: deviceBounds.size.height - 227.0, width: deviceBounds.size.width, height: 227.0)
//
//           }, completion: nil)
//
//       }
//
//       @objc class func hideListView() {
//
//           UIView.animate(withDuration: 0.3, animations: {
//
//
//               listView.frame = CGRect(x: 0, y: deviceBounds.size.height, width: deviceBounds.size.width, height: 227.0)
//
//           }) { (Bool) in
//
//               //listV.myDelegate?.ListDidHide!()
//
//               listView.removeFromSuperview()
//
//           }
//       }
//}
var toolbar = UIToolbar()
class basicfunc:NSObject{
    //MARK: - Show Picker Function
   // var toolbar = UIToolbar()
    var Pickerview:UIPickerView?
    let deviceBounds:CGRect! = UIScreen.main.bounds
    func ShowPicker(picker : UIPickerView, viewController:UIViewController,selector: Selector?){
        toolbar.removeFromSuperview()
        picker.removeFromSuperview()
        
       // picker = UIPickerView.init()
        
        picker.backgroundColor = .white
        picker.showsSelectionIndicator = true
        picker.setValue(UIColor.black, forKey: "textColor")
        picker.autoresizingMask = .flexibleWidth
        picker.contentMode = .center
        picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 280, width: UIScreen.main.bounds.size.width, height: 280)
       // viewSelectMonth.addToolBar(self, selector: #selector(donePressed))
        viewController.view.addSubview(picker)
        toolbar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 280, width: UIScreen.main.bounds.size.width, height: 50))
        
        toolbar.barStyle = .black
        toolbar.isTranslucent = false
        toolbar.tintColor = .white
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: selector)
        done.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont.setLatoFont(name: .latoBold, size: 16),
            NSAttributedString.Key.foregroundColor : UIColor.white,
        ], for: .normal)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    
        toolbar.setItems([flexibleSpace, done], animated: false)
        toolbar.isUserInteractionEnabled = true
        toolbar.sizeToFit()
       // viewController.inputAccessoryView = toolbar
        viewController.view.addSubview(toolbar)
    }


}
public func getDateAndTime(timeZoneIdentifier: String) -> String? {

      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
      dateFormatter.timeZone = TimeZone(identifier: timeZoneIdentifier)
   // let todaydate = dateFormatter.string(from: Date())

      return dateFormatter.string(from: Date())
  }


extension String {
    func localized(bundle: Bundle = .main, tableName: String = "localization") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "\(self)", comment: "")
    }
}
var activityView: UIActivityIndicatorView?
func showActivityIndicator(viewController:UIViewController) {
    activityView = UIActivityIndicatorView(style: .large)
    activityView?.center = viewController.view.center
    viewController.view.addSubview(activityView!)
    activityView?.startAnimating()
}

func hideActivityIndicator(){
    if (activityView != nil){
        activityView?.stopAnimating()
    }
}
