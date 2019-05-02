//
//  CountryList.swift
//  Community
//
//  Created by Hatshit on 09/12/17.
//  Copyright © 2017 Hatshit. All rights reserved.
//

import UIKit
import ObjectMapper

class CountryList: NSObject, Mappable {

    // for Get Country List in WelCome Screen
    
    var isFirst:Bool?
    var loc_country:String?
    var loc_country_code:String?
    var loc_createdate:String?
    var loc_id:String?
    var loc_name:String?
    var loc_updatedate:String?
    
    
    //for Get Main Category List in AddReguestVC
    var cat_description:String?
    var cat_id:String?
    var cat_image:String?
    var cat_name:String?
        var grp_description:String?
        var grp_id:String?
        var grp_image:String?
        var grp_title:String?
        var pst_count:String?
        var usr_count:String?
        var usr_join:String?

    
    
    var scat_description:String?// common for for get User HiveReq All Post in TabbarVC

    var scat_id:String?
    var scat_image:String?
    var scat_title:String?
   
    
    //for Get User TagList in AddTagVC
    var htag_id:String?
    var htag_text:String?
    

    // for get User HiveReq All Post in TabbarVC
    var profile_image:String?
    var pst_completed:String?
    var pst_createdate:String?
    var pst_description:String?
    var pst_id:String?
    var pst_title:String?
    var pst_updatedate:String?
    var replies_count:String?
    var upvote_count:String?
    var usr_fname:String?
    var usr_id:String?
    var usr_lname:String?
    var usr_upvote:String?
    var tags:[Tags]?
    
    

    
    // for get User HelpReq All Post in TabbarVC
    var help_usrs:[UserListModel]?
    var pext_date:String?
    var pext_lat:String?
    var pext_location:String?
    var pext_long:String?
    var pext_type:String?
    var chat_report:String?
    var pext_timeZone : String?
   // var pst_completed:String?
    //var pst_createdate:String?
    //var pst_description:String?
    //var pst_title:String?
   // var pst_updatedate:String?
   // var scat_description:String?
    //var scat_title:String?
    //var usr_id:String?
    var subCat_icon:String?

    var usr_request:String?
   // var tags:[Tags]?
    

    
    // for get User HiveReq All Post Comments in PostVC
    var ans_createdate:String?
    var ans_description:String?
    var ans_id:String?
    var ans_ntfy_id:String?
    var gta_ntfy_id : String?
    var ans_updatedate:String?
    var count_upvote:String?
    var kudos:String?
    var user_upvote:String?
    var kd_id : String?
    var kd_title  :String?
    var kd_count: String?
    var kd_isRead: String?

    
    
    var data: [ChatHomeDataModel]?
    var total_count: String?

   //For KrmPotsByCatVC
    var Count: String?
    var cat: String?
    
    //For ComplteredHRVC
    var points: String?
    var pst_isDeleted : String?

    
    // For Repost
    var usr_report : String?

    
    // Notification
    
    var gta_kd_id:String?

    var ntfy_createdate:String?
    var ntfy_from:String?
    var ntfy_id:String?
    var ntfy_isRead:String?
    //var ntfy_message:String?
    var ntfy_pst_type:String?
    // var ntfy_pst_id:String?
    var ntfy_to:String?
    var ntfy_type:String?
    var ntfy_updatedate:String?
    
    var pst_crtr_name:String?
    //var pst_id:String?
    var pst_loc_id:String?
    var pst_ans_dscptn:String?
    var pst_crtr_id:String?
    //var usr_fname:String?
    var usr_usrname : String?
    

    //For Kudos
    var scat_icon:String?

//    //For Thank ypu notes
    var gta_id:String?
    var kd_createdate:String?
    var kd_note : String?
    var kd_description : String?

    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        // for Get Country List in WelCome Screen
        loc_country     <- map["loc_country"]
        loc_country_code     <- map["loc_country_code"]
        loc_createdate  <- map["loc_createdate"]
        loc_id  <- map["loc_id"]
        loc_name  <- map["loc_name"]
        loc_updatedate  <- map["loc_updatedate"]
        
        //for Get Main Category List in AddReguestVC
        cat_description  <- map["cat_description"]
        cat_id  <- map["cat_id"]
        cat_image  <- map["cat_image"]
        cat_name  <- map["cat_name"]
        
        //for Get Sub Category List in CategoryVC

        
                scat_description  <- map["scat_description"]
                scat_id  <- map["scat_id"]
                scat_image  <- map["scat_image"]
                scat_title  <- map["scat_title"]
        
        
        grp_description  <- map["grp_description"]
        grp_id  <- map["grp_id"]
        grp_image  <- map["grp_image"]
        grp_title  <- map["grp_title"]
        pst_count  <- map["pst_count"]
        usr_count  <- map["usr_count"]
        usr_join  <- map["usr_join"]
        
        //for Get User TagList in AddTagVC
        htag_id  <- map["htag_id"]
        htag_text  <- map["htag_text"]
        
        // for get User HiveReq All Post in TabbarVC
        
        profile_image     <- map["profile_image"]
        pst_completed  <- map["pst_completed"]
        pst_createdate  <- map["pst_createdate"]
        pst_description  <- map["pst_description"]
        pst_id  <- map["pst_id"]
        pst_title     <- map["pst_title"]
        pst_updatedate  <- map["pst_updatedate"]
        replies_count  <- map["replies_count"]
        pst_description  <- map["pst_description"]
       // scat_title  <- map["scat_title"]
        tags <- map["tags"]
        upvote_count     <- map["upvote_count"]
        usr_fname  <- map["usr_fname"]
        usr_id  <- map["usr_id"]
        usr_lname  <- map["usr_lname"]
        usr_upvote  <- map["usr_upvote"]
        
        
        // for get User HelpReq All Post in TabbarVC
        help_usrs  <- map["help_usrs"]
        pext_date  <- map["pext_date"]
        pext_lat     <- map["pext_lat"]
        pext_location  <- map["pext_location"]
        pext_long  <- map["pext_long"]
        pext_type  <- map["pext_type"]
        usr_id  <- map["usr_id"]
        usr_request  <- map["usr_request"]
        subCat_icon  <- map["subCat_icon"]
        chat_report  <- map["chat_report"]
        pext_timeZone  <- map["pext_timeZone"]


          
        // for get User HiveReq All Post Comments in PostVC
        ans_createdate     <- map["ans_createdate"]
        ans_ntfy_id     <- map["ans_ntfy_id"]
        gta_ntfy_id     <- map["gta_ntfy_id"]
        ans_description  <- map["ans_description"]
        ans_id  <- map["ans_id"]
        ans_updatedate  <- map["ans_updatedate"]
        count_upvote  <- map["count_upvote"]
        kudos  <- map["kudos"]
        kd_id  <- map["kd_id"]
        kd_title  <- map["kd_title"]
        kd_count  <- map["kd_count"]
        kd_isRead  <- map["kd_isRead"]

        user_upvote  <- map["user_upvote"]
        
        data  <- map["data"]
        total_count  <- map["total_count"]
        
        //For KrmPotsByCatVC
        Count  <- map["Count"]
        cat  <- map["cat"]

        //For ComplteredHRVC
        points  <- map["points"]
        pst_isDeleted  <- map["pst_isDeleted"]
        
        usr_report  <- map["usr_report"]

        
        //For Notification
        gta_kd_id  <- map["gta_kd_id"]
        ntfy_createdate  <- map["ntfy_createdate"]
        ntfy_from  <- map["ntfy_from"]
        ntfy_id  <- map["ntfy_id"]
        ntfy_isRead  <- map["ntfy_isRead"]
        //ntfy_message  <- map["ntfy_message"]
        ntfy_pst_type  <- map["ntfy_pst_type"]
        //ntfy_pst_id  <- map["ntfy_pst_id"]
        ntfy_to  <- map["ntfy_to"]
        ntfy_type  <- map["ntfy_type"]
        ntfy_updatedate  <- map["ntfy_updatedate"]
        
        pst_crtr_name  <- map["pst_crtr_name"]
        //ntfy_pst_id  <- map["ntfy_pst_id"]
        pst_loc_id  <- map["pst_loc_id"]
        pst_ans_dscptn  <- map["pst_ans_dscptn"]
        pst_crtr_id  <- map["pst_crtr_id"]
        usr_usrname  <- map["usr_usrname"]

        //For Kudos
        scat_icon  <- map["scat_icon"]

       //For Thank ypu notes
        gta_id  <- map["gta_id"]
        kd_createdate  <- map["kd_createdate"]
        kd_note  <- map["kd_note"]
        kd_description  <- map["kd_description"]


   
    }
    
}
