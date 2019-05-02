//
//  AddTagVC.swift
//  Community
//
//  Created by Hatshit on 04/12/17.
//  Copyright © 2017 Hatshit. All rights reserved.
//

import UIKit
import ObjectMapper

class AddTagVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {

    var arrOfTag = [String]()
    var onHideComplete: (([Any]) -> Void)?
    var callForFltHomeVC: ((Bool , [Any]) -> Void)?
    var isMoveFromFltHomeVC : Bool!


    @IBOutlet weak var bgViewOFAddTagBtn: UIView!
    @IBOutlet weak var btn_AddTags: UIButton!
    @IBOutlet weak var table_View: UITableView!
    @IBOutlet weak var txt_Field: UITextField!
    
    //=============================================
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let touch: UITouch = touches.first!
        if (touch.view == table_View || touch.view == self.view){
            
              self.txt_Field.resignFirstResponder()
            
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.RegistorKeyBordNotificatiomn()
        table_View.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setUpview()
    }
    
    
    
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
       //print("viewWillDisappear")
        
        self.removeKeyBordNotification()

        // Call For FliterHomeVC
        if self.callForFltHomeVC != nil {
            self.callForFltHomeVC!(true , arrOfTag)
        }
        
        // Call For New PostVC
        if(arrOfTag.count == 0){
            if self.onHideComplete != nil {
                self.onHideComplete!(arrOfTag)
            }
        }
    }
    
    
    func setUpview(){
        
        if(isMoveFromFltHomeVC){
            btn_AddTags.isHidden = true
            self.hideTabBar()
        }else{
            btn_AddTags.isHidden = false
        }

        
        if(arrOfTag.count == 0){
                  btn_AddTags.alpha = 0.5
                  btn_AddTags.isUserInteractionEnabled = false
        }
    }
    

    func RegistorKeyBordNotificatiomn(){
        // Registor KeyBord NotifiCations
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func removeKeyBordNotification(){
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
//========================================
//MARK:-  Key Board notification method
//========================================
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            var visibleRect = self.bgViewOFAddTagBtn.frame
            visibleRect.origin.y = (self.view.frame.size.height - keyboardSize.height) - self.bgViewOFAddTagBtn.frame.size.height
            
            self.bgViewOFAddTagBtn.frame = visibleRect
            // self.table_View.frame.size.height -= keyboardSize.height
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            DispatchQueue.main.async {
                //self.table_View.frame.size.height += keyboardSize.height
                
                var visibleRect = self.bgViewOFAddTagBtn.frame
                visibleRect.origin.y = self.view.frame.size.height - self.bgViewOFAddTagBtn.frame.size.height
                self.bgViewOFAddTagBtn.frame = visibleRect
            }
        }
    }
    
    
//===============================================
// MARK:- Hide Tab Bar only when came from Flter
//===============================================
    func hideTabBar(){
        
        tabBarController?.tabBar.isHidden = true
        let arrOfviews = tabBarController?.view.subviews
        for view in arrOfviews!{
            if view.isKind(of: UIButton.self) {
                view.isHidden = true
            }
        }
    }
   // self contains[cd] %@ SELF == %@p Tag_Name contains[cd]
//============================
// MARK:- Add Btn Action
//============================
    @IBAction func addBtnAction(_ sender: UIButton) {
        
  
        let trimmedString = txt_Field.text?.trimmingCharacters(in: .whitespacesAndNewlines)

        if(sender.tag == 0){// for Add Btn
            if ( txt_Field.text?.characters.count == 0  ){
                
                ShowAlert(title: "Alert", message: "Please enter some text.", controller: self, cancelButton: nil, okButton: "OK", style: .alert, callback: { (isCancel, isOk) in
                })
                
            }else{
                let trimmedString = txt_Field.text?.trimmingCharacters(in: .whitespacesAndNewlines)
         
                if(trimmedString != ""){
                    
                    if(isMoveFromFltHomeVC == true ? self.arrOfTag.count >= 0 :self.arrOfTag.count != 3 ){
                        
                        var predicates = NSPredicate()
                        let firstChar : Character = (trimmedString?.characters.first)!
                        if(firstChar == "#"){
                            
                               predicates = NSPredicate(format: "self MATCHES %@", String(format: "%@", trimmedString!))
                        }else{
                               predicates = NSPredicate(format: "self MATCHES %@", String(format: "#%@", trimmedString!))
                            
                        }

                       let filterArray = (self.arrOfTag as NSArray).filtered(using: predicates)
                        
                        if(filterArray.count == 0){
                            
                            let index = trimmedString?.index ((trimmedString?.startIndex)!, offsetBy: 0)
                            let firstChar : Character = (trimmedString?[index!])!
                            if(firstChar == "#"){
                                
                                self.arrOfTag.append( trimmedString!)
                                if(arrOfTag.count != 0){
                                    btn_AddTags.alpha = 1.0
                                    btn_AddTags.isUserInteractionEnabled = true
                                    
                                }
                                self.txt_Field.resignFirstResponder()
                                self.txt_Field.text = ""
                                self.table_View.reloadData()
                            }else{
                                
                                self.arrOfTag.append(String(format: "#%@",trimmedString!) )
                                if(arrOfTag.count != 0){
                                    btn_AddTags.alpha = 1.0
                                    btn_AddTags.isUserInteractionEnabled = true
                                    
                                }
                                self.txt_Field.resignFirstResponder()
                                self.txt_Field.text = ""
                                self.table_View.reloadData()
                            }
                            
                            
                        }else{
                                ShowAlert(title: "Alert", message: "This tag is already added.", controller: self, cancelButton: nil, okButton: "OK", style: .alert, callback: { (isCancel, isOk) in
                                })
                  
                        }
                    }else{
                        ShowAlert(title: "Alert", message: "You can add upto 3 tags.", controller: self, cancelButton: nil, okButton: "OK", style: .alert, callback: { (isCancel, isOk) in
                        })
                        
                    }
                }else{
                    
                    ShowAlert(title: "Alert", message: "Please enter the tittle.", controller: self, cancelButton: nil, okButton: "OK", style: .alert, callback: { (isCancel, isOk) in
                    })
                }

            }
        }else{ // for AddTags  btn
            
            if self.onHideComplete != nil {
                 self.onHideComplete!(arrOfTag)
            }
            
            self.navigationController?.popViewController(animated: true)
            
        }
    }
    
//======================================
// MARK:-Table View Delegate Methods
//======================================
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->Int{
        return arrOfTag.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "AddTag"
        var cell: AddTagCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? AddTagCell
        if cell == nil {
            tableView.register(UINib(nibName: "AddTagCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? AddTagCell
        }
        
        cell.cell_LblTag.text = arrOfTag[indexPath.row] as? String
        cell.cell_BtnDelete.addTarget(self, action: #selector(deletedBtnAction(btn:)), for: .touchUpInside)
        cell.cell_BtnDelete.tag = indexPath.row

        return cell
    }
    
    @objc func deletedBtnAction(btn: UIButton){//Perform actions here
        
        arrOfTag.remove(at: btn.tag)
        if(arrOfTag.count == 0){
            
                btn_AddTags.alpha = 0.5
                btn_AddTags.isUserInteractionEnabled = false
           
        }
        table_View.reloadData()
    }

//======================================
// MARK:-Text Field Delegate Methods
//======================================

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        //print("textFieldShouldReturn")
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //print("While entering the characters this method gets called")
        
        if (string == " " || string == "*") {
            
            if(string == "*"){
                ShowAlert(title: "Alert", message: "You can't add * as a tag.", controller: self, cancelButton: nil, okButton: "OK", style: .alert, callback: { (isCancel, isOk) in
                })
            }
            
            return false
        }
      
        let maxLength = 13
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        if(newString.length >= maxLength){
        ShowAlert(title: "Alert", message: "Text Limit Exist.", controller: self, cancelButton: nil, okButton: "OK", style: .alert, callback: { (isCancel, isOk) in
         })
        }
        
        return newString.length <= maxLength
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //print("TextField should return method called")
        textField.resignFirstResponder();
        return true;
    }
}
