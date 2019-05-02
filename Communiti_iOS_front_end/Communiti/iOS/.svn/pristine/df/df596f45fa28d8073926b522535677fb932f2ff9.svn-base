//
//  Global.swift
//  Swift_Demo
//
//  Created by Hemant Pandagre on 02/09/17.
//  Copyright © 2017 Hemant Pandagre. All rights reserved.
//

import Foundation
import UIKit
import ReachabilitySwift
//import FCAlertView



let KgooglePlaceAPIKey = "AIzaSyBCskeOBd72sFZjvK1LSHBfQb2DzcQrGdY"
//let KgoogleMapAPIKey = "AIzaSyBnc9omZcrDaVFC3G6W8s_HqzK2OCWMKuQ"
//let KgoogleMapAPIKey = "AIzaSyDQxMUTuibPQcxsri9FACN2mSUgQAr7N40"
let KgoogleMapAPIKey = "AIzaSyBEIRmg394K3PFBFWZ3SSxuDXpkkk1MmbA"


enum FCAlertType {
    case FCAlertTypeSuccess
    case FCAlertTypeWarning
    case FCAlertTypeCaution
    case FCAlertTypeProgress
}

// capitalization Of First Letter
extension String {
    func capitalizingFirstLetter() -> String {
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())
        return first + other
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }

}

extension UIImage {
    
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func resizedTo1MB() -> UIImage? {
        guard let imageData = UIImagePNGRepresentation(self) else { return nil }
        
        var resizingImage = self
        var imageSizeKB = Double(imageData.count) / 1000.0 // ! Or devide for 1024 if you need KB but not kB
        
        while imageSizeKB > 1000 { // ! Or use 1024 if you need KB but not kB
            guard let resizedImage = resizingImage.resized(withPercentage: 0.9),
                let imageData = UIImagePNGRepresentation(resizedImage)
                else { return nil }
            
            resizingImage = resizedImage
            imageSizeKB = Double(imageData.count) / 1000.0 // ! Or devide for 1024 if you need KB but not kB
        }
        
        return resizingImage
    }
}

private struct AssociatedKeys {
    static var section = "section"
}
extension UIButton {
    var section : Int {
        get {
            guard let number = objc_getAssociatedObject(self,   &AssociatedKeys.section) as? Int else {
                return -1
            }
            return number
        }
        
        set(value) {
            objc_setAssociatedObject(self,&AssociatedKeys.section,Int(value),objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

extension UIViewController {
    
    func showToast(message : String , width : CGFloat ) {
        let toastLabel = UILabel(frame: CGRect(x: (self.view.frame.size.width/2) - (width/2), y: self.view.frame.size.height-100, width: width, height: 45))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = Font.LucidaSans(fontSize: 13.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        toastLabel.numberOfLines = 0
        windowController().view.addSubview(toastLabel)
        UIView.animate(withDuration: 5.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    
    func showToastForMoreData(message : String , width : CGFloat ) {
        
        DispatchQueue.main.async {
               let toastLabel = UILabel(frame: CGRect(x: (self.view.frame.size.width/2) - (width/2), y: self.view.frame.size.height-100, width: width, height: 35))
            toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            toastLabel.textColor = UIColor.white
            toastLabel.textAlignment = .center;
            toastLabel.font = Font.LucidaSans(fontSize: 13.0)
            toastLabel.text = message
            toastLabel.alpha = 1.0
            toastLabel.layer.cornerRadius = 10;
            toastLabel.clipsToBounds  =  true
            toastLabel.numberOfLines = 0
            windowController().view.addSubview(toastLabel)
            UIView.animate(withDuration: 2.0, delay: 0.1, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }, completion: {(isCompleted) in
                toastLabel.removeFromSuperview()
            })
        }
        
     
  
    }
    
}


//============================
//MARK:- Save Img Into Cach
//============================
var queue = OperationQueue()

func saveImgIntoCach( strImg : String , imageView : UIImageView){
    
    queue.addOperation { () -> Void in
           DispatchQueue.main.async{
         imageView.image = UIImage(named: "helpPost_Defalt");
      }
            let imgUrl = URL(string:strImg)

       
        
        let img = ImageCaching.sharedInterface().getImage(imgUrl?.absoluteString)
        if((img) != nil){
            DispatchQueue.main.async {
                imageView.image = img
            }
        }else{
            
           // DispatchQueue.global(qos: .background).async {
                if (imgUrl != nil){
                    
                    if  let data = try? Data(contentsOf: imgUrl!){//make sure your
                        let image = UIImage(data: data)
                        OperationQueue.main.addOperation({
                            if((image) != nil){
                                imageView.image = image
                                ImageCaching.sharedInterface().setImage(image, withID: imgUrl?.absoluteString)
                            }
                        })
                        
//                        DispatchQueue.main.async {
//                            if((image) != nil){
//                                imageView.image = image
//                                ImageCaching.sharedInterface().setImage(image, withID: imgUrl?.absoluteString)
//                            }
//                        }
                    }else{
                        DispatchQueue.main.async{
                         imageView.image = UIImage(named: "helpPost_Defalt");
                        }
                    }
                }
            //}
        }
        
     
    }
    
    
    
}
//=====================================
//MARK:- Google Analytics Methods
//=====================================

func btnClickEvent(caregoryNm : String , action : String , label : String){
    
    let tracker = GAI.sharedInstance().defaultTracker
    tracker?.send(GAIDictionaryBuilder.createEvent(withCategory: caregoryNm, action: action, label: label == "" ? nil : label, value: nil).build() as [NSObject : AnyObject])

}

//============================
//MARK:- UserDefalt
//============================
func setDataInUserDefalt( key : String , userData : Any){
    
    let userDefaults = UserDefaults.standard
    userDefaults.setValue(userData, forKey: key)
    userDefaults.synchronize() // don't forget this!!!!
  }

   func getDataInUserDefalt(key : String) -> Any{
       let userDefaults = UserDefaults.standard
       return userDefaults.value(forKey:key) as Any
    }


//============================
//MARK:- AppDelegate Object
//============================
    func APP_Delegate() -> AppDelegate{
        return UIApplication.shared.delegate as! AppDelegate
    }



let reachability = Reachability()!
var isNetwork = Bool()
//====================
//MARK:- Convert Date
//====================
func showDate( timeInterval : String) -> String{
    let date = NSDate(timeIntervalSince1970: (Double(timeInterval)!))
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM dd"
    let strDate = dateFormatter.string(from: date as Date)
    //print("Date = " , strDate)
    return strDate
}



func convertDateInUTCFormate( timeInterval : String) -> String{
    let date = NSDate(timeIntervalSince1970: (Double(timeInterval)!))
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd MMM yyyy, h:mm a"
    dateFormatter.amSymbol = "AM"
    dateFormatter.pmSymbol = "PM"
    let strDate = dateFormatter.string(from: date as Date)
   // print("Date = " , strDate)
    return strDate
}


func convertDateForFirebaseInUTC(date : Date) -> String{
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
    dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
    return  dateFormatter.string(from: date)
}

func dateWithComparisonDate(strDate : String) -> String{
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
    dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
    let enteredDate = dateFormatter.date(from: strDate)
    
  
    let calender = Calendar.current
    let otherDay = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: enteredDate!)
    let today = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: Date())

    if(today.day == otherDay.day && today.month == otherDay.month && today.year == otherDay.year && today.era == otherDay.era && today.day == otherDay.day && today.day == otherDay.day){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        let display = dateFormatter.string(from: enteredDate!)
        return String(format: "%@", display)
    }else{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        let display = dateFormatter.string(from: enteredDate!)
        return String(format: "%@", display)
        // return dateFormateChange(dateString: strDate)
    }
}


func dateFormateChange(dateString : String) -> String{
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
    dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
    let date = dateFormatter.date(from: dateString)
    
    dateFormatter.dateFormat = "EEE-MMM-dd, HH:mm"
    dateFormatter.timeZone = NSTimeZone.local
    return dateFormatter.string(from: date!)
    
}




func dateFormateWithoutTime( timeInterval : String) -> String{
    let date = NSDate(timeIntervalSince1970: (Double(timeInterval))!)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd MMM yyyy"
    let strDate = dateFormatter.string(from: date as Date)
    //print("Date = " , strDate)
    return strDate
}


func comparedateWithCurrentDate(timeInterval : String) -> String{
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "dd MMM yyyy"
    let sysDate = formatter.string(from: date)
    
    let secoundDate = dateFormateWithoutTime(timeInterval: timeInterval)
    
    switch sysDate.compare(secoundDate) {
    case .orderedAscending     :  return("orderedAscending")
    case .orderedDescending    :  return("orderedDescending")
    case .orderedSame          :  return("orderedSame")
    }
 
}

func convertSystemDateIntoLocalTimeZone(date : Date) -> String {
    
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd 00:00:00"
  //  formatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
    formatter.timeZone = TimeZone.current
    let result = formatter.string(from: date)

    return result
    
}

func convertSystemDateIntoLocalTimeZoneWithStaticTime(date : Date) -> String {
    
//    let formatter = DateFormatter()
//    formatter.dateFormat = "yyyy-MM-dd'T'23:59:59"
//    formatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
//    let result = formatter.string(from: date)
//
//    let formatter3 = DateFormatter()
//    formatter3.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
//    let date2 = formatter3.date(from: result)
//
//
//    let formatter2 = DateFormatter()
//    formatter2.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
//    formatter2.timeZone = NSTimeZone(name: "UTC")! as TimeZone
//    let strr = formatter2.string(from: date2!)
//    let timestamp = (date2?.timeIntervalSince1970)
//    let date = Date(timeIntervalSince1970: timestamp!)

//    
//    let sourceDate = date
//    let sourceTimeZone = NSTimeZone(abbreviation: "GMT")
//    let destinationTimeZone = TimeZone.current
//    let sourceGMTOffset = sourceTimeZone?.secondsFromGMT(for: sourceDate)
//    let destinationGMTOffset = destinationTimeZone.secondsFromGMT(for: sourceDate)
//    let interval =  destinationGMTOffset - sourceGMTOffset!
//    let destinationDate = Date.init(timeInterval: TimeInterval(interval), since: sourceDate)
    
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone.current
        let strDate = formatter.string(from: date)
    
//
//    let formatter1 = DateFormatter()
//    formatter1.dateFormat = "yyyy-MM-dd'T'23:59:59"
//    let result1 = formatter1.string(from: destinationDate)
//    
//    //let date1 = formatter1.date(from: result1)
//
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "yyyy-MM-ddT23:59:59"
//  //  dateFormatter.timeZone =  TimeZone.current
//    let date = dateFormatter.date(from: result1)
//    
//    let formatter2 = DateFormatter()
//    formatter2.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
//    formatter2.timeZone = NSTimeZone(name: "UTC")! as TimeZone
//    let fdf = formatter2.date(from: result1)
//    let result2 = formatter2.string(from: destinationDate)
    return strDate
    
}

func getDate(localDate: Date) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd 00:00:00 +000"
    dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT")! as TimeZone
    let startDate2 = dateFormatter.string(from: localDate)
    print(startDate2)
    
    let dateFormatter1 = DateFormatter()
    dateFormatter1.dateFormat = "yyyy-MM-dd 00:00:00 +000"
    dateFormatter1.timeZone = NSTimeZone(abbreviation: "GMT")! as TimeZone
    let startDate21 = dateFormatter1.date(from: startDate2)
    print(startDate21)
    
    return startDate21!
}

func datedifference(timeInterval : String , timeZone : String) -> String{ // which date small of big
    
    let sourceTimeZoneGMT = NSTimeZone(abbreviation: "GMT")
    let destinationTimeZoneGMT = TimeZone.current
    let sourceGMTOffsetGMT = sourceTimeZoneGMT?.secondsFromGMT(for: Date())
    let destinationGMTOffsetGMT = destinationTimeZoneGMT.secondsFromGMT(for: Date())
    let intervalGMT =  destinationGMTOffsetGMT - sourceGMTOffsetGMT!
    let currentDate = Date.init(timeInterval: TimeInterval(intervalGMT), since: Date())

    
    
    
    let sourceDate1 = NSDate(timeIntervalSince1970:Double(timeInterval)!)
    let sourceTimeZone1 = NSTimeZone(abbreviation: "GMT")
    var destinationTimeZone1 : TimeZone!
    if(timeZone == ""){
         destinationTimeZone1 = TimeZone.current
    }else{
         destinationTimeZone1 = TimeZone.init(identifier: timeZone)
    }
    let sourceGMTOffset1 = sourceTimeZone1?.secondsFromGMT(for: sourceDate1 as Date)
    let destinationGMTOffset1 = destinationTimeZone1?.secondsFromGMT(for: sourceDate1 as Date)
    let interval1 =  destinationGMTOffset1! - sourceGMTOffset1!
    let destinationDate = Date.init(timeInterval: TimeInterval(interval1), since: sourceDate1 as Date)
    
   
     print(getDate(localDate: currentDate))
     print(getDate(localDate: destinationDate))
    
    let startDate = getDate(localDate: currentDate)
    let endDate = getDate(localDate: destinationDate)
 
    print(startDate)
    print(endDate)
    
    let dateCompaire = startDate.compare(endDate)
    print(dateCompaire)
        switch dateCompaire  {
        case .orderedAscending:
            //print("\(secoundDate!) is after \(firstDate!)")
            return("Big")
        case .orderedDescending:
            //print("\(secoundDate!) is before \(firstDate!)")
            return("Small")
        default:
            // print("\(secoundDate!) is the same as \(firstDate!)")
            return("Same")
        }
    
}



func mergedDate(date : Date , time : Date) -> Date{
    if(date.description != " " && time.description != " "){
        let gregorian = Calendar.init(identifier: .gregorian)
        let unitFlagsDate: Set<Calendar.Component> = [.year, .month, .day]
        var dateComponents = gregorian.dateComponents(unitFlagsDate, from: date)
        let unitFlagsTime: Set<Calendar.Component> = [.hour, .minute, .second]
        var timeComponents = gregorian.dateComponents(unitFlagsTime, from: time)
        timeComponents.timeZone = TimeZone.init(secondsFromGMT: 0)
        dateComponents.second = timeComponents.second
        dateComponents.hour = timeComponents.hour
        dateComponents.minute = timeComponents.minute
       // dateComponents.timeZone = TimeZone.init(secondsFromGMT: 0)
        let combDate = gregorian.date(from: dateComponents)
        return combDate!
    }
    return date
}

func currentMergedDate(date : Date , time : Date) -> Date{
   
    if(date.description != " " && time.description != " "){
        let gregorian = Calendar.init(identifier: .gregorian)
        let unitFlagsDate: Set<Calendar.Component> = [.year, .month, .day]
        var dateComponents = gregorian.dateComponents(unitFlagsDate, from: date)
       //   let unitFlagsTime: Set<Calendar.Component> = [.hour, .minute, .second]
      //  var timeComponents = gregorian.dateComponents(unitFlagsTime, from: time)
        dateComponents.second = -10
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.timeZone = TimeZone.init(secondsFromGMT: 0)
        let combDate = gregorian.date(from: dateComponents)
        return combDate!
    }
    return date
}


    
    func compareOfTodayAndYesterday(dateString : String) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        let serverDate = dateFormatter.date(from: dateString)
        
        dateFormatter.dateFormat = "EEE-MMM-dd, HH:mm"
        dateFormatter.timeZone = NSTimeZone.local
        
        
        let sysDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        
        let order = Calendar.current.compare(sysDate, to: serverDate!, toGranularity: .day)
        
        switch order {
        case .orderedAscending:
            //print("\(serverDate!) is after \(sysDate)")
            return("Big")
        case .orderedDescending:
            //print("\(serverDate!) is before \(sysDate)")
            return("Small")
        default:
           // print("\(serverDate!) is the same as \(sysDate)")
            return("Today")
        }
    }

func dayDifference(dateString : String) -> String
{
    let calendar = NSCalendar.current
   // let date = Date(timeIntervalSince1970: TimeInterval(interval))
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
    dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
    let date = dateFormatter.date(from: dateString)
    if calendar.isDateInYesterday(date!) { return "Yesterday" }
    else if calendar.isDateInToday(date!) { return "Today" }
    else if calendar.isDateInTomorrow(date!) { return "Tomorrow" }
    else {
        
        dateFormatter.dateFormat = "MMM d yyyy"
        dateFormatter.timeZone = NSTimeZone.local
        let timeStamp = dateFormatter.string(from: date!)
        return timeStamp
    }
}
    

func dayDifference(unixTimestamp : String) -> String // For Kudos Notes 
{
    let dateFormatter = DateFormatter()
    let date = Date(timeIntervalSince1970: Double(unixTimestamp)!)
    dateFormatter.dateFormat = "d MMMM,yyyy"
    dateFormatter.timeZone = NSTimeZone.local
    let strDate = dateFormatter.string(from: date)
     return strDate
//    if calendar.isDateInYesterday(date) { return "Yesterday, \(strDate)"}
//    else if calendar.isDateInToday(date) { return "Today, \(strDate)"}
//    else if calendar.isDateInTomorrow(date) { return "Tomorrow, \(strDate)"}
//    else {
//        return strDate
//    }
}


func dateFormateWithMonthandDay(timeInterval : String)-> String{
    let date = NSDate(timeIntervalSince1970: (Double(timeInterval)!))
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd MMMM"
    dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT")! as TimeZone
    let strDate = dateFormatter.string(from: date as Date)
   // print("Date = " , strDate)
    return strDate
}


 //===========================
 // MARK:- Network Monitoring
 //===========================
     func StartNetworkMonitoring() -> Void {
        reachability.whenReachable = { reachability in
            DispatchQueue.main.async {
                isNetwork = true
                if reachability.isReachableViaWiFi {
                    print("Reachable via WiFi")
                } else {
                    print("Reachable via Cellular")
                }
                
                
                if (UserDefaults.standard.bool(forKey: "isLoggedIn")){
                   // NotificationCentreClass.fireHelpedUserlistAtChatNotifier()
                }
            }
         }
        reachability.whenUnreachable = { reachability in
            DispatchQueue.main.async {
                isNetwork = false
                print("Not reachable")
            }
        }
     
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
     }
     
     func StopNetowrkMonitoring() -> Void {
          reachability.stopNotifier()
     }
     
     
     func isHaveNetowork() -> Bool {
          return isNetwork
     }


func setUserData (userData : [String : Any]){
    let userDefaults = UserDefaults.standard
    userDefaults.setValue(userData, forKey: "userDetails")
    userDefaults.synchronize() // don't forget this!!!!
}


func getUserData() -> [String : Any]{
    let userDefaults = UserDefaults.standard
    return userDefaults.value(forKey: "userDetails") as! [String : Any]
}




//====================
//MARK:- Show Alert
//====================
func ShowAlert(title:String? , message:String?,controller:UIViewController, cancelButton:NSString?, okButton:NSString?, style:UIAlertControllerStyle, callback:@escaping(Bool, Bool) -> Void){
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title:title, message:message, preferredStyle: style)
            
            
            //Tap on Cancel button
            if (cancelButton != nil) {
                alert.addAction(UIAlertAction(title:cancelButton! as String, style: UIAlertActionStyle.cancel, handler:{ action in
                    callback(true,false)
                }))
            }
            
            //Tap on Ok button
            if (okButton != nil) {
                alert.addAction(UIAlertAction(title:okButton! as String, style: UIAlertActionStyle.default, handler: { action in
                    callback(false,true)
                }))
            }
            controller.present(alert, animated: true, completion: nil)
        }
    }


func ShowError(message:String, controller:UIViewController) -> Void {
    ShowAlert(title: nil, message: message, controller: controller, cancelButton: "OK", okButton:nil,style:UIAlertControllerStyle.alert, callback:{_ in})
    //killLoader()
}

/*
//====================
//MARK:- Loader
//====================
var loader : LoaderVw?
    func showLoader() -> Void {
         DispatchQueue.main.async {
            loader = LoaderVw.init(nibName: "LoaderVw", bundle: nil)
            loader?.view.frame = UIScreen.main.bounds
            windowController().view.addSubview(loader!.view)
        }
    }

    func killLoader() -> Void {
        DispatchQueue.main.async {
            if (loader != nil){
                loader!.view.removeFromSuperview()
                loader = nil
            }
        }
    }
*/
//=======================
//MARK:- Email Validation
//=======================
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with:testStr)
    }


//==========================
//MARK:- Password Validation
//==========================
func isValidPassword(_ password : String) -> Bool{
    let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[0-9])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
    return passwordTest.evaluate(with: password)
}


//==========================
//MARK:- PhoneNumber Validation
//==========================
func isValidPhoneNumber(_ PhoneNumber : String) -> Bool{
    let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
    let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
    let result =  phoneTest.evaluate(with: PhoneNumber)
    return result
}


//==========================
//MARK:- UserName Validation
//==========================
func isValidUsername(Input:String) -> Bool {
    let RegEx = "\\A\\w{4,12}\\z"
    let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
    return Test.evaluate(with: Input)
}


//========================
//MARK:- Window Controller
//========================
    func windowController() -> UIViewController {
        return  (UIApplication.shared.keyWindow?.rootViewController as! UINavigationController)
    }

//================================================
//MARK:- Move To Login Screen When Session Expire
//================================================
func moveforLoginWhenSeccionExpire(controller : UIViewController){
     APP_Delegate().isPopForLogin = true
     UserDefaults.standard.removeObject(forKey: "isLoggedIn")
     UserDefaults.standard.removeObject(forKey: "TotalKMPoints")
    //controller.navigationController?.popViewController(animated: false)
     controller.navigationController?.popToRootViewController(animated: false)
     //ShowError(message: "Your session has timed out, please login again.", controller: windowController())
}

func moveforLoginWhenBlocked( title:String ,controller : UIViewController){
    APP_Delegate().isPopForLogin = true
    controller.navigationController?.popToRootViewController(animated: false)
    APP_Delegate().showBlockPopup(title: title, controller: controller)
}

//====================
//MARK:- Add Shadow
//====================
func dropShadow(view : UIView,color: UIColor, opacity: Float, offSet: CGSize, shadowRadius: CGFloat,round :Bool) {
    view.layer.cornerRadius = view.bounds.width/2
    view.layer.shadowColor = color.cgColor
    view.layer.shadowOpacity = opacity
    view.layer.shadowRadius = shadowRadius
    view.layer.shadowOffset = offSet
    view.layer.masksToBounds = false
}


//====================
//MARK:- Add border
//====================
    func addBorder(objct:AnyObject,color:UIColor, width:CGFloat, cornerRadius:CGFloat ) -> Void {
        
        //for UIView
        if objct is UIView{
            (objct as! UIView).layer.borderColor = color.cgColor
            (objct as! UIView).layer.borderWidth = width
            (objct as! UIView).layer.cornerRadius = cornerRadius
            (objct as! UIView).clipsToBounds = true
        }
        
        //for UIButton
        if objct is UIButton{
            (objct as! UIButton).layer.borderColor = color.cgColor
            (objct as! UIButton).layer.borderWidth = width
            (objct as! UIButton).layer.cornerRadius = cornerRadius
            (objct as! UIButton).clipsToBounds = true
        }
        
        //for UILabel
        if objct is UILabel{
            (objct as! UILabel).layer.borderColor = color.cgColor
            (objct as! UILabel).layer.borderWidth = width
            (objct as! UILabel).layer.cornerRadius = cornerRadius
            (objct as! UILabel).clipsToBounds = true
        }
        
        //for UIImageView
        if objct is UIImageView{
            (objct as! UIImageView).layer.borderColor = color.cgColor
            (objct as! UIImageView).layer.borderWidth = width
            (objct as! UIImageView).layer.cornerRadius = cornerRadius
            (objct as! UIImageView).clipsToBounds = true
        }
    }



//====================
//MARK:- Gradient
//====================
func addGradient(objct:Any, cornerRadius:CGFloat) -> Void {
        let gradient = CAGradientLayer()
        gradient.colors = [color(red: 240, green: 178, blue: 41), color(red: 237, green: 137, blue: 75)]
        gradient.cornerRadius = cornerRadius;
        gradient.masksToBounds = false;
        
        
        //for UIView
        if objct is UIView{
            gradient.frame = (objct as! UIView).bounds
            (objct as! UIView).layer.insertSublayer(gradient, at: 0)
            
        }
        
        //for UIButton
        if objct is UIButton{
            gradient.frame = (objct as! UIButton).bounds
            (objct as! UIButton).layer.insertSublayer(gradient, at: 0)
        }
        
        //for UILabel
        if objct is UILabel{
            gradient.frame = (objct as! UILabel).bounds
            (objct as! UILabel).layer.insertSublayer(gradient, at: 0)    }
        
        //for UIImageView
        if objct is UIImageView{
            gradient.frame = (objct as! UIImageView).bounds
            (objct as! UIImageView).layer.insertSublayer(gradient, at: 0)
        }
        
    }

//====================
//MARK:- Color 
//====================

    func theamColor(red:Float,green:Float,blue:Float) -> UIColor {
    let color = UIColor.init(colorLiteralRed: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1)
    return color 
    }

  func progressBarColor() -> UIColor{
    let color = UIColor.init(colorLiteralRed: 70/255.0, green: 174/255.0, blue: 79/255.0, alpha: 1)

    return color
  }

func color(red:Float,green:Float,blue:Float) -> CGColor {
    let color = UIColor.init(colorLiteralRed: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1)
    return color.cgColor as CGColor
}
func createProgressBar(idx : CGFloat , viewController : UIViewController){
    
    let label = UILabel(frame: CGRect(x: 0, y: 63, width: (UIScreen.main.bounds.size.width)/idx, height: 5))
    label.text = ""
    label.clipsToBounds = true;
    label.backgroundColor = progressBarColor()
    viewController.view.addSubview(label)
}


//====================
//MARK:- Loader
//====================
var loader_View : LoaderView!

func showLoader(view : UIView){
    
    if (loader_View == nil) {
        loader_View = LoaderView.instanceFromNib() as! LoaderView;
        loader_View.frame = CGRect(x: 0, y: 20, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 80)
    }
    showLoaderWithAnimation(view: loader_View)
    windowController().view.addSubview(loader_View)

}

func killLoader(){
    if(loader_View != nil){
        DispatchQueue.main.async(execute: {
            killLoaderWithAnimation(view : loader_View)
        })
    }
}


func showLoaderWithAnimation(view : LoaderView){
    view.isHidden=false;
    view.transform = CGAffineTransform(scaleX: 1, y: 1)
    view.alpha = 0.0
    
    UIView.animate(withDuration: 0.1,
                   delay: 0.1,
                   options: UIViewAnimationOptions.curveEaseIn,
                   animations: { () -> Void in
                    
                    view.alpha = 1.0
                    view.transform = CGAffineTransform(scaleX:1, y: 1)
                    
    }, completion: { (finished) -> Void in
        // ....
    })
}

func killLoaderWithAnimation(view : UIView){
    
    UIView.animate(withDuration: 0.1,
                   delay: 0.1,
                   options: UIViewAnimationOptions.curveEaseIn,
                   animations: { () -> Void in
                    view.alpha = 0;
                    view.transform = CGAffineTransform(scaleX: 1, y: 1)
                    
    }, completion: { (finished : Bool) -> Void in
        if(finished){
            view.removeFromSuperview()
        }
    })
}

var slidevw : SliderView!

func showSlideView (callBack : @escaping (String) -> Void ){
    
     if slidevw == nil {
        slidevw = SliderView.instanceFromNib() as! SliderView;
        slidevw.frame = UIScreen.main.bounds;
        
        slidevw.bg_View.frame = CGRect(x: UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        slidevw.setUpOfTableview()
        windowController().view.addSubview(slidevw)
        slidevw.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        UIView.animate(withDuration: 0.12,
                       delay: 0.0,
                       options: UIViewAnimationOptions.curveEaseIn,
                       animations: { () -> Void in
                        
                        slidevw.backgroundColor = UIColor(white: 0.0, alpha: 0.6)
                        slidevw.bg_View.frame = CGRect(x: slidevw.frame.size.width/2, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }, completion: { (finished) -> Void in

        })
        
      
           //Handle Click Action Of Side View
            slidevw.onHideComplete = {(result : String) -> Void in
              callBack(result)
            }
        }
   }


func removeSideView(){
    if slidevw != nil {
        slidevw.backgroundColor = UIColor(white: 0.0, alpha: 0.6)// remove side view
        UIView.animate(withDuration:  0.15,
                       delay: 0.0,
                       options: UIViewAnimationOptions.curveEaseIn,
                       animations: { () -> Void in
                        slidevw.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
                        slidevw.bg_View.frame = CGRect(x: UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }, completion: { (finished) -> Void in
            if (slidevw != nil){
                slidevw.removeFromSuperview()
                slidevw = nil
            }  
        })
    }
}


enum KudosType : Int  {
    case Funny = 21
    case Inspiring
    case Researched
    case Helpful
    case Creative
}

//==============================
// MARK:- Get Task Status Image
//==============================
func KudosTypeAndImage(kudosTyp : KudosType , isSmall : Bool) -> (String, UIImage){
    switch kudosTyp {
    case .Funny:
        return ( "Funny",( isSmall ? UIImage(named: "small_Funny")! : UIImage(named: "funny_Selected")!))
    case .Inspiring:
        return ( "Inspiring", (isSmall ?  UIImage(named: "small_Inspiring")! :  UIImage(named: "Inspiring_Selected")!))
    case .Researched:
        return ( "Researched", (isSmall ? UIImage(named: "small_Researched")! : UIImage(named: "Researched_Selected")!))
    case .Helpful:
        return ( "Helpful", (isSmall ? UIImage(named: "small_Helpful")! : UIImage(named: "healpful_Selected")!))
    case .Creative:
        return ( "Creative", (isSmall ?  UIImage(named: "small_Creative")! :  UIImage(named: "creative_Selected")!))
    default: break
        
    }
}



//==============================
// MARK:- Get Task Status Image
//==============================
func KudosTypeAndImageAtNoti(kudosTyp : KudosType , isSmall : Bool) -> (String, UIImage){
    switch kudosTyp {
    case .Funny:
        return ( "Funny", UIImage(named: "funny_brown")!)
    case .Inspiring:
        return ( "Inspiring", UIImage(named: "Inspiration_brown")!)
    case .Researched:
        return ( "Researched",  UIImage(named: "Research_brown")!)
    case .Helpful:
        return ( "Helpful",  UIImage(named: "helpful_brown")!)
    case .Creative:
        return ( "Creative",  UIImage(named: "Creative_brown")!)
    default: break
        
    }
}


















