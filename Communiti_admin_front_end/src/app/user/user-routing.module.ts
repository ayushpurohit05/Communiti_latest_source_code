import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { UserManagementComponent } from './user-management/user-management.component';
import { FlagAgainstUserComponent } from './flag-against-user/flag-against-user.component';
import { CommunityProfileComponent } from './community-profile/community-profile.component';
import { UserProfileComponent } from './user-profile/user-profile.component';
import { UserChatComponent } from './user-chat/user-chat.component';
import { DummyUserComponent } from './dummy-user/dummy-user.component';
import { ExistingUserComponent } from './existing-user/existing-user.component';
import { ExistingPostComponent } from './existing-post/existing-post.component';
import { UtcFilterPipe } from '../core/pipes/utc-filter.pipe';

const userRoutes: Routes = [
	{ path: 'userManagment', component: UserManagementComponent },
	{ path: 'flag-against', component: FlagAgainstUserComponent },
	{ path: 'community', component: CommunityProfileComponent },
	{ path: 'user-profile', component: UserProfileComponent },
	{ path: 'user-chat', component: UserChatComponent },
	{ path: 'dummy-user', component: DummyUserComponent },
	{ path: 'existing-user', component: ExistingUserComponent },
	{ path: 'existing-user-post', component: ExistingPostComponent },
];

@NgModule({
	imports: [RouterModule.forChild(userRoutes)],
	exports: [RouterModule]
})
export class UserRoutingModule { }

export const UserRoutingComponents = [
	UserManagementComponent,
	FlagAgainstUserComponent,
	CommunityProfileComponent,
	UserProfileComponent,
	UserChatComponent,
	DummyUserComponent,
	ExistingUserComponent,
	ExistingPostComponent,
	UtcFilterPipe
]
