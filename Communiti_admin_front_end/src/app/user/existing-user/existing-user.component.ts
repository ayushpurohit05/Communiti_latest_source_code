import { Component, OnInit } from '@angular/core';
import { Router }  from '@angular/router';
import { FormGroup, FormControl, FormBuilder, Validators } from '@angular/forms';
import { HttpService} from '../../core/services/http.service';
import { CommonService } from '../../core/services/common.service';
@Component({
  selector: 'app-existing-user',
  templateUrl: './existing-user.component.html',
  styleUrls: ['./existing-user.component.scss']
})
export class ExistingUserComponent implements OnInit {
  	newPostData: FormGroup;
  	editUserData: FormGroup;
	private dummyUserList: any;
	private currentPage : number = 1;
    private itemsPerPage : number = 10;
    private params: any;
	private totalItems : number = 0;
	private search: string;
	private addPostPageCheck: boolean = false;
	private addUserCheck: boolean = false;
	private groupList: any;
	private categoryLis: any;
	private userData: any;
	private getUserGroupList: any = '';
	private userGroupList: any;
	private tagArrya: any = [];
	private editUsercheck: boolean = false;
	private locationList: any;
	private editUserObj = {
		fname: '',
		lname:'',
		userName: '',
		email: '',
		//location: ''
	};
	myProfileViewObj={
	  displayImage:"",
	  uploadedFile:""
	}
	constructor(
		private router: Router,
		private http: HttpService,
		private formBuilder : FormBuilder,
		private commonService:CommonService,
	) { }

	ngOnInit() {
	  	this.newPostData = this.formBuilder.group({
	      	title: ['', [Validators.required]],
	      	description: ['',Validators.required],
	      	group: ['', [Validators.required]],
	      	tags: [],
	    }); 
		this.params ={
			socialName: 'website',
			limit : this.itemsPerPage,
			page : 0,
			search: ''
		};
		this.getExistingUser(this.params);
		//this.getLocation();
		this.editUserFormInt();
	}
	/*edit User form initialization*/
	editUserFormInt(){
	    this.editUserData = this.formBuilder.group({
	      	fName: [this.editUserObj.fname, [Validators.required]],
	      	lName: [this.editUserObj.lname, [Validators.required]],
	      	userName: [this.editUserObj.userName, [Validators.required]],
	      	email: [this.editUserObj.email,Validators.required],
	      	//location: [this.editUserObj.location, [Validators.required]],
	    }); 
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
	/*get group*/
	getGroup(dummyUserData) {
		this.userData = dummyUserData;
		this.userData.categoryId = this.categoryLis[0].cat_id;
		var abc = {
			'hiveId': this.categoryLis[0].cat_id,
		    //'locId': dummyUserData.usr_app_location,
		    'dmUsrId': dummyUserData.usr_id,
		}
		this.http.post('getHiveGroupList',abc).subscribe((result: any)=> {
			if(result.success){
				this.groupList = result.data;
			}else{
			  this.commonService.showErrorAlert(result.message);
			}
		  },error => {
		    this.commonService.showErrorAlert("some thing want worng");
		});
	}
	getExistingUser(params) {
    	this.http.post('getUserslist',params).subscribe((result: any)=> {
			if(result.success){
				this.dummyUserList = result.data;
				this.categoryLis = result.category;
				this.totalItems = result.total_count;
				this.router.navigate(['/user/existing-user']);
			}else{
				this.dummyUserList = [];
				this.categoryLis = [];
				this.totalItems = 0;
			  this.commonService.showErrorAlert(result.message);
			}
		},error => {
		    this.commonService.showErrorAlert("some thing want worng");
		});
	}
	addNewPost(postDetails) {
		for(let index = 0; index < postDetails.tags.length; index ++) {
			this.tagArrya.push(
				'#'+ postDetails.tags[index].value
			);
		}
		let params = {
			catId: this.categoryLis[0].cat_id,
			ttl: postDetails.title,
			dscptn: postDetails.description,
			tags: this.tagArrya,
			//locId: this.userData.usr_app_location,
			grpId: postDetails.group,
			dmUsrId: this.userData.usr_id
		}
		this.http.post('addUserHive',params).subscribe((result: any)=> {
			if(result.success){
				this.commonService.showAlert(result.message);
				this.commonService.changeState(this.userData);
				this.router.navigate(['/user/existing-user-post']);
			}else{
			  this.commonService.showErrorAlert(result.message);
			}
		},error => {
		    this.commonService.showErrorAlert("some thing want worng");
		});
	}
	goEditUser(editUserData) {
		this.userData = editUserData;
		this.editUserObj = {
			fname: editUserData.usr_fname,
			lname: editUserData.usr_lname,
			userName: editUserData.usr_username,
			email: editUserData.usr_email,
			//location: editUserData.usr_app_location
		};
		this.editUsercheck = true;
    	this.myProfileViewObj.displayImage = editUserData.profile_image;
    	this.editUserFormInt();
	}
	editUser(details) {
		let profileImage = this.myProfileViewObj.uploadedFile === '' ? 'null' : this.myProfileViewObj.uploadedFile;
		let fd = new FormData();
	    fd.append('fname', details.fName);
	    fd.append('lname', details.lName);
	    fd.append('username', details.userName);
	    fd.append('email', details.email);
	    //fd.append('appLocation', details.location);
	    fd.append('usrId', this.userData.usr_id);
	    fd.append('fileName', profileImage)
    	this.http.post('editDummyUsrProfile',fd).subscribe((result: any)=> {
			if(result.success){
				this.editUsercheck = false;
				for(let index = 0; index < this.dummyUserList.length; index++) {
					if(this.dummyUserList[index].usr_id == this.userData.usr_id) {
						this.dummyUserList[index] = result.data;
					}
				}
			}else{
			  this.commonService.showErrorAlert(result.message);
			}
		  },error => {
		    this.commonService.showErrorAlert("some thing want worng");
		});
	}
	onKeydown() {
		this.search;
		this.params ={
			socialName: 'website',
			limit : this.itemsPerPage,
			page : 0,
			search: this.search
		}
		this.getExistingUser(this.params);
	}
	/*open new post bottons*/
	goAddPostPage(dummyUserData) {
		this.commonService.setLocalStorageData('selectedUserData', dummyUserData);
		this.getGroup(dummyUserData);
		this.addPostPageCheck = true;
	}
	/* open add new post */
	openAddNewPostPage() {
		this.addUserCheck = true;
	}
	/*go Back*/
	gotoBack() {
		this.router.navigate(['/user/dummy-user']);
	}
	/*go to list*/
	gotoBackList() {
		this.addPostPageCheck = false;
		this.addUserCheck = false;
	}
	/*go existing post*/
	goExistingPost() {
		this.commonService.changeState(this.userData);
		this.router.navigate(['/user/existing-user-post']);
	}
	/*function for pagination*/
	pageChanged(event: any): void {
        this.params ={
			socialName: 'website',
			limit : this.itemsPerPage,
			page : (event.page - 1) * this.itemsPerPage,
			search: ''
		}
		this.getExistingUser(this.params);
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
