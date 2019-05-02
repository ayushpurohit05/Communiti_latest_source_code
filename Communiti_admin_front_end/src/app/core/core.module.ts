
import { NgModule } from '@angular/core';
import { HttpModule, XHRBackend, RequestOptions, Http } from '@angular/http';

import { AuthService } from './services/auth.service';
import { HttpService } from './services/http.service';
import { AuthenticationInterceptor } from './services/authentication.interceptor';
import { HTTP_INTERCEPTORS, HttpClientModule } from '@angular/common/http';
import { CommonService } from './services/common.service';
import { ChatService } from './services/chat.service';


@NgModule({
  declarations: [
    // components
    // DummyService,
    // pipes
   ],
  exports: [
    // components
    // DummyService
  ],
  imports: [
    HttpClientModule
    // Were not working on modules sice update to rc-5
    // TO BE moved to respective modules.
  ],
  providers: [
    HttpService,
    CommonService,
    AuthService,
    ChatService,
    {
      provide: HTTP_INTERCEPTORS,
      useClass: AuthenticationInterceptor,
      multi: true,
    }
  ]
})
export class CoreModule {}
