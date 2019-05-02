import { Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs/BehaviorSubject';
import { HttpService} from './http.service';
import { Router,NavigationEnd,RoutesRecognized }  from '@angular/router';
@Injectable()
export class AuthService {
	private loggedIn = new BehaviorSubject<boolean>(false); // {1}
	
    loggedInUserData:string;
    chatData;
    currentUrl;
    
  	constructor(private http: HttpService,private router: Router) {
      router.events.filter(e => e instanceof NavigationEnd)
        .subscribe((e: NavigationEnd) => {
            this.currentUrl = e.url;
            setTimeout(callback=>{
                window.scrollTo(0, 0);    
            },100)
        }); 
    }
    //login Api
    doLogin(param){
      return this.http.post('login', param);
    }
    //change mail API
    doChangeMail(param){
      return this.http.post('changeEmail',param);
    }
    //admin logout
    doAdminLogout(param){
      return this.http.post('logout',param);
    }
	get isLoggedIn() {
		return this.loggedIn.asObservable(); // {2}
	}
    setLoginFlag(flag){
        this.loggedIn.next(flag);
    }

    getLoginUserData(){
        return this.loggedInUserData;
    }
    setLoginUserData(data){
        this.loggedInUserData=data;
        if(data){
            this.setLoginFlag(true);
        }else{
            this.setLoginFlag(false);
        }
    }
    getChatData(){
        return this.chatData;
    }
    setChatData(data){
        this.chatData=data;
    }
    isLogin(){
        if(this.loggedInUserData){
            if(this.currentUrl == "/login"){
                return false;
            }else{
                return true;
            }
        }
    }
}
