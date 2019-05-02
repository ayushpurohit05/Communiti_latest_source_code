import { Component, OnInit } from '@angular/core';
import { Router }  from '@angular/router';
import { FormGroup, FormControl, FormBuilder, Validators } from '@angular/forms';
import { ValidatorService } from './../../core/services/validator.service';
import { CommonService } from './../../core/services/common.service';
import { HttpService} from './../../core/services/http.service';

@Component({
  selector: 'app-forgot-password',
  templateUrl: './forgot-password.component.html',
  styleUrls: ['./forgot-password.component.scss'],
  providers: [ValidatorService]
})
export class ForgotPasswordComponent implements OnInit {
  forgetPasswordData: FormGroup;
  constructor(private formBuilder: FormBuilder,private validator:ValidatorService,private router: Router,private commonService:CommonService,private http: HttpService) { }

  ngOnInit() {
  	this.forgetPasswordData = this.formBuilder.group({
      adm_email : ['',[Validators.required,this.validator.validateEmail]],
    });
  }
  forgetPassword(){
    this.http.post('ForgotPassword',this.forgetPasswordData.value).subscribe((result: any)=> {
    if(result.success){
      this.commonService.showAlert(result.message);
      this.router.navigate(['/login']);
    }
    else{
      this.commonService.showErrorAlert(result.message);
    }
      },error => {
        this.commonService.showErrorAlert("some thing want worng");
    });
  }
}
