//
//  KudosVC.swift
//  Communiti
//
//  Created by mac on 25/07/18.
//  Copyright © 2018 Hatshit. All rights reserved.
//

import UIKit

class KudosVC: UIViewController, UITextViewDelegate{
    
    
    @IBOutlet var imgView_Funny: UIImageView!
    @IBOutlet var lbl_Funny: UILabel!
    @IBOutlet var imgView_Inspiring: UIImageView!
    @IBOutlet var lbl_Inspiring: UILabel!
    @IBOutlet var imgView_Researched: UIImageView!
    @IBOutlet var lbl_Researched: UILabel!
    @IBOutlet var imgView_HelpFul: UIImageView!
    @IBOutlet var lbl_HelpFul: UILabel!
    @IBOutlet var imgView_Creative: UIImageView!
    @IBOutlet var lbl_Creative: UILabel!
    @IBOutlet var txt_view: UITextView!
    @IBOutlet var scroll_View: UIScrollView!
    @IBOutlet var btnContinue: UIButton!
    @IBOutlet var bgViewOFTxtVw: UIView!
    
    var arrOfShowData = [CountryList]()
    var sltKudos_Id : String?
    var callbackOFKudos: ((Int?) -> Void)?
    var countryListObjOFAns : CountryList?
    var countryList : CountryList?
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.txt_view.isEditable = false
        self.txt_view.isSelectable = false

        self.btnContinue.isEnabled = false
        btnContinue.backgroundColor = UIColor(red: 192/255, green: 238/255, blue: 229/255, alpha: 1)
        
        self.getDataFromServer()
        if(Constants.kIphone_5){
            self.scroll_View.isScrollEnabled = true
        }else{
            self.scroll_View.isScrollEnabled = false

        }

         self.setUpMethod()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.removeKeyboardNotification()
    }
    
    func setUpMethod(){
        self.registorKeyboardNotification()
    }
    
    
    
    @IBAction func btnContinueAction(_ sender: Any) {
        
        if let sltKudos_id = self.sltKudos_Id{
            self.giveKudos(kudos_Id: sltKudos_id)
        }else{
            ShowError(message: "Please select any one kudos", controller: windowController())
        }
    }
    
    
    @IBAction func btnActionMethod(_ sender: UIButton) {
     
        self.highLightSltKudos(btn: sender)
    }
    
    
    func highLightSltKudos(btn : UIButton){
        
        sltKudos_Id = self.arrOfShowData[btn.tag].scat_id!
        self.txt_view.text = "(Maximum 300 characters)"
        self.btnContinue.isEnabled = true
        self.btnContinue.backgroundColor = UIColor(red: 9/255, green: 196/255, blue: 154/255, alpha: 1)
        self.txt_view.isEditable = true
        self.txt_view.isSelectable = true
        self.bgViewOFTxtVw.layer.shadowOpacity = 1
        self.bgViewOFTxtVw.layer.shadowRadius = 1
        self.bgViewOFTxtVw.layer.shadowOffset =  CGSize(width: 0, height: 1)

        
        switch btn.tag {
        case 0:
            self.imgView_Funny.image = UIImage.init(named: "funny_Selected")
            self.lbl_Funny.textColor = UIColor.black
            self.imgView_Inspiring.image = UIImage.init(named: "Inspiring_DisSelect")
            self.lbl_Inspiring.textColor = UIColor.lightGray
            self.imgView_Researched.image = UIImage.init(named: "researched_DisSelect")
            self.lbl_Researched.textColor =  UIColor.lightGray
            self.imgView_HelpFul.image = UIImage.init(named: "helpful_DisSelect")
            self.lbl_HelpFul.textColor =  UIColor.lightGray
            self.imgView_Creative.image = UIImage.init(named: "creative_DisSelect")
            self.lbl_Creative.textColor =  UIColor.lightGray

            break
        case 1:
            
            self.imgView_Funny.image = UIImage.init(named: "funny_DisSelect")
            self.lbl_Funny.textColor = UIColor.lightGray
            self.imgView_Inspiring.image = UIImage.init(named: "Inspiring_Selected")
            self.lbl_Inspiring.textColor = UIColor.black
            self.imgView_Researched.image = UIImage.init(named: "researched_DisSelect")
            self.lbl_Researched.textColor =  UIColor.lightGray
            self.imgView_HelpFul.image = UIImage.init(named: "helpful_DisSelect")
            self.lbl_HelpFul.textColor =  UIColor.lightGray
            self.imgView_Creative.image = UIImage.init(named: "creative_DisSelect")
            self.lbl_Creative.textColor =  UIColor.lightGray
            
            
            break
        case 2:
            
            self.imgView_Funny.image = UIImage.init(named: "funny_DisSelect")
            self.lbl_Funny.textColor = UIColor.lightGray
            self.imgView_Inspiring.image = UIImage.init(named: "Inspiring_DisSelect")
            self.lbl_Inspiring.textColor = UIColor.lightGray
            self.imgView_Researched.image = UIImage.init(named: "Researched_Selected")
            self.lbl_Researched.textColor =  UIColor.black
            self.imgView_HelpFul.image = UIImage.init(named: "helpful_DisSelect")
            self.lbl_HelpFul.textColor =  UIColor.lightGray
            self.imgView_Creative.image = UIImage.init(named: "creative_DisSelect")
            self.lbl_Creative.textColor =  UIColor.lightGray
            
            break
        case 3:
            
            self.imgView_Funny.image = UIImage.init(named: "funny_DisSelect")
            self.lbl_Funny.textColor = UIColor.lightGray
            self.imgView_Inspiring.image = UIImage.init(named: "Inspiring_DisSelect")
            self.lbl_Inspiring.textColor = UIColor.lightGray
            self.imgView_Researched.image = UIImage.init(named: "researched_DisSelect")
            self.lbl_Researched.textColor =  UIColor.lightGray
            self.imgView_HelpFul.image = UIImage.init(named: "healpful_Selected")
            self.lbl_HelpFul.textColor =  UIColor.black
            self.imgView_Creative.image = UIImage.init(named: "creative_DisSelect")
            self.lbl_Creative.textColor =  UIColor.lightGray
            
            break
        case 4:
            
            self.imgView_Funny.image = UIImage.init(named: "funny_DisSelect")
            self.lbl_Funny.textColor = UIColor.lightGray
            self.imgView_Inspiring.image = UIImage.init(named: "Inspiring_DisSelect")
            self.lbl_Inspiring.textColor = UIColor.lightGray
            self.imgView_Researched.image = UIImage.init(named: "researched_DisSelect")
            self.lbl_Researched.textColor =  UIColor.lightGray
            self.imgView_HelpFul.image = UIImage.init(named: "helpful_DisSelect")
            self.lbl_HelpFul.textColor =  UIColor.lightGray
            self.imgView_Creative.image = UIImage.init(named: "creative_Selected")
            self.lbl_Creative.textColor =  UIColor.black
            
            break
            
        default:
            break
        }
        
        
        
    }
    
 
    //=====================================
    //MARK:- Registor Keyboard Notification
    //=====================================
    func registorKeyboardNotification(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    
    //=====================================
    //MARK:- Remove Keyboard Notification
    //=====================================
    func removeKeyboardNotification(){
        
        NotificationCenter.default.removeObserver(self,name: NSNotification.Name.UIKeyboardWillShow,object: nil)
        NotificationCenter.default.removeObserver(self,name: NSNotification.Name.UIKeyboardWillHide,object: nil)
    }
    

    
    
    //========================================================
    //MARK:- Text View Delegate method
    //========================================================
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textView.text = ""
        textView.textColor = UIColor.black
        return true;
    }

    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let result = (textView.text as NSString?)?.replacingCharacters(in: range, with: text) ?? text
        if(result.count >= 300){
            return false
        }


        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    //========================================
    //MARK:-  Key Board notification method
    //========================================
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            var userInfo = notification.userInfo!
            var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
            keyboardFrame = self.view.convert(keyboardFrame, from: nil)
            
            var visibleRect = self.view.frame;
            visibleRect.size.height -= keyboardFrame.size.height;
            
               var frameFrmScrollView = self.bgViewOFTxtVw.convert(self.bgViewOFTxtVw.bounds, to:self.scroll_View)
            frameFrmScrollView.origin.y += 128.0  // 128 bgViewOFTxtVw Height

            
            let scrollPoint = CGPoint(x: 0.0, y: (((frameFrmScrollView.origin.y) + (frameFrmScrollView.size.height)) - visibleRect.size.height))
                self.scroll_View.setContentOffset(scrollPoint, animated: true)
               }
          
       
    }

    
    @objc func keyboardWillHide(notification: NSNotification) {
        DispatchQueue.main.async {
            let scrollPoint = CGPoint(x: 0.0, y: -50)

            self.scroll_View.setContentOffset(scrollPoint, animated: true)

        }
        
        
    }
    
    //========================================
    //MARK:-  get Kudos list
    //========================================
    /*
     1.usrToken->user token
     2.scatType->enum('REPORT', 'KUDOS')
     */
    func getDataFromServer() -> Void {
        
        showLoader(view: windowController().view)
        
        let dict : Dictionary = ["usrToken" : getUserData()["usr_token"],
                                 "scatType" : "KUDOS"]
        
        ServerCommunicator(params: dict as? Dictionary<String, String> , service: Service.getReportListData, callBack: { [weak self] (response:Any ,isError: Bool) in
            guard let weakSelf = self else { return }
            killLoader()

            guard !isError , (response as! [String : Any])["success"] as! Bool else {
                ShowError(message: isError ? "Server issue. Please try again later." : (response as! [String : Any])["message"]  as! String, controller: weakSelf)
                return
            }
            
            DispatchQueue.main.async {
                  print(response)
                let countryResponseBody = Mapper<CountryResponseBody>().map(JSONObject: response)
                 weakSelf.arrOfShowData = (countryResponseBody?.data)!
                
           }
        })
    }
    
    //================================
    // Call Service For Give Kudos
    //================================
    func giveKudos(kudos_Id  :String){
        
        /*
         1.usrToken->user token
         2.ansId->comment id
         3.kudoId->kudoId
         4.kudoCmnt->kudoCmnt
         */
 
        self.btnContinue.isEnabled = false
        var trimmTxt   = txt_view.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if(trimmTxt == "(Maximum 300 characters)"){
           trimmTxt = ""
        }
        
        
        let dict : Dictionary =  ["usrToken" : getUserData()["usr_token"],
                                  "ansId" : countryListObjOFAns?.ans_id ,
                                  "kudoId" : kudos_Id,
                                  "kudoCmnt" :  trimmTxt,
                                  "pstTtl" : countryList?.pst_title]
        
        ServerCommunicator(params: dict as? Dictionary<String, String>  , service: Service.giveKudos, callBack: {[weak self]  (response:Any ,isError:Bool) in
            
            guard let weekSelf = self else { return }

            if(!isError){
                let dictResponse = response as! NSDictionary
                if(dictResponse["success"] as! Bool){
                    let resultData = dictResponse["data"] as Any
                    print("RESPONSE ==",resultData)
                    
                    DispatchQueue.main.async {
                        // let value  = (resultData as? [Any])[0]
                     //   countryListObjOFAns?.gta_ntfy_id = value["gta_ntfy_id"]
                        
                        if(dictResponse["message"] as! String == "Like successfully."){
                            if weekSelf.callbackOFKudos != nil {
                                weekSelf.callbackOFKudos!(Int(weekSelf.sltKudos_Id!)!)
                            }
                        weekSelf.navigationController?.popViewController(animated: true)
                            weekSelf.btnContinue.isEnabled = true

                      }
                    }
                   
                }else{
                    weekSelf.btnContinue.isEnabled = false
                    ShowError(message: dictResponse["message"]  as! String, controller: windowController())
                    
                }
                
            }else{
                weekSelf.btnContinue.isEnabled = false
                ShowAlert(title: "Error", message: "Server issue. Please try again later.", controller: windowController(), cancelButton: nil, okButton: "OK", style: .alert, callback: { (isCancel, isOk) in
                })
                
            }
        })
        
        
        
    }
    
    
    

}
