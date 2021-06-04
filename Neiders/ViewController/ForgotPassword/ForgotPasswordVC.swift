//
//  ForgotPasswordVC.swift
//  Neiders
//
//  Created by DIPIKA GHOSH on 22/04/21.
//

import UIKit

class ForgotPasswordVC: UIViewController,AlertDisplayer {
    
    @IBOutlet weak var textOTP1: UITextField!
    @IBOutlet weak var textOTP2: UITextField!
    @IBOutlet weak var textOTP3: UITextField!
    @IBOutlet weak var textOTP4: UITextField!
    @IBOutlet weak var lblenterOtpMobileNumber: UILabel!
    @IBOutlet weak var textPassword: UITextField!
    
    @IBOutlet weak var btnvalidate: UIButton!
    
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var lblRetypePassword: UILabel!
    
    @IBOutlet weak var lblOTPCount: UILabel!
    
    @IBOutlet weak var btnResendOTP: UIButton!
    
    @IBOutlet weak var viewResendOtp: UIView!
    @IBOutlet weak var btnShowPassword: UIButton!
    
    var user:Users?
    
    
    var str1 = ""
    var str2 = ""
    var str3 = ""
    var str4 = ""
    var inputOTP = ""
    var timer:Timer?
    var strPhoneNumber:String = ""
    var strcountryCode:String = ""
    var count = 60
    var phoneNumber:String?
    var countryCode = "+91"
    var userId:String?
    var isComingFromloginVC:Bool? = true
    var viewModelForgotPassword:ForgotPasswordViewModel?
    var iconClick = true
    

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModelForgotPassword = ForgotPasswordViewModel()
        textOTP1.delegate = self
        textOTP2.delegate = self
        textOTP3.delegate = self
        textOTP4.delegate = self
        textPassword.delegate = self
        textPassword.tag = 5
        
        textOTP1.tag = 0
        textOTP2.tag = 1
        textOTP3.tag = 2
        textOTP4.tag = 3
        
        textOTP1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        textOTP2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        textOTP3.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        textOTP4.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        btnResendOTP.isHidden = true
        setUPForgotPassword()
       
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ForgotPasswordVC.update), userInfo: nil, repeats: true)
        self.btnvalidate.isUserInteractionEnabled = true
        

        // Do any additional setup after loading the view.
    }
    func setUPForgotPassword(){
        if isComingFromloginVC == true {
          
            if let phoneNumber = phoneNumber {
            VerifyAPI.sendVerificationCode(countryCode, phoneNumber)
              
            }
            
        }else {
           // viewResendOtp.isHidden = false
            if let phoneNumber = phoneNumber {
            VerifyAPI.sendVerificationCode(countryCode, phoneNumber)
              
            }
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
        if let lang = UserDefaults.standard.value(forKey: "LANG") {
            if lang as? String == "ENG" {
                Bundle.setLanguage("en")
            }else {
                Bundle.setLanguage("fr")
            }
        }
        languageSet()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.timer?.invalidate()
        self.timer = nil
    }
    
    func languageSet() {
        lblenterOtpMobileNumber.text = "Enter the OTP sent to your registered mobile number".localized()
        lblRetypePassword.text = "Retype Password".localized()
        btnvalidate.setTitle("Validate".localized(), for: .normal)
        btnSave.setTitle("Save".localized(), for: .normal)
        textPassword.placeholder = "Password".localized()
        btnResendOTP.setTitle("RESEND OTP".localized(), for: .normal)
        
    }
    
    
    @objc func update() {
        if(count > 0) {
            count = count - 1
             self.btnResendOTP.isHidden = true
            DispatchQueue.main.async {
                self.lblOTPCount.text = "\("Time left".localized()) (\(self.count) sec)"
            }
        }else{
            self.btnResendOTP.isHidden = false
            self.btnResendOTP.titleLabel?.textColor = UIColor(red: 140/255, green: 212/255, blue: 155/255, alpha: 1)
            self.timer?.invalidate()
            self.btnvalidate.isHidden = true
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func btnSubmit(_ sender: Any) {
       // self.navigationController?.popViewController(animated: true)
        callForgotPasswordApi()
    }
    
    @IBAction func btnResendOTP(_ sender: Any) {
        count = 60
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ForgotPasswordVC.update), userInfo: nil, repeats: true)
        self.clearOTP()
        if let phoneNumber = phoneNumber {
        VerifyAPI.sendVerificationCode(countryCode, phoneNumber)
            self.btnvalidate.isHidden = false
        }
    }
    @IBAction func buttonValidate(_ sender: Any) {
        if isComingFromloginVC == true {
            if inputOTP.count == 4 {
                if (phoneNumber == "") {
                    self.showAlertWith(message: "Some thing went wrong. Please try again later".localized())
                }else {
                callOTPApi(countryCode:self.countryCode,phoneNumber:self.phoneNumber ?? "")
                }
           // self.navigationController?.popViewController(animated: true)
            }else {
                showAlertWith(message: "Please enter 4 digit Otp".localized())
            }
        }else {
            if inputOTP.count == 4 {
            
            VerifyAPI.validateVerificationCode(self.countryCode, self.phoneNumber ?? "", inputOTP) { checked in
                if (checked.success) {
                    let resultMessage = checked.message
                    print(resultMessage)
                    if self.isComingFromloginVC ?? true{
                        self.callForgotPasswordApi()
                       // self.navigationController?.popViewController(animated: true)
                    }else {
                        let loginvc = LogInVC(nibName: "LogInVC", bundle: nil)
                        self.navigationController?.pushViewController(loginvc, animated: true)
                    }
                    
                  //  self.performSegue(withIdentifier: "checkResultSegue", sender: nil)
                } else {
                   // self.errorLabel.text = checked.message
                    self.showAlertWith(message: "Wrong OTP! Please try again".localized())
                   print(checked.message)
                }
            }
        }else {
            showAlertWith(message: "Please enter 4 digit Otp".localized())
        }
        }
       // self.navigationController?.popViewController(animated: true)
    }
    
    deinit {
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
}
    
    @objc func keyboardWillShow( _ sender: NSNotification) {
         self.view.frame.origin.y = -100 // Move view 150 points upward
    }

    @objc func keyboardWillHide(_ sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnShowHidePassword(_ sender: Any) {
        if(iconClick == true) {
           
            textPassword.isSecureTextEntry = false
            btnShowPassword.setImage(UIImage(named: "invisible"), for: .normal)
               } else {
                textPassword.isSecureTextEntry = true
               btnShowPassword.setImage(UIImage(named: "view"), for: .normal)
               }

               iconClick = !iconClick
    }
    
    func clearOTP()  {
        self.textOTP1.text = ""
        self.textOTP2.text = ""
        self.textOTP3.text = ""
        self.textOTP4.text = ""
   
    }
    
    func callForgotPasswordApi(){
        guard let userid = userId else {
            "Some thing went wrong. Please try again later".localized()
            return
        }
        DispatchQueue.main.async {
            showActivityIndicator(viewController: self)
        }
        viewModelForgotPassword?.UPdate(strPassword: textPassword.text!, strid: userid, completion: { (result) in
            DispatchQueue.main.async {
            switch result{
            case .success(let result):
//            DispatchQueue.main.async {
                
                hideActivityIndicator()
                if let success = result as? Bool , success == true {
                    let alertOkAction = UIAlertAction(title: "OK", style: .default) { (_) in
                        self.navigationController?.popViewController(animated: true)

                    }

                    self.showAlertWith(message: "You have changed your password successfully".localized(), type: .custom(actions: [alertOkAction]))
                }else {
                    self.showAlertWith(message: "Some thing went wrong. Please try again later".localized())
                }
           // }
            case .failure(let error):
                hideActivityIndicator()
            self.showAlertWith(message: error.localizedDescription)
            }
            }
            
            
        })
       // self.navigationController?.popViewController(animated: true)
    }
    
    func callOTPApi(countryCode:String,phoneNumber:String){
        VerifyAPI.validateVerificationCode(countryCode, phoneNumber, inputOTP) { checked in
            if (checked.success) {
                let resultMessage = checked.message
                print(resultMessage)
                
                self.timer?.invalidate()
                self.timer = nil
                self.viewResendOtp.isHidden = true
               // self.clearOTP()
                self.btnvalidate.isUserInteractionEnabled = false
             
                
              //  self.performSegue(withIdentifier: "checkResultSegue", sender: nil)
            } else {
               // self.errorLabel.text = checked.message
                self.showAlertWith(message: "Wrong OTP! Please try again".localized())
               print(checked.message)
            }
        }
    }

}


extension ForgotPasswordVC : UITextFieldDelegate {
    
    @objc func textFieldDidChange(textField: UITextField){
        let text = textField.text
        if (text?.utf16.count)! == 1{
            switch textField{
            case textOTP1:
                str1 = textOTP1.text!
                textOTP2.becomeFirstResponder()
                
            case textOTP2:
                str2 = textOTP2.text!
                textOTP3.becomeFirstResponder()
                
            case textOTP3:
                str3 = textOTP3.text!
                textOTP4.becomeFirstResponder()
                
            case textOTP4:
                str4 = textOTP4.text!
                textOTP4.resignFirstResponder()

                
                
            default:
                break
            }
        }
        else if  text?.count == 0 {
            switch textField{
            case textOTP1:
                str1 = textOTP1.text!
                textOTP1.becomeFirstResponder()
                
            case textOTP2:
                str2 = textOTP2.text!
                textOTP1.becomeFirstResponder()
                
            case textOTP3:
                str3 = textOTP3.text!
                textOTP2.becomeFirstResponder()
                
            case textOTP4:
                str4 = textOTP4.text!
                textOTP3.becomeFirstResponder()

                
            default:
                break
            }
        }
        else{
            
            if textField.tag == 0 {
                if (textField.text! == ""){
                str1 = textField.text!
                }
                else {
                textField.text! = ""
                  str1 = textField.text!
                }
               
            }
            else if textField.tag == 1 {
                if (textField.text! == ""){
                str2 = textField.text!
                }
                else {
                 textField.text! = ""
                    str2 = textField.text!
                }
               
            }
            else if textField.tag == 2 {
                if (textField.text! == ""){
                str3 = textField.text!
                }
                else {
                  textField.text! = ""
                    str3 = textField.text!
                }
                
            }
            else if textField.tag == 3 {
                if (textField.text! == ""){
                str4 = textField.text!
                }
                else {
                  textField.text! = ""
                    str4 = textField.text!
                }
               
            }


            print("Already have value")

        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 0 {
          str1 = textField.text!
        }
        else if textField.tag == 1 {
           str2 = textField.text!
        }
        else if textField.tag == 2 {
            str3 = textField.text!
        }
        else if textField.tag == 3 {
           str4 = textField.text!
        }

       }
     func textFieldDidEndEditing(_ textField: UITextField) {
        
        self.inputOTP = "\(str1)\(str2)\(str3)\(str4)"
        print(inputOTP)
       
        
       }
    class func isString10Digits(ten_digits: String) -> Bool{

        if !ten_digits.isEmpty {

            let numberCharacters = NSCharacterSet.decimalDigits.inverted
            return !ten_digits.isEmpty && ten_digits.rangeOfCharacter(from: numberCharacters) == nil
        }
        return false
    }
}
