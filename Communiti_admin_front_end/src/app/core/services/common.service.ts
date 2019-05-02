import { Injectable } from '@angular/core';
import swal from 'sweetalert2';
import { BehaviorSubject } from "rxjs/BehaviorSubject"
@Injectable()
export class CommonService {
  constructor() { }
  
  	private state$ = new BehaviorSubject<any>(false);
	changeState(myChange) {
		this.state$.next(myChange);
	}
	getState() {
		return this.state$.asObservable();
	}
	showAlert(message){
		swal(message);
	}
	showErrorAlert(message){
		swal('Oops...',message , 'error');
	}
	/* set and get data local storage acording to browser */
	setLocalStorageData(key : string, value : any){
		if (value) {
            value = JSON.stringify(value);
        }
        localStorage.setItem(key, value);
	}
	getLocalStorageData(key : string){
		let value: string = localStorage.getItem(key);
        if (value && value != "undefined" && value != "null") {
            return JSON.parse(value);
        }
        else{
        	return null;
        }
	}
}
