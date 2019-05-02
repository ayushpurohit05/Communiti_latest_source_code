//
//  ViewController.swift
//  Communiti_App
//
//  Created by Navjot  on 11/24/17.
//  Copyright © 2017 Aplite_info. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import ObjectMapper

class OnBoardVC: UIViewController, UIScrollViewDelegate  {
    
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var policyLabel: FRHyperLabel!
    var backgroundImgView = UIImageView()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screensSize = UIScreen.main.bounds
        scroll.frame = CGRect(x: 0, y: 5, width: screensSize.width, height: screensSize.height-5)
        scroll.contentSize = CGSize(width: self.view.frame.size.width * 4, height: scroll.frame.size.height - 68)
        scroll.backgroundColor = .black
        backgroundImgView = UIImageView(frame:CGRect(x: 0, y: 0, width: scroll.contentSize.width/3, height: scroll.contentSize.height))
        backgroundImgView.image = UIImage(named: "bgimage.png")
        scroll.addSubview(backgroundImgView)
        
        for i in 0...3{
            let newX = i * Int(self.view.frame.size.width)
            let imView = UIImageView(frame: CGRect(x: CGFloat(newX), y: 0, width: self.view.frame.size.width, height:scroll.contentSize.height))
            imView.layoutIfNeeded()
            imView.image = UIImage(named: "img\(i+1)")
            scroll.addSubview(imView)
        }
        
        scroll.delegate = self
        pageControl.numberOfPages = 4
        customiseLabel()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var rect = self.backgroundImgView.frame
        rect.origin.x = scrollView.contentOffset.x/1.1
        self.backgroundImgView.frame = rect;
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.width
        pageControl.currentPage = Int(pageNumber)
    }
    
//======================================
// MARK:-Customise Label Method
//======================================
    func customiseLabel() -> Void {
        
        policyLabel.lineBreakMode =  NSLineBreakMode.byWordWrapping
        policyLabel.numberOfLines = 0
        let string = policyLabel.text
        let attributes = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption1), NSUnderlineColorAttributeName : UIColor.lightGray,NSForegroundColorAttributeName: UIColor.lightGray]
        policyLabel.attributedText = NSAttributedString(string: string!, attributes: attributes)
        let handler = {
            (hyperLabel: FRHyperLabel?, substring: String?) -> Void in
            if(substring == "Terms of Use"){
                UIApplication.shared.openURL(NSURL(string: "http://www.communiti.io/terms-of-use/")! as URL)
            }else{
                UIApplication.shared.openURL(NSURL(string: "http://communiti.io/privacy-policy/")! as URL)
            }
        }
        
        policyLabel.setLinksForSubstrings(["Terms of Use", "Privacy Policy"], withLinkHandler: handler)
    }
    
    @IBAction func pageControllerAction(_ sender: UIPageControl) {
        
        let x = CGFloat(sender.currentPage) * self.scroll.frame.width
        UIView.animate(withDuration: 0.1) {
            self.scroll.contentOffset.x = x
        }
    }
    


//======================================
// MARK:-LoginBtn Action Method
//======================================
    @IBAction func loginBtn(_ sender: UIButton) {
    
        if FBSDKAccessToken.current() != nil {
             FBSDKLoginManager().logOut()
        }
        sender.isUserInteractionEnabled = false
        if (UserDefaults.standard.bool(forKey: "isLoggedIn") == false) {
            showLoader(view: self.view)
            
            let loginManager: FBSDKLoginManager = FBSDKLoginManager();
            loginManager.logIn(withReadPermissions: ["public_profile", "email"]) { (result, error) in
            
                if(result != nil){
                    // Login Event For Analitics
                 FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields":"first_name, email, last_name, picture.type(large)"]).start { (connection, result, error) -> Void in
                
                    if result != nil{
                        let dictionary = result as! [String : Any]
                      //  print(dictionary )
                        var strBase64 = ""
                        let pic = dictionary["picture"] as! [String : Any]
                        let data    =  pic["data"] as! [String : Any]
                        let imgurl = data["url"]
                       
                        if  imgurl != nil{
                            let url = URL(string:imgurl as! String)
                            let imgData = try? Data(contentsOf: url!) //make sure your
                             strBase64 = (imgData?.base64EncodedString(options: .lineLength64Characters))!
                            strBase64 = ("data:image/jpg;base64," + strBase64)
                           // print(strBase64 )
                        }else{
                            
                             strBase64 = ""
                        }
                    
                    
                       // showLoader(view: self.view)
                        let dict : Dictionary = ["fname" : dictionary["first_name"] ?? "",
                                                 "lname" : dictionary["last_name"] ?? "",
                                                 "email" :  dictionary["email"] ?? "",
                                                 "socialId" : dictionary["id"] ?? "",
                                                 "socialNm" : "facebook",
                                                 "dvcToken" : APP_Delegate().userDeviceToken == nil ? "123" : APP_Delegate().userDeviceToken ?? "",
                                                 "dvcId" : "123",
                                                 "dvcTyp" : "iOS",
                                                 "pImg" :  strBase64]
 
            ServerCommunicator(params: dict as? Dictionary<String, String>, service: Service.Signin, callBack: { [weak self] (response:Any ,isError:Bool) in
                
                if((response as! [String : Any])["success"] as! Bool == false){
                    if((response as! [String : Any])["message"] as! String == "Deactive" ){
                        DispatchQueue.main.async {
                            APP_Delegate().showBlockPopup(title: (response as! [String : Any])["data"] as? String,controller: self!)
                           sender.isUserInteractionEnabled = true
                        }
                        return
                    }
                }
                            guard let weakSelf = self else { return }

                            if(!isError){
                                let dictResponse = response as! NSDictionary
                                if(dictResponse["success"] as! Bool){
                                    
                                btnClickEvent(caregoryNm: "Login", action: "User Login", label: "")
                                    
                                DispatchQueue.main.async {
                                     killLoader()
                                    // Set User Data
                                    let resultData = dictResponse["data"]
                                    print(resultData)
                                    setUserData(userData: resultData as! [String : Any])
                                    let join =  getUserData()["grp_join"] as? String
                                    if(join == "YES"){
                                        UserDefaults.standard.set(true, forKey: "isJoinedGrp")

                                    }else{
                                        UserDefaults.standard.set(false, forKey: "isJoinedGrp")

                                    }
                                    
                                    let userImg =  getUserData()["profile_image"] as? String

                                    if(userImg == "" || userImg == nil){
                                    
                                        let enterUserNameVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EnterUserName") as! EnterUserNameVC
                                        weakSelf.navigationController?.pushViewController(enterUserNameVC, animated: true)
                                                                              
                                    }else{
                                        
                                        APP_Delegate().isPopForLogin = false
                                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
                                        UserDefaults.standard.set(true, forKey: "isFirstTime")
                                        killLoader()
                                    weakSelf.navigationController?.popToRootViewController(animated: false)
                                    }
                             
                                    
                                       sender.isUserInteractionEnabled = true
                                    
                                    }
                                    
                                }else{
                                    killLoader()
                                     sender.isUserInteractionEnabled = true
                                    ShowError(message: dictResponse["message"]  as! String, controller: weakSelf)
                                }
                            }else{
                                killLoader()
                                 sender.isUserInteractionEnabled = true
                                ShowAlert(title: "Error", message: "Server issue. Please try again later.", controller: weakSelf, cancelButton: nil, okButton: "OK", style: .alert, callback: { (isCancel, isOk) in
                                })
                            }
                        })
                    }else{//
                         killLoader()
                         sender.isUserInteractionEnabled = true
                        //                        ShowAlert(title: "Error", message: "Server issue. Please try again later.", controller: self, cancelButton: nil, okButton: "OK", style: .alert, callback: { (isCancel, isOk) in
//                        })

                    }
                }

           }else{
                   killLoader()
                   sender.isUserInteractionEnabled = true
//                    ShowAlert(title: "Error", message: "Server issue. Please try again later.", controller: self, cancelButton: nil, okButton: "OK", style: .alert, callback: { (isCancel, isOk) in
//                    })

            }
         }//
        }else{
            let welComeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarCon") as! TabBarController
            self.navigationController?.pushViewController(welComeVC, animated: true)
        }
    }
}

