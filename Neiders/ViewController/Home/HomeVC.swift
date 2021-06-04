//
//  HomeVC.swift
//  Neiders
//
//  Created by DIPIKA GHOSH on 23/04/21.
//

import UIKit
import Kingfisher

class HomeVC: UIViewController,AlertDisplayer {

    @IBOutlet weak var collectionViewCourse: UICollectionView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var btnMenu: UIButton!
    
    @IBOutlet weak var shadowSearchView: UIView!
    
    @IBOutlet weak var viewFilter: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    
    @IBOutlet weak var textSearchHere: UITextField!
    @IBOutlet weak var lblFilter: UILabel!
    
    var searchItem = ""
    
    var viewModelHome:HomeViewModel?
    var isFromFilter:Bool? = false
    
    var arrCouseDetails = [["ENVIRONMENT","box1"],["SCIENCE & TECHNOLOGY","box2"],["POLITY","box3"],["PHYSICAL GEOGRAPHY","box4"],["MODERN HISTORY","box5"],["COMPUTER SCIENCE","box6"]]
    
    func setupUI(){
    
        viewHeader.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.gray, radius: 3.0, opacity: 0.6)
        viewFilter.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.gray, radius: 3.0, opacity: 0.6)
        shadowSearchView.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.gray, radius: 3.0, opacity: 0.6)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        txtSearch.delegate = self
        collectionViewCourse.delegate = self
        collectionViewCourse.dataSource = self
        collectionViewCourse.register(CourseCollectionCell.self)
        setupUI()
        SidePanelViewController.default.delegate = self
        SidePanelViewController.default.isloggedin = true
        viewModelHome = HomeViewModel()
        callContentList()
        txtSearch.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)
        
  }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
     
//            if let lang = UserDefaults.standard.value(forKey: "LANG") {
//                if lang as? String == "ENG" {
//                    Bundle.setLanguage("en")
//                }else {
//                    Bundle.setLanguage("fr")
//                }
//            }
        languageSet()
        if (isFromFilter == true){
            if  self.viewModelHome?.arrayContentList.count == 0{
                self.showAlertWith(message: "No data found".localized())
            }
            collectionViewCourse.reloadData()
        }else {
            self.viewModelHome?.arrayContentList = viewModelHome?.dataService ?? []
           // callContentList()
        }
        collectionViewCourse.reloadData()
      
        
    }
    func languageSet () {
        if let lang = UserDefaults.standard.value(forKey: "LANG") {
            if lang as? String == "ENG" {
                Bundle.setLanguage("en")
            }else {
                Bundle.setLanguage("fr")
            }
        }
        lblFilter.text = "Filter".localized()
        textSearchHere.placeholder = "Search here".localized()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func callContentList(){
        DispatchQueue.main.async {
            showActivityIndicator(viewController: self)
        }
        viewModelHome?.callContentList(completion: {(result) in
            DispatchQueue.main.async {
            switch result{
            case .success(let result):
//            DispatchQueue.main.async {
                
                hideActivityIndicator()
                if let success = result as? Bool , success == true {
                self.collectionViewCourse.reloadData()
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

    @IBAction func btnMenu(_ sender: UIButton) {
        
        if sender.isSelected {
            SidePanelViewController.default.hide()
            sender.isSelected = false
        }
        else {
            SidePanelViewController.default.show(on: self)
            sender.isSelected = true
        }
    }
    
    @IBAction func btnFilter(_ sender: Any) {
        let signupVC = FilterOptionVC(nibName: "FilterOptionVC", bundle: nil)
        self.navigationController?.pushViewController(signupVC, animated: true)
    }
}

extension HomeVC:SidePanelDelegate {
    func showLanguagePopUP(status: Bool) {
        if status == true {
            let VC = LanguageVC(nibName: "LanguageVC", bundle: nil)
            VC.modalPresentationStyle = .overCurrentContext
            VC.delegate = self
           self.navigationController?.present(VC, animated: true, completion: nil)
        }
    }
    
    
    func didDisplayMenu(status: Bool) {
        if status == false {
            btnMenu.isSelected = false
        }
    }
    
  
    
    
}

extension HomeVC:LanguageSelectProtocol {
    func setLanguageHome() {
        languageSet()
    }
    
    
}

extension HomeVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModelHome?.arrayContentList.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionViewCourse.frame.width - 10)/2, height: (collectionViewCourse.frame.width - 10)/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CourseCollectionCell.self), for: indexPath) as! CourseCollectionCell
        let imgurl = (viewModelHome?.arrayContentList[indexPath.row].content_url ?? "").components(separatedBy: "?")
        _ = URL(string: imgurl[0])
      
        if let imagUrl = URL(string: imgurl[0]){
                   KingfisherManager.shared.retrieveImage(with: imagUrl, options: nil, progressBlock: nil, completionHandler: { image, error, cacheType, imageURL in
                       
                       cell.imageCourse.image = image
                       
                   })
               }
        
         
        cell.lblCourseName.text =  "\(viewModelHome?.arrayContentList[indexPath.row].title ?? "")"
         return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let coursedetailsVC = CourseDetailsVC(nibName: "CourseDetailsVC", bundle: nil)
        coursedetailsVC.courseId = viewModelHome?.arrayContentList[indexPath.row].id ?? ""
        coursedetailsVC.imageUrl = viewModelHome?.arrayContentList[indexPath.row].content_url ?? ""
        coursedetailsVC.courseDetails = "\(viewModelHome?.arrayContentList[indexPath.row].title ?? "") \n\(viewModelHome?.arrayContentList[indexPath.row].subject ?? "")"
        self.navigationController?.pushViewController(coursedetailsVC, animated: true)
    }
}

extension HomeVC:UITextFieldDelegate{
    @objc func textFieldValueChange(_ txt: UITextField)  {
        searchItem = txt.text!

        if (searchItem != ""){

            viewModelHome?.searchLocString = searchItem
            viewModelHome?.getSearchLocation(completion: { (result) in
                switch result {
                case .success(let result):
                    if let success = result as? Bool , success == true {
                        DispatchQueue.main.async {
                           // self.tableSearchLocation.reloadData()
                        }

                    }
                case .failure( _): break


                }
            })

        }else {
            self.viewModelHome?.arrayContentList = viewModelHome?.dataService ?? []

        }
        self.collectionViewCourse.reloadData()
     }
    
}







