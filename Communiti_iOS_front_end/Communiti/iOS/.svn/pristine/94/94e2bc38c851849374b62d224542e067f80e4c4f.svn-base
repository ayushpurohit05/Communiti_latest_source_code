//
//  UserProfileVC.swift
//  Community
//
//  Created by Hatshit on 09/02/18.
//  Copyright © 2018 Hatshit. All rights reserved.
//

import UIKit

class UserProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet var containerView_Bottom: NSLayoutConstraint!
    
    @IBOutlet var bgviewOFImage: UIView!
    @IBOutlet var btn_SecNmEdit: UIButton!
    @IBOutlet var btnEditUserImg: UIButton!
    @IBOutlet var btnStartErnBadge: UIButton!
    @IBOutlet weak var emailEditButton: UIButton!
    @IBOutlet weak var btn_UserNm: UIButton!
    
    @IBOutlet var Img_NotesUserProfile: UIImageView!
    @IBOutlet var imgVW_EditProfile: UIImageView!
    @IBOutlet weak var img_ViewUser: UIImageView!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var txtFieldSecNm: UITextField!
    @IBOutlet weak var bgViewOfEmail_H: NSLayoutConstraint!
    @IBOutlet var bgViewSecNm_H: NSLayoutConstraint!
    
    @IBOutlet weak var BgviewOfKudosBadge: UIView!
    @IBOutlet weak var bg_viewOfThKNotest: UIView!
    @IBOutlet var bg_viewOfThKNotest_H: NSLayoutConstraint!
    @IBOutlet var bgViewOFSecNm: UIView!
    @IBOutlet var bg_VwOFNm_H: NSLayoutConstraint!
    @IBOutlet weak var bg_VwOFNm: UIView!
    @IBOutlet weak var bg_VwOFEmail: UIView!
    @IBOutlet weak var bg_VwOFKarmaPoints: UIView!
    
    @IBOutlet weak var table_view: UITableView!
    @IBOutlet var coll_view: UICollectionView!
    @IBOutlet var collVw_W: NSLayoutConstraint!
    @IBOutlet var scroll_View: UIScrollView!

    @IBOutlet var lbl_AlertOFNoKudos: UILabel!
    @IBOutlet weak var lbl_TotalKMPoints: UILabel!
    @IBOutlet weak var validEmailMsgLabel: UILabel!
    @IBOutlet var lbl_NoteUserNm: UILabel!
    @IBOutlet var lbl_ThkNotesTittle: UILabel!
    @IBOutlet var lbl_ThkNotesCount: UILabel!



    let imagePicker = UIImagePickerController()
    var arrOfShowData = [String]()
    var isOtherUSerProfile : Bool!
    var otherUserId : String?
    var isEmailEdit : Bool?
    let reuseIdentifier = "Collection_Cell"
    var arrOfCollnData = [CountryList]()
    var latestNoteUserId : String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scroll_View.isHidden = true
     
        if(otherUserId  == getUserData()["usr_id"] as? String){
            //Navigation Tittle
            self.navigationItem.title = "ME"
            isOtherUSerProfile = false
        }else{
            //Navigation Tittle
            self.navigationItem.title = "USER PROFILE"
            isOtherUSerProfile = true
        }
        //Call Service There
        self.getKudosNotesList()
        self.getUserKudosWithCount()
        
        self.validEmailMsgLabel.isHidden = true
        btn_UserNm.setTitle(" ", for: .normal)
        
        if (!isOtherUSerProfile){
            self.btn_SecNmEdit.isHidden = false
            self.btnEditUserImg.isHidden = false
            self.imgVW_EditProfile.isHidden = false
            btnClickEvent(caregoryNm: "Edit Profile", action: "Edit_Profile_Click", label: "")
            NotificationCentreClass.registerCategoryRegisterNotifier(vc: self, selector: #selector(self.refreshKarmaPointsByNotifier))
            validEmailMsgLabel.isHidden = true
            self.setUpData()

        }else{
            
            self.btn_SecNmEdit.isHidden = true
            self.btnEditUserImg.isHidden = true
            self.imgVW_EditProfile.isHidden = true
            self.bgViewOfEmail_H.constant = 0
            self.bg_VwOFNm_H.constant = 0
            self.navigationItem.rightBarButtonItem = nil
            self.getUserProfileDetail()
        }
      
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        //=============Future use ================
        // arrOfShowData = ["Category" , "Action"]
        //=========================================
         arrOfShowData = ["Hives" ]
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (!isOtherUSerProfile){
            DispatchQueue.main.async {
                self.lbl_TotalKMPoints.text = UserDefaults.standard.value(forKey: "TotalKMPoints") as? String
            }
        }
    }

    
    
    func setUpData()  {

        // Show  All View
        self.showAllinitialHiddenViews();
        
        btn_UserNm.setTitle((getUserData()["usr_fname"] as? String)?.capitalizingFirstLetter(), for: .normal)
        
        //For Image
        let strImg = getUserData()["profile_image"] as! String
        if( strImg  == ""){
            img_ViewUser.image =  UIImage(named: "user") 
        }else{
            
            saveImgIntoCach(strImg: strImg, imageView: img_ViewUser)

        }
        

        //For Email
            emailTextField.isUserInteractionEnabled = false
            let emailStr = getUserData()["usr_email"] as! String
            if emailStr == ""
            {
                emailTextField.text = "Enter your email"
                emailTextField.textColor = UIColor.lightGray
            }else{
                emailTextField.text = emailStr
                emailTextField.textColor = UIColor.black

            }
            
          //For secound name
        self.txtFieldSecNm.isUserInteractionEnabled = false
        if let secoundNM = getUserData()["usr_username"] as? String {
            if secoundNM == ""
            {
                txtFieldSecNm.text = "Enter your name"
                txtFieldSecNm.textColor = UIColor.lightGray
            }else{
                txtFieldSecNm.text = secoundNM
                txtFieldSecNm.textColor = UIColor.black

            }
        }
    }
    
    func showAllinitialHiddenViews()  {
//
//        // Show  All View
//        self.bgViewOFSecNm.isHidden = false
//        self.bg_VwOFNm.isHidden = false
//        self.bg_VwOFEmail.isHidden = false
//        self.bg_VwOFKarmaPoints.isHidden = false
//        self.img_ViewUser.isHidden = false
//        self.table_view.isHidden = false
    }
    
    @IBAction func btnStartEarningBadges(_ sender: Any) {
        
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    //========================================
    //MARK:-  Btn notes Profile Action Method
    //========================================
    @IBAction func btnNotesProfileAction(_ sender: Any) {
        
        let userProfileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "USERPROFILEVC") as! UserProfileVC
        //userProfileVC.isOtherUSerProfile = true
        userProfileVC.otherUserId = latestNoteUserId
        self.navigationController?.pushViewController(userProfileVC, animated: true)
        
    }
    
    
    @IBAction func btnThankYouNotesAction(_ sender: Any) {
        
        let thankYouNotesVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "THANKYOUNOTESVC") as! ThankYouNotesVC
        
        thankYouNotesVC.UesrID = isOtherUSerProfile ? otherUserId as? String : getUserData()["usr_id"] as? String
        self.navigationController?.pushViewController(thankYouNotesVC, animated: true)
        
    }
    
//========================================================
//MARK:- Right Navi Btn Action
//========================================================
    
    @IBAction func rightNviBtnActionMethod(_ sender: Any) {
        //self.openDropDownMenu()
    }

//========================================================
//MARK:- Open DropDownMenu Of User Post
//========================================================
    
    func openDropDownMenu(){
        
        let userId = getUserData()["usr_id"] as! String
        //let responseid = CountryList?.usr_id!
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
       
       
        alert.addAction(UIAlertAction(title: "Share", style: .default) { action in
            self.shareBtnACtion(message: "I think you might like this post on Communiti, the app for helping and building meaningful connections with people around you!", isPostShare: true)
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
        })
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
 
    
    //====================================
    //MARK:- Share Btn Action Method
    //====================================
    func shareBtnACtion(message : String , isPostShare : Bool){
       // isShareBtnClk = true
        let text = String(format: "%@ \n%@checkCommunityApp?pstId=%@&type=KarmaPoints",message,Service.Base_URL,"2")
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        activityViewController.completionWithItemsHandler = { activity, success, items, error in
            if(success){
                if(isPostShare){
                    btnClickEvent(caregoryNm: "Hive Request", action: "Share Hive Post", label: "")
                }
            }
        }
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
//======================================
//MARK:- Refresh Karma points
//======================================
    func refreshKarmaPointsByNotifier() {
        DispatchQueue.main.async {
            self.lbl_TotalKMPoints.text = UserDefaults.standard.value(forKey: "TotalKMPoints") as? String
        }
        
    }
    
    
    @IBAction func editBtnOFSecoundName(_ sender: UIButton) {
         self.isEmailEdit = false
    
        
        if sender.titleLabel?.text == "Edit"{
            self.txtFieldSecNm.isUserInteractionEnabled = true
            sender.setTitleColor(UIColor.init(red: 40/255, green: 176/255, blue: 79/255, alpha: 1), for: .normal)
            sender.setTitle("Save", for: .normal)
            txtFieldSecNm.becomeFirstResponder()


        }else{
            if isValidUsername(txtFieldSecNm.text!){
        
                self.editEmailAndNameAndUserImgService(email: "", secNm: self.txtFieldSecNm.text, img: nil, sltBtnTag: sender.tag)
            self.txtFieldSecNm.isUserInteractionEnabled = false
            self.txtFieldSecNm.resignFirstResponder()
            sender.setTitleColor(.lightGray, for: .normal)
            sender.setTitle("Edit", for: .normal)
            }else{
                ShowError(message: "Please enter valid username", controller: windowController())
            }
        }
        
    }
  //  "^[a-zA-Z0-9_@]*$"
    func isValidUsername(_ username : String) -> Bool{
        if username.count < 30{
            let regex =  "^[a-zA-Z0-9_@!]+$"
            
            let passwordTest = NSPredicate(format: "SELF MATCHES %@", regex)
            return passwordTest.evaluate(with: username)
        }else{
            return false
            
        }
    }
//
    
    @IBAction func editImgBtnAction(_ sender: Any) {
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
             picker.dismiss(animated: true, completion:nil)
             self.editEmailAndNameAndUserImgService(email: "", secNm: "", img: chosenImage , sltBtnTag: 0)
        }
        
      
    }
    
    @IBAction func editEmailBtn(_ sender: UIButton) {
        self.isEmailEdit = true
        if sender.titleLabel?.text == "Edit"{
            emailTextField.isUserInteractionEnabled = true
            emailEditButton.setTitleColor(UIColor.init(red: 40/255, green: 176/255, blue: 79/255, alpha: 1), for: .normal)
            emailEditButton.setTitle("Save", for: .normal)
            emailTextField.becomeFirstResponder()
            if getUserData()["usr_email"] as! String == ""{
                emailTextField.text = ""
            }
        }else{
            if isValidEmail(testStr: emailTextField.text!){
                self.editEmailAndNameAndUserImgService(email: self.emailTextField.text, secNm: "", img: nil, sltBtnTag: sender.tag)
                emailTextField.resignFirstResponder()
                emailTextField.isUserInteractionEnabled = false
                emailEditButton.setTitleColor(.lightGray, for: .normal)
                emailEditButton.setTitle("Edit", for: .normal)
            }else{
                UIView.animate(withDuration: 0.1, animations: {
                    self.validEmailMsgLabel.isHidden = false
                })
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.validEmailMsgLabel.isHidden = true
                }
            }
        }
    }
    
    
    //======================================
    //MARK:- Edit Enail, username & image
    //======================================
    /*
     1.usrToken->user token
     2.email->email
     OR
     3.userName->user unique name
     OR
     4.""pImg""->base64 string
 */

    func editEmailAndNameAndUserImgService(email : String? , secNm :String? , img : UIImage?, sltBtnTag : Int){
        
        showLoader(view: windowController().view)
        var strBase64 : String?
        if(sltBtnTag == 0){
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
        }
        
        let trimmedemail = email?.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedSecNm = secNm?.trimmingCharacters(in: .whitespacesAndNewlines)
        let secname : String?
        if trimmedSecNm != "" {
            let index = trimmedSecNm?.index ((trimmedSecNm?.startIndex)!, offsetBy: 0)
            let firstChar : Character = (trimmedSecNm![index!])
            secname = firstChar == "@" ? trimmedSecNm :  String(format: "@%@",trimmedSecNm!)
        }else{
            secname = ""
        }

        let dict : Dictionary = ["usrToken" : getUserData()["usr_token"],
                                 "email" : trimmedemail ?? "",
                                 "userName" : secname ?? "",
                                 "pImg" : strBase64 ?? ""]
        
        ServerCommunicator(params: dict as? Dictionary<String, String>  , service: Service.editUserProfile, callBack: { [weak self] (response:Any ,isError:Bool) in
            guard let weakSelf = self else { return }

            
            if(!isError){
                var dictResponse = response as! [String : Any]
                if(dictResponse["success"] as! Bool){
                    DispatchQueue.main.async {
                        print(response)
                        
                        if(sltBtnTag == 3){
                            btnClickEvent(caregoryNm: "Edit Profile", action: "Edit Email", label: "")
                            weakSelf.emailTextField.text = trimmedemail
                            var dict = getUserData()
                            dict["usr_email"] = trimmedemail
                            setUserData(userData: dict)
                        }else if (sltBtnTag == 1){
                            weakSelf.txtFieldSecNm.text = secname
                            var dict = getUserData()
                            dict["usr_username"] = secname
                            setUserData(userData: dict)
                        }else if(sltBtnTag == 0){
                            
                            let imageURL  = (dictResponse["data"] as! [String : Any])["imageName"] as? String
                            print(imageURL!)
                            var dict = getUserData()
                        ImageCaching.sharedInterface().removeImagewithID(dict["profile_image"] as! String)
                            dict["profile_image"] = imageURL
                            setUserData(userData: dict)
                            if let imageUrl1 = imageURL{
                                if  let data = try? Data(contentsOf: URL.init(string: imageUrl1)!){//make sure your
                                    let image = UIImage(data: data)
                                      killLoader()
                                    DispatchQueue.main.async {
                                        if((image) != nil){                                            ImageCaching.sharedInterface().setImage(image, withID: imageUrl1)

                                        }
                                    }
                                }
                            }
                        }
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
                           // moveforLoginWhenBlocked(title: ((response as! [String : Any])["data"] as? String)!, controller: self!)
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

//======================================
//MARK:- Tabel view delegate methods
//======================================
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->Int{
        return arrOfShowData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "UserProfileVCCell"
        var cell: UserProfileVCCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? UserProfileVCCell
        if cell == nil {
            tableView.register(UINib(nibName: "UserProfileVCCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? UserProfileVCCell
        }
        switch indexPath.row {
        case 0  :
            cell.lbl_ItemNM.text = arrOfShowData[indexPath.row]
            cell.imgVwOfItem.image = UIImage(named: "KPCategory")
        case 1  :
            cell.lbl_ItemNM.text = arrOfShowData[indexPath.row]
            cell.imgVwOfItem.image = UIImage(named: "KPAction")
        default :
            print( "default case")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == 0){
            let krmPotsByCatVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "KRMPOTSBYCATVC") as! KrmPotsByCatVC
            krmPotsByCatVC.isOtherUser = isOtherUSerProfile
            krmPotsByCatVC.otheruser_Id = otherUserId as! String
          
            self.navigationController?.pushViewController(krmPotsByCatVC, animated: true)
        }else{
            let krmPotsByActsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "KRMPOTSBYACTSVC") as! KrmPotsByActsVC
               krmPotsByActsVC.isOtherUser = isOtherUSerProfile
            krmPotsByActsVC.otheruser_Id = otherUserId as! String
              self.navigationController?.pushViewController(krmPotsByActsVC, animated: true)
        }
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if(UIScreen.main.bounds.size.height == 568)
        {
            return 50.0;
        }
        else{
             return 60.0;
        }
    }
    
    
    //========================================================
    // MARK:- Collection View Delegate Method
    //========================================================
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrOfCollnData.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : UserProfileColloctionCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! UserProfileColloctionCell
        
        let countryListResult = arrOfCollnData[indexPath.row]
        let typeWithImg = KudosTypeAndImage(kudosTyp: KudosType(rawValue: Int(countryListResult.kd_id!)!)!, isSmall: false)
        cell.lbl_Name.text = typeWithImg.0
        cell.imgView.image = typeWithImg.1
        cell.lbl_Count.text = countryListResult.kd_count
        
        if(isOtherUSerProfile){
            cell.lbl_Count.backgroundColor = UIColor.black

        }else{
            cell.lbl_Count.backgroundColor = countryListResult.kd_isRead == "NO" ? (UIColor(red: 49/255, green: 194/255, blue: 154/255, alpha: 1)) : UIColor.black

        }

        return cell
    }
    
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {


            let kudosDetailsVC = storyboard?.instantiateViewController(withIdentifier: "KUDOSDETAILSVC") as! KudosDetailsVC
            kudosDetailsVC.objOFUserProfile = arrOfCollnData[indexPath.row]
            kudosDetailsVC.user_id = otherUserId
            kudosDetailsVC.callBackFromKdDetailVC =  {(isReloadCollView : Bool) -> Void in
                if(isReloadCollView){
                    self.coll_view.reloadData()
                }
            }
            navigationController?.pushViewController(kudosDetailsVC, animated: true)
            
       
     
    }

    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {

        let CellCount = arrOfCollnData.count
        let collectionViewFrame = self.coll_view.frame
        let collectionViewWidth = collectionViewFrame.size.width
         let CellWidth = 90
        let CellSpacing = 10
        let totalCellWidth = CellWidth * CellCount
        let totalSpacingWidth = CellSpacing * (CellCount - 1)
        
        let leftInset = (collectionViewWidth - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset
        
        return UIEdgeInsetsMake(0, leftInset, 0, rightInset)
    }
    
    
    
//========================================================
//MARK:- Show Other User Profile Info
//========================================================
    /*
     1.usrToken->user token
     2.usrId->user id
     3.helpId->help Id
     4.hiveId->hive Id

 */
    func getUserProfileDetail(){
        showLoader(view: windowController().view)
        let dict : Dictionary = ["usrToken" : getUserData()["usr_token"],
                                 "usrId" : otherUserId,
                                 "helpId" : UserDefaults.standard.value(forKey: "HelpReq_Id") as! String ,
                                 "hiveId" : UserDefaults.standard.value(forKey: "HiveReq_Id") as! String]
        
        ServerCommunicator(params: dict as? Dictionary<String, String>  , service: Service.getUserProfileDetail, callBack: { [weak self] (response:Any ,isError:Bool) in
            
            if(!isError){
                var dictResponse = response as! [String : Any]
                if(dictResponse["success"] as! Bool){
                    DispatchQueue.main.async {
                        print(response)
                       let result = dictResponse["data"] as? [String : Any]
             
                        self?.txtFieldSecNm.text = (result!["usr_username"] as? String)?.capitalizingFirstLetter()
                        
                        //For user Secound name
                        self?.txtFieldSecNm.text = result!["usr_username"] as? String
                        
                        
                        //For Image
                        
                         let imageURL  =  result!["profile_image"] as! String
                         print(imageURL)
                       // ImageCaching.sharedInterface().removeImagewithID(imageURL)
                        if  imageURL != ""{
                            if  let data = try? Data(contentsOf: URL.init(string: imageURL)!){//make sure your
                                let image = UIImage(data: data)
                                killLoader()
                                DispatchQueue.main.async {
                                    if((image) != nil){
                                        self?.img_ViewUser.image = image
                                        ImageCaching.sharedInterface().setImage(image, withID: imageURL)
                                        
                                    }
                                }
                            }
                        }

                        
                        
                        
                        
                        
//                        // For Img
//                        let strImg = result!["profile_image"] as! String
//                        if( strImg  == ""){
//                            self?.img_ViewUser.image =  UIImage(named: "user")
//                        }else{
//
//                            let url = URL(string:strImg)
//                            let data = try? Data(contentsOf: url!) //make sure your
//                            if let dataCheck = data{
//                                self?.img_ViewUser.image = UIImage(data: dataCheck)
//                            }else{
//                                self?.img_ViewUser.image =  UIImage(named: "user")
//                            }
//                        }
                        
                        // For Email
                          self?.validEmailMsgLabel.isHidden = true
                        
                        // For Karma points
                         self?.lbl_TotalKMPoints.text = result!["karmpoint"] as? String
                        
                        // Show  All View
                          self?.showAllinitialHiddenViews();
                        
                           killLoader()
                    }
                }else{
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
    
    //========================================================
    //MARK:- Show Other User Profile Info
    //========================================================
    /*
     1.usrToken->user token
     2.usrId->user id
     */
    func getUserKudosWithCount(){
        showLoader(view: windowController().view)
        let dict : Dictionary = ["usrToken" : getUserData()["usr_token"],
                                 "usrId" : isOtherUSerProfile ? otherUserId : getUserData()["usr_id"]]
                                 
        ServerCommunicator(params: dict as? Dictionary<String, String>  , service: Service.getUserKudosWithCount, callBack: { [weak self] (response:Any ,isError:Bool) in
            
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {
                killLoader()
               //weakSelf.BgviewOfKudosBadge.isHidden = false
            }
            if(!isError){
                var dictResponse = response as! [String : Any]
                if(dictResponse["success"] as! Bool){
                    DispatchQueue.main.async {
                        print(response)
                        let countryResponseBody = Mapper<CountryResponseBody>().map(JSONObject: response)
                       
                        weakSelf.arrOfCollnData = (countryResponseBody?.data!)!
                        if(weakSelf.arrOfCollnData.count > 0){
                            
                            
                            if(Int((self?.view.frame.size.width)!) >= (102 * weakSelf.arrOfCollnData.count)){
                                
                                weakSelf.collVw_W.constant = (CGFloat(102 *    weakSelf.arrOfCollnData.count))
                            }else{
                                weakSelf.collVw_W.constant  = (self?.view.frame.size.width)!
                            }
                         
                            
                            weakSelf.coll_view.isHidden = false
                            weakSelf.coll_view.reloadData()

                        }else{
                            weakSelf.coll_view.isHidden = true
                            weakSelf.lbl_AlertOFNoKudos.isHidden = false
                            weakSelf.btnStartErnBadge.isHidden = false
                        }

                    }
                }else{
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
                        DispatchQueue.main.async {
                            weakSelf.lbl_AlertOFNoKudos.isHidden = false
                            weakSelf.btnStartErnBadge.isHidden =  weakSelf.isOtherUSerProfile ? true :  false
                            weakSelf.lbl_AlertOFNoKudos.text = weakSelf.isOtherUSerProfile ? "This user is working hard to participate with their community and earn more Badges" : "You haven’t received any Kudos Badges yet. Join Hives and start answering posts to get badges!"
                        }
                       
                    
                        //ShowError(message: isError ? "Server issue. Please try again later." : (response as! [String : Any])["message"]  as! String, controller: self!)
                    }
                }
            }else{
                ShowAlert(title: "Error", message: "Server issue. Please try again later.", controller: self!, cancelButton: nil, okButton: "OK", style: .alert, callback: { (isCancel, isOk) in
                })
            }
        })
    }
    
    //========================================================
    //MARK:- Show Thank you Notes Latest Post
    //========================================================
    /*
  
     1.usrToken->user token
     2.limit->limit
     3.page->page

     */
    func getKudosNotesList(){
        showLoader(view: windowController().view)
        let dict : Dictionary = ["usrToken" : getUserData()["usr_token"],
                                 "limit" : "1",
                                 "page" : 0,
                                 "usrId" : isOtherUSerProfile ? otherUserId : getUserData()["usr_id"]]
        
        ServerCommunicator(params: dict as? Dictionary<String, Any>  , service: Service.getKudosNotesList, callBack: { [weak self] (response:Any ,isError:Bool) in
            
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {

             killLoader()
             //weakSelf.bg_viewOfThKNotest.isHidden = false
             weakSelf.scroll_View.isHidden = false
            }
            if(!isError){
                var dictResponse = response as! [String : Any]
                if(dictResponse["success"] as! Bool){
                    DispatchQueue.main.async {
                        print(response)
                        let countryResponseBody = Mapper<CountryResponseBody>().map(JSONObject: response)
                        let result = countryResponseBody?.data
                        
                        if(countryResponseBody?.total_count == "1"){
                            weakSelf.lbl_ThkNotesCount.text =  String(format: "%@ Thank You Note", countryResponseBody?.total_count ?? "0")

                        }else{
                             weakSelf.lbl_ThkNotesCount.text =  String(format: "%@ Thank You Notes", countryResponseBody?.total_count ?? "0")
                        }
                    
                        
                        weakSelf.lbl_ThkNotesTittle.text = String(format: "\"%@\"",(result?[0].kd_note)! )
                        weakSelf.lbl_NoteUserNm.text = result?[0].usr_usrname
                        weakSelf.latestNoteUserId = result?[0].usr_id
                        
                        if(result![0].profile_image != ""){
                            saveImgIntoCach(strImg: (result![0].profile_image)!, imageView: weakSelf.Img_NotesUserProfile)
                        }else{
                            weakSelf.Img_NotesUserProfile.image  =  UIImage(named: "helpPost_Defalt")
                        }
                        
                        weakSelf.bgviewOFImage.layer.borderColor = UIColor.lightGray.cgColor

                    }
                }else{
                    if((response as! [String : Any])["message"] as! String == "Your session has timed out, please login again."){
                        DispatchQueue.main.async {
                            moveforLoginWhenSeccionExpire(controller: self!)
                        }
                    }else if((response as! [String : Any])["message"] as! String == "Deactive" ){
                        DispatchQueue.main.async {
                            APP_Delegate().showBlockPopup(title: (response as! [String : Any])["data"] as? String,controller: self!)
                        }
                        return
                    }else if ((response as! [String : Any])["message"] as! String == "Oops! There is no data to display." ){
                        DispatchQueue.main.async {
                         self?.bg_viewOfThKNotest_H.constant = 0
                        }
                    }
                }
            }else{
                ShowAlert(title: "Error", message: "Server issue. Please try again later.", controller: self!, cancelButton: nil, okButton: "OK", style: .alert, callback: { (isCancel, isOk) in
                })
            }
        })
    }
    
    
    
    
    
    
    
    
    
   
}// END
