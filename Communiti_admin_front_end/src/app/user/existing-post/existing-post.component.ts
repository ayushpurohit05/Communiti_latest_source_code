import { Component, OnInit, TemplateRef } from '@angular/core';

import { FormGroup, FormControl, FormBuilder, Validators } from '@angular/forms';
import { BsModalService } from 'ngx-bootstrap/modal';
import { BsModalRef } from 'ngx-bootstrap/modal/bs-modal-ref.service';
import { Router }  from '@angular/router';
import { HttpService} from '../../core/services/http.service';
import { CommonService } from '../../core/services/common.service';
@Component({
  selector: 'app-existing-post',
  templateUrl: './existing-post.component.html',
  styleUrls: ['./existing-post.component.scss']
})
export class ExistingPostComponent implements OnInit {
	private existingPostList: any;
	private totalItems: number = 0;
	private currentPage : number = 1;
    private itemsPerPage : number = 10;
	private userDetails: any;
	private params: any;
	private search: any = '';
	private locationId: any = '';
	private locationList: any;
	private postCommentList: any;
	private postObj: any;
	private commentCheck: boolean = false;
	private selectedUserData: any;
	postData: FormGroup;
	modalRef: BsModalRef;
	myProfileViewObj={
		displayImage:"",
		uploadedFile:""
	}
	constructor(
		private router: Router,
		private http: HttpService,
		private formBuilder : FormBuilder,
		private commonService:CommonService,
		private modalService: BsModalService
	) { }

	ngOnInit() {
		this.commonService.getState().subscribe(data => {
			this.userDetails = data;
		});
		this.postData = this.formBuilder.group({
	      	description: ['', [Validators.required]]
	    }); 
		this.selectedUserData =  this.commonService.getLocalStorageData('selectedUserData');
		this.params ={
			dmUsrId: this.selectedUserData.usr_id,
			catId: this.userDetails.categoryId,
			//locId: this.locationId,
			filter: this.search,
			limit : this.itemsPerPage,
			page : 0,
		};
		this.getExistingPost(this.params);
		//this.getLocation();
	}
	/*get location*/
	getLocation(){
		this.http.post('getLocation','').subscribe((result: any)=> {
			if(result.success){
				this.locationList = result.data;
			}else{
			  this.commonService.showErrorAlert(result.message);
			}
		  },error => {
		    this.commonService.showErrorAlert("some thing want worng");
		});
	}
	getExistingPost(params) {
    	this.http.post('getOrFilterAllHivePost',params).subscribe((result: any)=> {
			if(result.success){
				this.existingPostList = result.data;
				this.totalItems = result.total_count;
			}else{
			  this.commonService.showErrorAlert(result.message);
			}
		},error => {
		    this.commonService.showErrorAlert("some thing want worng");
		});
	}
	selectLocation(data) {
		this.locationId = data;
		this.params ={
			dmUsrId: this.selectedUserData.usr_id,
			catId: this.userDetails.categoryId,
			//locId: this.locationId,
			filter: this.search,
			limit : this.itemsPerPage,
			page : 0,
		}
		this.getExistingPost(this.params);
	}
	showPostReplyModel(template: TemplateRef<any>,postData) {
		this.postObj = postData;
		this.modalRef = this.modalService.show(template);
	}
	sendPostReply(replyObj) {
        let params = {
			dmUsrId: this.selectedUserData.usr_id,
			pstId: this.postObj.pst_id,
			dscptn: replyObj.description,
			pstTtl: this.postObj.pst_title,
			pstUsrId: this.postObj.usr_id,
			pstUsrNm: this.postObj.usr_fname
		}
		this.http.post('addCommentOnPost',params).subscribe((result: any)=> {
			if(result.success){
				this.postData.setValue({
					description: ''
				});
				this.modalRef.hide();
			}else{
			  this.commonService.showErrorAlert(result.message);
			}
		},error => {
		    this.commonService.showErrorAlert("some thing want worng");
		});
	}
	clickOnView(details) {
		this.postObj = details;
		let params = {
			dmUsrId: this.selectedUserData.usr_id,
			pstId: details.pst_id,
			limit : this.itemsPerPage,
			page : 0,
		}
		this.viewPostComment(params)
	}
	viewPostComment(params) {
		this.http.post('getAllPostComments',params).subscribe((result: any)=> {
			if(result.success){
				this.postCommentList = result.data;
				this.totalItems = result.total_count;
				this.commentCheck = true;
			}else{
			  this.commonService.showErrorAlert(result.message);
			}
		},error => {
		    this.commonService.showErrorAlert("some thing want worng");
		});
	}
	onKeydown() {
		this.search;
		this.params ={
			dmUsrId: this.selectedUserData.usr_id,
			catId: this.userDetails.categoryId,
			//locId: this.locationId,
			filter: this.search,
			limit : this.itemsPerPage,
			page : 0,
		}
		this.getExistingPost(this.params);
	}
	/* post up Vote*/
	upVote(postDetails) {
		let params ={
			dmUsrId: this.selectedUserData.usr_id,
			voteTyp: 'Post',
			voteId: postDetails.pst_id,
		}
		this.http.post('upvoteDownvotePostOrAnswer',params).subscribe((result: any)=> {
			if(result.success){
				for(let index = 0; index < this.existingPostList.length; index++) {
					if(this.existingPostList[index].pst_id == postDetails.pst_id) {
						this.existingPostList[index].usr_upvote = postDetails.usr_upvote == 'NO' ? 'YES' : 'NO';
						if(postDetails.usr_upvote == 'YES') {
							this.existingPostList[index].upvote_count = parseInt(this.existingPostList[index].upvote_count == 0 ? 0 : this.existingPostList[index].upvote_count) + 1;
						}else {
							this.existingPostList[index].upvote_count = parseInt(this.existingPostList[index].upvote_count) - 1;
						}
						break;
					}
				}
			}else{
			  this.commonService.showErrorAlert(result.message);
			}
		},error => {
		    this.commonService.showErrorAlert("some thing want worng");
		});
	}
	/* comment up Vote*/
	commentupVote(commentDetails) {
		let params ={
			dmUsrId: this.selectedUserData.usr_id,
			voteTyp: 'Answer',
			voteId: commentDetails.ans_id,
		}
		this.http.post('upvoteDownvotePostOrAnswer',params).subscribe((result: any)=> {
			if(result.success){
				for(let index = 0; index < this.postCommentList.length; index++) {
					if(this.postCommentList[index].ans_id == commentDetails.ans_id) {
						this.postCommentList[index].user_upvote = commentDetails.user_upvote == 'NO' ? 'YES' : 'NO';
						if(commentDetails.user_upvote == 'YES') {
							this.postCommentList[index].count_upvote = parseInt(this.postCommentList[index].count_upvote == 0 ? 0 : this.postCommentList[index].count_upvote) + 1;
						}else {
							this.postCommentList[index].count_upvote = parseInt(this.postCommentList[index].count_upvote) - 1;
						}
						break;
					}
				}
			}else{
			  this.commonService.showErrorAlert(result.message);
			}
		},error => {
		    this.commonService.showErrorAlert("some thing want worng");
		});
	}
	/*set great answer*/
	setGreatAnswer(commentDetails) {
		let params ={
			dmUsrId: this.selectedUserData.usr_id,
			ansId: commentDetails.ans_id,
		}
		this.http.post('likeAndUnlikeAnswer',params).subscribe((result: any)=> {
			if(result.success){
				for(let index = 0; index < this.postCommentList.length; index++) {
					if(this.postCommentList[index].ans_id == commentDetails.ans_id) {
						this.postCommentList[index].great = commentDetails.great == 'NO' ? 'YES' : 'NO';
						break;
					}
				}
			}else{
			  this.commonService.showErrorAlert(result.message);
			}
		},error => {
		    this.commonService.showErrorAlert("some thing want worng");
		});
	}
	gotoPostList() {
		this.commentCheck = false;
	}
	/*go Back*/
	gotoBack() {
		this.router.navigate(['/user/existing-user']);
	}
	/*function for pagination*/
	pageChanged(event: any): void {
        this.params ={
			dmUsrId: this.selectedUserData.usr_id,
			catId: this.userDetails.categoryId,
			//locId: this.locationId,
			filter: this.search,
			limit : this.itemsPerPage,
			page : (event.page - 1) * this.itemsPerPage,
		}
		this.getExistingPost(this.params);
    }
    /*function for comment pagination*/
    commentPageChanged(event: any): void {
        this.params ={
			dmUsrId: this.selectedUserData.usr_id,
			pstId: this.postObj.pst_id,
			limit : this.itemsPerPage,
			page : (event.page - 1) * this.itemsPerPage,
		}
		this.viewPostComment(this.params);
    }
}
