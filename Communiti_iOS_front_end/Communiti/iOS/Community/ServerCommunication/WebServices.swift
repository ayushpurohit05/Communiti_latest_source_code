//
//  WebServices.swift
//  Swift_Demo
//
//  Created by Hemant Pandagre on 02/09/17.
//  Copyright © 2017 Hemant Pandagre. All rights reserved.
//

import Foundation
import UIKit
//===========================
// MARK:- Services
//===========================
class Service {
    

    
  //================ Clint Server Url==============================

      //static let Base_URL : String =  "http://ec2-18-220-150-203.us-east-2.compute.amazonaws.com/community/services/index.php/UserController/"
//================================================================
   //  static let Base_URL : String = "http://192.168.88.94/community1/UserController/"
    //============================ Main Serv ============================
    //SerVer URL main
      static let Base_URL : String = "http://communitytheapp.com/community/services/index.php/UserController/"
   //  static let Base_URL : String = "http://ec2-18-220-150-203.us-east-2.compute.amazonaws.com/community_demo/services/index.php/UserController/"

    //===================================================================

    //Services
    static let Signup : String = "signup"
    static let Signin : String = "login"
    static let getCountryLocation : String = "getLocation"
    static let getMaincategoryList : String = "getCategories"
    static let getSubcategoryList : String = "getSubCategory"
    static let addUserTags : String = "addTags"
    static let getUserTagList : String = "getUserTag"
    static let addUserHiveReq : String = "addUserHive"
    static let addUserHelpRequest : String = "addUserHelpRequest"

   // static let getUserHiveReqPost : String = "getAllHivePost"
    static let getUserHiveReqPost : String = "getOrFilterAllHivePost"
    static let upVoteAndDownVoteForPost : String = "upvoteDownvotePostOrAnswer"
    static let getAllPostComments : String = "getAllPostComments"
    static let addCommentOnPost : String = "addCommentOnPost"
    static let greatAndUnGreatAns : String = "likeAndUnlikeAnswer"
    static let editUserHivePost : String = "editUserHiveById"
    static let detetePostOfHiveOrHelp : String = "deleteHelpOrHivePostById"
    static let editHiveReqComment : String = "editHiveCommentById"
    static let deleteHiveReqComment : String = "deleteHiveCommentById"
    static let editUserHelpPost : String = "editUserHelpRequest"
    static let manageMyOrOtherHelpRequest : String = "manageMyOrOtherHelpRequest"
    static let getAllHelpRequestedUser : String = "GetAllHelpRequestedUser"
    static let getHelpReqDetails : String = "getHelpRequestById"
    static let doHelpForHelpPost : String = "userRequestForHelp"
    static let endHelpRequest: String = "endHelpRequest"
    static let getHivePostDetails : String = "getOrFilterAllHivePost"
    static let sendFirebaseMsg : String = "sendFirebaseMsg"

    // GetHiveList
    static let getHiveGroupList : String = "getHiveGroupList"
    static let joinGroupByUser : String = "joinGroupByUser"
    static let removeFromGroup : String = "removeFromGroup"


    

    
    // Chat
    static let getMyHelpReqListAtChat: String = "userHelpRequestChatList"
    static let getOtherHelpReqListAtChat: String = "otherHelpRequestChatList"
    static let getHelpReqUserListAtChat: String = "allTypeHelpRequestChatsById"
    static let getAllHelpedUserOnSelfPostAtChat: String = "getAllUserChatList"
    static let getAdminDetail : String = "getAdminDetail"


    // Karma Points
    static let getKrmPotsCatList: String = "getCategoryWithKarmaPoint"
    static let getKrmPotsActsList: String = "getKarmaPointActionData"
    static let createdOrCompletedHelpRequestKarmaPoint: String = "createdOrCompletedHelpRequestKarmaPoint"
    static let hiveContributionKarmaPoint: String = "hiveContributionKarmaPoint"

    //Edit
    static let editUserProfile:String = "editUserProfile"
    static let addAppLocation:String = "addAppLocation"
    
    //Report
    static let getReportListData:String = "getCommonScatData"
    static let addUserReport:String = "addUserReport"
    
    //Notification
    static let getNotificationList:String = "getNotificationList"
    static let changeNotificationStatus:String = "changeNotificationStatus"

     //LogOut
    static let userLogout:String = "userLogout"

    static let getUserHelpReqPost : String = "getOrFilterAllHelpRequest"
    
    //UserProfileVC
    static let getUserProfileDetail : String = "getUserProfileDetail"

    // GetKudosList
    static let getKudosList:String = "getCommonScatData"
    static let giveKudos : String = "likeAndUnlikeAnswer"
    static let getUserKudosWithCount: String = "getKudosCount"

    static let getUserKudosPost: String = "getUserKudosPost"
    static let readKudos: String = "readKudos"
    static let getKudosNotesList: String = "getKudosCommentList"


}


//============================
// MARK:- BaseURL combination
//============================
func BaseURL(url:String) -> String {
    return Service.Base_URL + url
}

func dictionaryConvertInString(params : Dictionary <String , String>?) -> NSMutableData {
    var postData = NSMutableData()
    for (key,value) in params! {
        if postData.length == 0{
            var str = "\(key)=\(value)"
            str = (str.replacingOccurrences(of: " ", with: "%20") as String?)!
            postData = NSMutableData(data: str.data(using: String.Encoding.utf8)!)
        }else{
            var str = "\(key)=\(value)"
            str = (str.replacingOccurrences(of: " ", with: "%20") as String?)!
            postData.append("&\(str)".data(using: String.Encoding.utf8)!)
        }
    }
    return postData
}

//======================================
// MARK:- Service Only For Google API
//=======================================
func serviceForGoogle(params : Dictionary <String , Any>?, service: String, callBack : @escaping (Any?, Bool) -> Void ){
    
    if isHaveNetowork() {
        //Request for Service
        var request = URLRequest(url: URL(string: service)!)
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        request.httpShouldHandleCookies = false
        request.timeoutInterval = 30
        request.httpMethod = "POST"
        let timeZone = NSTimeZone()
       // [request setValue:[[self class] getLocalTimeZone] forHTTPHeaderField:@"User-Time-Zone"];
       // request.setValue(timeZone.name, forHTTPHeaderField: "User-Time-Zone")

        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: params!, options: .prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
            request.httpBody = jsonData
            let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
            // here "decoded" is of type `Any`, decoded from JSON data
            
            // you can now cast it with the right type
            if let dictFromJSON = decoded as? [String:String] {
               // print(dictFromJSON)
            }
            request.httpBody = jsonData
        } catch {
            print(error.localizedDescription)
        }
        
        
        //Call Request
        RequestService(urlRequest: request, callBack:callBack)
    }else{
        ShowAlert(title: "Alert", message: "Please check your connection", controller: UIApplication.shared.keyWindow!.rootViewController!, cancelButton: nil, okButton: "Ok", style: .alert, callback: { (isOk, isCancel) in
            
        })
        killLoader()
    }
}

//==============================
// MARK:- Service without Image
//==============================
func ServerCommunicator(params : Dictionary <String , Any>?, service: String,  callBack : @escaping (Any?, Bool) -> Void ){
  
    //print(service)
    if isHaveNetowork() {
        
        //if showLoader { showLoader(view: nil) }
        
        //Request for Service
        var request = URLRequest(url: URL(string: BaseURL(url: service))!)
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        request.httpShouldHandleCookies = false
        request.timeoutInterval = 30
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        let timeZone = TimeZone.current.identifier
        request.setValue(TimeZone.current.identifier, forHTTPHeaderField: "User-Time-Zone")


    do {
        let jsonData = try JSONSerialization.data(withJSONObject: params!, options: .prettyPrinted)
        // here "jsonData" is the dictionary encoded in JSON data
        request.httpBody = jsonData
        let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
        // here "decoded" is of type `Any`, decoded from JSON data
        
        // you can now cast it with the right type
        if let dictFromJSON = decoded as? [String:String] {
            //print(dictFromJSON)
        }
        request.httpBody = jsonData
    } catch {
        print(error.localizedDescription)
    }
    
   
    //Call Request
          RequestService(urlRequest: request, callBack:callBack)
    }else{
        ShowAlert(title: "Alert", message: "Please check your connection", controller: UIApplication.shared.keyWindow!.rootViewController!, cancelButton: nil, okButton: "Ok", style: .alert, callback: { (isOk, isCancel) in
            
        })
        
        StartNetworkMonitoring()

        killLoader()
    }
}


//============================
// MARK:- Service with Image
//============================
func PostImageWithParams(parameters:[String:NSObject],service:String ,imgView:UIImageView, imageName:String, callBack:@escaping (Any?, Bool) -> Void ){
    
    if isHaveNetowork() {
        let body = NSMutableData()
        let BoundaryConstant = "----------V2ymHFg03ehbqgZCaKO6jy"
        let contentType = "multipart/form-data; boundary=\(BoundaryConstant)"
        
        for (key, value) in parameters {
            body.appendString(string: "--\(BoundaryConstant)\r\n")
            body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString(string: "\(value)\r\n")
        }
        
        //Convert Image to Data formate
        let imageData = UIImageJPEGRepresentation(imgView.image!, 1.0)
        
        //Convert imageData to Base64 in data formate, not in string formate
        let strBase64 = imageData?.base64EncodedData(options: .lineLength64Characters)
        
        if (imageData != nil) {
            body.appendString(string: "--\(BoundaryConstant)\r\n")
            body.appendString(string: "Content-Disposition: form-data; name=\"\(imageName)\"; filename=\"image.jpg\"\r\n")
            body.appendString(string: "Content-Type: image/jpeg\r\n\r\n")
            body.append(strBase64!)
            body.appendString(string: "\r\n")
        }
        body.appendString(string: "--\(BoundaryConstant)--\r\n")
        
        //Request for Service
        var request = URLRequest(url: URL(string: BaseURL(url: service))!)
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        request.httpShouldHandleCookies = false
        request.timeoutInterval = 30
        request.httpMethod = "POST"
        request.httpBody = body as Data
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        request.setValue("\(body.length)", forHTTPHeaderField: "Content-Length")
        
        //Request Service
          RequestService(urlRequest: request, callBack: callBack)
        
    }else{
       // showFCalert(title: "Warning", subtitle:"Please check your connection" , alertType: FCAlertType.FCAlertTypeCaution, buttonTitle: "Ok", otherButtons: [], view: windowController())
        
        ShowAlert(title: "Warning", message: "Please check your connection", controller: windowController(), cancelButton: "Ok", okButton: nil, style: .alert, callback: {_ in})
        killLoader()
    }
}


//========================
// MARK:- Request Service
//========================
func RequestService(urlRequest:URLRequest, callBack : @escaping (Any?, Bool) -> Void) {
    //Call service
    let  session = URLSession(configuration: URLSessionConfiguration.default)
    let task = session.dataTask(with: urlRequest) { data, response, error in
        
        if(error == nil){
        let errResponse: String = String(data:(data)!, encoding: String.Encoding.utf8)!
            NSLog("response = %@", errResponse)
        
        do {
            guard let result = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject] else {
                print("error trying to convert data to JSON")
                callBack(nil , true)
                return
            }
            
            // now we have the todo, let's just print it to prove we can access it
            //print("JSON_Response: " + result.description)
            callBack(result,false)
            // the result object can be dictionary or array
        }
        catch  {
            print("error trying to convert data to JSON")
            callBack(nil , true)
            return
        }
        }else{
            
            callBack(nil , true)
         
        }
        
        killLoader()
   }
    task.resume()
}

//=======================
// MARK:- Append String
//=======================
extension NSMutableData {
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
