
import { Observable } from 'rxjs/Observable';
import 'rxjs/add/operator/do';
import 'rxjs/add/operator/catch';
import 'rxjs/add/observable/throw';
import 'rxjs/add/observable/empty';
import { Injectable } from '@angular/core';
import { HttpErrorResponse, HttpEvent, HttpHandler, HttpInterceptor, HttpRequest } from '@angular/common/http';
import { AuthService } from './auth.service';
import { Subject } from 'rxjs/Subject';

@Injectable()
export class AuthenticationInterceptor implements HttpInterceptor {

	public loading = new Subject();

	constructor() {
	}
	intercept(req: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {
		this.requestInterceptor();
		return next.handle(this.setAuthorizationHeader(req))
			.catch((event) => {
				console.log('event', event);
				if (event instanceof HttpErrorResponse) {
					return this.catch401(event);
				}
			});
	}

	/**
   * Request interceptor.
   */
	private requestInterceptor(): void {
		this.loading.next({
			loading: true, hasError: false, hasMsg: ''
		});
	}
	// Request Interceptor to append Authorization Header
	private setAuthorizationHeader(req: HttpRequest<any>): HttpRequest<any> {
		// Make a clone of the request then append the Authorization Header
		// Other way of writing :
		//return req.clone({ headers: req.headers.set('Content-Type', 'application/x-www-form-urlencoded;multipart/form-data;charset=UTF-8') });
		return req.clone({
			setHeaders: {
				//'Content-Type': 'application/json',
				//'Content-Type': 'application/x-www-form-urlencoded',
				//'Authorization': 'Bearer sq0atp-iVVmPjIsx79GyKXb8Y27iQ'
			}
		});
	}
	// Response Interceptor
	private catch401(error: HttpErrorResponse): Observable<any> {
		// Check if we had 401 response
		if (error.status === 401) {
			// redirect to Login page for example
			return Observable.empty();
		}
		return Observable.throw(error);
	}
}