import { Component, OnInit, TemplateRef } from '@angular/core';

import { Router }  from '@angular/router';
import { FormGroup, FormControl, FormBuilder, Validators } from '@angular/forms';
import { BsModalRef } from 'ngx-bootstrap/modal/bs-modal-ref.service';
import { BsModalService } from 'ngx-bootstrap/modal';
import { HttpService} from '../../core/services/http.service';
import { CommonService } from '../../core/services/common.service';
@Component({
  selector: 'app-dummy-user',
  templateUrl: './dummy-user.component.html',
  styleUrls: ['./dummy-user.component.scss']
})
export class DummyUserComponent implements OnInit {
  	userData: FormGroup;
	modalRef: BsModalRef;
	private locationList: any;
	private addUserCheck: boolean = false;
	myProfileViewObj={
		displayImage:"",
		uploadedFile:""
	}
	constructor(
		private router: Router,
		private http: HttpService,
		private formBuilder : FormBuilder,
		private commonService:CommonService,
		private modalService: BsModalService
	) { }

	ngOnInit() {
	  	this.userData = this.formBuilder.group({
	      	fName: ['', [Validators.required]],
	      	lName: ['', [Validators.required]],
	      	email: ['', [Validators.required]],
	      	//location: ['', [Validators.required]],
	    }); 
		//this.getLocation();
	}
	/*get location*/
	getLocation(){
		this.http.post('getLocation','').subscribe((result: any)=> {
			if(result.success){
				this.locationList = result.data;
			}else{
			  this.commonService.showErrorAlert(result.message);
			}
		  },error => {
		    this.commonService.showErrorAlert("some thing want worng");
		});
	}
	/*show add user form*/
	gotoAddUser() {
		this.addUserCheck = true;
	}
	/*go to Existing user*/
	gotoExistingUser() {
		this.router.navigate(['/user/existing-user']);
	}
	/*go Back*/
	gotoBack() {
		this.addUserCheck = false;
	}
	/*add Dummy user*/
	addUser(details) {
    	let profileImage = this.myProfileViewObj.uploadedFile === '' ? 'null' : this.myProfileViewObj.uploadedFile;
		let fd = new FormData();
	    fd.append('fname', details.fName);
	    fd.append('lname', details.lName);
	    fd.append('email', details.email);
	    //fd.append('appLocation', details.location);
	    fd.append('fileName', profileImage);
    	this.http.post('addDummyUser',fd).subscribe((result: any)=> {
			if(result.success){
				this.router.navigate(['/user/existing-user']);
			}else{
			  this.commonService.showErrorAlert(result.message);
			}
		  },error => {
		    this.commonService.showErrorAlert("some thing want worng");
		});
	}
	//File select and show
	fileChange(event){
		if(event && event.target && event.target.files && event.target.files.length){
			this.myProfileViewObj.uploadedFile = event.target.files[0];
			var reader = new FileReader();
			reader.onload = (e: any)=>{
			this.myProfileViewObj.displayImage = e.target.result;
			};
			reader.readAsDataURL(event.target.files[0]);
		}
	}
}
