//
//  SelectProfileVC.swift
//  Communiti
//
//  Created by mac on 19/07/18.
//  Copyright © 2018 Hatshit. All rights reserved.
//

import UIKit

class SelectProfileVC: UIViewController,UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    let imagePicker = UIImagePickerController()
    @IBOutlet weak var img_ViewUser: UIImageView!
    @IBOutlet weak var btnContinue: UIButton!

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnContinue.backgroundColor = UIColor(red: 192/255, green: 238/255, blue: 229/255, alpha: 1)
        btnContinue.isEnabled = false

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnContinueACtion(_ sender: Any) {
        
        self.editEmailAndNameAndUserImgService(img: self.img_ViewUser.image)

    }
    
    
    
    
    @IBAction func selectImg(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        DispatchQueue.main.async {
            self.img_ViewUser.image = chosenImage
            self.btnContinue.isEnabled = true
            self.btnContinue.backgroundColor = UIColor(red: 9/255, green: 196/255, blue: 154/255, alpha: 1)
            self.btnContinue.isEnabled = true
            picker.dismiss(animated: true, completion:nil)
        }
        
    }
    
    func editEmailAndNameAndUserImgService( img : UIImage?){
        
        showLoader(view: windowController().view)
        var strBase64 : String?
            if let imgData:String = UIImageJPEGRepresentation(img!, 0.4)?.base64EncodedString() {
                //Check size of compress image in mb
                var dataDecoded : Data = Data(base64Encoded: imgData, options: .ignoreUnknownCharacters)!
                let dataDecodedSize = dataDecoded.count
                print("size of image in MB: %f ", (Int(dataDecodedSize) / 1024)/1024)
                let imageSizeInMB  = (Int(dataDecodedSize) / 1024)/1024
                if(imageSizeInMB > 2){
                    ShowError(message: "Oops! Your image is a bit too large, try uploading pics smaller than 2 MB", controller: windowController())
                    return
                }
                
                 strBase64 = ("data:image/jpg;base64," + imgData)
            }
       
        

        let dict : Dictionary = ["usrToken" : getUserData()["usr_token"],
                                 "email" : "",
                                 "userName" :  "",
                                 "pImg" : strBase64 ?? ""]
        
        ServerCommunicator(params: dict as? Dictionary<String, String>  , service: Service.editUserProfile, callBack: { [weak self] (response:Any ,isError:Bool) in
            guard let weakSelf = self else { return }
            
            
            if(!isError){
                var dictResponse = response as! [String : Any]
                if(dictResponse["success"] as! Bool){
                    DispatchQueue.main.async {
                        print(response)
                        
                            let imageURL  = (dictResponse["data"] as! [String : Any])["imageName"] as? String
                            print(imageURL!)
                            var dict = getUserData()
                            ImageCaching.sharedInterface().removeImagewithID(dict["profile_image"] as! String)
                            dict["profile_image"] = imageURL
                            setUserData(userData: dict)
                            if let imageUrl1 = imageURL{
                                if  let data = try? Data(contentsOf: URL.init(string: imageUrl1)!){//make sure your
                                    let image = UIImage(data: data)
                                    
                                    DispatchQueue.main.async {
                                        if((image) != nil){                                            ImageCaching.sharedInterface().setImage(image, withID: imageUrl1)
                                            
                                        }
                                    }
                                }
                            }
                        
                         APP_Delegate().isPopForLogin = false
                         UserDefaults.standard.set(true, forKey: "isLoggedIn")
                         UserDefaults.standard.set(true, forKey: "isFirstTime")
                          killLoader()
                        weakSelf.navigationController?.popToRootViewController(animated: false)
                        
                    }
                }else{
                    killLoader()
                    if((response as! [String : Any])["message"] as! String == "Your session has timed out, please login again."){
                        DispatchQueue.main.async {
                            moveforLoginWhenSeccionExpire(controller: self!)
                        }
                    }else if((response as! [String : Any])["message"] as! String == "Deactive" ){
                        DispatchQueue.main.async {
                            APP_Delegate().showBlockPopup(title: (response as! [String : Any])["data"] as? String,controller: self!)
                        }
                        return
                    }else{
                        killLoader()
                        ShowError(message: isError ? "Server issue. Please try again later." : (response as! [String : Any])["message"]  as! String, controller: self!)
                    }
                }
            }else{
                killLoader()
                ShowAlert(title: "Error", message: "Server issue. Please try again later.", controller: self!, cancelButton: nil, okButton: "OK", style: .alert, callback: { (isCancel, isOk) in
                })
            }
        })
    }


}
