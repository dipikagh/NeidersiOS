//
//  LanguageVC.swift
//  Neiders
//
//  Created by DIPIKA GHOSH on 23/04/21.
//

import UIKit


protocol LanguageSelectProtocol:class {
    func setLanguageHome()
}
class LanguageVC: UIViewController,AlertDisplayer {
    
    @IBOutlet weak var btnApply: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lblSelectLanguage: UILabel!
    
    @IBOutlet weak var imgFrench: UIImageView!
    @IBOutlet weak var imgEnglish: UIImageView!
    @IBOutlet weak var imgSpanish: UIImageView!
    
    var strSlectedLang = ""
    weak var delegate:LanguageSelectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let lang = UserDefaults.standard.value(forKey: "LANG") {
            if lang as? String == "ENG" {
                Bundle.setLanguage("en")
                imgEnglish.image = UIImage(named: "active_radio_btn")
                imgFrench.image = UIImage(named: "inactive_radio_btn")
                imgSpanish.image = UIImage(named: "inactive_radio_btn")
                strSlectedLang = "ENG"
                // Do any additional setup after loading the view.
                
            } else if lang as? String == "ES" {
                Bundle.setLanguage("es")
                imgSpanish.image = UIImage(named: "active_radio_btn")
                imgEnglish.image = UIImage(named: "inactive_radio_btn")
                imgFrench.image = UIImage(named: "inactive_radio_btn")
                strSlectedLang = "ES"
                // Do any additional setup after loading the view.
                
            }
            else {
                Bundle.setLanguage("fr")
                imgEnglish.image = UIImage(named: "inactive_radio_btn")
                imgFrench.image = UIImage(named: "active_radio_btn")
                imgSpanish.image = UIImage(named: "inactive_radio_btn")
                strSlectedLang = "FR"
                // Do any additional setup after loading the view.
                
            }
        }
        lblSelectLanguage.text = "Select App default Language".localized()
        btnApply.setTitle("APPLY".localized(), for: .normal)
        btnCancel.setTitle("CANCEL".localized(), for: .normal)
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnEnglish(_ sender: Any) {
        imgEnglish.image = UIImage(named: "active_radio_btn")
        imgFrench.image = UIImage(named: "inactive_radio_btn")
        imgSpanish.image = UIImage(named: "inactive_radio_btn")
        strSlectedLang = "ENG"
        
    }
    @IBAction func btnFrench(_ sender: Any) {
        imgEnglish.image = UIImage(named: "inactive_radio_btn")
        imgFrench.image = UIImage(named: "active_radio_btn")
        imgSpanish.image = UIImage(named: "inactive_radio_btn")
        strSlectedLang = "FR"
    }
    
    @IBAction func btnSpanish(_ sender: Any) {
        imgEnglish.image = UIImage(named: "inactive_radio_btn")
        imgFrench.image = UIImage(named: "inactive_radio_btn")
        imgSpanish.image = UIImage(named: "active_radio_btn")
        strSlectedLang = "ES"
    }
    
    
    @IBAction func buttonApply(_ sender: Any) {
        if let lang = UserDefaults.standard.value(forKey: "LANG") {
            if lang as? String == strSlectedLang {
                if (strSlectedLang == "ENG") {
                    let alertOkAction = UIAlertAction(title: "OK", style: .default) { (_) in
                        self.delegate?.setLanguageHome()
                        self.dismiss(animated: true, completion: nil)
                        
                    }
                    
                    self.showAlertWith(message: "English is already selected".localized(), type: .custom(actions: [alertOkAction]))
                }else {
                    let alertOkAction = UIAlertAction(title: "OK", style: .default) { (_) in
                        self.delegate?.setLanguageHome()
                        self.dismiss(animated: true, completion: nil)
                        
                    }
                    
                    self.showAlertWith(message: "English is already selected".localized(), type: .custom(actions: [alertOkAction]))
                }
            }else {
                if (strSlectedLang == "ENG") {
                    UserDefaults.standard.set("ENG", forKey: "LANG")
                }else  if (strSlectedLang == "ES") {
                    UserDefaults.standard.set("ES", forKey: "LANG")
                }
                else {
                    UserDefaults.standard.set("FR", forKey: "LANG")
                }
                delegate?.setLanguageHome()
                self.dismiss(animated: true, completion: nil)
            }
        }else {
            if (strSlectedLang == "ENG") {
                UserDefaults.standard.set("ENG", forKey: "LANG")
            }
            else  if (strSlectedLang == "ES") {
                UserDefaults.standard.set("ES", forKey: "LANG")
            }else {
                UserDefaults.standard.set("FR", forKey: "LANG")
            }
            delegate?.setLanguageHome()
            self.dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func buttonCancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}





