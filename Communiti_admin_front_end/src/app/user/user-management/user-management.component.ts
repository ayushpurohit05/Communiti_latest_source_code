import { Component, OnInit, TemplateRef} from '@angular/core';
import { BsModalService } from 'ngx-bootstrap/modal';
import { BsModalRef } from 'ngx-bootstrap/modal/bs-modal-ref.service';
import swal from 'sweetalert2';

import { CommonService } from '../../core/services/common.service';
import { HttpService} from '../../core/services/http.service';
import { AuthService } from './../../core/services/auth.service';

@Component({
  selector: 'app-user-management',
  templateUrl: './user-management.component.html',
  styleUrls: ['./user-management.component.scss']
})
export class UserManagementComponent implements OnInit {
	userList : any ;
	userDetails : any;
	totalItems : number = 0;
	modalRef: BsModalRef;
	currentPage : number = 1;
        itemsPerPage : number = 10;
        params:object;
	constructor(private http: HttpService,
		private commonService:CommonService,
		private modalService: BsModalService,
		private authService:AuthService) { }

	ngOnInit() {
		this.params ={
			limit : this.itemsPerPage,
			page : 0
		}
		this.authService.setChatData(false);
	    this.getUsersList(this.params);
	}
	viewUserDetails(template: TemplateRef<any>,details) {
		this.http.post('viewUser',{usr_id: details.usr_id}).subscribe((result: any)=> {
		if(result.success){
			this.userDetails = result.data;
			this.modalRef = this.modalService.show(template);
		}else{
		  this.commonService.showErrorAlert(result.message);
		}
		  },error => {
		    this.commonService.showErrorAlert("some thing want worng");
		});
	}
	blockUnblockUser(details,index){
		let isActive = details.Status == 'Active' ? 'Deactive' : 'Active';
		swal({
	        title: 'Are you sure?',
	        text: 'Want to ' + isActive + ' User ?',
	        type: 'warning',
	        showCancelButton: true,
	        confirmButtonColor: '#3085d6',
	        cancelButtonColor: '#d33',
	        confirmButtonText: 'Yes'
	    }).then((result) => {
	        if (result.value) {
	            /*delete code here*/
	            this.http.post('activeInactiveUser',{usr_id: details.usr_id,usr_isDelete: isActive}).subscribe((result: any)=> {
				if(result.success){
					this.userList[index].Status = isActive;
				}else{
				  this.commonService.showErrorAlert(result.message);
				}
				  },error => {
				    this.commonService.showErrorAlert("some thing want worng");
				});
	        }
	    })
	}
	/*function for get user list*/
	getUsersList(params){
		this.http.post('getUserslist',params).subscribe((result: any)=> {
			if(result.success){
				this.userList = result.data;
				this.totalItems = result.total_count;
			}else{
			  this.commonService.showErrorAlert(result.message);
			}
		  },error => {
		    this.commonService.showErrorAlert("some thing want worng");
		});
	}
	/*function for pagination*/
	pageChanged(event: any): void {
        this.params ={
			limit : this.itemsPerPage,
			page : (event.page - 1) * this.itemsPerPage
		}
		this.getUsersList(this.params);
    }

}
