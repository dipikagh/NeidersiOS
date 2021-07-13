//
//  EditPasswordVC.swift
//  Neiders
//
//  Created by DIPIKA GHOSH on 22/04/21.
//

import UIKit
import Amplify
import AmplifyPlugins
import AWSPluginsCore


class EditPasswordVC: UIViewController,UITextFieldDelegate,AlertDisplayer {
    
    @IBOutlet weak var tableviewEditPassword: UITableView!
    var arrayInputField = [["Old Password".localized(),"password_icon"], ["New Password".localized(),"password_icon"],["Confirm New Password".localized(),"password_icon"]]
    var Userd = Users()
    var viewModelEditPassword:EditPasswordViewModel?
    var iconClick = true
    var activityView: UIActivityIndicatorView?
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModelEditPassword = EditPasswordViewModel()
        tableviewEditPassword.delegate = self
        tableviewEditPassword.dataSource = self
        tableviewEditPassword.register(InputTableViewCell.self)
        tableviewEditPassword.register(SubmitTableViewCell.self)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let lang = UserDefaults.standard.value(forKey: "LANG") {
            if lang as? String == "ENG" {
                Bundle.setLanguage("en")
            }else if lang as? String == "ES" {
                Bundle.setLanguage("es")
            }else {
                Bundle.setLanguage("fr")
            }
            
        }
        
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        
        _ = self.navigationController?.popViewController(animated: true)
        let previousViewController = self.navigationController?.viewControllers.last as? HomeVC
        previousViewController?.isFromFilter = false
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    
}
extension EditPasswordVC:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0){
            return arrayInputField.count
        }else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier:  String(describing: InputTableViewCell.self), for: indexPath) as! InputTableViewCell
            cell.textInputType.placeholder = arrayInputField[indexPath.row][0]
            cell.imageInputType.image = UIImage(named: arrayInputField[indexPath.row][1])
            cell.textInputType.isSecureTextEntry = true
            cell.textInputType.delegate = self
            cell.textInputType.tag = indexPath.row
            cell.textInputType.addTarget(self, action: #selector(textInputValue(_:)), for: .editingChanged)
            cell.btnShowPassword.addTarget(self, action: #selector(showHidePassword(_:)), for: .touchUpInside)
            cell.btnShowPassword.tag = indexPath.row
            cell.textInputType.text = viewModelEditPassword?.arrayContainer[indexPath.row]
            if (indexPath.row == 1){
                cell.lblPasswordDeclaration.text = "Password should be of min 8 characters including upper string,lower string,alphanumeric and special symbols".localized()
            }else {
                cell.lblPasswordDeclaration.text = ""
            }
            
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier:  String(describing: SubmitTableViewCell.self), for: indexPath) as! SubmitTableViewCell
            cell.btnSubmit.setTitle("Save".localized(), for: .normal)
            cell.btnSubmit.addTarget(self, action: #selector(btnSubmitClick(_:)), for: .touchUpInside)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: switch indexPath.row {
            case 0: return 75
            case 1: return 90
            case 2: return 75
        default:
            return 0
        }
        case 1: return 90
            
        default:
            return 0
        }
        
    }
    @objc func btnSubmitClick(_ sender:UIButton){
        callEditPasswordApi()
       
    }
    
    @objc func textInputValue(_ textfield:UITextField) {
        viewModelEditPassword?.arrayContainer[textfield.tag] = textfield.text!
        print(viewModelEditPassword?.arrayContainer as Any)
    }
    
    @objc func showHidePassword(_ sender:UIButton){
        let cell = tableviewEditPassword.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! InputTableViewCell
        if(iconClick == true) {
            
            cell.textInputType.isSecureTextEntry = false
            cell.btnShowPassword.setImage(UIImage(named: "invisible"), for: .normal)
        } else {
            cell.textInputType.isSecureTextEntry = true
            cell.btnShowPassword.setImage(UIImage(named: "view"), for: .normal)
        }
        
        iconClick = !iconClick
        // tableviewEditPassword.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .none)
        // tab
        
    }
    
    
    func updateNewPassword(){
        
        let Id = UserDefaults.standard.value(forKey: "ID") as? String ?? ""
        print(Id)
        if viewModelEditPassword?.arrayContainer[0] == "" {
            showAlertWith(message: "Old Password field can not be blank".localized())
            
        }else if !(viewModelEditPassword?.arrayContainer[0].isValidPassword() ?? false) {
            showAlertWith(message: "Password should be of min 8 characters including upper string,lower string,alphanumeric and special symbols".localized())
            
        }
        else if viewModelEditPassword?.arrayContainer[1] == ""{
            showAlertWith(message:"New Password field can not be blank".localized())
            
        }else if !(viewModelEditPassword?.arrayContainer[1].isValidPassword() ?? false) {
            showAlertWith(message:"Password should be of min 8 characters including upper string,lower string,alphanumeric and special symbols".localized())
        }
        else if viewModelEditPassword?.arrayContainer[2] == "" {
            showAlertWith(message:"Confirm New Password field can not be blank".localized())
        }
        else if viewModelEditPassword?.arrayContainer[2] != viewModelEditPassword?.arrayContainer[1] {
            showAlertWith(message:"New password and confirm new password field does not match".localized())
        }
        else {
            DispatchQueue.main.async {
                showActivityIndicator(viewController: self)
            }
            Amplify.API.query(request: .get(Users.self, byId: Id))
            { event in
                switch event {
                case .success(let result):
                    switch result {
                    case .success(var user):
                        DispatchQueue.main.async {
                            
                            print("retrieved the user of description \(user as Any)")
                            if (user?.password == self.viewModelEditPassword?.arrayContainer[0]){
                                user?.password = self.viewModelEditPassword?.arrayContainer[1]
                                print( user?.password as Any)
                                
                                let updatedTodo = user
                                
                                
                                Amplify.DataStore.save(updatedTodo!) { result in
                                    switch result {
                                    case .success(let savedTodo):
                                        
                                        print("Updated item: \(savedTodo as Any )")
                                        hideActivityIndicator(viewController: self)
                                        
                                        let alertOkAction = UIAlertAction(title: "OK", style: .default) { (_) in
                                            
                                            _ = self.navigationController?.popViewController(animated: true)
                                            let previousViewController = self.navigationController?.viewControllers.last as? HomeVC
                                            
                                            previousViewController?.isFromFilter = false
                                            
                                            
                                        }
                                        
                                        self.showAlertWith(message: "You have changed your password successfully".localized(), type: .custom(actions: [alertOkAction]))
                                    case .failure(let error):
                                        // completion(.success(false))
                                        print("Could not update data with error: \(error)")
                                    }
                                }
                                
                            }else {
                                DispatchQueue.main.async {
                                    hideActivityIndicator(viewController: self)
                                }
                                self.showAlertWith(message:"Old Passsword is incorrect".localized())
                            }
                        }
                        
                        
                    case .failure(let error):
                        self.showAlertWith(message:"Some thing went wrong. Please try again later".localized())
                        print("Got failed result with \(error.errorDescription)")
                        DispatchQueue.main.async {
                            hideActivityIndicator(viewController: self)
                        }
                    }
                case .failure(let error):
                    self.showAlertWith(message:"Some thing went wrong. Please try again later".localized())
                    DispatchQueue.main.async {
                        hideActivityIndicator(viewController: self)
                    }
                    print("Got failed event with error \(error)")
                }
            }
        }
        
        
        
        
    }
    
    

    
    func callEditPasswordApi(){
        
        DispatchQueue.main.async {
            showActivityIndicator(viewController: self)

        }
        viewModelEditPassword?.UPdate(completion: { (result) in
           
                switch result{
                case .success(let result):
                           //     DispatchQueue.main.async {
                    
                   let delay = 15
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {
//                        self.activityView?.stopAnimating()
//                        self.activityView?.isHidden = true
                        hideActivityIndicator(viewController: self)
                        if let success = result as? Bool , success == true {
                            let alertOkAction = UIAlertAction(title: "OK", style: .default) { (_) in
                                self.navigationController?.popViewController(animated: true)
                                
                            }
                            
                            self.showAlertWith(message: "You have changed your password successfully".localized(), type: .custom(actions: [alertOkAction]))
                        }else {
                            self.showAlertWith(message: "Some thing went wrong. Please try again later".localized())
                        }
                    // }
                    }
                   
                case .failure(let error):
                    DispatchQueue.main.async {
                        hideActivityIndicator(viewController: self)
                    }
                    self.showAlertWith(message: error.localizedDescription)
                }
            
            
            
        })
        // self.navigationController?.popViewController(animated: true)
    }
    
    
   
    

    
    func toggleComplete(_ todo: Users) {
        let updatedTodo = todo
        // AppSyncRealTimeClient._version = 1
        
        // updatedTodo.completed.toggle()
        
        Amplify.DataStore.save(updatedTodo) { result in
            switch result {
            case .success(let savedTodo):
                print("Updated item: \(savedTodo as Any )")
                
            case .failure(let error):
                print("Could not update data with error: \(error)")
            }
        }
        
        
    }
    

    
    
}

