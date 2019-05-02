<?php
defined('BASEPATH') OR exit('No direct script access allowed');
class CronjobController extends CI_Controller 
{
	public function __construct()
    {
        parent::__construct();
		$this->load->model('UserModel');
	}

    //--Function for send notification to user for help expire today using cron job
	public function notfyForExpireHelpToday()
	{
		$this->UserModel->notfyForExpireHelpToday();
	}

	//--Function for expired help request by cron job
	public function expiredAllPost()
	{
		$this->UserModel->expiredAllPost();
	}

	//--Function for send notification only login users
	public function notifyUserLoginInteractOnApp()
    {
    	$this->UserModel->notifyUserLoginInteractOnApp();
    }

    //--Function for send notification to user for interact on APP
    public function notifyUserActionInteractionOnApp()
    {
    	$this->UserModel->notifyUserActionInteractionOnApp();
    }
}