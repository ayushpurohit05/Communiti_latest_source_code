//
//  UpDatePostVC.swift
//  Community
//
//  Created by Hatshit on 28/12/17.
//  Copyright © 2017 Hatshit. All rights reserved.
//

import UIKit

class UpDatePostVC: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    
    var ctrObjOfUpdatePost : CountryList!
    var sltSubCat_Id : String!
    var sltSubCatName : String!
    var sltGroup_Id : String!
    var sltGroupName : String!
    var trimmedTittleStr : String!
    var trimmedDescStr : String!
    var addedTags = [Any]() // used to get data from TagVC
    
    @IBOutlet weak var lbl_Count: UILabel!
    @IBOutlet weak var bg_View_H: NSLayoutConstraint!
    @IBOutlet weak var btn_CreatePost: UIButton!
    @IBOutlet weak var btn_addAditionalHTag: UIButton!
    @IBOutlet weak var lbl_tagView: UILabel!
    @IBOutlet weak var tagViewImage: UIImageView!
    @IBOutlet weak var tag_View: UIView!
    @IBOutlet weak var lbl_CateName: UILabel!
    @IBOutlet weak var Container_View: UIView!
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet var text_View : UITextView!
    @IBOutlet weak var lbl_Hashtag1: UILabel!
    @IBOutlet weak var lbl_Hashtag2: UILabel!
    @IBOutlet weak var lbl_Hashtag3: UILabel!
    @IBOutlet weak var lbl_Hashtag4: UILabel!
    @IBOutlet weak var lbl_Hashtag1_W: NSLayoutConstraint!
    @IBOutlet weak var lbl_Hashtag2_W: NSLayoutConstraint!
    @IBOutlet weak var lbl_Hashtag3_W: NSLayoutConstraint!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.setUpOfNavigationBar()
        self.setUpData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(addedTags.count != 0){
                self.lbl_tagView.isHidden = true
                self.tagViewImage.image = UIImage(named: "Acitive_hastag_x")
        }else{
                self.lbl_tagView.isHidden = false
                self.tagViewImage.image = UIImage(named: "hastag_x")
        }
    
        DispatchQueue.main.async {
            self.createTags()
        }
    }
    
    //===========================
    //MARK:- SetUp Method method
    //===========================

    func setUpData(){
        
        if(APP_Delegate().isEditHiveFld){
            self.hideTabBarController()
            btn_CreatePost.setTitle("Update Post", for: .normal)
            textfield.text = ctrObjOfUpdatePost.pst_title ?? "Update post title"
            textfield.textColor = UIColor.black
            lbl_Count.text = String(format: "%d", 100 - (textfield.text?.characters.count)!)
            text_View.text = ctrObjOfUpdatePost.pst_description ?? "Update decription";
            text_View.textColor = UIColor.black
            btn_CreatePost.backgroundColor = UIColor(red: 9/255, green: 196/255, blue: 154/255, alpha: 1)
            btn_CreatePost.isUserInteractionEnabled = true
            lbl_CateName.text =   String(format: "  #%@  ", self.sltGroupName ?? "No group")
        }else{
            self.hideTabBarController()
            btn_CreatePost.setTitle("Update Request", for: .normal)
            textfield.text = ctrObjOfUpdatePost.pst_title ?? ""
            textfield.textColor = UIColor.black
            lbl_Count.text = String(format: "%d", 100 - (textfield.text?.characters.count)!)
            text_View.text = ctrObjOfUpdatePost.pst_description ?? "Request decription";
            text_View.textColor = UIColor.black
            btn_CreatePost.backgroundColor = UIColor(red: 9/255, green: 196/255, blue: 154/255, alpha: 1)
            btn_CreatePost.isUserInteractionEnabled = true
            lbl_CateName.text =   String(format: "  #%@    ", self.sltSubCatName ?? "No category")
        }
    }
    
    
//===========================
//MARK:- Create Tag method
//===========================
    
    func createTags(){
        
        if addedTags.count >= 3 {
            self.lbl_Hashtag1.text =  String(format: "  %@  ",(addedTags[0] as? String)!)
            self.lbl_Hashtag2.text =  String(format: "  %@  ",(addedTags[1] as? String)!)
            self.lbl_Hashtag3.text =  String(format: "  %@  ",(addedTags[2] as? String)!)
            self.lbl_Hashtag4.text =  String(format: "  %@  ",(addedTags[2] as? String)!)
            DispatchQueue.main.async {
                self.manageDesignOftagsFeedCell()
                self.manageTagsSize()
            }
        }else  if addedTags.count >= 2 {
            self.lbl_Hashtag1.text =  String(format: "  %@  ",(addedTags[0] as? String)!)
            self.lbl_Hashtag2.text =  String(format: "  %@  ",(addedTags[1] as? String)!)
            self.lbl_Hashtag3.text =  ""
            self.lbl_Hashtag4.isHidden =  true
            self.manageDesignOftagsFeedCell()
            
        }else  if addedTags.count >= 1 {
            self.lbl_Hashtag1.text =  String(format: "  %@  ",(addedTags[0] as? String)!)
            self.lbl_Hashtag2.text = ""
            self.lbl_Hashtag3.text = ""
            self.lbl_Hashtag4.isHidden =  true
            self.manageDesignOftagsFeedCell()
        }else {
            self.lbl_Hashtag1.text = ""
            self.lbl_Hashtag2.text = ""
            self.lbl_Hashtag3.text = ""
            self.lbl_Hashtag4.isHidden =  true
            
        }
    }
    
    
    func manageTagsSize(){
        
        let lbl_Hashtag1_W = self.lbl_Hashtag1.intrinsicContentSize.width
        let lbl_Hashtag2_W = self.lbl_Hashtag2.intrinsicContentSize.width
        let lbl_Hashtag3_W = self.lbl_Hashtag3.intrinsicContentSize.width
        
        if(self.tag_View.frame.size.width < (lbl_Hashtag1_W + lbl_Hashtag2_W + lbl_Hashtag3_W + (20 + 60))){
            lbl_Hashtag3.isHidden = true
            lbl_Hashtag4.isHidden = false
            
        }else{
            lbl_Hashtag3.isHidden = false
            lbl_Hashtag4.isHidden = true
        }
    }
    
    func manageDesignOftagsFeedCell(){
        self.lbl_Hashtag1.layer.borderColor = UIColor(red: 140/255, green: 140/255, blue: 140/255, alpha: 1).cgColor
        self.lbl_Hashtag2.layer.borderColor = UIColor(red: 140/255, green: 140/255, blue: 140/255, alpha: 1).cgColor
        self.lbl_Hashtag3.layer.borderColor = UIColor(red: 140/255, green: 140/255, blue: 140/255, alpha: 1).cgColor
        self.lbl_Hashtag4.layer.borderColor = UIColor(red: 140/255, green: 140/255, blue: 140/255, alpha: 1).cgColor
        
        
        self.lbl_Hashtag1.textColor = UIColor(red: 140/255, green: 140/255, blue: 150/255, alpha: 1)
        self.lbl_Hashtag2.textColor = UIColor(red: 140/255, green: 140/255, blue: 150/255, alpha: 1)
        self.lbl_Hashtag3.textColor = UIColor(red: 140/255, green: 140/255, blue: 150/255, alpha: 1)
        self.lbl_Hashtag4.textColor = UIColor(red: 140/255, green: 140/255, blue: 150/255, alpha: 1)
        
    }
    
//====================================================================================
//MARK:- add the items in navigation bar and change the back button tittle and color
//====================================================================================
    func setUpOfNavigationBar(){
        
        self.navigationItem.backBarButtonItem?.title = " "
        self.navigationItem.title = APP_Delegate().isEditHiveFld == true ? "UPDATE HIVE POST" : "UPDATE HR POST"
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
    }
    
    func hideTabBarController(){
        
        tabBarController?.tabBar.isHidden = true
        if let arrOfviews = tabBarController?.view.subviews{
        for view in arrOfviews{
            if view.isKind(of: UIButton.self) {
                view.isHidden = true
            }
         }
        }
    }
    
    @IBAction func BtnActionMethod(_ sender: UIButton) {
        
        if(sender.tag == 0){// Update Post
            self.validationMethod()
        }else{// For Tag
            
            self.textfield.resignFirstResponder()
            self.text_View.resignFirstResponder()
            
            let addTagVC  = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddTagCon") as! AddTagVC
            
            addTagVC.arrOfTag = addedTags as! [String]
            addTagVC.isMoveFromFltHomeVC = false
            addTagVC.onHideComplete = {(result : [Any]) -> Void in
                //print(result)
                self.addedTags.removeAll()
                self.addedTags = result
                
            }
            
            self.navigationController?.pushViewController(addTagVC, animated: true)
        }
    }
    
    //========================================================
    //MARK:- Text Field Delegate method
    //========================================================
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        //print("textFieldShouldReturn")
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let maxLength = 100
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        //change the value of the label
        if(newString.length <= maxLength){
            lbl_Count.text =  String(100 - newString.length)
        }
        
        let trimDesc = text_View.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimTittle = textfield.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if(trimDesc != "" && text_View.text != "Update decription" ){
            
            if(newString.length != 0 || trimTittle != ""){
                btn_CreatePost.backgroundColor = UIColor(red: 9/255, green: 196/255, blue: 154/255, alpha: 1)
                btn_CreatePost.isUserInteractionEnabled = true
            }else{
                btn_CreatePost.backgroundColor = UIColor(red: 192/255, green: 238/255, blue: 229/255, alpha: 1)
                btn_CreatePost.isUserInteractionEnabled = false
            }
            
        }else{
            
            btn_CreatePost.backgroundColor = UIColor(red: 192/255, green: 238/255, blue: 229/255, alpha: 1)

            btn_CreatePost.isUserInteractionEnabled = false
        }
        
        return newString.length <= maxLength
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    
    //========================================================
    //MARK:- Text View Delegate method
    //========================================================
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        if(APP_Delegate().isEditHiveFld){
            if (text_View.text == "Update decription")  {
                text_View.text = "";
            }
        }else{
            if text_View.text == "Request decription"  {
                text_View.text = "";
                
            }
        }
        
        text_View.textColor = UIColor.black
        return true;
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if text_View.text.characters.count == 0 {
            text_View.textColor = UIColor.lightGray
            
            if(APP_Delegate().isEditHiveFld){
                text_View.text =  "Update decription"
            }else{
                text_View.text =  "Request decription"
            }
            
            
            textView.resignFirstResponder()
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        
        self.enableAndDissableBtnMethod(range: range, txtString: text, clcFieldTxt: textView.text)
        
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    
    func enableAndDissableBtnMethod(range : NSRange , txtString : String , clcFieldTxt : String ){
        
        let currentString: NSString = clcFieldTxt as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: txtString) as NSString
        
        let trimTittle = textfield.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimDesc = text_View.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        if(trimTittle !=  "" ){
            
            if(trimDesc != "" || newString.length != 0){
                
                
                //btn_CreatePost.alpha = 1.0
                btn_CreatePost.backgroundColor = UIColor(red: 9/255, green: 196/255, blue: 154/255, alpha: 1)

                btn_CreatePost.isUserInteractionEnabled = true
            }else{
                
                btn_CreatePost.backgroundColor = UIColor(red: 192/255, green: 238/255, blue: 229/255, alpha: 1)

                //btn_CreatePost.alpha = 0.5
                btn_CreatePost.isUserInteractionEnabled = false
            }
            
        }else{
            
            btn_CreatePost.backgroundColor = UIColor(red: 192/255, green: 238/255, blue: 229/255, alpha: 1)

            //btn_CreatePost.alpha = 0.5
            btn_CreatePost.isUserInteractionEnabled = false
        }
        
        
    }
    //========================================================
    //MARK:- Text Field Valedation method
    //========================================================
    func validationMethod(){
        
        if(textfield.text?.characters.count != 0 && text_View.text.characters.count != 0){
            
            trimmedTittleStr = textfield.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            trimmedDescStr = text_View.text.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if(trimmedTittleStr != ""){
                if(APP_Delegate().isEditHiveFld){
                    if(trimmedDescStr != ""  &&  text_View.text != "Update decription"){
                        
                        self.updatepostOfHive()
                    }else{
                        ShowAlert(title: "Alert", message: "Please enter some text in description.", controller: self, cancelButton: nil, okButton: "OK", style: .alert, callback: { (isCancel, isOk) in
                        })
                    }
                }else{
                    if(trimmedDescStr != "" && text_View.text != "Request decription"){
                        
                          self.updatepostOfHelp()
                    }else{
                        
                        ShowAlert(title: "Alert", message: "Please enter some text in description.", controller: self, cancelButton: nil, okButton: "OK", style: .alert, callback: { (isCancel, isOk) in
                        })
                    }
                }
            }else{
                ShowAlert(title: "Alert", message: "Please enter some text in tittle.", controller: self, cancelButton: nil, okButton: "OK", style: .alert, callback: { (isCancel, isOk) in
                })
            }
        }else{
            ShowAlert(title: "Alert", message: "Please enter some text in tittle and description.", controller: self, cancelButton: nil, okButton: "OK", style: .alert, callback: { (isCancel, isOk) in
            })
        }
    }

    //========================================================
    //MARK:- Call Service For Edit Post Of Hive
    //========================================================
    /*
     1.usrToken->user token
     2.pstId->post id
     3.ttl->title
     4.dscptn->description
     5.tags->array('sport','demo')
     6.grpId->sub category id
 
     */
    
    func updatepostOfHive( ){
        
        let dict : [String : Any] = ["usrToken" : getUserData()["usr_token"] ?? "",
                                     "pstId" :    ctrObjOfUpdatePost.pst_id ?? "",
                                     "ttl" : trimmedTittleStr,
                                     "dscptn" : trimmedDescStr,
                                     "tags" : addedTags,
                                     "grpId" : sltGroup_Id]
        
        ServerCommunicator(params: dict  , service: Service.editUserHivePost, callBack: { [weak self] (response:Any ,isError:Bool) in
            
            guard let weakSelf = self else { return }
            
            guard !isError , (response as! [String : Any])["success"] as! Bool else {
                killLoader()
                ShowError(message: isError ? "Server issue. Please try again later." : (response as! [String : Any])["message"]  as! String, controller: weakSelf)
                return
            }
            

            let responseModel = Mapper<CountryResponseBody>().map(JSONObject: response)
          //  print("RESPONSE ==",(response as! [String : Any])["data"]!)
            DispatchQueue.main.async {
                weakSelf.ctrObjOfUpdatePost.pst_title = weakSelf.trimmedTittleStr
                weakSelf.ctrObjOfUpdatePost.pst_description = weakSelf.trimmedDescStr
                weakSelf.ctrObjOfUpdatePost.tags?.removeAll()
                weakSelf.ctrObjOfUpdatePost.tags = responseModel?.data?[0].tags
                weakSelf.ctrObjOfUpdatePost.pst_createdate = responseModel?.data?[0].pst_createdate
                weakSelf.ctrObjOfUpdatePost.grp_title = self?.sltGroupName
                weakSelf.navigationController?.popToRootViewController(animated: true)
                APP_Delegate().isEditHiveFld = false
                killLoader()
            }
        })
    }
    
    
    //========================================================
    //MARK:- Call Service For Edit Post Of Help
    //========================================================
    /*
     1.usrToken->user token
     2.pstId->Post id
     3.scatId->sub category id
     4.ttl->title
     5.dscptn->description
     6.helpTyp->help type('Location', 'Virtual')
     7.helpLoc->location name
     8.helpDate->help date
     9.helpLat->latitude
     10.helpLng->longitude
     11.tags->array('a','b')
     */
    
    func updatepostOfHelp( ){
        
        let dict : [String : Any] = ["usrToken" : getUserData()["usr_token"] ?? "",
                                     "pstId" :    ctrObjOfUpdatePost.pst_id ?? "",
                                     "scatId" : sltSubCat_Id,
                                     "ttl" : trimmedTittleStr,
                                     "dscptn" : trimmedDescStr,
                                     "tags" : addedTags,
                                     "helpTyp" : getDataInUserDefalt(key: "TypeOfReq"),
                                     "helpLoc" : getDataInUserDefalt(key: "Location_Addrs") ,
                                     "helpDate" : getDataInUserDefalt(key: "HelpReqDate"),
                                     "helpLat" :  getDataInUserDefalt(key: "Location_Lat"),
                                     "helpLng" : getDataInUserDefalt(key: "Location_Long")]
        
    
        ServerCommunicator(params: dict  , service: Service.editUserHelpPost, callBack: { [weak self] (response:Any ,isError:Bool) in
            
            guard let weakSelf = self else { return }
            
            guard !isError , (response as! [String : Any])["success"] as! Bool else {
                killLoader()
                ShowError(message: isError ? "Server issue. Please try again later." : (response as! [String : Any])["message"]  as! String, controller: weakSelf)
                return
            }
            
            
            let dictResponse = response as! NSDictionary
            let resultData = dictResponse["data"]
            let responseModel = Mapper<CountryResponseBody>().map(JSONObject: response)
            
            
            //print("RESPONSE ==",resultData!)
            DispatchQueue.main.async {
        
                weakSelf.ctrObjOfUpdatePost.pst_title = weakSelf.trimmedTittleStr
                weakSelf.ctrObjOfUpdatePost.pst_description = weakSelf.trimmedDescStr
                weakSelf.ctrObjOfUpdatePost.tags?.removeAll()
                weakSelf.ctrObjOfUpdatePost.tags = responseModel?.data?[0].tags
                weakSelf.ctrObjOfUpdatePost.pext_date = responseModel?.data?[0].pext_date
                weakSelf.ctrObjOfUpdatePost.scat_title = self?.sltSubCatName
                weakSelf.ctrObjOfUpdatePost.subCat_icon = getDataInUserDefalt(key: "HelpReqSubCatImg") as? String
                weakSelf.ctrObjOfUpdatePost.pext_lat = getDataInUserDefalt(key: "Location_Lat") as? String
                weakSelf.ctrObjOfUpdatePost.pext_location = getDataInUserDefalt(key: "Location_Addrs") as? String
                weakSelf.ctrObjOfUpdatePost.pext_long = getDataInUserDefalt(key: "Location_Long") as? String
                weakSelf.ctrObjOfUpdatePost.pext_type = getDataInUserDefalt(key: "TypeOfReq") as? String

                // fire notification
                NotificationCentreClass.fireHelpNotifier()
                weakSelf.navigationController?.popToRootViewController(animated: true)
                APP_Delegate().isEditHiveFld = false
                
                killLoader()
            }
        })
    }
    

}
