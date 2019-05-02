import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule , ReactiveFormsModule}   from '@angular/forms';

import { AuthRoutingModule,RoutingComponents } from './auth-routing.module';

@NgModule({
  imports: [
    CommonModule,
    AuthRoutingModule,
    FormsModule,
    ReactiveFormsModule
  ],
  exports: RoutingComponents,
  declarations: RoutingComponents
})
export class AuthModule { }
