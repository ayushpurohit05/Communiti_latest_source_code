import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { LoginComponent } from './login/login.component';
import { ForgotPasswordComponent } from './forgot-password/forgot-password.component';

const routes: Routes = [
	{ path: '', redirectTo: '/login',pathMatch: 'full'},
	{ path: 'login', component: LoginComponent,pathMatch: 'full' },
	{ path: 'forgot', component: ForgotPasswordComponent },
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class AuthRoutingModule { }

export const RoutingComponents = [
    	LoginComponent,
    	ForgotPasswordComponent
    ]
