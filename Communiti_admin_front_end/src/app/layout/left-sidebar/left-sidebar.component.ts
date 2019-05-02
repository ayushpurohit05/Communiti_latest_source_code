import { Component, OnInit } from '@angular/core';
import { Router, NavigationEnd } from '@angular/router';
import { CommonService } from './../../core/services/common.service';
import { HttpService} from './../../core/services/http.service';
import { AuthService } from './../../core/services/auth.service';
import { Observable } from 'rxjs/Observable';
import { ChatService } from './../../core/services/chat.service';
import { Subject } from 'rxjs/Subject';

@Component({
	selector: 'app-left-sidebar',
	templateUrl: './left-sidebar.component.html',
	styleUrls: ['./left-sidebar.component.scss']
})
export class LeftSidebarComponent implements OnInit {

	pushRightClass: string = 'push-right';
	showMenu: string = '';
	private urlObj: any;
	private urlCheck: boolean;
	myCount$: Subject<{myCount: number}>
	constructor(
		public router: Router,
		private commonService:CommonService,
		private http: HttpService,
		private authService:AuthService,
		private chatService:ChatService
	) {
		this.myCount$ = this.chatService.myCount;
		/*create event for side manu bar hide*/
		this.router.events.subscribe(val => {
			if (
				val instanceof NavigationEnd &&
				window.innerWidth <= 992 &&
				this.isToggled()
			) {
				this.toggleSidebar();
			}
		});
	}
	ngOnInit() {
		this.getUrl();
	}
	/*active url check*/
	getUrl() {
		this.router.events.subscribe(val => {
			this.urlObj = val;
			if(this.urlObj.url == '/user/dummy-user' || this.urlObj.url == '/user/existing-user'|| this.urlObj.url == '/user/existing-user-post'){
					this.urlCheck = true;
			}else{
				this.urlCheck = false;
			}
		});
	}
	/*function for side manu bar hide*/
	isToggled(): boolean {
		const dom: Element = document.querySelector('body');
		return dom.classList.contains(this.pushRightClass);
	}

	toggleSidebar() {
		const dom: any = document.querySelector('body');
		dom.classList.toggle(this.pushRightClass);
	}
	/*function for logout*/
	logOut(){
		let param={adm_id:''};
		this.http.post('logout',param).subscribe((result: any)=> {
		if(result.success){
			this.authService.setLoginUserData(null);
			this.commonService.showAlert("logout successfully");
			this.router.navigate(['/login']);
		}else{
			this.commonService.showErrorAlert(result.message);
		}
			},error => {
				this.commonService.showErrorAlert("some thing want worng");
		});
	}
}
