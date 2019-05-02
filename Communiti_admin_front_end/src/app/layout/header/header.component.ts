import { Component, OnInit } from '@angular/core';
import { Observable } from 'rxjs/Observable';
import { Router }  from '@angular/router';
import { AuthService } from './../../core/services/auth.service';
import { AngularFireDatabase , AngularFireList,AngularFireAction} from 'angularfire2/database';
import 'rxjs/add/operator/map';
import { CommonService } from '../../core/services/common.service';
import { HttpService} from '../../core/services/http.service';
import { ChatService} from '../../core/services/chat.service';

@Component({
  selector: 'app-header',
  templateUrl: './header.component.html',
  styleUrls: ['./header.component.scss']
})
export class HeaderComponent implements OnInit{
  pushRightClass: string = 'push-right';
  readUnreadCount: AngularFireList<any>;
  userList : any;
  countArr : any[];
  userMsgId;
  unread;
  nodeChangeData;
  constructor(private authService:AuthService,private router: Router,private db: AngularFireDatabase,private http: HttpService,private commonService:CommonService,private chatService:ChatService) {}
  toggleSidebar() {
        const dom: any = document.querySelector('body');
        dom.classList.toggle(this.pushRightClass);
  }
  ngOnInit() {
		this.authService.setChatData(false);
  	    this.countArr = [];
	    this.http.get('getUserslist').subscribe((result: any)=> {
			if(result.success){
				this.userList = result.data;
				for(let i =0;i<this.userList.length;i++){
					this.readUnreadCount = this.db.list('admin/admin_userId_'+this.userList[i].usr_id+'/status/user_id_'+this.userList[i].usr_id); 
					this.readUnreadCount.snapshotChanges().map(changes => {
						if(changes.length!=0){
							this.nodeChangeData = changes;
							this.unread = this.nodeChangeData [0].payload.val();
							this.userMsgId = this.nodeChangeData[0].payload.ref.parent.key;
						}
						return changes.map(c => ({ key: c.payload.key, ...c.payload.val() })); })
					.subscribe(actions => { 
						if(actions.length>0){
				       	    if(this.unread !=0){
				       	    	if(this.countArr.length == 0){
				       	    		this.countArr.push(this.userMsgId);
				       	    	}
				       	    	let callBackMsgKey = this.countArr.find(x=>x == this.userMsgId);
				       	    	if(!callBackMsgKey){
									this.countArr.push(this.userMsgId);
				       	    	}
				       	    }
				       	    if(this.nodeChangeData[0].type =='child_changed' && this.countArr.length>0 && this.unread == 0 ){
				       	    	this.countArr.splice(0,1);
				       	    }
				        }
				        this.chatService.setChatCount(this.countArr.length);
					});
					// this.readUnreadCount = this.db.list('admin/admin_userId_'+this.userList[i].usr_id+'/status/user_id_'+this.userList[i].usr_id);
				 //    this.readUnreadCount.snapshotChanges(['child_changed'])
				 //     .subscribe(actions => {
				 //         if(actions.length>0){
				 //         	let unread = actions[0].payload.val();
				 //       	    if(unread !=0){
				 //       	    	if(this.countArr.length == 0){
				 //       	    		this.countArr.push(actions[0].payload.ref.parent.key);
				 //       	    	}
				 //       	    	let callBackMsgKey = this.countArr.find(x=>x == actions[0].payload.ref.parent.key);
				 //       	    	if(!callBackMsgKey){
					// 				this.countArr.push(actions[0].payload.ref.parent.key);
				 //       	    	}
				 //       	    }
				 //       	    if(actions[0].type =='child_changed' && this.countArr.length>0 && unread == 0 ){
				 //       	    	this.countArr.splice(0,1);
				 //       	    }
				 //         }
				 //    });
				}
			}else{
			  this.commonService.showErrorAlert(result.message);
			}
		  },error => {
		    this.commonService.showErrorAlert("some thing want worng");
		});
	}
}
