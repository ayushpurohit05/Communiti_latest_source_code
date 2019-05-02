import { Injectable } from '@angular/core';
import { CanActivate, ActivatedRouteSnapshot, RouterStateSnapshot,Router } from '@angular/router';
import { AuthService } from './../services/auth.service';
import { Observable } from 'rxjs/Observable';
import { HttpService} from './../services/http.service';

@Injectable()
export class AuthGuard implements CanActivate {
  constructor(
    private authService: AuthService,
    private router: Router,
    private http:HttpService
  ) {}

  canActivate(
    next: ActivatedRouteSnapshot,
    state: RouterStateSnapshot): Observable<boolean> | Promise<boolean> | boolean {
    if(this.authService.getLoginUserData()){
      return true;
    }else{
      return this.http.get('getLoggedIn').map((result: any)=> {
        if(result.success){
          this.authService.setLoginUserData(result.data);
          return true;
        }else{
          this.router.navigate(['/login']);
          return false;
        }
      },error => {
          this.router.navigate(['/login']);
          return false;
      });
    }
  }
}
