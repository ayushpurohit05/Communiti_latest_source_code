import { Component, OnInit,ViewChild, ElementRef,AfterViewChecked ,HostListener} from '@angular/core';
import { FormGroup, FormControl, FormBuilder, Validators } from '@angular/forms';

import { AngularFireDatabase , AngularFireList,AngularFireAction} from 'angularfire2/database';
import { Observable } from 'rxjs/Observable';
import { BehaviorSubject } from 'rxjs/BehaviorSubject';
import { Subscription } from 'rxjs/Subscription';
import 'rxjs/add/operator/switchMap';

import 'rxjs/add/operator/map';
import * as moment from 'moment';
import { CommonService } from '../../core/services/common.service';
import { HttpService} from '../../core/services/http.service';
import { AuthService } from './../../core/services/auth.service';
import { OrderPipe } from 'ngx-order-pipe';
@Component({
  selector: 'app-user-chat',
  templateUrl: './user-chat.component.html',
  styleUrls: ['./user-chat.component.scss']
})
export class UserChatComponent implements OnInit ,AfterViewChecked{
	@ViewChild('scrollMe') private myScrollContainer: ElementRef;
	itemsRef: AngularFireList<any>;
	items: Observable<any[]>;
	messageData: FormGroup;
	readUnreadCount: AngularFireList<any>;
	readUnreadStatus: AngularFireList<any>;
	userStatus: AngularFireList<any>;
	userList : any;
	showMesg:any;
	userSelectedShow : number;
	loginAdminData : any;
	adminCount:number = 0;
	userProfileImage : string = '';
	messageList : any[];
	keyIndex : any;
	isScroll : boolean = true;
	checkForChat : boolean = true;
    chatCheck : boolean = false;
    perentKey:string;
    private userOnOffline: any;
    private onOffLineCheck: boolean = false;
	constructor(private db: AngularFireDatabase,private http: HttpService,
		private authService:AuthService,private commonService:CommonService,
		private formBuilder: FormBuilder,private orderPipe: OrderPipe) {
	}

	ngOnInit() {
		this.messageList = [];
		this.loginAdminData = this.authService.getLoginUserData();
		this.messageData = this.formBuilder.group({
	      msg: ['',[Validators.required]]
	    });
	    this.http.get('getUserslist').subscribe((result: any)=> {
			if(result.success){
				this.userList = result.data;
				for(let i =0;i<this.userList.length;i++){
					this.userList[i].count = "";
				}
				for(let i =0;i<this.userList.length;i++){
					this.readUnreadCount = this.db.list('admin/admin_userId_'+this.userList[i].usr_id+'/status/user_id_'+this.userList[i].usr_id);
				    this.readUnreadCount.snapshotChanges(['child_changed'])
				     .subscribe(actions => {
				       actions.forEach(action => {
			            this.userList[i].count = action.payload.val();
				      });
				    });
				}
			}else{
			  this.commonService.showErrorAlert(result.message);
			}
		  },error => {
		    this.commonService.showErrorAlert("some thing want worng");
		});
	}
	callbackCheck = true;
	setUserData = [];
	userMsgId ;
	getMessage(user_id,userProfileImage){
		this.chatCheck = false;
		this.callbackCheck=true;
		if(!this.chatCheck){
    		this.myScrollContainer.nativeElement.scrollTo(0,this.myScrollContainer.nativeElement.scrollHeight )
    		this.isScroll = true;
    	}else{
    		this.myScrollContainer.nativeElement.scrollTop =263;
    	}
		this.keyIndex='';
		this.userSelectedShow = user_id;
        this.showMesg = true;
        this.messageData.reset();
        this.userProfileImage = userProfileImage;
        //this.isScroll = true;
        this.checkForChat = true;
	    this.itemsRef = this.db.list('admin/admin_userId_'+user_id+'/message', ref => ref.orderByKey().limitToLast(10));
	    this.items = this.itemsRef.snapshotChanges().map(changes => {
	    	if(changes.length != 0){
	    		this.userMsgId = changes[0].payload.ref.parent.parent.key;
	    	}
          return changes.map(c => ({ key: c.payload.key, ...c.payload.val() }));
        });
        this.items.subscribe(data => {
    		if(this.callbackCheck){
    			this.messageList = data;
    			this.callbackCheck = false;
    			this.authService.setChatData(true);
        		this.updateCount();
    		}else if(this.userMsgId == 'admin_userId_'+this.userSelectedShow){
    			this.messageList = data;
        		let aaa= this.myScrollContainer.nativeElement.scrollHeight;
				setTimeout (() => {
					this.myScrollContainer.nativeElement.scrollTo(0,aaa);
			    }, 500)
			    if(this.authService.getChatData()){
			    	this.updateCount();
			    }
    		}
			// if(this.callbackCheck){
			// 	this.authService.setChatData(data);
			// 	this.messageList = data;
			// 	this.callbackCheck = false;
			// }else{
			// 	if(this.messageList.length == 0){
			// 		if(data.length != 0){
			// 			if(data[data.length - 1].sender == 'admin'){
			// 				this.messageList = data;
			// 			}
			// 		}
			// 	}else{
			// 		if(data[data.length - 1].sender == 'admin'){
			// 				this.messageList = data;
			// 		}else{
			// 			this.setUserData = this.authService.getChatData();
			// 			for(let insert = 0 ; insert < this.setUserData.length; insert++){
			// 				if(this.setUserData[insert].sender == data[data.length - 1].sender){
			// 					this.messageList = data;
			// 					let aaa= this.myScrollContainer.nativeElement.scrollHeight;
			// 					setTimeout (() => {
			// 						this.myScrollContainer.nativeElement.scrollTo(0,aaa);
			// 						this.updateCount();
			// 				    }, 500)
			// 				}
			// 			}
			// 		}
			// 	}
			// }
           if(this.messageList.length>0){
           	 this.keyIndex = this.messageList[0].key;
           }
        });
         /*get admin unread count*/
	    this.adminCount = 0;
	    this.readUnreadStatus = this.db.list('admin/admin_userId_'+user_id+'/status'); //this var for update read unread count
        this.readUnreadStatus.snapshotChanges().map(changes => {
        	if(changes.length !=0){
        		this.perentKey = changes[0].payload.ref.parent.parent.key;
        	}
          return changes.map(c => ({ key: c.payload.key, ...c.payload.val() }));
        }).subscribe(data => {
        	if(data.length != 0){
	     	    if(this.perentKey == 'admin_userId_'+this.userSelectedShow){
	     	    	for(let i =0;i<data.length;i++){
	     	    		if(data[i].key =='admin'){
	     	    			this.adminCount = data[i].unread;
	     	    		}
	     	    	}
	     	    }
        	}
           
        });
	   this.updateCount();
     }
     /*update user unread count*/
     updateCount(){
       this.readUnreadCount = this.db.list('admin/admin_userId_'+this.userSelectedShow+'/status');
       this.readUnreadCount.snapshotChanges(['child_added'])
	    .subscribe(actions => {
	     actions.forEach(action => {
	     	if(action.key == 'user_id_'+this.userSelectedShow){
	     		this.readUnreadCount.update('user_id_'+this.userSelectedShow, { unread: 0 });
                //this.userList[index].count = 0;
                let aaa= this.myScrollContainer.nativeElement.scrollHeight;
				setTimeout (() => {
					this.myScrollContainer.nativeElement.scrollTo(0,aaa);
			    }, 500)
	     	}
	     });
	   });
     }
	send(){
		this.onOffLineCheck = true;
		this.userStatus = this.db.list('useronlinestaus/user_id_'+this.userSelectedShow+'/status');
	    this.userStatus.snapshotChanges()
	    .subscribe(actions => {
	        actions.forEach(action => {
	            this.userOnOffline = action.payload.val();
	            if(this.onOffLineCheck){
	            	if (this.userOnOffline == '0') {
						this.onOffLineCheck = false;
		            	let params = {
		            		usrId: this.userSelectedShow,
		            	 	msg: this.messageData.value.msg,
		            	 	fName: this.loginAdminData.adm_name,
		            	 	lName: this.loginAdminData.adm_username
		            	}
		            	this.http.post('sendFirebaseMsg',params).subscribe((result: any)=> {
							if(result.success){
								this.itemsRef.push({
								    firstname: this.loginAdminData.adm_name,
								    lastname : this.loginAdminData.adm_username,
								    message: this.messageData.value.msg,
								    receipt: 0,
								    sender: 'admin',
								    timestamp: moment.utc().format('YYYY-MM-DDTHH:mm:ss.SSS')
								});
								this.messageData.reset();
								//this.commonService.showAlert(result.message);
							}else{
							  	this.commonService.showErrorAlert(result.message);
							}
						},error => {
						    this.commonService.showErrorAlert("some thing want worng");
						});
		            } else {
						this.onOffLineCheck = false;
			        	this.itemsRef.push({
						    firstname: this.loginAdminData.adm_name,
						    lastname : this.loginAdminData.adm_username,
						    message: this.messageData.value.msg,
						    receipt: 0,
						    sender: 'admin',
						    timestamp: moment.utc().format('YYYY-MM-DDTHH:mm:ss.SSS')
						});
						this.messageData.reset();
			        }
	            }
	        });
	    });
		this.adminCount = this.adminCount+1;
		this.readUnreadStatus.update('admin', { unread: this.adminCount });
	    this.readUnreadCount.update('user_id_'+this.userSelectedShow, { unread: 0 });
		let aaa= this.myScrollContainer.nativeElement.scrollHeight
		setTimeout (() => {
		this.myScrollContainer.nativeElement.scrollTo(0,aaa)
	    }, 500)
	}

	onScrollTop() {
		if(this.messageList.length>0){
			this.isScroll = false;
			let oldKey = this.keyIndex;
	        let newMessageArry = [];
	        this.itemsRef = this.db.list('admin/admin_userId_'+this.userSelectedShow+'/message', ref => ref.orderByKey().endAt(this.keyIndex).limitToLast(5));
		    this.items = this.itemsRef.snapshotChanges().map(changes => {
              return changes.map(c => ({ key: c.payload.key, ...c.payload.val() }));
            });
	        this.items.subscribe(data => {
	           if(data.length>0){
			      this.keyIndex = data[0].key;
			      data.forEach(action => {
		            if(oldKey!=action.key){
		            	if(!this.chatCheck){
		            		this.myScrollContainer.nativeElement.scrollTo(0,this.myScrollContainer.nativeElement.scrollHeight )
		            	}else{
		            		this.myScrollContainer.nativeElement.scrollTop =263;
		            	}
		            	//this.myScrollContainer.nativeElement.scrollTop =263;
		            	
		            	newMessageArry.unshift(action);
		            }
			      });
			    }
			    newMessageArry.forEach(arr => {
		         this.messageList.unshift(arr);
			    });
	        });
		}
    }
	ngAfterViewChecked() {        
        this.scrollToBottom();        
    } 

    scrollToBottom(): void {
    	if(this.isScroll){
    		try {
            //this.myScrollContainer.nativeElement.scrollTop = this.myScrollContainer.nativeElement.scrollHeight;
        	this.myScrollContainer.nativeElement.scrollTo(0,this.myScrollContainer.nativeElement.scrollHeight )
        } catch(err) { }  

    	}               
    }
	@HostListener("window:scroll", ['$event'])
	scroll(event){
		if(this.checkForChat){
			this.onScrollTop();
		}
		try {
	      let top = event.target.scrollTop;
	      let height = this.myScrollContainer.nativeElement.scrollHeight;
	      let offset = this.myScrollContainer.nativeElement.offsetHeight;

	      // emit bottom event
	      if (top > height - offset - 1) {
	      	this.checkForChat = false;
	      }

	      // emit top event
	      if (top === 0) {
	      	this.onScrollTop();
	      	this.chatCheck = true;
	        console.log('top scroll');
	      }

    	} catch (err) {}
	}
}





//import { Component, OnInit,ViewChild, ElementRef,AfterViewChecked ,HostListener} from '@angular/core';
// import { FormGroup, FormControl, FormBuilder, Validators } from '@angular/forms';

// import { AngularFireDatabase , AngularFireList,AngularFireAction} from 'angularfire2/database';
// import { Observable } from 'rxjs/Observable';
// import { BehaviorSubject } from 'rxjs/BehaviorSubject';
// import { Subscription } from 'rxjs/Subscription';
// import 'rxjs/add/operator/switchMap';

// import 'rxjs/add/operator/map';
// import * as moment from 'moment';
// import { CommonService } from '../../core/services/common.service';
// import { HttpService} from '../../core/services/http.service';
// import { AuthService } from './../../core/services/auth.service';
// import { OrderPipe } from 'ngx-order-pipe';
// @Component({
//   selector: 'app-user-chat',
//   templateUrl: './user-chat.component.html',
//   styleUrls: ['./user-chat.component.scss']
// })
// export class UserChatComponent implements OnInit ,AfterViewChecked{
// 	@ViewChild('scrollMe') private myScrollContainer: ElementRef;
// 	itemsRef: AngularFireList<any>;
// 	items: Observable<any[]>;
// 	messageData: FormGroup;
// 	readUnreadCount: AngularFireList<any>;
// 	readUnreadStatus: AngularFireList<any>;
// 	userStatus: AngularFireList<any>;
// 	userList : any;
// 	showMesg:any;
// 	userSelectedShow : number;
// 	loginAdminData : any;
// 	adminCount:number = 0;
// 	userProfileImage : string = '';
// 	messageList : any[];
// 	keyIndex : any;
// 	isScroll : boolean = true;
// 	checkForChat : boolean = true;
//     chatCheck : boolean = false;
//     perentKey:string;
// 	constructor(private db: AngularFireDatabase,private http: HttpService,
// 		private authService:AuthService,private commonService:CommonService,
// 		private formBuilder: FormBuilder,private orderPipe: OrderPipe) {
// 	}

// 	ngOnInit() {
// 		this.messageList = [];
// 		this.loginAdminData = this.authService.getLoginUserData();
// 		this.messageData = this.formBuilder.group({
// 	      msg: ['',[Validators.required]]
// 	    });
// 	    this.http.get('getUserslist').subscribe((result: any)=> {
// 			if(result.success){
// 				this.userList = result.data;
// 				for(let i =0;i<this.userList.length;i++){
// 					this.userList[i].count = "";
// 				}
// 				for(let i =0;i<this.userList.length;i++){
// 					this.readUnreadCount = this.db.list('admin/admin_userId_'+this.userList[i].usr_id+'/status/user_id_'+this.userList[i].usr_id);
// 				    this.readUnreadCount.snapshotChanges(['child_changed'])
// 				     .subscribe(actions => {
// 				       actions.forEach(action => {
// 			            this.userList[i].count = action.payload.val();
// 				      });
// 				    });
// 				}
// 			}else{
// 			  this.commonService.showErrorAlert(result.message);
// 			}
// 		  },error => {
// 		    this.commonService.showErrorAlert("some thing want worng");
// 		});
// 	}
// 	callbackCheck = true;
// 	setUserData = [];
// 	userMsgId ;
// 	getMessage(user_id,userProfileImage){
// 		this.chatCheck = false;
// 		this.callbackCheck=true;
// 		if(!this.chatCheck){
//     		this.myScrollContainer.nativeElement.scrollTo(0,this.myScrollContainer.nativeElement.scrollHeight )
//     		this.isScroll = true;
//     	}else{
//     		this.myScrollContainer.nativeElement.scrollTop =263;
//     	}
// 		this.keyIndex='';
// 		this.userSelectedShow = user_id;
//         this.showMesg = true;
//         this.messageData.reset();
//         this.userProfileImage = userProfileImage;
//         //this.isScroll = true;
//         this.checkForChat = true;
// 	    this.itemsRef = this.db.list('admin/admin_userId_'+user_id+'/message', ref => ref.orderByKey().limitToLast(10));
// 	    this.items = this.itemsRef.snapshotChanges().map(changes => {
// 	    	if(changes.length != 0){
// 	    		this.userMsgId = changes[0].payload.ref.parent.parent.key;
// 	    	}
//           return changes.map(c => ({ key: c.payload.key, ...c.payload.val() }));
//         });
//         this.items.subscribe(data => {
//     		if(this.callbackCheck){
//     			this.messageList = data;
//     			this.callbackCheck = false;
//     			this.authService.setChatData(true);
//         		this.updateCount();
//     		}else if(this.userMsgId == 'admin_userId_'+this.userSelectedShow){
//     			this.messageList = data;
//         		let aaa= this.myScrollContainer.nativeElement.scrollHeight;
// 				setTimeout (() => {
// 					this.myScrollContainer.nativeElement.scrollTo(0,aaa);
// 			    }, 500)
// 			    if(this.authService.getChatData()){
// 			    	this.updateCount();
// 			    }
//     		}
// 			// if(this.callbackCheck){
// 			// 	this.authService.setChatData(data);
// 			// 	this.messageList = data;
// 			// 	this.callbackCheck = false;
// 			// }else{
// 			// 	if(this.messageList.length == 0){
// 			// 		if(data.length != 0){
// 			// 			if(data[data.length - 1].sender == 'admin'){
// 			// 				this.messageList = data;
// 			// 			}
// 			// 		}
// 			// 	}else{
// 			// 		if(data[data.length - 1].sender == 'admin'){
// 			// 				this.messageList = data;
// 			// 		}else{
// 			// 			this.setUserData = this.authService.getChatData();
// 			// 			for(let insert = 0 ; insert < this.setUserData.length; insert++){
// 			// 				if(this.setUserData[insert].sender == data[data.length - 1].sender){
// 			// 					this.messageList = data;
// 			// 					let aaa= this.myScrollContainer.nativeElement.scrollHeight;
// 			// 					setTimeout (() => {
// 			// 						this.myScrollContainer.nativeElement.scrollTo(0,aaa);
// 			// 						this.updateCount();
// 			// 				    }, 500)
// 			// 				}
// 			// 			}
// 			// 		}
// 			// 	}
// 			// }
//            if(this.messageList.length>0){
//            	 this.keyIndex = this.messageList[0].key;
//            }
//         });
//          /*get admin unread count*/
// 	    this.adminCount = 0;
// 	    this.readUnreadStatus = this.db.list('admin/admin_userId_'+user_id+'/status'); //this var for update read unread count
//         this.readUnreadStatus.snapshotChanges().map(changes => {
//         	if(changes.length !=0){
//         		this.perentKey = changes[0].payload.ref.parent.parent.key;
//         	}
//           return changes.map(c => ({ key: c.payload.key, ...c.payload.val() }));
//         }).subscribe(data => {
//         	if(data.length != 0){
// 	     	    if(this.perentKey == 'admin_userId_'+this.userSelectedShow){
// 	     	    	for(let i =0;i<data.length;i++){
// 	     	    		if(data[i].key =='admin'){
// 	     	    			this.adminCount = data[i].unread;
// 	     	    		}
// 	     	    	}
// 	     	    }
//         	}
           
//         });
// 	   this.updateCount();
//      }
//      /*update user unread count*/
//      updateCount(){
//        this.readUnreadCount = this.db.list('admin/admin_userId_'+this.userSelectedShow+'/status');
//        this.readUnreadCount.snapshotChanges(['child_added'])
// 	    .subscribe(actions => {
// 	     actions.forEach(action => {
// 	     	if(action.key == 'user_id_'+this.userSelectedShow){
// 	     		this.readUnreadCount.update('user_id_'+this.userSelectedShow, { unread: 0 });
//                 //this.userList[index].count = 0;
//                 let aaa= this.myScrollContainer.nativeElement.scrollHeight;
// 				setTimeout (() => {
// 					this.myScrollContainer.nativeElement.scrollTo(0,aaa);
// 			    }, 500)
// 	     	}
// 	     });
// 	   });
//      }
// 	send(){
// 		this.userStatus = this.db.list('useronlinestaus/user_id_'+this.userSelectedShow+'/status');
// 	    this.userStatus.snapshotChanges()
// 	    .subscribe(actions => {
// 	        actions.forEach(action => {
// 	            let userOnOffline = action.payload.val();
// 	            if (!userOnOffline) {
// 	            	let params = {
// 	            		usrId: this.userSelectedShow,
// 	            	 	msg: this.messageData.value.msg,
// 	            	 	fName: this.loginAdminData.adm_name,
// 	            	 	lName: this.loginAdminData.adm_username
// 	            	}
// 	            	this.http.post('sendFirebaseMsg',params).subscribe((result: any)=> {
// 						if(result.success){
// 							//this.commonService.showAlert(result.message);
// 						}else{
// 						  	this.commonService.showErrorAlert(result.message);
// 						}
// 					},error => {
// 					    this.commonService.showErrorAlert("some thing want worng");
// 					});
// 	            }
// 	        });
// 	    });
// 		this.adminCount = this.adminCount+1;
// 		this.itemsRef.push({
// 		    firstname: this.loginAdminData.adm_name,
// 		    lastname : this.loginAdminData.adm_username,
// 		    message: this.messageData.value.msg,
// 		    receipt: 0,
// 		    sender: 'admin',
// 		    timestamp: moment.utc().format('YYYY-MM-DDTHH:mm:ss.SSS')
// 		});
// 		this.readUnreadStatus.update('admin', { unread: this.adminCount });
// 	    this.readUnreadCount.update('user_id_'+this.userSelectedShow, { unread: 0 });
// 		this.messageData.reset();
// 		//this.myScrollContainer.nativeElement.scrollTop =263;
// 		let aaa= this.myScrollContainer.nativeElement.scrollHeight
// 		setTimeout (() => {
// 		this.myScrollContainer.nativeElement.scrollTo(0,aaa)
// 	    }, 500)
// 	}

// 	onScrollTop() {
// 		if(this.messageList.length>0){
// 			this.isScroll = false;
// 			let oldKey = this.keyIndex;
// 	        let newMessageArry = [];
// 	        this.itemsRef = this.db.list('admin/admin_userId_'+this.userSelectedShow+'/message', ref => ref.orderByKey().endAt(this.keyIndex).limitToLast(5));
// 		    this.items = this.itemsRef.snapshotChanges().map(changes => {
//               return changes.map(c => ({ key: c.payload.key, ...c.payload.val() }));
//             });
// 	        this.items.subscribe(data => {
// 	           if(data.length>0){
// 			      this.keyIndex = data[0].key;
// 			      data.forEach(action => {
// 		            if(oldKey!=action.key){
// 		            	if(!this.chatCheck){
// 		            		this.myScrollContainer.nativeElement.scrollTo(0,this.myScrollContainer.nativeElement.scrollHeight )
// 		            	}else{
// 		            		this.myScrollContainer.nativeElement.scrollTop =263;
// 		            	}
// 		            	//this.myScrollContainer.nativeElement.scrollTop =263;
		            	
// 		            	newMessageArry.unshift(action);
// 		            }
// 			      });
// 			    }
// 			    newMessageArry.forEach(arr => {
// 		         this.messageList.unshift(arr);
// 			    });
// 	        });
// 		}
//     }
// 	ngAfterViewChecked() {        
//         this.scrollToBottom();        
//     } 

//     scrollToBottom(): void {
//     	if(this.isScroll){
//     		try {
//             //this.myScrollContainer.nativeElement.scrollTop = this.myScrollContainer.nativeElement.scrollHeight;
//         	this.myScrollContainer.nativeElement.scrollTo(0,this.myScrollContainer.nativeElement.scrollHeight )
//         } catch(err) { }  

//     	}               
//     }
// 	@HostListener("window:scroll", ['$event'])
// 	scroll(event){
// 		if(this.checkForChat){
// 			this.onScrollTop();
// 		}
// 		try {
// 	      let top = event.target.scrollTop;
// 	      let height = this.myScrollContainer.nativeElement.scrollHeight;
// 	      let offset = this.myScrollContainer.nativeElement.offsetHeight;

// 	      // emit bottom event
// 	      if (top > height - offset - 1) {
// 	      	this.checkForChat = false;
// 	      }

// 	      // emit top event
// 	      if (top === 0) {
// 	      	this.onScrollTop();
// 	      	this.chatCheck = true;
// 	        console.log('top scroll');
// 	      }

//     	} catch (err) {}
// 	}
// }

