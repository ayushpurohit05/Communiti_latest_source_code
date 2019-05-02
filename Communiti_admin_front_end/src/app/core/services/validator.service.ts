import { Injectable } from '@angular/core';
import { FormGroup, FormControl } from '@angular/forms';

@Injectable()
export class ValidatorService {

  constructor() { }
  //Email validation
	validateEmail(c: FormControl){
	  let EMAIL_REGEXP = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/ ;
	  return EMAIL_REGEXP.test(c.value) ? null : {
	    validateEmail: {
	        valid: false
	      }
	    };
	}
	// password and re-type password are same validation 
	validateConfirmPass(passwordKey: string, passwordConfirmationKey: string) {
    return (group: FormGroup) => {
      let password = group.controls[passwordKey],
      passwordConfirmation = group.controls[passwordConfirmationKey];
      if (password.value !== passwordConfirmation.value) {
        return passwordConfirmation.setErrors({notEquivalent: true})
      }
      else {
        return passwordConfirmation.setErrors(null);
      }
    }
  }
}
