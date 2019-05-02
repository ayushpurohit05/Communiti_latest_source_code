import { Component, OnInit, TemplateRef} from '@angular/core';
import { HttpService} from '../../core/services/http.service';
import { CommonService } from '../../core/services/common.service';
import { BsModalService } from 'ngx-bootstrap/modal';
import { BsModalRef } from 'ngx-bootstrap/modal/bs-modal-ref.service';
import { AuthService } from './../../core/services/auth.service';
@Component({
  selector: 'app-flag-against-user',
  templateUrl: './flag-against-user.component.html',
  styleUrls: ['./flag-against-user.component.scss']
})
export class FlagAgainstUserComponent implements OnInit {
	flagList : any;
	hiveHelpList : any;
	totalItems : number = 0;
	currentPage : number = 1;
    itemsPerPage : number = 10;
    params:object;
    modalRef: BsModalRef;

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
	    this.getUserFlagList(this.params);
	}

	getUserFlagList(params){
		this.http.post('flagAgainstUserlist',params).subscribe((result: any)=> {
			if(result.success){
				this.flagList = result.data.contents;
				this.totalItems = result.data.numOfRows[0].count;

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
		this.getUserFlagList(this.params);
    }
    goFlagDetails(template: TemplateRef<any>,flagObj,Details){
    	this.hiveHelpList = '';
    	
    	let params ={
    		usr_id : Details.userid,
    		ID : flagObj.ID,
    		Type : flagObj.Type
    	}
    	this.http.post('getflagAgainstlist',params).subscribe((result: any)=> {
			if(result.success){
				this.hiveHelpList = result.data.contents[0];
				if(this.hiveHelpList){
					this.modalRef = this.modalService.show(
				      template,
				      Object.assign({}, { class: 'gray modal-lg' })
				    );
				}else{
					this.commonService.showAlert('There is no data to display.');
				}
			}else{
			  this.commonService.showErrorAlert(result.message);
			}
		  },error => {
		    this.commonService.showErrorAlert("some thing want worng");
		});
    }
}
