import { Component, OnInit } from '@angular/core';
import { Router }  from '@angular/router';
import { FormGroup, FormControl, FormBuilder, Validators } from '@angular/forms';
import { AuthService } from './../../core/services/auth.service';
import { ValidatorService } from './../../core/services/validator.service';
import { CommonService } from '../../core/services/common.service';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss'],
  providers: [ValidatorService]
})
export class LoginComponent implements OnInit {
	loginUserData: FormGroup;
	constructor(private router: Router,
		private authService:AuthService,
		private formBuilder: FormBuilder,
		private validator:ValidatorService,
		private commonService:CommonService) { }

	ngOnInit() {
		this.loginUserData = this.formBuilder.group({
	        adm_email : ['',[Validators.required,this.validator.validateEmail]],
	        adm_password: ['',[Validators.required]],
       });
	}
	login():void{
		this.authService.doLogin(this.loginUserData.value).subscribe((result: any)=> {
			if(result.success){
				this.authService.setLoginUserData(result.data);
				this.router.navigate(['/dashBoard']);
			}else{
				this.commonService.showErrorAlert(result.message);
			}
        },error => {
           this.commonService.showErrorAlert("some thing want worng");
        });
	}
}
