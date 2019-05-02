//
//  NewPostVC.swift
//  Community
//
//  Created by Navjot  on 12/4/17.
//  Copyright © 2017 Hatshit. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding
import ObjectMapper

class NewPostVC: UIViewController, UITextViewDelegate , UITextFieldDelegate {
 
//=========================================================
    
    @IBOutlet weak var lbl_Count: UILabel!
    @IBOutlet weak var btn_CreatePost: UIButton!
    @IBOutlet weak var btn_addAditionalHTag: UIButton!
    @IBOutlet weak var lbl_tagView: UILabel!
    @IBOutlet weak var tagViewImage: UIImageView!
    
    @IBOutlet weak var tag_View: UIView!
    @IBOutlet weak var lbl_CateName: UILabel!
    @IBOutlet weak var scroll_View: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var Container_View: UIView!
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet var text_View : UITextView!
    

    @IBOutlet weak var lbl_Hashtag1: UILabel!
    @IBOutlet weak var lbl_Hashtag2: UILabel!
    @IBOutlet weak var lbl_Hashtag3: UILabel!
    @IBOutlet weak var lbl_Hashtag4: UILabel!

//=========================================================
 
    var ctrObjOfNewPost : CountryList!
    var addedTags = [Any]() // used to get data from TagVC
    var trimmedTittleStr : String!
    var trimmedDescStr : String!
    
//=========================================================
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        if(APP_Delegate().reqType){
            createProgressBar(idx: 1.0, viewController: self)
        }else{
            let width = self.view.frame.size.width/5
            let label = UILabel(frame: CGRect(x: 0, y: 63, width: width*5, height: 5))
            label.text = ""
            label.clipsToBounds = true;
            label.backgroundColor = progressBarColor()
            self.view.addSubview(label)
        }
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

    
//=======================
//MARK:- Set Up method
//=======================
    
    func setUpData(){
        
        
        if(APP_Delegate().reqType){

                btn_CreatePost.setTitle("Create Post", for: .normal)
                textfield.placeholder =  "Post title"
                text_View.text =  "Post decription";
                text_View.textColor = UIColor.lightGray;
                //btn_CreatePost.alpha = 0.5
                 btn_CreatePost.backgroundColor = UIColor(red: 192/255, green: 238/255, blue: 229/255, alpha: 1)

                btn_CreatePost.isUserInteractionEnabled = false
                lbl_CateName.text =   String(format: "  #%@  ", ctrObjOfNewPost.grp_title!)
        }else{
                btn_CreatePost.setTitle("Create Request", for: .normal)
                textfield.placeholder =  "Request title"
                text_View.text = "Request decription";
                text_View.textColor = UIColor.lightGray;
                //btn_CreatePost.alpha = 0.5
                 btn_CreatePost.backgroundColor = UIColor(red: 192/255, green: 238/255, blue: 229/255, alpha: 1)

                btn_CreatePost.isUserInteractionEnabled = false
                lbl_CateName.text =   String(format: "  #%@  ", getDataInUserDefalt(key: "HelpReqSubCatName") as! String )
 
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
        self.lbl_Hashtag1.layer.borderColor = UIColor(red: 135/255, green: 135/255, blue: 135/255, alpha: 1).cgColor
        self.lbl_Hashtag2.layer.borderColor = UIColor(red: 135/255, green: 135/255, blue: 135/255, alpha: 1).cgColor
        self.lbl_Hashtag3.layer.borderColor = UIColor(red: 135/255, green: 135/255, blue: 135/255, alpha: 1).cgColor
        self.lbl_Hashtag4.layer.borderColor = UIColor(red: 135/255, green: 135/255, blue: 135/255, alpha: 1).cgColor

        
        self.lbl_Hashtag1.textColor = UIColor(red: 135/255, green: 135/255, blue: 135/255, alpha: 1)
        self.lbl_Hashtag2.textColor = UIColor(red: 135/255, green: 135/255, blue: 135/255, alpha: 1)
        self.lbl_Hashtag3.textColor = UIColor(red: 135/255, green: 135/255, blue: 135/255, alpha: 1)
        self.lbl_Hashtag4.textColor = UIColor(red: 135/255, green: 135/255, blue: 135/255, alpha: 1)

    }
   
//========================================================
//MARK:- add the items in navigation bar and change the back button tittle and color
//========================================================
    func setUpOfNavigationBar(){
        
        self.navigationItem.title = APP_Delegate().reqType == true ? "CREATE A POST" : "HELP REQUEST"
        self.navigationController?.navigationBar.tintColor = UIColor.white

    }

 
    @IBAction func BtnActionMethod(_ sender: UIButton) {
        if(sender.tag == 0){
            self.validationMethod()
        }else{
            
            self.textfield.resignFirstResponder()
            self.text_View.resignFirstResponder()
            
            let addTagVC  = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddTagCon") as! AddTagVC
            addTagVC.isMoveFromFltHomeVC = false
            addTagVC.arrOfTag = addedTags as! [String]
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
        //print("While entering the characters this method gets called")
        
    
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

        if(trimDesc != "" && text_View.text != (APP_Delegate().reqType == true ? "Post decription" : "Request decription")){
            
            if(newString.length != 0 || trimTittle != ""){
                btn_CreatePost.backgroundColor = UIColor(red: 9/255, green: 196/255, blue: 154/255, alpha: 1)

                //btn_CreatePost.alpha = 1.0
                btn_CreatePost.isUserInteractionEnabled = true
            }else{
                btn_CreatePost.backgroundColor = UIColor(red: 192/255, green: 238/255, blue: 229/255, alpha: 1)

                //btn_CreatePost.alpha = 0.5
                btn_CreatePost.isUserInteractionEnabled = false
            }
            
        }else{
            btn_CreatePost.backgroundColor = UIColor(red: 192/255, green: 238/255, blue: 229/255, alpha: 1)

            // btn_CreatePost.alpha = 0.5
             btn_CreatePost.isUserInteractionEnabled = false
        }

        return newString.length <= maxLength
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //print("TextField should return method called")
        textField.resignFirstResponder();
        return true;
    }
    
 
//========================================================
//MARK:- Text View Delegate method
//========================================================
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        if(APP_Delegate().reqType){
            if (text_View.text == "Post decription")  {
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
            
            if(APP_Delegate().reqType){
                 text_View.text =  "Post decription"
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
           
                btn_CreatePost.backgroundColor = UIColor(red: 9/255, green: 196/255, blue: 154/255, alpha: 1)

                //btn_CreatePost.alpha = 1.0
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

    /*
     1. catId->category id
     2.scatId->sub category id
     3. ttl->post title
     4.dscptn->post description
     5. tags->array(1,2) tags id
     6.usrToken->user token
 */
//========================================================
//MARK:- Text Field Valedation method
//========================================================
    func validationMethod(){
   
        if(textfield.text?.characters.count != 0 && text_View.text.characters.count != 0){
            
            trimmedTittleStr = textfield.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            trimmedDescStr = text_View.text.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if(trimmedTittleStr != ""){
                if(APP_Delegate().reqType){
                    if(trimmedDescStr != ""  &&  text_View.text != "Post decription"){
                        
                           self.btn_CreatePost.isUserInteractionEnabled = false
                           self.addHiveReqMethod()
                        
                    }else{
                        ShowAlert(title: "Alert", message: "Please enter some text in description.", controller: self, cancelButton: nil, okButton: "OK", style: .alert, callback: { (isCancel, isOk) in
                        })
                    }
                }else{
                    if(trimmedDescStr != "" && text_View.text != "Request decription"){
                        
                        self.btn_CreatePost.isUserInteractionEnabled = false
                        self.addHelpReqMethod()
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
//MARK:- Add Hive Req Method
//========================================================
    func addHiveReqMethod(){
        /*
 
         1. catId->category id
         2.scatId->sub category id
         3. ttl->post title
         4.dscptn->post description
         5. tags->array(1,2) tags id
         6.usrToken->user token
         7.locId->Location id
         8.grpId->group id
 
 */
        
        showLoader(view: self.view)
        let userData = getUserData()
        
        let dict : Dictionary = ["usrToken" : getUserData()["usr_token"]!,
                                 "catId" : UserDefaults.standard.value(forKey: "HiveReq_Id") as! String,
                                 "scatId" :  "",
                                 "ttl" : trimmedTittleStr ?? "",
                                 "dscptn" : trimmedDescStr ?? "",
                                 "tags" : addedTags,
                                 "grpId" : ctrObjOfNewPost.grp_id ?? ""] as [String : Any]
        
        ServerCommunicator( params: dict , service: Service.addUserHiveReq, callBack: {[weak self] (response:Any ,isError:Bool) in
            if(!isError){
                
                guard let weakSelf = self else { return }
                
                let dictResponse = response as! NSDictionary
                if(dictResponse["success"] as! Bool){
                    let resultData = dictResponse["data"]
                    //print("RESPONSE ==",resultData!)
                    if(( dictResponse["data"] ) != nil){
                        
                        DispatchQueue.main.async {
                            weakSelf.textfield.text = ""
                            weakSelf.text_View.text = ""
                            killLoader()
                            APP_Delegate().reqType = true
                            self?.btn_CreatePost.isUserInteractionEnabled = true
                            self?.tabBarController?.selectedIndex = 0
                          
                            // Fire Notification for FeedVC
                           // let dict:[String: Any] = ["idx": 0]
                           //NotificationCentreClass.firePostNotifier(dict: dict)
                           
                         weakSelf.navigationController?.popToRootViewController(animated: true)
                            weakSelf.showToast(message: (dictResponse["message"] as? String)!, width: 150)
                        }
                    }
                }else{
                    killLoader()
                    if((response as! [String : Any])["message"] as! String == "Your session has timed out, please login again." ){
                         DispatchQueue.main.async {
                            moveforLoginWhenSeccionExpire(controller: self!)
                        }
                        
                    }else if((response as! [String : Any])["message"] as! String == "Deactive" ){
                         DispatchQueue.main.async {
                            APP_Delegate().showBlockPopup(title: (response as! [String : Any])["data"] as? String,controller: self!)
                            
                        }
                        return
                    }else{
                        self?.btn_CreatePost.isUserInteractionEnabled = true
                        ShowError(message: dictResponse["message"]  as! String, controller: weakSelf)
                    }
                }
            }else{
                killLoader()
                self?.btn_CreatePost.isUserInteractionEnabled = true
                ShowAlert(title: "Error", message: "Server issue. Please try again later.", controller: self!, cancelButton: nil, okButton: "OK", style: .alert, callback: { (isCancel, isOk) in
                })
            }
        })
    }
    
    
    /*
 
     "1.usrToken->user token
     2.catId->category id
     3.scatId->sub category id
     4.ttl->title
     5.dscptn->description
     6.helpTyp->help type('Location', 'Virtual')
     7.helpLoc->location name
     8.helpDate->help date
     9.helpLat->latitude
     10.helpLng->longitude
     11.tags->array(1,2)"
 */
//========================================================
//MARK:- Add Help Req Method
//========================================================
    func addHelpReqMethod(){
        
        let dict : Dictionary = [
                                  "usrToken" : getUserData()["usr_token"] ?? "",
                                  "catId" : UserDefaults.standard.value(forKey: "HelpReq_Id") as? String ?? "",
                                  "scatId" : getDataInUserDefalt(key: "HelpReqSubCatId") as? String ?? "",
                                 "ttl" : trimmedTittleStr ?? "",
                                 "dscptn" : trimmedDescStr ?? "",
                                 "tags" : addedTags,
                                 "helpTyp" : getDataInUserDefalt(key: "TypeOfReq"),
                                 "helpLoc" : getDataInUserDefalt(key: "Location_Addrs") ,
                                 "helpDate" : getDataInUserDefalt(key: "HelpReqDate"),
                                 "helpLat" :  getDataInUserDefalt(key: "Location_Lat"),
                                 "helpLng" : getDataInUserDefalt(key: "Location_Long"),
                                ]
        
        ServerCommunicator(params: dict as Any as? Dictionary<String, Any> , service: Service.addUserHelpRequest, callBack: { [weak self] (response:Any ,isError:Bool) in
            if(!isError){
                
                guard let weakSelf = self else { return }

                let dictResponse = response as! NSDictionary
                if(dictResponse["success"] as! Bool){
                    //let resultData = dictResponse["data"]
                   // print("RESPONSE ==",resultData!)
                    
                    if(( dictResponse["data"] ) != nil){
                        DispatchQueue.main.async {
                            btnClickEvent(caregoryNm: "Help Request", action: "Create Help Request", label: "")
                            weakSelf.textfield.text = ""
                            weakSelf.text_View.text = ""
                            self?.btn_CreatePost.isUserInteractionEnabled = true
                            killLoader()
                            
                            // Fire HelpREq Notification
                            //NotificationCentreClass.fireHelpNotifier()

                            APP_Delegate().reqType = false
                            self?.tabBarController?.selectedIndex = 0
                            weakSelf.navigationController?.popToRootViewController(animated: true)
                        }
                        
                    }
                    
                }else{
                    killLoader()
                    if((response as! [String : Any])["message"] as! String == "Your session has timed out, please login again." ){
                        DispatchQueue.main.async {
                            moveforLoginWhenSeccionExpire(controller: self!)
                        }
                        
                    }else if((response as! [String : Any])["message"] as! String == "Deactive" ){
                         DispatchQueue.main.async {
                            APP_Delegate().showBlockPopup(title: (response as! [String : Any])["data"] as? String,controller: self!)
                            
                        }
                        return
                    }else{
                        self?.btn_CreatePost.isUserInteractionEnabled = true
                        ShowError(message: dictResponse["message"]  as! String, controller: weakSelf)
                    }
                    
                }
            }else{
                killLoader()
                self?.btn_CreatePost.isUserInteractionEnabled = true
                ShowAlert(title: "Error", message: "Server issue. Please try again later.", controller: self!, cancelButton: nil, okButton: "OK", style: .alert, callback: { (isCancel, isOk) in
                })
            }
        })
 
    }
 
}
