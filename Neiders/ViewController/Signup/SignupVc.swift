//
//  SignupVc.swift
//  Neiders
//
//  Created by DIPIKA GHOSH on 20/04/21.
//

import UIKit
import AmplifyPlugins
import Amplify



class SignupVc: UIViewController,AlertDisplayer {
    
    @IBOutlet weak var tableSignup: UITableView!
    private var activeTextField:UITextField!
    
    
    var viewModelSignup: SignupViewModel?
    var iconClick = true
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModelSignup = SignupViewModel()
        tableSignup.delegate = self
        tableSignup.dataSource = self
        tableSignup.register(InputTableViewCell.self)
        tableSignup.register(UserTypeTableCell.self)
        tableSignup.register(SubmitTableViewCell.self)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        // activeTextField.delegate = self
        
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
        
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification:Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size {
            
            if activeTextField != nil {
                // UIScreen.main.nativeBounds.height <= 1334
                if activeTextField.tag == 3 {
                    moveView(keyboardSize:keyboardSize)
                }
            }
        }
    }
    
    @objc private func keyboardWillHide(_ notification:Notification) {
        
        if let _ = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size {
            tableSignup.setContentInsetAndScrollIndicatorInsets(to: 0)
        }
    }
    
    private func moveView(keyboardSize:CGSize) {
        if let cellView = activeTextField.superview?.superview {
            let rect = tableSignup.convert(activeTextField.bounds, from: activeTextField)
            
            let bottomPadding = UIApplication.key?.safeAreaInsets.bottom ?? 0.0
            let keyboardHeight = keyboardSize.height - (AppConstant.defaultToolbarHeight + bottomPadding)
            
            
            if rect.origin.y + cellView.frame.height >= keyboardHeight {
                tableSignup.setContentInsetAndScrollIndicatorInsets(to: keyboardHeight)
            }else {
                tableSignup.setContentInsetAndScrollIndicatorInsets(to: 80)
            }
        }
        
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func callSignup() {
        DispatchQueue.main.async {
            showActivityIndicator(viewController: self)
        }
        viewModelSignup?.callSignup(fullName: viewModelSignup?.arrayContainer[0] ?? "", email: viewModelSignup?.arrayContainer[1] ?? "", phone: viewModelSignup?.arrayContainer[3] ?? "", password: viewModelSignup?.arrayContainer[2] ?? "", loginType: viewModelSignup?.arrayContainer[4] ?? "", completion: {(result) in
            DispatchQueue.main.async {
                switch result {
                
                case .success(let result):
                    hideActivityIndicator(viewController: self)
                    if let success = result as? Users , success.phone != "" {
                        print(success.phone as Any)
                        let alertOkAction = UIAlertAction(title: "OK", style: .default) { (_) in
                            
                            let forgotpassVC = ForgotPasswordVC(nibName: "ForgotPasswordVC", bundle: nil)
                            forgotpassVC.phoneNumber = success.phone ?? ""
                            forgotpassVC.isComingFromloginVC = false
                            self.navigationController?.pushViewController(forgotpassVC, animated: true)
                        }
                        self.showAlertWith(message: "Sign up successful".localized(), type: .custom(actions: [alertOkAction]))
                        
                    }
                    
                    
                case .failure(let error):
                    hideActivityIndicator(viewController: self)
                    self.showAlertWith(message: error.localizedDescription)
                    
                }
            }
        })
    }
    
    
    
}
extension SignupVc:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0){
            return viewModelSignup?.arrayInputField.count ?? 0
        }else if (section == 1){
            return 1
        }else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier:  String(describing: InputTableViewCell.self), for: indexPath) as! InputTableViewCell
            cell.textInputType.tag = indexPath.row
            cell.textInputType.placeholder = viewModelSignup?.arrayInputField[indexPath.row][0]
            cell.imageInputType.image = UIImage(named: viewModelSignup?.arrayInputField[indexPath.row][1] ?? "")
            cell.btnShowPassword.isHidden = true
            if (cell.textInputType.tag == 2) {
                
                cell.textInputType.isSecureTextEntry = true
                cell.textInputType.keyboardType = .default
                cell.textInputType.textContentType = .oneTimeCode
                cell.btnShowPassword.isHidden = false
                cell.btnShowPassword.addTarget(self, action: #selector(showHidePassword(_:)), for: .touchUpInside)
                cell.btnShowPassword.tag = indexPath.row
                cell.lblPasswordDeclaration.text = "Password should be of min 8 characters including upper string,lower string,alphanumeric and special symbols".localized()
            }else if (cell.textInputType.tag == 3){
                cell.textInputType.isSecureTextEntry = false
                cell.textInputType.keyboardType = .phonePad
                cell.lblPasswordDeclaration.text = ""
            }else {
                cell.textInputType.isSecureTextEntry = false
                cell.textInputType.keyboardType = .emailAddress
                cell.lblPasswordDeclaration.text = ""
            }
            
            cell.textInputType.delegate = self
            cell.textInputType.autocorrectionType = .no
            cell.textInputType.addToolBar(self, selector: #selector(donePressed))
            cell.textInputType.addTarget(self, action: #selector(textInputValue(_:)), for: .editingChanged)
            
            return cell
        }else if (indexPath.section == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier:  String(describing: UserTypeTableCell.self), for: indexPath) as! UserTypeTableCell
            cell.btnStudent.addTarget(self, action: #selector(btnStudentClicked(_:)), for: .touchUpInside)
            cell.btnTeacher.addTarget(self, action: #selector(btnTeacherClicked(_:)), for: .touchUpInside)
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier:  String(describing: SubmitTableViewCell.self), for: indexPath) as! SubmitTableViewCell
            cell.btnSubmit.addTarget(self, action: #selector(btnSubmitClick(_:)), for: .touchUpInside)
            cell.btnSubmit.setTitle("Sign up".localized(), for: .normal)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:  switch indexPath.row {
        case 0: return 75
        case 1: return 75
        case 2: return 90
        case 3: return 75
        default:
            return 0
        }
        
        case 1: return 100
        case 2: return 90
        default:
            return 0
        }
        
    }
    @objc private func donePressed() {
        self.view.endEditing(true)
        activeTextField?.resignFirstResponder()
    }
    
    @objc func onDoneButtonTapped() {
        toolbar.removeFromSuperview()
    }
    @objc func btnStudentClicked(_ sender: UIButton){
        viewModelSignup?.arrayContainer[4] = "Student"
        let cell = tableSignup.cellForRow(at: IndexPath(row: 0, section: 1)) as? UserTypeTableCell
        cell?.imageStudent.image = UIImage(named: "active_radio_btn")
        cell?.imageViewTeacher.image = UIImage(named: "inactive_radio_btn")
    }
    @objc func btnTeacherClicked(_ sender: UIButton){
        let cell = tableSignup.cellForRow(at: IndexPath(row: 0, section: 1)) as? UserTypeTableCell
        cell?.imageStudent.image = UIImage(named: "inactive_radio_btn")
        cell?.imageViewTeacher.image = UIImage(named: "active_radio_btn")
        viewModelSignup?.arrayContainer[4] = "Teacher"
    }
    @objc func textInputValue(_ textfield:UITextField) {
        viewModelSignup?.arrayContainer[textfield.tag] = textfield.text!
    }
    
    @objc func btnSubmitClick(_ sender:UIButton){
        callSignup()
        
    }
    
    @objc func showHidePassword(_ sender:UIButton){
        let cell = tableSignup.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! InputTableViewCell
        if(iconClick == true) {
            
            cell.textInputType.isSecureTextEntry = false
            cell.btnShowPassword.setImage(UIImage(named: "invisible"), for: .normal)
        } else {
            cell.textInputType.isSecureTextEntry = true
            cell.btnShowPassword.setImage(UIImage(named: "view"), for: .normal)
        }
        
        iconClick = !iconClick
        
        
    }
}
extension SignupVc: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        
        return true
    }
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        activeTextField = nil
        toolbar.removeFromSuperview()
        
        
    }
}
