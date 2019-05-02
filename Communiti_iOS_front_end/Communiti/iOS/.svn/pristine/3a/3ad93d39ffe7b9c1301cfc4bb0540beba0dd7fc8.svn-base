

//
//  HelpedUserListView.swift
//  Community
//
//  Created by Hatshit on 11/01/18.
//  Copyright © 2018 Hatshit. All rights reserved.
//

import UIKit

class HelpedUserListView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var table_View: UITableView!
    @IBOutlet weak var bg_View: UIView!
    @IBOutlet weak var alert_View: UIView!
    
    
    var onHideComplete: ((Bool , [Any]) -> Void)?  // 1)true for End reqend btn click
    var arrOfTableItem : [UserListModel]!
    var arrOfsltUsrID = [String]()

    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let touch: UITouch = touches.first!
        if (touch.view == bg_View){
            DispatchQueue.main.async {
                self.killViewWithAnimation(view: self)

                if self.onHideComplete != nil {
                    self.onHideComplete!(false , [""])
                }
            }
        }
    }

    class func instanceFromNib() -> UIView {
        return UINib(nibName: "HelpedUserListView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
        
    }
    
    
    @IBAction func BtnActionMethod(_ sender: Any) {
        
        DispatchQueue.main.async {
            
            self.killViewWithAnimation(view: self)
            if self.onHideComplete != nil {
                self.onHideComplete!(true , (self.arrOfsltUsrID.count != 0 ? self.arrOfsltUsrID : ["No_ID"]))
            }
        }
    }
    
    
    func killViewWithAnimation(view : UIView){
        UIView.animate(withDuration: 0.1,
                       delay: 0.1,
                       options: UIViewAnimationOptions.curveEaseIn,
                       animations: { () -> Void in
                        self.bg_View.alpha = 0;
                        self.alert_View.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
                        
        }, completion: { (finished : Bool) -> Void in
            if(finished){
                view.removeFromSuperview()
            }
        })
    }
    
    
//======================================
//MARK:- Tabel view delegate methods
//======================================
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->Int{
        return (arrOfTableItem ?? []).count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "HelpedUserListcell"
        var cell: HelpedUserListcell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? HelpedUserListcell
        if cell == nil {
            tableView.register(UINib(nibName: "HelpedUserListcell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? HelpedUserListcell
        }
       let userListModel = arrOfTableItem[indexPath.row]
        
        cell.checkMark_ImgView.isHidden = true
        cell.bgViewOfImg.layer.borderColor = UIColor.lightGray.cgColor
        cell.lbl_Name.text = userListModel.usr_fname?.capitalizingFirstLetter()
        if(userListModel.profile_image != ""){
            
            saveImgIntoCach(strImg: userListModel.profile_image!, imageView: cell.userImg_View)
            
        }else{
            cell.userImg_View.image =  UIImage(named: "user")
            
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        let helpedUserListcell = tableView.cellForRow(at: indexPath) as! HelpedUserListcell

        if( helpedUserListcell.checkMark_ImgView.isHidden){
            helpedUserListcell.checkMark_ImgView.isHidden = false
            helpedUserListcell.bgViewOfCell.backgroundColor = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)
        }else{
            helpedUserListcell.checkMark_ImgView.isHidden = true
            helpedUserListcell.bgViewOfCell.backgroundColor = UIColor.white
        }
        
       
        let userListModel = arrOfTableItem[indexPath.row]
        self.arrOfsltUsrID.append(userListModel.usr_id!)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
   
//========================================================
// MARK:- Call SerVice For Get All HelpRequested User
//========================================================
    /*
     1.usrToken->user token
     2.pstId->help id
     */
    func getAllHelpRequestedUser(controller : UIViewController, pst_Id : String, callBack : @escaping ( Bool , String) -> Void ){
        showLoader(view: controller.view)
        let dict : Dictionary = ["usrToken" : getUserData()["usr_token"],
                                 "pstId" : pst_Id]
        
        ServerCommunicator(params: dict as? Dictionary<String, String> , service: Service.getAllHelpRequestedUser , callBack: { [weak self] (response:Any ,isError: Bool) in
            
            guard let weakSelf = self else { return }
            
            guard !isError , (response as! [String : Any])["success"] as! Bool else {
                killLoader()
                //ShowError(message: isError ? "Server issue. Please try again later." : (response as! [String : Any])["message"]  as! String, controller: controller)
                
                if(isError){
                     ShowError(message:  "Server issue. Please try again later." , controller: controller)
                   
                }else{
                    
                     callBack(false, (response as! [String : Any])["message"]  as! String)
                }
                return
            }
            
            DispatchQueue.main.async {
                killLoader()
                let helpedUserList = Mapper<HelpedUserList>().map(JSONObject: response)
                //print(helpedUserList!)
                weakSelf.arrOfTableItem = (helpedUserList?.data!)!
                weakSelf.table_View.reloadData()
                callBack(true , "Users are Available")
            }
        })
        
    }

}
