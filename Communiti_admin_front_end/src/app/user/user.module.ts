import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { UserRoutingModule,UserRoutingComponents } from './user-routing.module';
import { ModalModule } from 'ngx-bootstrap/modal';
import { PaginationModule } from 'ngx-bootstrap/pagination';
import { FormsModule , ReactiveFormsModule}   from '@angular/forms';
import { OrderModule } from 'ngx-order-pipe';
import { TagInputModule } from 'ngx-chips';
//import { CoreModule } from '../core/core.module';

@NgModule({
  imports: [
    CommonModule,
    UserRoutingModule,
    ModalModule.forRoot(),
    PaginationModule.forRoot(),
    FormsModule,
    ReactiveFormsModule,
    OrderModule,
    TagInputModule
    //CoreModule
  ],
  exports:UserRoutingComponents,
  declarations: UserRoutingComponents
})
export class UserModule { }
