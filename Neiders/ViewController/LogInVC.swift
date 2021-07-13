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
import AuthenticationServices
import JWTDecode


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
    
    @IBOutlet weak var stackViewAppleLogin: UIStackView!
    
    
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
        
        textInputEmail.delegate = self
        textInputPassword.delegate = self
        viewModelLogin = loginViewModel()
        textInputEmail.tag = 0
        textInputPassword.tag = 1
        textInputEmail.addTarget(self, action: #selector(textInputValue(_:)), for: .editingChanged)
        textInputPassword.addTarget(self, action: #selector(textInputValue(_:)), for: .editingChanged)
        setupProviderLoginView()
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textInputEmail.text = ""
        textInputPassword.text = ""
        if let lang = UserDefaults.standard.value(forKey: "LANG") {
            if lang as? String == "ENG" {
                Bundle.setLanguage("en")
            }else if lang as? String == "ES" {
                Bundle.setLanguage("es")
            }else {
                Bundle.setLanguage("fr")
            }
            
        }
        
        arrCointainer = ["",""]
        setLanguage()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       // performExistingAccountSetupFlows()
    }
    
    func setupProviderLoginView() {
        let authorizationButton = ASAuthorizationAppleIDButton()
        authorizationButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
        self.stackViewAppleLogin.addArrangedSubview(authorizationButton)
    }
    func setLanguage() {
        buttonSignup.setTitle("Sign up".localized(), for: .normal)
        textInputEmail.placeholder = "User Name".localized()
        textInputPassword.placeholder = "Password".localized()
        buttonLogin.setTitle("Login".localized(), for: .normal)
        buttonLoginWithFb.setTitle("Log in with Facebook".localized(), for: .normal)
        
        let stringFP = "Forgot Password".localized()
        if let lang = UserDefaults.standard.value(forKey: "LANG") {
            if lang as? String == "ES" {
                let forgotPAssAttribute: [NSAttributedString.Key : Any] = [
                    NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
                    NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 12),
                    NSAttributedString.Key.foregroundColor: UIColor(named: "CustomYellow")!]
                
                let attributedString = NSAttributedString(string: stringFP, attributes: forgotPAssAttribute)
                btnForgotPAssword.setAttributedTitle(attributedString, for: .normal)
                
                let str = "Don't have an Account? Create an Account".localized()
                
                
                var myMutableString = NSMutableAttributedString()
        
                myMutableString = NSMutableAttributedString(string: str)
        
                myMutableString.setAttributes([ NSAttributedString.Key.foregroundColor : UIColor(red: 6 / 255.0, green: 68 / 255.0, blue: 108 / 255.0, alpha: 1.0)], range: NSRange(location:23,length:16)) // What ever range you want to give
        
                lblSignup.attributedText = myMutableString
                
            }else {
                let forgotPAssAttribute: [NSAttributedString.Key : Any] = [
                    NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
                    NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 14),
                    NSAttributedString.Key.foregroundColor: UIColor(named: "CustomYellow")!]
                
                let attributedString = NSAttributedString(string: stringFP, attributes: forgotPAssAttribute)
                btnForgotPAssword.setAttributedTitle(attributedString, for: .normal)
                
                let str = "Don't have an Account? Create an Account".localized()
                
                
                var myMutableString = NSMutableAttributedString()
        
                myMutableString = NSMutableAttributedString(string: str)
        
                myMutableString.setAttributes([ NSAttributedString.Key.foregroundColor : UIColor(red: 6 / 255.0, green: 68 / 255.0, blue: 108 / 255.0, alpha: 1.0)], range: NSRange(location:27,length:15)) // What ever range you want to give
        
                lblSignup.attributedText = myMutableString
            }
            
        }
           
//        let forgotPAssAttribute: [NSAttributedString.Key : Any] = [
//            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
//            NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 14),
//            NSAttributedString.Key.foregroundColor: UIColor(named: "CustomYellow")!]
//
//        let attributedString = NSAttributedString(string: stringFP, attributes: forgotPAssAttribute)
//        btnForgotPAssword.setAttributedTitle(attributedString, for: .normal)
        //let str = "Don't have an Account? Create an Account".localized()
        
        
//        var myMutableString = NSMutableAttributedString()
//        
//        myMutableString = NSMutableAttributedString(string: str)
//        
//        myMutableString.setAttributes([ NSAttributedString.Key.foregroundColor : UIColor(red: 6 / 255.0, green: 68 / 255.0, blue: 108 / 255.0, alpha: 1.0)], range: NSRange(location:27,length:15)) // What ever range you want to give
//        
//        lblSignup.attributedText = myMutableString
    }
    
    /// - Tag: perform_appleid_request for AppleSignin
    @objc
    func handleAuthorizationAppleIDButtonPress() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    // - Tag: perform_appleid_password_request
    /// Prompts the user if an existing iCloud Keychain credential or Apple ID credential is found.
//    func performExistingAccountSetupFlows() {
//        // Prepare requests for both Apple ID and password providers.
//        let requests = [ASAuthorizationAppleIDProvider().createRequest(),
//                        ASAuthorizationPasswordProvider().createRequest()]
//
//        // Create an authorization controller with the given requests.
//        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
//        authorizationController.delegate = self
//        authorizationController.presentationContextProvider = self
//        authorizationController.performRequests()
//    }
    
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
    
    @IBAction func btnback(_ sender: Any) {
       self.navigationController?.popViewController(animated: true)
       
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
      
    }
    
    @IBAction func btnSkiplogin(_ sender: Any) {
//        let homeVC = HomeVC(nibName: "HomeVC", bundle: nil)
//        self.navigationController?.pushViewController(homeVC, animated: true)
        
    }
    
    
    func callSignin(){
        DispatchQueue.main.async {
            showActivityIndicator(viewController: self)
        }
        viewModelLogin?.callSigninApi(email: arrCointainer[0], password: arrCointainer[1], completion: {(result) in
            DispatchQueue.main.async {
                switch result {
                
                case .success(let result):
                    hideActivityIndicator(viewController: self)
                    
                    if let success = result as? Bool , success == true {
                        
                    
                        
                        if let unitwebVC = UIApplication.getTopMostViewController()?.navigationController?.ifExitsOnStack(vc: UnitWebVC.self) {
                            UIApplication.getTopMostViewController()?.navigationController?.popToViewController(unitwebVC, animated: true)

                        } else {
                            let homeVC = HomeVC(nibName: "HomeVC", bundle: nil)
                            UIApplication.getTopMostViewController()?.navigationController?.pushViewController(homeVC, animated: true)
                        }
                    
                    }
                    
                    
                case .failure(let error):
                    hideActivityIndicator(viewController: self)
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
                    hideActivityIndicator(viewController: self)
                    
                    if let user = result as? Users {
                        
                        let forgotPassVC = ForgotPasswordVC(nibName: "ForgotPasswordVC", bundle: nil)
                        forgotPassVC.isComingFromloginVC = true
                        let countrycode = user.phone?.components(separatedBy: " ")
                        forgotPassVC.phoneNumber = countrycode?[1] ?? ""
                        forgotPassVC.countryCode = countrycode?[0] ?? ""
                       // forgotPassVC.phoneNumber = user.phone ?? ""
                        forgotPassVC.userId = user.id
                        
                        self.navigationController?.pushViewController(forgotPassVC, animated: true)
                    }
                    
                    
                case .failure(let error):
                    hideActivityIndicator(viewController: self)
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
                if (self.fbEmail != "") {
                self.callSignup(strFullName:self.fbName,strEmail:self.fbEmail )
                }
                
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
                    hideActivityIndicator(viewController: self)
                    if let success = result as? Bool , success == true {
                        
                        let homeVC = HomeVC(nibName: "HomeVC", bundle: nil)
                        self.navigationController?.pushViewController(homeVC, animated: true)
                    }
                    
                    
                case .failure(let error):
                    hideActivityIndicator(viewController: self)
                    self.showAlertWith(message: error.localizedDescription)
                    
                }
            }
        })
        
        
    }
}

extension LogInVC: ASAuthorizationControllerDelegate {
    /// - Tag: did_complete_authorization
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:

            // Create an account in your system.
            let userIdentifier = appleIDCredential.user

            print(userIdentifier)
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email ?? ""

            if let identityTokenData = appleIDCredential.identityToken,let identityTokenString = String(data: identityTokenData, encoding: .utf8) {
                print("Identity Token \(identityTokenString)")
                do {
                   let jwt = try decode(jwt: identityTokenString)
                   let decodedBody = jwt.body as Dictionary
                   print(decodedBody)
                   print("Decoded email: "+(decodedBody["email"] as? String ?? "n/a"))
                 let getEmail = (decodedBody["email"] as? String ?? "n/a")
                    let Name = "\(fullName?.givenName ?? "") \(fullName?.familyName ?? "")"
                    print(getEmail, "\(Name)")
                    if (Name != ""){
                        
                        callSignup(strFullName:Name,strEmail:getEmail )
                    }
                } catch {
                   print("decoding failed")
                }

            }

        case let passwordCredential as ASPasswordCredential:

            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password

            // For the purpose of this demo app, show the password credential as an alert.
            DispatchQueue.main.async {
                self.showPasswordCredentialAlert(username: username, password: password)
            }

        default:
            break
        }
    }



    private func showPasswordCredentialAlert(username: String, password: String) {
        let message = "The app has received your selected credential from the keychain. \n\n Username: \(username)\n Password: \(password)"
        let alertController = UIAlertController(title: "Keychain Credential Received",
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

    /// - Tag: did_complete_error
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
    }



    
}
extension LogInVC: ASAuthorizationControllerPresentationContextProviding {
    /// - Tag: provide_presentation_anchor
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
