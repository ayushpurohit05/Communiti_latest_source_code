import { Component, OnInit } from '@angular/core';
import { AuthService } from '../core/services/auth.service';
import { CommonService } from '../core/services/common.service';
import { HttpService} from '../core/services/http.service';
@Component({
	selector: 'app-dashboard',
	templateUrl: './dashboard.component.html',
	styleUrls: ['./dashboard.component.scss']
})
export class DashboardComponent implements OnInit {
	helpCount:number=0;
	hiveCount:number=0;
	constructor(private authService:AuthService,private commonService:CommonService,private http: HttpService) { }

	ngOnInit() {
		this.authService.setChatData(false);
		this.http.get('dashboard').subscribe((result: any)=> {
		if(result.success){
			this.helpCount = result.data[0].helpCount;
			this.hiveCount = result.data[0].hiveCount;
		}else{

			this.commonService.showErrorAlert(result.message);
		}
			},error => {
				this.commonService.showErrorAlert("some thing want worng");
		});
	}
}
