import { Component, OnInit } from '@angular/core';
import { FormGroup, FormControl, FormBuilder, Validators } from '@angular/forms';
import { ValidatorService } from './../../core/services/validator.service';
import { CommonService } from './../../core/services/common.service';
import { HttpService} from './../../core/services/http.service';
import { AuthService } from './../../core/services/auth.service';

@Component({
  selector: 'app-user-profile',
  templateUrl: './user-profile.component.html',
  styleUrls: ['./user-profile.component.scss'],
  providers: [ValidatorService]
})
export class UserProfileComponent implements OnInit {
  changePasswordData: FormGroup;
  changeEmailData: FormGroup;
  loginUserData:any;
  changesPasswordParams: any = {};
  goMailTab : boolean = true;
  goPasswordTab : boolean = false;
  goProfileTab : boolean = false;
  myProfileViewObj={
      displayImage:"",
      uploadedFile:""
  }
  constructor(private formBuilder : FormBuilder,
  	private validator : ValidatorService,
  	private commonService : CommonService,
  	private http : HttpService,
  	private authService : AuthService) { }

  ngOnInit() {
    this.authService.setChatData(false);
  	this.loginUserData = this.authService.getLoginUserData();
    this.myProfileViewObj.displayImage = this.loginUserData.adm_image;
  	this.changePasswordData = this.formBuilder.group({
      oldPassword: ['', [Validators.required]],
      newPassword: ['', [Validators.required]],
      confirmPassword: ['', [Validators.required]],
    }, {
      validator: this.validator.validateConfirmPass('newPassword', 'confirmPassword')
    }); 
    this.changeEmailData = this.formBuilder.group({
        adm_userName: [this.loginUserData.adm_name],
        adm_email : [this.loginUserData.adm_email,[Validators.required,this.validator.validateEmail]]
    });
  }
  changePassword(){
    this.changesPasswordParams ={
    	adm_password : this.changePasswordData.value.oldPassword,
    	adm_npassword : this.changePasswordData.value.newPassword,
    	adm_cpassword : this.changePasswordData.value.confirmPassword,
    	adm_id : parseInt(this.loginUserData.adm_id)

    }
    this.http.post('changePassword',this.changesPasswordParams).subscribe((result: any)=> {
		if(result.success){
			this.commonService.showAlert(result.message);
			this.changePasswordData.reset();

		}else{
		  this.commonService.showErrorAlert(result.message);
		}
	  },error => {
	    this.commonService.showErrorAlert("some thing want worng");
	});
  }
  changeEmail(){
    let profileImage = this.myProfileViewObj.uploadedFile === '' ? 'null' : this.myProfileViewObj.uploadedFile;
    let fd = new FormData();
    fd.append('adm_email', this.changeEmailData.value.adm_email);
    fd.append('adm_name', this.changeEmailData.value.adm_userName);
    fd.append('adm_id', this.loginUserData.adm_id);
    fd.append('admImage', profileImage);
   this.http.post('changeEmail',fd).subscribe((result: any)=> {
		if(result.success){
      this.loginUserData = {
        adm_email : this.changeEmailData.value.adm_email,
        adm_username: this.changeEmailData.value.adm_userName,
        //adm_username: '',
        adm_name: this.changeEmailData.value.adm_userName,
        adm_image : result.record[0].profile_image,
        adm_id : this.loginUserData.adm_id
      }
      this.authService.setLoginUserData(this.loginUserData);
			this.commonService.showAlert(result.message);
		}else{
		  this.commonService.showErrorAlert(result.message);
		}
	  },error => {
	    this.commonService.showErrorAlert("some thing want worng");
	  });
  }
  /* tabs hide show */
  goChangePassword(){
    this.goMailTab= true;
    this.goProfileTab = false;
    this.goPasswordTab= false;
  }
  goChangeMail(){
    this.goPasswordTab = true;
    this.goProfileTab = false;
    this.goMailTab= false;
  }
  /* tabs hide show */
  goProfile(){
    this.goProfileTab = true;
    this.goPasswordTab = false;
    this.goMailTab= false;
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
