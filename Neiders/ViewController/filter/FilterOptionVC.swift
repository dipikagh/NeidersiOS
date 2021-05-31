//
//  FilterOptionVC.swift
//  Neiders
//
//  Created by DIPIKA GHOSH on 30/04/21.
//

import UIKit

class FilterOptionVC: UIViewController,AlertDisplayer {

    @IBOutlet weak var tableFilter: UITableView!
   
    @IBOutlet weak var lblFilter: UILabel!
    
    @IBOutlet weak var viewShadow: UIView!
   
    @IBOutlet weak var btnApply: UIButton!
    var viewModelFilter: FilterViewModel?
    var setindexOrganization = Set<Int>()
    var setindexContentType = Set<Int>()
    var setindexLanguage = Set<Int>()
    var setindexOrganizationStr = Set<String>()
    var setindexContentTypeStr = Set<String>()
    var setindexLanguagestr = Set<String>()
    var strOrganizationName:String = ""
    var strLanguage:String = ""
    var strContentType:String = ""
 
    override func viewDidLoad() {
        super.viewDidLoad()
       
        viewModelFilter = FilterViewModel()
        tableFilter.delegate = self
        tableFilter.dataSource = self
        tableFilter.register(FilterCell.self)
        viewShadow.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.gray, radius: 3.0, opacity: 0.6)
        callContentList()
        lblFilter.text = "Filter".localized()
        btnApply.setTitle("APPLY".localized(), for: .normal)
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
    
    
    func callContentList(){
        DispatchQueue.main.async {
            showActivityIndicator(viewController: self)
        }
        viewModelFilter?.callContentList(completion: {(result) in
            DispatchQueue.main.async {
            switch result{
            case .success(let result):
//            DispatchQueue.main.async {
                
                hideActivityIndicator()
                if let success = result as? Bool , success == true {
                    self.tableFilter.reloadData()
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
    }
    func callFilterList(){
        strOrganizationName = setindexOrganizationStr.joined(separator: "")
        strContentType = setindexContentTypeStr.joined(separator: "")
        strLanguage = setindexLanguagestr.joined(separator: "")
       // strOrganizationName = setindexOrganizationStr.
        print("\(strOrganizationName) \(strContentType) \(strLanguage)")
        
        DispatchQueue.main.async {
            showActivityIndicator(viewController: self)
        }
        viewModelFilter?.callFilteredContentList(organizationName: strOrganizationName, contentType: strContentType, language: strLanguage, completion: {(result) in
            DispatchQueue.main.async {
            switch result{
            case .success(let result):
//            DispatchQueue.main.async {
                
                hideActivityIndicator()
                if let success = result as? Bool , success == true {
                    _ = self.navigationController?.popViewController(animated: true)
                            let previousViewController = self.navigationController?.viewControllers.last as? HomeVC
                    previousViewController?.viewModelHome?.arrayContentList = self.viewModelFilter?.arrayContentList ?? []
                    previousViewController?.isFromFilter = true
                   
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
    }
    
    @IBAction func btnBack(_ sender: Any) {
       // self.navigationController?.popViewController(animated: true)
        _ = self.navigationController?.popViewController(animated: true)
                let previousViewController = self.navigationController?.viewControllers.last as? HomeVC
//        previousViewController?.viewModelHome?.arrayContentList = self.viewModelFilter?.arrayContentList ?? []
        previousViewController?.isFromFilter = false
    }
    
    @IBAction func btnApply(_ sender: Any) {
      //  self.navigationController?.popViewController(animated: true)
        callFilterList()
       
        
    }
    

    

}
extension FilterOptionVC:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerHeading = UILabel(frame: CGRect(x: 15, y: 10, width: self.view.frame.width, height: 40))
        let imageView = UIImageView(frame: CGRect(x: self.view.frame.width - 30, y: 20, width: 20, height: 20))
        imageView.tintColor = UIColor(named: "CustomYellow")

        if (viewModelFilter?.items[section].collapsed == true){
            imageView.image = UIImage(named: "remove")
        }else{
            imageView.image = UIImage(named: "plus")
        }
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60))
        let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(headerViewTapped))
        tapGuesture.numberOfTapsRequired = 1
        headerView.addGestureRecognizer(tapGuesture)
       // headerView.backgroundColor = UIColor.red
        headerView.tag = section
        headerHeading.text = viewModelFilter?.items[section].name
        headerHeading.textColor = .black
        
        headerView.addSubview(headerHeading)
        headerView.addSubview(imageView)
        return headerView
     }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModelFilter?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let itms = viewModelFilter?.items[section]
        return !(itms?.collapsed ?? true) ? 0 : itms?.items.count ?? 0
    }

    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:  String(describing: FilterCell.self), for: indexPath) as! FilterCell
        cell.lblFilterOption.text = viewModelFilter?.items[indexPath.section].items[indexPath.row]
        if (indexPath.section == 0){
        if (setindexOrganization.contains(indexPath.row)) {
            cell.imgSelectOption.image = UIImage(named: "active_radio_btn")
        }else {
            cell.imgSelectOption.image = UIImage(named: "inactive_radio_btn")
        }
        }
        else if (indexPath.section == 1){
        if (setindexContentType.contains(indexPath.row)) {
            cell.imgSelectOption.image = UIImage(named: "active_radio_btn")
        }else {
            cell.imgSelectOption.image = UIImage(named: "inactive_radio_btn")
        }
        }else {
            if (setindexLanguage.contains(indexPath.row)) {
                cell.imgSelectOption.image = UIImage(named: "active_radio_btn")
            }else {
                cell.imgSelectOption.image = UIImage(named: "inactive_radio_btn")
            }
        }
       
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 0){
            if (setindexOrganization.count == 0){
                setindexOrganization.insert(indexPath.row)
                setindexOrganizationStr.insert(viewModelFilter?.items[0].items[indexPath.row] ?? "")
            }
           else if setindexOrganization.count == 1 {
          
           // setindexOrganization.insert(indexPath.row)
           if setindexOrganization.contains(indexPath.row) {
           
            setindexOrganization.removeAll()
            setindexOrganizationStr.remove(viewModelFilter?.items[0].items[indexPath.row] ?? "")
        }else {
            setindexOrganization.removeAll()
            setindexOrganizationStr.removeAll()
            setindexOrganization.insert(indexPath.row)
            setindexOrganizationStr.insert(viewModelFilter?.items[0].items[indexPath.row] ?? "")
            //arrFilterValue[0].append(viewModelFilter?.items[0].items[indexPath.row] ?? "")
            
        }
            }
            else {
//                setindexOrganization.removeAll()
//                setindexOrganization.insert(indexPath.row)
            }
        }else if (indexPath.section == 1){
            if (setindexContentType.count == 0){
                setindexContentType.insert(indexPath.row)
                setindexContentTypeStr.insert(viewModelFilter?.items[1].items[indexPath.row] ?? "")
            }else if (setindexContentType.count == 1){
            if setindexContentType.contains(indexPath.row) {
               
                setindexContentType.removeAll()
                setindexContentTypeStr.remove(viewModelFilter?.items[1].items[indexPath.row] ?? "")
            }else {
                setindexContentType.removeAll()
                setindexContentTypeStr.removeAll()
                setindexContentType.insert(indexPath.row)
                setindexContentTypeStr.insert(viewModelFilter?.items[1].items[indexPath.row] ?? "")
            }
            }
        }else{
            if (setindexLanguage.count == 0){
                setindexLanguage.insert(indexPath.row)
                setindexLanguagestr.insert(viewModelFilter?.items[2].items[indexPath.row] ?? "")
            }else {
            if setindexLanguage.contains(indexPath.row) {
               
                setindexLanguage.removeAll()
                setindexLanguagestr.remove(viewModelFilter?.items[2].items[indexPath.row] ?? "")
            }else {
                setindexLanguage.removeAll()
                setindexLanguagestr.removeAll()
                setindexLanguage.insert(indexPath.row)
                setindexLanguagestr.insert(viewModelFilter?.items[2].items[indexPath.row] ?? "")
            }
            }
        }
        tableFilter.reloadData()
    }
    @objc func headerViewTapped(tapped:UITapGestureRecognizer){
        print(tapped.view?.tag ?? 0)
        if viewModelFilter?.items[tapped.view!.tag].collapsed == true{
            viewModelFilter?.items[tapped.view!.tag].collapsed = false
        }else{
            viewModelFilter?.items[tapped.view!.tag].collapsed = true
        }
        if let imView = tapped.view?.subviews[1] as? UIImageView{
            if imView.isKind(of: UIImageView.self){
                if (viewModelFilter?.items[tapped.view!.tag].collapsed == true){
                    imView.image = UIImage(named: "collapsed")
                }else{
                    imView.image = UIImage(named: "expand")
                }
            }
        }
        tableFilter.reloadData()
    }

    
    
}
