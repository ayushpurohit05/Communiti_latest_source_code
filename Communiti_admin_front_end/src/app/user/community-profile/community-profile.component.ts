import { Component, OnInit } from '@angular/core';

import { CommonService } from '../../core/services/common.service';
import { HttpService} from '../../core/services/http.service';
import { AuthService } from './../../core/services/auth.service';
@Component({
  selector: 'app-community-profile',
  templateUrl: './community-profile.component.html',
  styleUrls: ['./community-profile.component.scss']
})
export class CommunityProfileComponent implements OnInit {

  constructor(private http: HttpService,private commonService:CommonService,
		private authService:AuthService) { }
  	communitiProfileData : any ;
    currentPage : number = 1;
    itemsPerPage : number = 10;
    totalItems : number = 0;
    params:object;
	ngOnInit() {
		this.params = {
			limit : this.itemsPerPage,
			page : 0
		}
		this.authService.setChatData(false);
		this.getCommunityProfileList(this.params);
	}
	/*function for get commuinity profile*/
	getCommunityProfileList(params){
		this.http.post('Communityprofile',params).subscribe((result: any)=> {
			if(result.success){
				this.communitiProfileData = result.data.contents;
				this.totalItems = result.data.numOfRows[0].count;

			}else{
			  this.commonService.showErrorAlert(result.message);
			}
		  },error => {
		    this.commonService.showErrorAlert("some thing want worng");
		});
	}
	pageChanged(event: any): void {
	   this.params ={
			limit : this.itemsPerPage,
			page : (event.page - 1) * this.itemsPerPage
	    }
	   this.getCommunityProfileList(this.params);
    }

}
