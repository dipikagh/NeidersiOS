//
//  LogInVC.swift
//  Neiders
//
//  Created by DIPIKA GHOSH on 20/04/21.
//

import UIKit
import Amplify
import AmplifyPlugins
import FBSDKLoginKit
import FBSDKCoreKit


class LogInVC: UIViewController,UITextFieldDelegate,AlertDisplayer {
    
    
    @IBOutlet weak var buttonSignup: UIButton!
    @IBOutlet weak var buttonLoginWithFb: UIButton!
    @IBOutlet weak var buttonLogin: UIButton!
    
    @IBOutlet weak var textInputEmail: UITextField!
    @IBOutlet weak var textInputPassword: UITextField!
    @IBOutlet weak var btnForgotPAssword: UIButton!
    
    @IBOutlet weak var lblSignup: UILabel!
    @IBOutlet weak var lblor: UILabel!
    
    @IBOutlet weak var btnShowPassword: UIButton!
    
  //  @IBOutlet weak var btnFacebook: FBLoginButton!
    
    var viewModelLogin: loginViewModel?
    var arrCointainer = ["",""]
    var fbId : String = ""
    var fbEmail : String = ""
    var fbFName : String = ""
    var fbLName : String = ""
    var fbName : String = ""
    var fbPickUrl : String = ""
    var iconClick = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        buttonSignup.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.gray, radius: 3.0, opacity: 0.6)
        buttonLoginWithFb.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.gray, radius: 3.0, opacity: 0.6)
        buttonLogin.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.gray, radius: 3.0, opacity: 0.6)
        textInputEmail.text = ""
        textInputPassword.text = ""
        textInputEmail.delegate = self
        textInputPassword.delegate = self
        viewModelLogin = loginViewModel()
        textInputEmail.tag = 0
        textInputPassword.tag = 1
        textInputEmail.addTarget(self, action: #selector(textInputValue(_:)), for: .editingChanged)
        textInputPassword.addTarget(self, action: #selector(textInputValue(_:)), for: .editingChanged)
        
//        if let lang = UserDefaults.standard.value(forKey: "Lang") {
//            if lang as? String == "ENG" {
//                Bundle.setLanguage("en")
//                // Do any additional setup after loading the view.
//
//            }else {
//                Bundle.setLanguage("es")
//                // Do any additional setup after loading the view.
//
//            }
//        }
      //  Bundle.setLanguage("fr")
       

        // Do any additional setup after loading the view.
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
       
        
        textInputEmail.text = ""
        textInputPassword.text = ""
         arrCointainer = ["",""]
        setLanguage()
      
        }
    func setLanguage() {
        buttonSignup.setTitle("Sign up".localized(), for: .normal)
        textInputEmail.placeholder = "User Name".localized()
        textInputPassword.placeholder = "Password".localized()
        buttonLogin.setTitle("Login".localized(), for: .normal)
        buttonLoginWithFb.setTitle("Log in with Facebook".localized(), for: .normal)
       
        let stringFP = "Forgot Password".localized()
        let forgotPAssAttribute: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
            NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 14),
            NSAttributedString.Key.foregroundColor: UIColor(named: "CustomYellow")!]

        let attributedString = NSAttributedString(string: stringFP, attributes: forgotPAssAttribute)
        btnForgotPAssword.setAttributedTitle(attributedString, for: .normal)
        let str = "Don't have an Account? Create an Account".localized()
//        let string = str
//        var myRange = NSRange(location: 26, length: 15) // range starting at location 17 with a lenth of 7: "Strings"
//        string.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: myRange)
       
        var myMutableString = NSMutableAttributedString()

        myMutableString = NSMutableAttributedString(string: str)

        myMutableString.setAttributes([ NSAttributedString.Key.foregroundColor : UIColor(red: 6 / 255.0, green: 68 / 255.0, blue: 108 / 255.0, alpha: 1.0)], range: NSRange(location:27,length:15)) // What ever range you want to give

    lblSignup.attributedText = myMutableString
    }
    
    func facebookLogin(){
        if let token = AccessToken.current,
           !token.isExpired {
            // User is logged in, do work such as go to next view controller.
            let token = token.tokenString
            
            let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields": "id, email, first_name, last_name, picture, short_name, name"], tokenString: token, version: nil, httpMethod: .get)
            request.start { (connection, result, error) in
                print("\(String(describing: result))")
                
            }
        }else{
//            btnFacebook.permissions = ["public_profile", "email"]
//            btnFacebook.delegate = self
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @objc func textInputValue(_ textfield:UITextField) {
        arrCointainer[textfield.tag] = textfield.text!
    }
    
    
    @IBAction func btnShowHidePassword(_ sender: Any) {
        
        if(iconClick == true) {
           
            textInputPassword.isSecureTextEntry = false
            btnShowPassword.setImage(UIImage(named: "invisible"), for: .normal)
               } else {
                textInputPassword.isSecureTextEntry = true
               btnShowPassword.setImage(UIImage(named: "view"), for: .normal)
               }

               iconClick = !iconClick
    }
    

    @IBAction func btnForgotPassword(_ sender: Any) {
        if textInputEmail.text == "" {
            showAlertWith(message: "Please enter registered email address".localized())
        }else {
            callforgotPass()
        }
       
    }
    @IBAction func btnSignUp(_ sender: Any) {
       
        let signupVC = SignupVc(nibName: "SignupVc", bundle: nil)
        self.navigationController?.pushViewController(signupVC, animated: true)
    }
    
    
    @IBAction func btnFacebook(_ sender: Any) {
        getFBUserData()
        
//        let loginManager = LoginManager()
//        loginManager.logIn(
//            permissions: [.publicProfile,.email],
//            viewController: self
//        ) { result in
//            self.loginManagerDidComplete(result)
//        }
    }
    
    @IBAction func btnLogin(_ sender: Any) {
        callSignin()
//        let signupVC = HomeVC(nibName: "HomeVC", bundle: nil)
//        self.navigationController?.pushViewController(signupVC, animated: true)
    }
    func callSignin(){
        DispatchQueue.main.async {
            showActivityIndicator(viewController: self)
        }
        viewModelLogin?.callSigninApi(email: arrCointainer[0], password: arrCointainer[1], completion: {(result) in
            DispatchQueue.main.async {
            switch result {
           
            case .success(let result):
                hideActivityIndicator()
         
                if let success = result as? Bool , success == true {
                  
                        let homeVC = HomeVC(nibName: "HomeVC", bundle: nil)
                        self.navigationController?.pushViewController(homeVC, animated: true)
                    }
                    
              
            case .failure(let error):
                hideActivityIndicator()
                self.showAlertWith(message: error.localizedDescription)
                
            }
            }
        })

        
    }
    
    func callforgotPass(){
        DispatchQueue.main.async {
            showActivityIndicator(viewController: self)
        }
        viewModelLogin?.callForgotApi(email: arrCointainer[0], completion: {(result) in
            DispatchQueue.main.async {
            switch result {
           
            case .success(let result):
                hideActivityIndicator()
         
                if let user = result as? Users {
                  
                    let forgotPassVC = ForgotPasswordVC(nibName: "ForgotPasswordVC", bundle: nil)
                    forgotPassVC.isComingFromloginVC = true
                    forgotPassVC.phoneNumber = user.phone ?? ""
                    forgotPassVC.userId = user.id
                    
                    self.navigationController?.pushViewController(forgotPassVC, animated: true)
                    }
                    
              
            case .failure(let error):
                hideActivityIndicator()
                self.showAlertWith(message: error.localizedDescription)
                
            }
            }
        })

        
    }
    
}


extension LogInVC{
    func loginManagerDidComplete(_ result: LoginResult) {
        
        switch result {
        case .cancelled:
            //showAlertMessage(title: "Ooops", message: "User cancelled login.", vc: self)
            print("")
        case .failed(let error):
            print(error.localizedDescription)
           // showAlertMessage(title: "Ooops", message: "Login failed with error \(error)", vc: self)
            
        case .success( _, _, _):
            //print(token.userID)
            self.getFBUserData()
           
        }
        
        
    }
    
    func getFBUserData(){
//
        let loginManager = LoginManager()
          //  UIApplication.shared.statusBarStyle = .default  // remove this line if not required
        loginManager.logIn(permissions: [ .publicProfile,.email ], viewController: self) { loginResult in
                print(loginResult)

                //use picture.type(large) for large size profile picture
            _ = GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                    if (error == nil){
                        //everything works print the user data
                        print("Result111:\(String(describing: result)) "as Any)
                    }
                    let dict = result as? NSDictionary
                    print("FB Email1st:\(String(describing: dict))")
    //                var fbId = ""
    //                var fbFName = ""
    //                var fbLName = ""
    //                var fbEmail = ""
    //                var fbName  = ""
                    if let id = dict?["id"] as? String{
                        self.fbId = id
                    }
                    if let fname = dict?["first_name"] as? String{
                        self.fbFName = fname
                    }
                    if let lname = dict?["last_name"] as? String{
                        self.fbLName = lname
                    }
                    if let fName = dict?["name"] as? String {
                        self.fbName = fName
                    }
                    if let Email = dict?["email"] as? String{
                        self.fbEmail = Email
                    }
                    var getPhone = ""
                    if let phone = dict?["phone"] as? String {
                        getPhone = phone
                    }
                    //get user picture url from dictionary
    //                if let  fbPickUrl = (((dict?["picture"] as? [String: Any])?["data"] as? [String:Any])?["url"] as? String){
    //                self.downloadImage(with: fbPickUrl) {
    //
    //                }
    //                }
                    print("FB ID: \(self.fbId)\n FB Email:\(self.fbEmail) \n FbFName:\(self.fbName) \n fbLName:\(self.fbLName) \n \(getPhone)")
                    ////CALL API BY LOGIN WITH FB
                 
                    self.callSignup(strFullName:self.fbName,strEmail:self.fbEmail )
                    
                })
            }
        
      /*  if((AccessToken.current) != nil){
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    //everything works print the user data
                    print("Result111:\(String(describing: result)) "as Any)
                }
                let dict = result as? NSDictionary
                print("FB Email1st:\(String(describing: dict))")
//                var fbId = ""
//                var fbFName = ""
//                var fbLName = ""
//                var fbEmail = ""
//                var fbName  = ""
                if let id = dict?["id"] as? String{
                    self.fbId = id
                }
                if let fname = dict?["first_name"] as? String{
                    self.fbFName = fname
                }
                if let lname = dict?["last_name"] as? String{
                    self.fbLName = lname
                }
                if let fName = dict?["name"] as? String {
                    self.fbName = fName
                }
                if let Email = dict?["email"] as? String{
                    self.fbEmail = Email
                }
                var getPhone = ""
                if let phone = dict?["phone"] as? String {
                    getPhone = phone
                }
                //get user picture url from dictionary
//                if let  fbPickUrl = (((dict?["picture"] as? [String: Any])?["data"] as? [String:Any])?["url"] as? String){
//                self.downloadImage(with: fbPickUrl) {
//
//                }
//                }
                print("FB ID: \(self.fbId)\n FB Email:\(self.fbEmail) \n FbFName:\(self.fbFName) \n fbLName:\(self.fbLName) \n \(getPhone)")
                ////CALL API BY LOGIN WITH FB
             
                self.callSignup(strFullName:self.fbFName,strEmail:self.fbEmail )
                
            })
            
        } */
        
    }
    
    func callSignup(strFullName:String,strEmail:String ) {
        DispatchQueue.main.async {
            showActivityIndicator(viewController: self)
        }
        viewModelLogin?.callSignup(fullName: strFullName, email: strEmail,  completion: {(result) in
            DispatchQueue.main.async {
            switch result {
           
            case .success(let result):
                hideActivityIndicator()
                if let success = result as? Bool , success == true {
                  
                    let homeVC = HomeVC(nibName: "HomeVC", bundle: nil)
                    self.navigationController?.pushViewController(homeVC, animated: true)
                    }
                    
              
            case .failure(let error):
                hideActivityIndicator()
                self.showAlertWith(message: error.localizedDescription)
                
            }
            }
        })
        

    }
}
