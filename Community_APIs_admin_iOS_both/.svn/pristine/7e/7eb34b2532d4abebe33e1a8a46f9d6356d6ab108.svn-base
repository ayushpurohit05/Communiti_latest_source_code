<?php
defined('BASEPATH') OR exit('No direct script access allowed');
class AdminController extends CI_Controller
{
	public function __construct()
    {
        parent::__construct();
		session_start();
        header("Access-Control-Allow-Headers: Content-Type");
		header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
		header("Access-Control-Allow-Origin: *");
		//--Load model
		$this->load->model('AdminModel');

        //--Get input
		$fileContent = file_get_contents("php://input");
		if(!empty($fileContent))
		{
			$this->requestData = json_decode(file_get_contents("php://input"));
		}
		else
		{
			$this->requestData = (object)$_REQUEST;
		}
	}

	//--Function for return json encoded data
    public function getJsonData($arrayResponse)
    {
        echo json_encode($arrayResponse);
    }

    //--Function for check session
	public function isSession()
	{
		if (isset($_SESSION['login_admin_session']))
			return true;
		else
			return true;
	}

	//-- common function for file upload 
	public function fileUpload($path,$imageName)
	{
		$config['upload_path']   = $path;
		$config['allowed_types'] = '*';  
		$config['file_name']     =$imageName;
		$config['max_size']      = 2*1024;

		$fileName = '';
		$this->load->library('upload', $config);
		
		if ($this->upload->do_upload('fileName')) 
		{
			$fileName = $this->upload->data(); 
			$data     = $fileName['file_name'];
		}
		else
		{
            $data = array('error' => $this->upload->display_errors());
		}
        return $data;
	}

	//--Function for logout or session expire
	public function logout()
	{
		if ($this->isSession()) 
		{
			unset($_SESSION['login_admin_session']);
			if(!isset($_SESSION['login_admin_session']))
			{
				session_destroy();
			}
			$returnResponse = array('success' => true, 'message' => 'Logout successfully.');
		}
		else
		{
			$returnResponse = array('success' => false, 'message' => 'Please login first to view this content..');
		}

        //-- Convert Response to json
		$this->getJsonData($returnResponse);
	}

	//--Function for login
	public function login()
	{
		$arrayResponse = array();
		try
		{
			//--admin param
			$admData['adm_email'] = isset($this->requestData->adm_email)?$this->requestData->adm_email:"";
			$admData['adm_password'] = isset($this->requestData->adm_password)?$this->requestData->adm_password:"";

			if(empty($admData['adm_email']) && empty($admData['adm_password']))
			{
				$arrayResponse = array('success' => false, 'message' =>'UserName and Password required');
			}
			else
			{
				//--Call model function for login
				$response = $this->AdminModel->login($admData);

				if ($response)
				{
					$login_usr_session1 = array
					(
						'user_id'    => $response['adm_id'],
						'user_name'  => $response['adm_name'],
						'user_email' => $response['adm_email'],
					);

					$_SESSION['login_admin_session'] = $login_usr_session1;

					$arrayResponse = array('success' => true, 'data' => $response, 'message' =>'Login successfully');
				}
				else
				{
					$arrayResponse = array('success' => false, 'message' => 'Wrong Username and Password.');
				}

				if(empty($arrayResponse))
				{
					throw new Exception('Oops! Something went wrong please try again.');
				}
			}
		}
		catch (Exception $e)
		{
			$arrayResponse = array('success' => false, 'message' => $e->getMessage());
		}

		//--Convert Response to json
		$this->getJsonData($arrayResponse);
	}

	//change email
	public function changeEmail()
	{
		$arrayResponse = array();

		try
		{
			if($this->isSession())
			{ 
				$admData['adm_id'] = isset($this->requestData->adm_id)?$this->requestData->adm_id:"";
				$admData['adm_email'] = isset($this->requestData->adm_email)?$this->requestData->adm_email:"";
				$admData['adm_name'] = isset($this->requestData->adm_name)?$this->requestData->adm_name:"";
				$admData['adm_image'] = isset($_FILES['admImage']['name'])?$_FILES['admImage']['name']:"";

				if($admData['adm_email'] =="" and $admData['adm_image'] == "")
				{
					$data = $this->AdminModel->adminRecord('comm_admin', $admData);
					$arrayResponse = array('success' => false,'record'=>$data, 'message' => 'Field is required.');
				}
				else
				{
					if($admData['adm_image'] != "" or $admData['adm_email'] != "")
					{
						//--Call controller function for save base64 image
						$path = './upload/adm_profile_image/';
						$config['upload_path']          = $path;
						$config['allowed_types']        = 'gif|jpg|png|jpeg';
						$config['max_size']             = 8000;
						$config['max_width']            = 1024;
						$config['max_height']           = 768;
						$config['encrypt_name'] = TRUE;
						$this->load->library('upload', $config);

						if ( ! $this->upload->do_upload('admImage'))
						{
							$error = array('error' => $this->upload->display_errors());
							$arrayResponse = array('success' => false,  'message' => 'Image is Not Updated.');
						}
						else
						{
							$data = array('upload_data' => $this->upload->data());
							$admData['img'] = $data['upload_data']['file_name'];
						}

						//--Call model function for email update
						$response = $this->AdminModel->changeEmail('comm_admin', $admData);
						$data = $this->AdminModel->adminRecord('comm_admin', $admData);

						if ($response ==1)
						{
							$arrayResponse = array('success' => true,'record'=>$data, 'data' => $response, 'message' =>'Updated successfully');
						}
						else
						{
							$arrayResponse = array('success' => false, 'message' => 'Not Updated.');
						}
					}
				}
			}
			else
			{
				$arrayResponse = array("success" => false, "message" => "Your session has timed out, please login again.");
			}
		}
		catch (Exception $e)
		{
			$arrayResponse = array('success' => false, 'message' => $e->getMessage());
		}

		//--Convert Response to json
		$this->getJsonData($arrayResponse);
	}

	// active inactive user
	public function activeInactiveUser()
	{
		$arrayResponse = array();

		try
		{
			if($this->isSession())
			{ 
				$usrId = isset($this->requestData->usr_id)?$this->requestData->usr_id:"";
				$usrData['usr_isDelete'] = isset($this->requestData->usr_isDelete)?$this->requestData->usr_isDelete:"";
				$userData['usr_updatedate'] = strtotime(gmdate('Y-m-d h:i:s a').' UTC');

				if(empty($usrId))
				{
					$arrayResponse = array('success' => false, 'message' =>'User id is required.');
				}
				else
				{
					//--Call model function for Active Inactive
					$response = $this->AdminModel->updateData('comm_users',array('usr_id' =>$usrId), $usrData);

					if($response)
					{
						$arrayResponse = array('success' => true, 'data' => $response, 'message' =>'Record updated successfully.');
					}
					else
					{
						$arrayResponse = array('success' => false, 'message' => 'Record not updated.');
					}
				}
			}
			else
			{
				$arrayResponse = array("success" => false, "message" => "Your session has timed out, please login again.");
			}
		}
		catch (Exception $e)
		{
			$arrayResponse = array('success' => false, 'message' => $e->getMessage());
		}

		//--Convert Response to json
		$this->getJsonData($arrayResponse);
	}

	// show dashboard
	public function dashboard()
	{
		$arrayResponse = array();

		try
		{
			if($this->isSession())
			{ 
				//--Call model function for show help & hive post count
				$help_count = $this->AdminModel->help_hive_count('comm_posts');

				if($help_count)
				{
					$arrayResponse = array('success' => true, 'data' => $help_count);
				}
				else
				{
					$arrayResponse = array('success' => false, 'message' => 'No Data Available');
				}
			}
			else
			{
				$arrayResponse = array("success" => false, "message" => "Your session has timed out, please login again.");
			}

			if(empty($arrayResponse))
			{
				throw new Exception('Oops! Something went wrong please try again.');
			}

		}
		catch (Exception $e)
		{
			$arrayResponse = array('success' => false, 'message' => $e->getMessage());
		}

		//--Convert Response to json
		$this->getJsonData($arrayResponse);
	}

	// forget password
	public function ForgotPassword()
  	{
		$arrayResponse = array();

		$admData['adm_email'] = isset($this->requestData->adm_email)?$this->requestData->adm_email:"";
		try
		{
			if(empty($admData['adm_email']))
			{
				$arrayResponse = array('success' => false, 'message' => 'Email id is required');
			}
			else
			{
				$findemail = $this->AdminModel->ForgotPassword($admData['adm_email']);
				if($findemail)
				{
	             	$this->AdminModel->sendpassword($findemail);
					$arrayResponse = array('success' => true, 'message' => 'New password has been sent to your registered email id');
	            }
				else
				{
					$arrayResponse = array('success' => false, 'message' => 'Oops! email id does not exists, please try again');
				}
			}

			if(empty($arrayResponse))
			{
				throw new Exception('Oops! Something went wrong please try again.');
			}
		}
		catch (Exception $e)
		{
			$arrayResponse = array('success' => false, 'message' => $e->getMessage());
		}

		//--Convert Response to json
		$this->getJsonData($arrayResponse);
  	}


	// change password
	public function changePassword()
	{
		$arrayResponse = array();

		try
		{
			if($this->isSession())
			{ 
				$admData['adm_id'] = isset($this->requestData->adm_id)?$this->requestData->adm_id:"";
				$admData['adm_password'] = isset($this->requestData->adm_password)?$this->requestData->adm_password:"";
				$admData['adm_npassword'] = isset($this->requestData->adm_npassword)?$this->requestData->adm_npassword:"";
				$admData['adm_cpassword'] = isset($this->requestData->adm_cpassword)?$this->requestData->adm_cpassword:"";

				if(empty($admData['adm_password']) && empty($admData['adm_npassword']) && empty($admData['adm_cpassword']))
				{
					$arrayResponse = array('success' => false, 'message' =>'All Fields are Empty');
				}
				elseif(empty($admData['adm_password']) || empty($admData['adm_npassword']) || empty($admData['adm_cpassword']))
				{
					$arrayResponse = array('success' => false, 'message' =>'Fields are Required.');
				}
				elseif($admData['adm_npassword'] != $admData['adm_cpassword'])
				{
					$arrayResponse = array('success' => false, 'message' =>'New Password and confirm password do not match.');
				}

				else
				{
					//--Call model function for email update
					$response = $this->AdminModel->changePassword('comm_admin', $admData);

					if (!empty($response))
					{
						$arrayResponse = array('success' => true, 'data' => $response, 'message' =>'Password has changed successfully.');
					}
					else
					{
						$arrayResponse = array('success' => false, 'message' => 'Password does not match.');
					}
				}
			}
			else
			{
				$arrayResponse = array("success" => false, "message" => "Your session has timed out, please login again.");
			}
		}
		catch (Exception $e)
		{
			$arrayResponse = array('success' => false, 'message' => $e->getMessage());
		}

		//--Convert Response to json
		$this->getJsonData($arrayResponse);
	}

	// show community profile
	public function communityProfile()
	{
		$arrayResponse = array();

		try
		{
			if($this->isSession())
			{ 
				//--Call model function for show help & hive post count
				$filterData['limit'] = isset($this->requestData->limit)?$this->requestData->limit:"10";
				$filterData['page'] = isset($this->requestData->page)?$this->requestData->page:"0";

				$response['contents'] = $this->AdminModel->communityProfile($filterData);
				$response['numOfRows']=$this->AdminModel->countRows();

				if($response)
				{

					$arrayResponse = array('success' => true, 'data' => $response);
				}
				else
				{
					$arrayResponse = array('success' => false, 'message' => 'No Data Available');
				}
			}
			else
			{
				$arrayResponse = array("success" => false, "message" => "Your session has timed out, please login again.");
			}

			if(empty($arrayResponse))
			{
				throw new Exception('Oops! Something went wrong please try again.');
			}

		}
		catch (Exception $e)
		{
			$arrayResponse = array('success' => false, 'message' => $e->getMessage());
		}

		//--Convert Response to json
		$this->getJsonData($arrayResponse);
	}

	// get user list
	public function getUserslist()
	{
		$arrayResponse = array();

		try
		{
			if($this->isSession())
			{ 
				$filterData['search'] = isset($this->requestData->search)?$this->requestData->search:"";
				$filterData['social_name'] = isset($this->requestData->socialName)?$this->requestData->socialName:"";
				$filterData['limit'] = isset($this->requestData->limit)?$this->requestData->limit:"";
				$filterData['page'] = isset($this->requestData->page)?$this->requestData->page:"";

				//--Call model function for show help & hive post count
				$response = $this->AdminModel->getUserslist($filterData);

				if($response)
				{
					$arrayResponse = $response;
				}
				else
				{
					$arrayResponse = array('success' => false, 'message' => 'No Data Available');
				}
			}
			else
			{
				$arrayResponse = array("success" => false, "message" => "Your session has timed out, please login again.");
			}

			if(empty($arrayResponse))
			{
				throw new Exception('Oops! Something went wrong please try again.');
			}

		}
		catch (Exception $e)
		{
			$arrayResponse = array('success' => false, 'message' => $e->getMessage());
		}

		//--Convert Response to json
		$this->getJsonData($arrayResponse);
	}

	// view user
	public function viewUser()
	{
		$arrayResponse = array();
		$usrData['usr_id'] = isset($this->requestData->usr_id)?$this->requestData->usr_id:"";

		try
		{
			if($this->isSession())
			{ 
				if(empty($usrData['usr_id']))
				{
					$arrayResponse = array('success' => false, 'message' => 'User id is required.');
				}
				else
				{
					//--Call model function for show help & hive post count
					$response = $this->AdminModel->viewUser($usrData);

					if($response)
					{
						$arrayResponse = array('success' => true, 'data' => $response, 'message' => 'Users record');
					}
					else
					{
						$arrayResponse = array('success' => false, 'message' => 'No Data Available');
					}
				}   
			}
			else
			{
				$arrayResponse = array("success" => false, "message" => "Your session has timed out, please login again.");
			}

			if(empty($arrayResponse))
			{
				throw new Exception('Oops! Something went wrong please try again.');
			}
		}
		catch (Exception $e)
		{
			$arrayResponse = array('success' => false, 'message' => $e->getMessage());
		}

		//--Convert Response to json
		$this->getJsonData($arrayResponse);
	}

	//--Function for edit comments
	public function editDummyUsrProfile()
	{
		$arrayResponse = array();

		try
		{
			if($this->isSession())
			{ 
				//--Get param
				$usrId = isset($this->requestData->usrId)?$this->requestData->usrId:"";
				$usrData['usr_fname'] = isset($this->requestData->fname)?$this->requestData->fname:"";
				$usrData['usr_lname'] = isset($this->requestData->lname)?$this->requestData->lname:"";
				$usrData['usr_username'] = isset($this->requestData->username)?'@'.$this->requestData->username:"";
				$usrData['usr_email'] = isset($this->requestData->email)?$this->requestData->email:"";
				$usrData['usr_gender'] = isset($this->requestData->gender)?$this->requestData->gender:"";
				$usrData['usr_dob'] = isset($this->requestData->dob)?$this->requestData->dob:"";
				$usrData['usr_app_location'] = isset($this->requestData->appLocation)?$this->requestData->appLocation:"";
				$usrData['usr_updatedate'] = strtotime(gmdate('Y-m-d h:i:s a').' UTC');

				if(empty($usrId))
				{
					$arrayResponse = array('success' => false, 'message' => 'User id is required.');
				}
				else
				{
					 $checkEmail = $this->AdminModel->singleData('usr_email', 'comm_users',array('usr_id!='=>$usrId,'usr_email' =>$usrData['usr_email'],'usr_email!=' =>''));

					 $checkUsername = $this->AdminModel->singleData('usr_username', 'comm_users',array('usr_id!='=>$usrId,'usr_username' =>$usrData['usr_username'],'usr_username!=' =>''));

					 if($checkEmail)
					 {
					 	 $arrayResponse = array('success' => false, 'message' => 'Email id already exist.');
					 }
					 elseif ($checkUsername) 
					 {
					 	 $arrayResponse = array('success' => false, 'message' => 'User name already exist.');
					 }
					 else
					 {
					 	if (isset($_FILES['fileName']) && !empty($_FILES['fileName']['tmp_name']))
					    {
					    	
					    	$imageName = $this->AdminModel->singleData('usr_image','comm_users', array('usr_id' => $usrId));

					    	if($imageName)
					    	{
					    		@unlink('./upload/profile_image/'.$imageName['usr_image']);
					    	}

					    	//--Upload image on folder
					    	$fileName = $this->fileUpload('./upload/profile_image/',$usrId);

							if (isset($fileName['error']))
							{
								$arrayResponse = array('success' =>false ,'message' =>'Error in uploading your file, please try again');
								$this->getJsonData($arrayResponse);
							}
							else
							{
								$usrData['usr_image'] = $fileName;
								$imageName = $this->AdminModel->singleData('usr_image','comm_users', array('usr_id' => $usrId));

							}
						 }

						//--Call model function for edit User
						$response = $this->AdminModel->updateData('comm_users',array('usr_id' =>$usrId), $usrData);

						if ($response)
						{
							$usrIdData['usr_id'] = $usrId;
							$editDataResponse = $this->AdminModel->viewUser($usrIdData);
							$arrayResponse = array('success' => true, 'data' => $editDataResponse, 'message' => 'You have successfully edited Record.');
						}
						else
						{
							$arrayResponse = array('success' => false, 'message' => 'Oops! Error in updating data, Please try again.');
						}
					}
				}
			}
			else
			{
				$arrayResponse = array("success" => false, "message" => "Your session has timed out, please login again.");
			}

			if(empty($arrayResponse))
			{
				throw new Exception('Oops! Something went wrong please try again.');
			}
		}
		catch (Exception $e)
		{
			$arrayResponse = array('success' => false, 'message' => $e->getMessage());
		}

		//--Convert Response to json
		$this->getJsonData($arrayResponse);
	}
	
	// glag against user list
	public function flagAgainstUserlist()
	{
		$arrayResponse = array();

		try
		{
			if($this->isSession())
			{ 
				//--Call model function for show flag user list
				$filterData['limit'] = isset($this->requestData->limit)?$this->requestData->limit:"";
				$filterData['page'] = isset($this->requestData->page)?$this->requestData->page:"";

				$response['contents'] = $this->AdminModel->flagAgainstUserlist($filterData);
				$response['numOfRows'] = $this->AdminModel->countRows();

				if($response)
				{
					$arrayResponse = array('success' => true, 'data' => $response);
				}
				else
				{
					$arrayResponse = array('success' => false, 'message' => 'No Data Available');
				}
			}
			else
			{
				$arrayResponse = array("success" => false, "message" => "Your session has timed out, please login again.");
			}

			if(empty($arrayResponse))
			{
				throw new Exception('Oops! Something went wrong please try again.');
			}
		}
		catch (Exception $e)
		{
			$arrayResponse = array('success' => false, 'message' => $e->getMessage());
		}

		//--Convert Response to json
		$this->getJsonData($arrayResponse);
	}

	//get flag against list
	public function getflagAgainstlist()
	{
		$arrayResponse = array();

		try
		{
			if($this->isSession())
			{ 
				//--Call model function for show flag user list
				$filterData['usr_id'] = isset($this->requestData->usr_id)?$this->requestData->usr_id:"";
				$filterData['ID'] = isset($this->requestData->ID)?$this->requestData->ID:"";
				$filterData['Type'] = isset($this->requestData->Type)?$this->requestData->Type:"";
				$filterData['limit'] = isset($this->requestData->limit)?$this->requestData->limit:"";
				$filterData['page'] = isset($this->requestData->page)?$this->requestData->page:"";

				$response['contents'] = $this->AdminModel->getflagAgainstlist($filterData);

				if($response)
				{

					$arrayResponse = array('success' => true, 'data' => $response);
				}
				else
				{
					$arrayResponse = array('success' => false, 'message' => 'No Data Available');
				}
			}
			else
			{
				$arrayResponse = array("success" => false, "message" => "Your session has timed out, please login again.");
			}

			if(empty($arrayResponse))
			{
				throw new Exception('Oops! Something went wrong please try again.');
			}
		}
		catch (Exception $e)
		{
			$arrayResponse = array('success' => false, 'message' => $e->getMessage());
		}

		//--Convert Response to json
		$this->getJsonData($arrayResponse);
	}

	//--Function for end help request
	public function sendFirebaseMsg()
	{
		$arrayResponse = array();

		try 
		{ 	
			//--Get param
			$usrId = isset($this->requestData->usrId)?$this->requestData->usrId:"";
			$msg = isset($this->requestData->msg)?$this->requestData->msg:"";
			$usrfName = isset($this->requestData->fName)?$this->requestData->fName:"";
			$usrlName = isset($this->requestData->lName)?$this->requestData->lName:"";

			if(empty($usrId))
			{
				$arrayResponse = array('success' => false, 'message' => 'User id is required.');
			}
			else
			{
				//--Call model function for end help request
				$response = $this->AdminModel->singleData('dev_device_token','comm_devices',array('dev_usr_id' => $usrId));

				if ($response)
				{
					//--notification data
					if(strlen($msg)>44)
					{
						$message = substr($msg, 0, 41).'...';
					}
					else
					{
						$message = $msg;
					}

		            //--msg for notification
		            $notifyMessage['ntfy_message'] = $message;
		            $notifyMessage['title'] = $usrfName.' '.$usrlName;
		            $notifyMessage['ntfy_pst_type'] = 'ADMIN_CHAT_MSG';

		            //-call function for send notification
            		$this->AdminModel->sendNotification($response['dev_device_token'], $notifyMessage);

					$arrayResponse = array('success' => true, 'data' => '', 'message' => 'Send successfully');
				}
				else
				{
					$arrayResponse = array('success' => false, 'message' => 'Not sent');
				}
			}

			if(empty($arrayResponse))
			{
				throw new Exception('Server Error, please try again.');
			}
		} 
		catch (Exception $e) 
		{
			$arrayResponse = array('success' => false, 'message' => $e->getMessage());
		}

		//--Convert Response to json
		$this->getJsonData($arrayResponse);
	}

	//--Function for login
	public function addDummyUser()
	{
		$arrayResponse = array();
		$imageError="";

		try 
		{ 	
			if($this->isSession())
			{ 
				//--user param
				$userData['usr_fname'] = isset($this->requestData->fname)?$this->requestData->fname:"";
				$userData['usr_lname'] = isset($this->requestData->lname)?$this->requestData->lname:"";
				$userData['usr_email'] = isset($this->requestData->email)?$this->requestData->email:"";
				$userData['usr_dob'] = isset($this->requestData->dob)?$this->requestData->dob:"";
				$userData['usr_gender'] = isset($this->requestData->gender)?$this->requestData->gender:"";
				$userData['usr_social_name'] = 'website';
				$userData['usr_fb_location'] = isset($this->requestData->fbLocation)?$this->requestData->fbLocation:"";
				$userData['usr_app_location'] = isset($this->requestData->appLocation)?$this->requestData->appLocation:"";
				$userData['usr_createddate'] = strtotime(gmdate('Y-m-d h:i:s a').' UTC');
				$userData['usr_username'] = "@".strtolower($userData['usr_fname'])."_".substr(uniqid(mt_rand(), true), 0, 3);

				if(empty($userData['usr_email']))
				{
					$arrayResponse = array('success' => false, 'message' =>'Email id is required');
				}
				else
				{
					$checkEmail = $this->AdminModel->singleData('usr_email','comm_users',array('usr_email' => $userData['usr_email']));

					if($checkEmail['usr_email'])
					{
						$arrayResponse = array('success' => true, 'message' =>'Email id already exist');
					}
					else
					{
						//--Call model function for login
						$response = $this->AdminModel->insertData($userData,'comm_users');

						if($response)
						{
							if (isset($_FILES['fileName']) && !empty($_FILES['fileName']['tmp_name']))
						    {
						    	//--Upload image on folder
						    	$fileName = $this->fileUpload('./upload/profile_image/',$response);

								if (isset($fileName['error']))
								{
									$imageError = 'Error in uploading your file, please try to edit.';
									//$this->getJsonData($arrayResponse);
								}
								else
								{
									$imageName['usr_image'] = $fileName;
									$this->AdminModel->updateData('comm_users', array('usr_id' => $response),$imageName);
								}
							 }

							 //--Call module function for join all group
							 $this->AdminModel->joinDefaultAppGroup($response);

							 $arrayResponse = array('success' => true, 'data' => $response, 'message' =>'Added successfully','imgErr' => $imageError);
						}
						else
						{
							$arrayResponse = array('success' => false, 'message' => 'Error! is adding data please try again.');
						}
					}
				}
			}
			else
			{
				$arrayResponse = array("success" => false, "message" => "Your session has timed out, please login again.");
			}

			if(empty($arrayResponse))
			{
				throw new Exception('Oops! Something went wrong please try again');
			}
		   
		} 
		catch (Exception $e) 
		{
			$arrayResponse = array('success' => false, 'message' => $e->getMessage());
		}

		//--Convert Response to json
		$this->getJsonData($arrayResponse);
	}

	//--Function for get location
	public function getLocation()
	{
		$arrayResponse = array();

		try 
		{ 	
			if($this->isSession())
			{  
				//--Call model function for get location
				$response = $this->AdminModel->selectMultipleData('*','comm_location');

				if ($response)
				{
					$arrayResponse = array('success' => true, 'data' => $response,'message' => 'Location get successfully');
				}
				else
				{
					$arrayResponse = array('success' => false, 'message' => 'Oops! There is no data to display.');
				}
			}
			else
			{
				$arrayResponse=array("success" => false, "message" => "Your session has timed out, please login again");
			}

			if(empty($arrayResponse))
			{
				throw new Exception('Server error, please try again.');
			}
		} 
		catch (Exception $e) 
		{
			$arrayResponse = array('success' => false, 'message' => $e->getMessage());
		}

		//--Convert Response to json
		$this->getJsonData($arrayResponse);
	}

	//--Function for get category
	public function getCategories()
	{
		$arrayResponse = array();

		try 
		{ 	
			if($this->isSession())
			{  
				$select = "cat_id,cat_name,cat_description,CASE WHEN cat_icon!='' THEN CONCAT('".CATEGORY_IMAGE."',cat_icon)  ELSE cat_icon END as cat_image";
				$where = array('cat_type' =>'CATEGARY');

				//--Call model function for get category
				$response = $this->AdminModel->selectMultipleData($select,'comm_categories',$where);

				if ($response)
				{
					$arrayResponse = array('success' => true, 'data' => $response,'message' => 'Category get successfully');
				}
				else
				{
					$arrayResponse = array('success' => false, 'message' => 'Oops! There is no data to display.');
				}
			}
			else
			{
				$arrayResponse=array("success" => false,"message" => "Your session has timed out, please login again.");
			}

			if(empty($arrayResponse))
			{
				throw new Exception('Server Error, please try again.');
			}
		} 
		catch (Exception $e) 
		{
			$arrayResponse = array('success' => false, 'message' => $e->getMessage());
		}

		//--Convert Response to json
		$this->getJsonData($arrayResponse);
	}

	//--Function for add user hive
	public function addUserHive()
	{
		$arrayResponse = array();

		try 
		{ 	
			if($this->isSession())
			{  
				//--Get param
				$hiveData['pst_cat_id'] = isset($this->requestData->catId)?$this->requestData->catId:"";
				$hiveData['pst_usr_id'] = isset($this->requestData->dmUsrId)?$this->requestData->dmUsrId:"";
				$hiveData['pst_title'] = isset($this->requestData->ttl)?$this->requestData->ttl:"";
				$hiveData['pst_description'] = isset($this->requestData->dscptn)?$this->requestData->dscptn:"";
				$hiveData['pst_grp_id'] = isset($this->requestData->grpId)?$this->requestData->grpId:"";
				$hiveData['pst_completed'] = 'NO';
				$hiveData['pst_createdate'] = strtotime(gmdate('Y-m-d h:i:s a').' UTC');
				$hiveData['pst_updatedate'] = strtotime(gmdate('Y-m-d h:i:s a').' UTC');
				$hiveTags = isset($this->requestData->tags)?$this->requestData->tags:array();

				if(empty($hiveData['pst_cat_id']))
				{
					$arrayResponse = array('success' => false, 'message' => 'Category id is required.');
				}
				elseif (empty($hiveData['pst_grp_id'])) 
				{
					$arrayResponse = array('success' => false, 'message' => 'Group id is required.');
				}
				elseif (empty($hiveData['pst_usr_id'])) 
				{
					$arrayResponse = array('success' => false, 'message' => 'User id is required');
				}
				else
				{
					//--Call model function for add hive post
					$response = $this->AdminModel->addUserHive($hiveData,$hiveTags);

					if ($response)
					{
						$userActivity['usr_lastActivity'] = strtotime(gmdate('Y-m-d h:i:s a').' UTC');
						$this->AdminModel->updateData('comm_users', array('usr_id' => $hiveData['pst_usr_id']), $userActivity);

						$arrayResponse = array('success' => true, 'data' => $response, 'message' => 'You Hive post has been successfully created.');
					}
					else
					{
						$arrayResponse = array('success' => false, 'message' => 'Oops! Error in adding data, Please try again.');
					}
				}
			}
			else
			{
				$arrayResponse = array("success" => false, "message" => "Token is expired,please login in again.");
			}

			if(empty($arrayResponse))
			{
				throw new Exception('Server Error, please try again.');
			}
		} 
		catch (Exception $e) 
		{
			$arrayResponse = array('success' => false, 'message' => $e->getMessage());
		}

		//--Convert Response to json
		$this->getJsonData($arrayResponse);
	}

	//--Function for edit user hive
	public function editUserHiveById()
	{
		$arrayResponse = array();

		try 
		{ 	
			if($this->isSession())
			{  
				//--Get param
				$pstId = isset($this->requestData->pstId)?$this->requestData->pstId:"";
				$hiveData['pst_grp_id'] = isset($this->requestData->grpId)?$this->requestData->grpId:"";
				$hiveData['pst_title'] = isset($this->requestData->ttl)?$this->requestData->ttl:"";
				$hiveData['pst_description'] = isset($this->requestData->dscptn)?$this->requestData->dscptn:"";
				$hiveData['pst_updatedate'] = strtotime(gmdate('Y-m-d h:i:s a').' UTC');
				$hiveTags = isset($this->requestData->tags)?$this->requestData->tags:array(); 
				$dmUsrId =isset($this->requestData->dmUsrId)?$this->requestData->dmUsrId:"";

				if(empty($pstId))
				{
					$arrayResponse = array('success' => false, 'message' => 'Post id is required.');
				}
				elseif (empty($hiveData['pst_grp_id'])) 
				{
					$arrayResponse = array('success' => false, 'message' => 'Group id is required.');
				}
				elseif (empty($dmUsrId)) 
				{
					$arrayResponse = array('success' => false, 'message' => 'User id is required');
				}
				else
				{
					//--Call model function for edit hive post
					$response = $this->AdminModel->editUserHiveById($pstId,$hiveData,$hiveTags);

					if ($response)
					{
						$userActivity['usr_lastActivity'] = strtotime(gmdate('Y-m-d h:i:s a').' UTC');
						$this->AdminModel->updateData('comm_users', array('usr_id' => $dmUsrId), $userActivity);

						$response[0]['pst_createdate'] = (string)$hiveData['pst_updatedate'];

						$arrayResponse = array('success' => true, 'data' => $response, 'message' => 'You have successfully edited your hive post');
					}
					else
					{
						$arrayResponse = array('success' => false, 'message' => 'Oops! Error in updating data, Please try again.');
					}
				}
			}
			else
			{
				$arrayResponse = array("success" => false, "message" => "Your session has timed out, please login again.");
			}

			if(empty($arrayResponse))
			{
				throw new Exception('Server Error, please try again.');
			}
		} 
		catch (Exception $e) 
		{
			$arrayResponse = array('success' => false, 'message' => $e->getMessage());
		}

		//--Convert Response to json
		$this->getJsonData($arrayResponse);
	}

	//--Function for hide post 
	public function deleteHelpOrHivePostById()
	{
		$arrayResponse = array();

		try 
		{ 	
			if($this->isSession())
			{  
				//--Get param
				$pstId = isset($this->requestData->pstId)?$this->requestData->pstId:"";
				$postData['pst_isDeleted'] = 1;
				$postData['pst_updatedate'] = strtotime(gmdate('Y-m-d h:i:s a').' UTC');
				$dmUsrId = isset($this->requestData->dmUsrId)?$this->requestData->dmUsrId:"";

				if(empty($pstId))
				{
					$arrayResponse = array('success' => false, 'message' => 'Post id is required.');
				}
				elseif (empty($dmUsrId)) 
				{
					$arrayResponse = array('success' => false, 'message' => 'User id is required');
				}
				else
				{
					//--Call model function for hide post
					$response = $this->AdminModel->updateData('comm_posts',array('pst_id' =>$pstId), $postData);

					if ($response)
					{
						//--Remove notification data
						$this->AdminModel->deleteData('comm_notification', array('ntfy_pst_id' => $pstId));

						$userActivity['usr_lastActivity'] = strtotime(gmdate('Y-m-d h:i:s a').' UTC');
						$this->AdminModel->updateData('comm_users', array('usr_id' => $dmUsrId), $userActivity);

						$arrayResponse = array('success' => true, 'data' => $response, 'message' => 'You have successfully deleted');
					}
					else
					{
						$arrayResponse = array('success' => false, 'message' => 'Oops! Error in deleting data, Please try again.');
					}
				}
			}
			else
			{
				$arrayResponse = array("success" => false, "message" => "Your session has timed out, please login again.");
			}

			if(empty($arrayResponse))
			{
				throw new Exception('Server Error, please try again.');
			}
		} 
		catch (Exception $e) 
		{
			$arrayResponse = array('success' => false, 'message' => $e->getMessage());
		}

		//--Convert Response to json
		$this->getJsonData($arrayResponse);
	}

	//--Function for get help data
	public function getOrFilterAllHivePost()
	{
		$arrayResponse = array();

		try 
		{ 	
			if($this->isSession())
			{  
				//--Get param
				$filterData['pst_id'] = isset($this->requestData->pstId)?$this->requestData->pstId:"";
				$filterData['cat_id'] = isset($this->requestData->catId)?$this->requestData->catId:"";
				$filterData['trend'] = isset($this->requestData->trndPst)?$this->requestData->trndPst:"";
				$filterData['filter'] = isset($this->requestData->filter)?$this->requestData->filter:"";
				$filterData['usr_id'] = isset($this->requestData->dmUsrId)?$this->requestData->dmUsrId:"";
				$filterData['limit'] = isset($this->requestData->limit)?$this->requestData->limit:"10";
				$filterData['start'] = isset($this->requestData->page)?$this->requestData->page:"0";
				$filterData['pst_grp_id'] = isset($this->requestData->grpId)?$this->requestData->grpId:"";
				
				if(empty($filterData['cat_id']) && empty($filterData['pst_id']))
				{
					$arrayResponse = array('success' => false, 'message' => 'Category or Post id is required.');
				}
				elseif (empty($filterData['usr_id'])) 
				{
					$arrayResponse = array('success' => false, 'message' => 'User id is required');
				}
				else
				{
					//--Call model function for get help data
					$response = $this->AdminModel->getOrFilterAllHivePost($filterData);

					if ($response)
					{
						$arrayResponse = $response;
					}
					else
					{
						$arrayResponse = array('success' => false, 'message' => 'Oops! There is no data to display.');
					}
				}
			}
			else
			{
				$arrayResponse = array("success" => false, "message" => "Your session has timed out, please login again.");
			}

			if(empty($arrayResponse))
			{
				throw new Exception('Server Error, please try again.');
			}
		} 
		catch (Exception $e) 
		{
			$arrayResponse = array('success' => false, 'message' => $e->getMessage());
		}

		//--Convert Response to json
		$this->getJsonData($arrayResponse);
	}

	//--Function for add comment on post
	public function addCommentOnPost()
	{
		$arrayResponse = array();

		try 
		{ 	
			if($this->isSession())
			{  
				//--Get param
				$postData['and_pst_id'] = isset($this->requestData->pstId)?$this->requestData->pstId:"";
				$postData['ans_usr_id'] = isset($this->requestData->dmUsrId)?$this->requestData->dmUsrId:"";
				$postData['ans_description'] = isset($this->requestData->dscptn)?$this->requestData->dscptn:"";
				$postData['ans_createdate'] = strtotime(gmdate('Y-m-d h:i:s a').' UTC');
				$postTitle = isset($this->requestData->pstTtl)?$this->requestData->pstTtl:"";
				$pstUsrNm = isset($this->requestData->pstUsrNm)?$this->requestData->pstUsrNm:"";
				$pstUsrId = isset($this->requestData->pstUsrId)?$this->requestData->pstUsrId:"";

				if(empty($postData['and_pst_id']))
				{
					$arrayResponse = array('success' => false, 'message' => 'Post id is required.');
				}
				elseif (empty($postData['ans_usr_id'])) 
				{
					$arrayResponse = array('success' => false, 'message' => 'User id is required');
				}
				else
				{
					//--Call model function for add comment on post
					$response = $this->AdminModel->addCommentOnPost($postData,$postTitle,$pstUsrId,$this->isSession()['usr_fname'],$pstUsrNm);

					if ($response)
					{
						$userActivity['usr_lastActivity'] = strtotime(gmdate('Y-m-d h:i:s a').' UTC');
						$this->AdminModel->updateData('comm_users', array('usr_id' => $postData['ans_usr_id']), $userActivity);

						$dataResponse[0]['ans_description'] = $postData['ans_description'];
						$dataResponse[0]['ans_createdate'] = (string)$postData['ans_createdate'];
						$dataResponse[0]['ans_updatedate'] = (string)$postData['ans_createdate'];
						$dataResponse[0]['ans_id'] = (string)$response['ans_id'];
						$dataResponse[0]['great'] = "NO";
						$dataResponse[0]['user_upvote'] = "NO";
						$dataResponse[0]['count_upvote'] = "0";
						$dataResponse[0]['usr_id'] = $postData['ans_usr_id'];
						$dataResponse[0]['profile_image'] = "";
						$dataResponse[0]['ans_ntfy_id'] = (string)$response['ntfy_id'];

						$arrayResponse = array('success' => true, 'data' => $dataResponse, 'message' => 'Comments added successfully.');
					}
					else
					{
						$arrayResponse = array('success' => false, 'message' => 'Oops! Error in adding data, Please try again.');
					}
				}
			}
			else
			{
				$arrayResponse = array("success" => false, "message" => "Your session has timed out, please login again.");
			}

			if(empty($arrayResponse))
			{
				throw new Exception('Server Error, please try again.');
			}
		} 
		catch (Exception $e) 
		{
			$arrayResponse = array('success' => false, 'message' => $e->getMessage());
		}

		//--Convert Response to json
		$this->getJsonData($arrayResponse);
	}

	//--Function for edit comments
	public function editHiveCommentById()
	{
		$arrayResponse = array();

		try 
		{ 	
			if($this->isSession())
			{  
				//--Get param
				$ansId = isset($this->requestData->ansId)?$this->requestData->ansId:"";
				$commentData['ans_description'] = isset($this->requestData->dscptn)?$this->requestData->dscptn:"";
				$commentData['ans_updatedate'] = strtotime(gmdate('Y-m-d h:i:s a').' UTC');
				$dmUsrId = isset($this->requestData->dmUsrId)?$this->requestData->dmUsrId:"";

				if(empty($ansId))
				{
					$arrayResponse = array('success' => false, 'message' => 'Answer id is required.');
				}
				elseif (empty($dmUsrId)) 
				{
					$arrayResponse = array('success' => false, 'message' => 'User id is required');
				}
				else
				{
					//--Call model function for edit comments
					$response = $this->AdminModel->updateData('comm_answers',array('ans_id' =>$ansId), $commentData);

					if ($response)
					{
						$userActivity['usr_lastActivity'] = strtotime(gmdate('Y-m-d h:i:s a').' UTC');
						$this->AdminModel->updateData('comm_users', array('usr_id' => $dmUsrId), $userActivity);

						$dataResponse[0]['ans_description'] = $commentData['ans_description'];
						$dataResponse[0]['ans_createdate'] = (string)$commentData['ans_updatedate'];

						$arrayResponse = array('success' => true, 'data' => $dataResponse, 'message' => 'You have successfully edited your comment.');
					}
					else
					{
						$arrayResponse = array('success' => false, 'message' => 'Oops! Error in updating data, Please try again.');
					}
				}
			}
			else
			{
				$arrayResponse = array("success" => false, "message" => "Your session has timed out, please login again.");
			}

			if(empty($arrayResponse))
			{
				throw new Exception('Server Error, please try again.');
			}
		} 
		catch (Exception $e) 
		{
			$arrayResponse = array('success' => false, 'message' => $e->getMessage());
		}

		//--Convert Response to json
		$this->getJsonData($arrayResponse);
	}

	//--Function for hide comment 
	public function deleteHiveCommentById()
	{
		$arrayResponse = array();

		try 
		{ 	
			if($this->isSession())
			{  
				//--Get param
				$ansId = isset($this->requestData->ansId)?$this->requestData->ansId:"";
				$ntfyId = isset($this->requestData->ntfyId)?$this->requestData->ntfyId:"";
				$dmUsrId = isset($this->requestData->dmUsrId)?$this->requestData->dmUsrId:"";
				$commentData['ans_isDeleted'] = 1;
				$commentData['ans_updatedate'] = strtotime(gmdate('Y-m-d h:i:s a').' UTC');

				if(empty($ansId))
				{
					$arrayResponse = array('success' => false, 'message' => 'Answer id is required.');
				}
				elseif (empty($dmUsrId)) 
				{
					$arrayResponse = array('success' => false, 'message' => 'User id is required');
				}
				else
				{
					//--Call model function for hide comment
					$response = $this->AdminModel->updateData('comm_answers',array('ans_id' => $ansId), $commentData);

					if ($response)
					{
						$userActivity['usr_lastActivity'] = strtotime(gmdate('Y-m-d h:i:s a').' UTC');
						$this->AdminModel->updateData('comm_users', array('usr_id' => $dmUsrId), $userActivity);

						//--Remove notification data
						$where = array('ntfy_id' =>$ntfyId);

						$this->AdminModel->deleteData('comm_notification',$where);

						$arrayResponse = array('success' => true, 'data' => $response, 'message' => 'You have successfully deleted your comment.');
					}
					else
					{
						$arrayResponse = array('success' => false, 'message' => 'Oops! Error in deleting data, Please try again.');
					}
				}
			}
			else
			{
				$arrayResponse = array("success" => false, "message" => "Your session has timed out, please login again.");
			}

			if(empty($arrayResponse))
			{
				throw new Exception('Server Error, please try again.');
			}
		} 
		catch (Exception $e) 
		{
			$arrayResponse = array('success' => false, 'message' => $e->getMessage());
		}

		//--Convert Response to json
		$this->getJsonData($arrayResponse);
	}

	//--Function for upvote post or answer
	public function upvoteDownvotePostOrAnswer()
	{
		$arrayResponse = array();

		try 
		{ 	
			if($this->isSession())
			{  
				//--Get param
				$voteData['upv_type'] = isset($this->requestData->voteTyp)?$this->requestData->voteTyp:"";
				$voteData['upv_usr_id'] = isset($this->requestData->dmUsrId)?$this->requestData->dmUsrId:"";
				$voteData['upv_pst_ans_id'] = isset($this->requestData->voteId)?$this->requestData->voteId:"";
				$voteData['upv_createdate'] = strtotime(gmdate('Y-m-d h:i:s a').' UTC');

				if(empty($voteData['upv_pst_ans_id']))
				{
					$arrayResponse = array('success' => false, 'message' => 'Post or answer id is required.');
				}
				elseif (empty($voteData['upv_type'])) 
				{
					$arrayResponse = array('success' => false, 'message' => 'Vote type is required.');
				}
				elseif (empty($voteData['upv_usr_id'])) 
				{
					$arrayResponse = array('success' => false, 'message' => 'User id is required');
				}
				else
				{
					if($voteData['upv_type'] =='Post')
					{
						//--get user post detail for notification
						$where1 = array('pst_id' => $voteData['upv_pst_ans_id']);
						$pstUsrDetail = $this->AdminModel->singleData('pst_usr_id,pst_title','comm_posts',$where1);
   				    }
   				    else if ($voteData['upv_type'] =='Answer') 
   				    {
   				    	//--get user post comment detail for notification
   				    	$where3 = array('ans_id' =>$voteData['upv_pst_ans_id']);
						$usrDetail = $this->AdminModel->singleData('ans_usr_id,ans_description,and_pst_id','comm_answers',$where3);
   				    }

					//--Make where condition for query
					$where = array('upv_type' => $voteData['upv_type'], 'upv_usr_id' => $voteData['upv_usr_id'],'upv_pst_ans_id' => $voteData['upv_pst_ans_id']);

					//--Call model function for check vote status
					$checkFeedback = $this->AdminModel->singleData('upv_id','comm_upvote',$where); 

					if(empty($checkFeedback))
					{ 
						//--Call model function for add upvote
						$response = $this->AdminModel->insertData($voteData,'comm_upvote');

						if ($response)
						{
							$userActivity['usr_lastActivity'] = strtotime(gmdate('Y-m-d h:i:s a').' UTC');
							$this->AdminModel->updateData('comm_users', array('usr_id' => $voteData['upv_usr_id']), $userActivity);

								if(isset($pstUsrDetail))
								{
									//--Get user device data
									$where2 = array('dev_usr_id' =>$pstUsrDetail['pst_usr_id']);
									$deviceData = $this->AdminModel->singleData('dev_device_token','comm_devices',$where2);

									//--notification data
									if(strlen($pstUsrDetail['pst_title'])>60)
									{
										$message = substr($pstUsrDetail['pst_title'], 0, 57).'...';
									}
									else
									{
										$message = $pstUsrDetail['pst_title'];
									}

									$pushMessage = 'Your post just got an upvote';

						            $notData['ntfy_from'] = $voteData['upv_usr_id'];
						            $notData['ntfy_to'] = $pstUsrDetail['pst_usr_id'];
						            $notData['ntfy_pst_id'] = $voteData['upv_pst_ans_id'];
						            $notData['ntfy_message'] = $message;
						            $notData['ntfy_type'] ='HIVE_UPVOTE';
						            $notData['ntfy_pst_type'] ='HIVE';
						            $notData['ntfy_createdate'] = $voteData['upv_createdate'];
						            
						            //--msg for notification
						            $notifyMessage['ntfy_message'] = $pushMessage;
						            $notifyMessage['ntfy_pst_type'] ='HIVE';

						            if($voteData['upv_usr_id']!=$pstUsrDetail['pst_usr_id'])
						            //-call function for send notification
		                    			$this->AdminModel->sendNotification($deviceData['dev_device_token'], $notifyMessage);

		                    		//--Save notification data
						            $this->AdminModel->insertData($notData,'comm_notification');
	           					}

								if(isset($usrDetail))
								{
									//--Get user device data
									$where4 = array('dev_usr_id' =>$usrDetail['ans_usr_id']);
									$deviceData = $this->AdminModel->singleData('dev_device_token','comm_devices',$where4);

									if(strlen($usrDetail['ans_description'])>60)
									{
										$message = substr($usrDetail['ans_description'], 0, 57).'...';
									}
									else
									{
										$message = $usrDetail['ans_description'];
									}

									$pushMessage = 'Your comment just got an upvote';

						            $notData['ntfy_from'] = $voteData['upv_usr_id'];
						            $notData['ntfy_to'] = $usrDetail['ans_usr_id'];
						            $notData['ntfy_pst_id'] = $usrDetail['and_pst_id'];
						            $notData['ntfy_message'] = $message;
						            $notData['ntfy_type'] ='COMMENT_UPVOTE';
						            $notData['ntfy_pst_type'] ='HIVE';
						            $notData['ntfy_createdate'] = $voteData['upv_createdate'];
						            
						            //--Msg for notification
						            $notifyMessage['ntfy_message'] = $pushMessage;
						            $notifyMessage['ntfy_pst_type'] ='HIVE';

						            if($voteData['upv_usr_id']!=$usrDetail['ans_usr_id'])
							            //-call function for send notification
			                    		$this->AdminModel->sendNotification($deviceData['dev_device_token'], $notifyMessage);

		                    		//--Save notification detail
						            $this->AdminModel->insertData($notData,'comm_notification');
	           					}
           				   
							$arrayResponse = array('success' => true, 'data' => 1, 'message' => 'Upvoted successfully.');
						}
						else
						{
							$arrayResponse = array('success' => false, 'message' => 'Error! in upvote, Please try again.');
						}
					 }
					 else
					 {
					 	//--Call model function for downvote
						$response = $this->AdminModel->deleteData('comm_upvote',$where);

						if ($response)
						{
							if($voteData['upv_type'] =='Post')
							{	
								//--Remove notification data
								$where5 = array('ntfy_from' =>$voteData['upv_usr_id'],'ntfy_to' =>$pstUsrDetail['pst_usr_id'],'ntfy_pst_id' =>$voteData['upv_pst_ans_id'],'ntfy_type' =>'HIVE_UPVOTE');
								$this->AdminModel->deleteData('comm_notification',$where5);
							}
							else if ($voteData['upv_type'] =='Answer') 
							{
								//--Remove notification data
								$where6 = array('ntfy_from' =>$voteData['upv_usr_id'],'ntfy_to' =>$usrDetail['ans_usr_id'],'ntfy_pst_id' =>$usrDetail['and_pst_id'] ,'ntfy_type'=>'COMMENT_UPVOTE');
								$this->AdminModel->deleteData('comm_notification',$where6);
							}

							$arrayResponse = array('success' => true, 'message' => 'Downvoted successfully.', 'data' => 0);
						}
						else
						{
							$arrayResponse = array('success' => false, 'message' => 'Error! in downvote, Please try again.');
						}
					 }
				}
			}
			else
			{
				$arrayResponse=array("success" => false,"message" => "Your session has timed out, please login again.");
			}

			if(empty($arrayResponse))
			{
				throw new Exception('Server Error, please try again.');
			}
		} 
		catch (Exception $e) 
		{
			$arrayResponse = array('success' => false, 'message' => $e->getMessage());
		}

		//--Convert Response to json
		$this->getJsonData($arrayResponse);
	}

	//--Function for like and unlike answer
	public function likeAndUnlikeAnswer()
	{
		$arrayResponse = array();

		try 
		{ 	
			if($this->isSession())
			{  
				//--Get param
				$likeData['gta_usr_id'] = isset($this->requestData->dmUsrId)?$this->requestData->dmUsrId:"";
				$likeData['gta_ans_id'] = isset($this->requestData->ansId)?$this->requestData->ansId:"";
				$likeData['gta_kd_id'] = isset($this->requestData->kudoId)?$this->requestData->kudoId:"";
				$likeData['gta_comment'] = isset($this->requestData->kudoCmnt)?$this->requestData->kudoCmnt:"";
				$likeData['gta_createdate'] = strtotime(gmdate('Y-m-d h:i:s a').' UTC');
				$pstTtl = isset($this->requestData->pstTtl)?$this->requestData->pstTtl:"";

				if(empty($likeData['gta_ans_id']))
				{
					$arrayResponse = array('success' => false, 'message' => 'Answer id is required.');
				}
				elseif (empty($likeData['gta_usr_id'])) 
				{
					$arrayResponse = array('success' => false, 'message' => 'User id is required');
				}
				else
				{
					//--get user post comment detail for notification
					$where1 = array('ans_id' =>$likeData['gta_ans_id']);
					$usrDetail = $this->AdminModel->singleData('ans_usr_id,ans_description,and_pst_id','comm_answers',$where1);
					
					//--Call model function for check user answer status
					$where2 = array('gta_usr_id' => $likeData['gta_usr_id'], 'gta_ans_id' => $likeData['gta_ans_id']);
					$checkStatus = $this->AdminModel->singleData('gta_id','comm_greatanswer',$where2);

					if(empty($checkStatus))
					{
						//--Call model function for like answer
						$response = $this->AdminModel->insertData($likeData,'comm_greatanswer');

						if ($response)
						{
							$userActivity['usr_lastActivity'] = strtotime(gmdate('Y-m-d h:i:s a').' UTC');
							$this->AdminModel->updateData('comm_users', array('usr_id' => $likeData['gta_usr_id']), $userActivity);

							if(isset($usrDetail))
							{
								//--Get user device data
								$where3 = array('dev_usr_id' =>$usrDetail['ans_usr_id']);
								$deviceData = $this->AdminModel->singleData('dev_device_token','comm_devices',$where3);

								if($likeData['gta_comment'])
								{
									$pushMessage = "Congratulation! Your comment was just awarded a badge and a Thank you note.";
								}
								else
								{
									$pushMessage = "Congratulation! Your comment was just awarded a badge.";
								}

								if(strlen($pstTtl)>60)
					            {
					                $message = substr($pstTtl, 0, 57).'...';
					            }
					            else
					            {
					                $message = $pstTtl;
					            }

					            $notData['ntfy_from'] = $likeData['gta_usr_id'];
					            $notData['ntfy_to'] = $usrDetail['ans_usr_id'];
					            $notData['ntfy_pst_id'] = $usrDetail['and_pst_id'];
					            $notData['ntfy_message'] = $message;
					            $notData['ntfy_type'] ='COMMENT_GREAT';
					            $notData['ntfy_pst_type'] ='HIVE';
					            $notData['ntfy_createdate'] = $likeData['gta_createdate'];
					            
					            //--Msg for notification
					            $notifyMessage['ntfy_message'] = $pushMessage;
					            $notifyMessage['ntfy_pst_type'] ='HIVE';

					            //--call function for send notification
	                    		$this->AdminModel->sendNotification($deviceData['dev_device_token'], $notifyMessage);

	                    		//--Save notification detail
					            $notifyIdData['gta_ntfy_id'] = $this->AdminModel->insertData($notData,'comm_notification');

					            if($notifyIdData['gta_ntfy_id'])
					            {
					            	//$notifyIdData['gta_ntfy_id'] = $notifyId;
					            	$this->AdminModel->updateData('comm_greatanswer', array('gta_id' => $response), $notifyIdData);
					            }
           					}

							$arrayResponse = array('success' => true, 'data' =>1, 'message' => 'Like successfully.');
						}
						else
						{
							$arrayResponse = array('success' => false, 'message' => 'Error! in adding data, Please try again.');
						}
					}
					else
					{
						$checkNotyId = $this->AdminModel->singleData('gta_ntfy_id,','comm_greatanswer',$where2);
						//--Call model function for unlike answer
						$response = $this->AdminModel->deleteData('comm_greatanswer',$where2);

						if ($response)
						{
							if($checkNotyId)
							 {
								$dataresponse = $this->AdminModel->deleteData('comm_notification',array('ntfy_id' => $checkNotyId['gta_ntfy_id']));
							}
							//--Remove notification data
							$where4 = array('ntfy_from' =>$likeData['gta_usr_id'],'ntfy_to' =>$usrDetail['ans_usr_id'],'ntfy_pst_id' =>$usrDetail['and_pst_id'] ,'ntfy_type'=>'COMMENT_GREAT');
							$this->AdminModel->deleteData('comm_notification',$where4);

							$arrayResponse = array('success' => true, 'message' => 'Unlike successfully.', 'data' => 0);
						}
						else
						{
							$arrayResponse = array('success' => false, 'message' => 'Error! in update data, Please try again.');
						}
					}
				}
			}
			else
			{
				$arrayResponse = array("success" => false, "message" => "Your session has timed out, please login again.");
			}

			if(empty($arrayResponse))
			{
				throw new Exception('Server Error, please try again.');
			}
		} 
		catch (Exception $e) 
		{
			$arrayResponse = array('success' => false, 'message' => $e->getMessage());
		}

		//--Convert Response to json
		$this->getJsonData($arrayResponse);
	}

	//--Function for get all comment
	public function getAllPostComments()
	{
		//$start = microtime(true);
		$arrayResponse = array();

		try 
		{ 	
			if($this->isSession())
			{  
				//--Get param
				$pstId = isset($this->requestData->pstId)?$this->requestData->pstId:"";
				$filterData['limit'] = isset($this->requestData->limit)?$this->requestData->limit:"50";
				$filterData['start'] = isset($this->requestData->page)?$this->requestData->page:"0";
				$usrId = isset($this->requestData->dmUsrId)?$this->requestData->dmUsrId:"";

				if(empty($pstId))
				{
					$arrayResponse = array('success' => false, 'message' => 'Post id is required.');
				}
				elseif (empty($usrId)) 
				{
					$arrayResponse = array('success' => false, 'message' => 'User id is required');
				}
				else
				{
					//--Call model function for get help
					$response = $this->AdminModel->getAllPostComments($pstId,$usrId,$filterData);

					if ($response)
					{
						$arrayResponse = $response;
					}
					else
					{
						$arrayResponse = array('success' => false, 'message' => 'Oops! There is no data to display.');
					}
				}
			}
			else
			{
				$arrayResponse = array("success" => false, "message" => "Your session has timed out, please login again.");
			}

			if(empty($arrayResponse))
			{
				throw new Exception('Server Error, please try again.');
			}
		} 
		catch (Exception $e) 
		{
			$arrayResponse = array('success' => false, 'message' => $e->getMessage());
		}

		//--Convert Response to json
		$this->getJsonData($arrayResponse);
	}

	//--Function for get karma point count
	public function getKarmaPointActionData()
	{
		$arrayResponse = array();

		try 
		{ 	
			if($this->isSession())
			{  
				//--Get param
				$count = isset($this->requestData->count)?$this->requestData->count:"";
				$helpId = isset($this->requestData->helpId)?$this->requestData->helpId:"2";
				$hiveId = isset($this->requestData->hiveId)?$this->requestData->hiveId:"1";
				$usrId = isset($this->requestData->usrId)?$this->requestData->usrId:"";
				$dmUsrId = isset($this->requestData->dmUsrId)?$this->requestData->dmUsrId:"";

				if(empty($usrId))
				{
					$usrId = $dmUsrId;
				}
				//--Call model function for get help
				$response = $this->AdminModel->getKarmaPointActionData($usrId,$count,$helpId,$hiveId);

				if ($response)
				{
					//$readCount = $this->AdminModel->notificationCount($dmUsrId);
					$arrayResponse = array('success' => true, 'data' => $response, 'message' => 'Get successfully');
				}
				else
				{
					$arrayResponse = array('success' => false, 'message' => 'Oops! There is no data to display.');
				}
			}
			else
			{
				$arrayResponse = array("success" => false,"message" => "Your session has timed out, please login again.");
			}

			if(empty($arrayResponse))
			{
				throw new Exception('Server Error, please try again.');
			}
		} 
		catch (Exception $e) 
		{
			$arrayResponse = array('success' => false, 'message' => $e->getMessage());
		}

		//--Convert Response to json
		$this->getJsonData($arrayResponse);
	}

	//--Function help full hive contribution
	public function hiveContributionKarmaPoint()
	{
		$arrayResponse = array();

		try 
		{ 	
			if($this->isSession())
			{  
				//--Get param
				$filterData['cat_id'] = isset($this->requestData->catId)?$this->requestData->catId:"1";
				$filterData['usr_id'] = isset($this->requestData->dmUsrId)?$this->requestData->dmUsrId:"";
			
				if(empty($filterData['cat_id']))
				{
					$arrayResponse = array('success' => false, 'message' => 'Category id is required.');
				}
				elseif (empty($filterData['usr_id'])) 
				{
					$arrayResponse = array('success' => false, 'message' => 'User id is required');
				}
				else
				{
					//--Call model function for get hive contribution karma points
					$response = $this->AdminModel->hiveContributionKarmaPoint($filterData);

					if ($response)
					{
						$arrayResponse = array('success' => true, 'data' => $response,'message' => 'Get successfully');
					}
					else
					{
						$arrayResponse = array('success' => false, 'message' => 'Oops! There is no data to display.');
					}
				}
			}
			else
			{
				$arrayResponse = array("success" => false, "message" => "Your session has timed out, please login again.");
			}

			if(empty($arrayResponse))
			{
				throw new Exception('Server Error, please try again.');
			}
		} 
		catch (Exception $e) 
		{
			$arrayResponse = array('success' => false, 'message' => $e->getMessage());
		}

		//--Convert Response to json
		$this->getJsonData($arrayResponse);
	}

	//--Function for add app location
	public function addAppLocation()
	{
		$arrayResponse = array();
		try 
		{ 	
			if($this->isSession())
			{  
				//--Get param
				$usrData['usr_app_location'] = isset($this->requestData->locId)?$this->requestData->locId:"";
				$usrData['usr_updatedate'] = strtotime(gmdate('Y-m-d h:i:s a').' UTC');
				$usrId = isset($this->requestData->dmUsrId)?$this->requestData->dmUsrId:"";

				if(empty($usrData['usr_app_location']))
				{
					$arrayResponse = array('success' => false, 'message' => 'Location id is required');
				}
				elseif (empty($usrId)) 
				{
					$arrayResponse = array('success' => false, 'message' => 'User id is required');
				}
				else
				{
					//--Call model function for add user app location
					$response = $this->AdminModel->updateData('comm_users',array('usr_id' =>$usrId),$usrData);

					if ($response)
					{
						$arrayResponse = array('success' => true, 'data' => $response,'message' => 'Added successfully');
					}
					else
					{
						$arrayResponse = array('success' => false, 'message' => 'Error! in adding data, Please try again');
					}
				}
			}
			else
			{
				$arrayResponse = array("success" => false, "message" => "Your session has timed out, please login again.");
			}

			if(empty($arrayResponse))
			{
				throw new Exception('Server Error, please try again.');
			}
		} 
		catch (Exception $e) 
		{
			$arrayResponse = array('success' => false, 'message' => $e->getMessage());
		}

		//--Convert Response to json
		$this->getJsonData($arrayResponse);
	}

	//--Function for get report list data and for kudos data
	public function getCommonScatData()
	{
		$arrayResponse = array();
		try 
		{ 	
			if($this->isSession())
			{    
				$scatType = isset($this->requestData->scatType)?$this->requestData->scatType:"";

				//--Call model function for get report list
				$select = "scat_id,scat_title,CASE WHEN scat_icon!='' THEN CONCAT('".SUB_CATEGORY_IMAGE."',scat_icon)  ELSE scat_icon END as scat_icon";
				$where = "scat_cat_id in (SELECT cat_id FROM comm_categories where cat_type = '".$scatType."')";

				$response = $this->AdminModel->selectMultipleData($select,'comm_subcategories',$where);

				if ($response)
				{
					$arrayResponse = array('success' => true, 'data' => $response,'message' => 'Get successfully');
				}
				else
				{
					$arrayResponse = array('success' => false, 'message' => 'Oops! There is no data to display.');
				}
			}
			else
			{
				$arrayResponse = array("success" => false, "message" => "Your session has timed out, please login again.");
			}

			if(empty($arrayResponse))
			{
				throw new Exception('Server Error, please try again.');
			}
		} 
		catch (Exception $e) 
		{
			$arrayResponse = array('success' => false, 'message' => $e->getMessage());
		}

		//--Convert Response to json
		$this->getJsonData($arrayResponse);
	}

	//--Function for add user report 
	public function addUserReport()
	{
		$arrayResponse = array();
		try 
		{ 	
			if($this->isSession())
			{  
				$rptData['rpt_scat_id'] = isset($this->requestData->scatId)?$this->requestData->scatId:"";
				$rptData['rpt_type'] = isset($this->requestData->type)?$this->requestData->type:"";
				$rptData['rpt_pst_ans_usr_id'] = isset($this->requestData->rptForId)?$this->requestData->rptForId:"";
				
				if(empty($rptData['rpt_scat_id']) || empty($rptData['rpt_type']) || empty($rptData['rpt_pst_ans_usr_id']))
				{
					$arrayResponse = array('success' => false, 'message' => 'All params is required');
				}
				else
				{
					$rptData['rpt_createdate'] = strtotime(gmdate('Y-m-d h:i:s a').' UTC');
					$rptData['rpt_usr_id'] = isset($this->requestData->dmUsrId)?$this->requestData->dmUsrId:"";

					//--Call model function for  add user report
					$response = $this->AdminModel->insertData($rptData,'comm_report');

					if ($response)
					{
						$userActivity['usr_lastActivity'] = strtotime(gmdate('Y-m-d h:i:s a').' UTC');
						$this->AdminModel->updateData('comm_users', array('usr_id' => $rptData['rpt_usr_id']), $userActivity);

						$arrayResponse = array('success' => true, 'data' => $response,'message' => 'Thank you, we are actively looking into your report.');
					}
					else
					{
						$arrayResponse = array('success' => false, 'message' => 'Error! in adding data, please try again.');
					}
				}
			}
			else
			{
				$arrayResponse = array("success" => false, "message" => "Your session has timed out, please login again.");
			}

			if(empty($arrayResponse))
			{
				throw new Exception('Server Error, please try again.');
			}
		} 
		catch (Exception $e) 
		{
			$arrayResponse = array('success' => false, 'message' => $e->getMessage());
		}

		//--Convert Response to json
		$this->getJsonData($arrayResponse);
	}
	
	//--Function for get group list data
	public function getHiveGroupList()
	{
		$arrayResponse = array();
		try 
		{ 	
			if($this->isSession())
			{  
				$pstDetail['usr_id'] = isset($this->requestData->dmUsrId)?$this->requestData->dmUsrId:"";
				$pstDetail['login_usr_id'] = isset($this->requestData->usrId)?$this->requestData->usrId:"";
				$pstDetail['hive_id'] = isset($this->requestData->hiveId)?$this->requestData->hiveId:"";
				
				if(empty($pstDetail['usr_id']))
				{
					$arrayResponse = array('success' => false, 'message' => 'User id is required.');
				}
				elseif (empty($pstDetail['hive_id'])) 
				{
					$arrayResponse = array('success' => false, 'message' => 'Hive id is required.');
				}
				else
				{
					//--Call model function for get report list
					$response = $this->AdminModel->getHiveGroupList($pstDetail);

					if ($response)
					{
						$arrayResponse = array('success' => true, 'data' => $response,'message' => 'Get successfully');
					}
					else
					{
						$arrayResponse = array('success' => false, 'message' => 'Oops! There is no data to display.');
					}
				}
			}
			else
			{
				$arrayResponse = array("success" => false, "message" => "Your session has timed out, please login again.");
			}

			if(empty($arrayResponse))
			{
				throw new Exception('Server Error, please try again.');
			}
		} 
		catch (Exception $e) 
		{
			$arrayResponse = array('success' => false, 'message' => $e->getMessage());
		}

		//--Convert Response to json
		$this->getJsonData($arrayResponse);
	}
	
	//--Function for get karma point count
	public function getCategoryWithKarmaPoint()
	{
		$arrayResponse = array();

		try 
		{ 	
			if($this->isSession())
			{  
				//--Get param
				$catData['hive_id'] = isset($this->requestData->hiveId)?$this->requestData->hiveId:"1";
				$catData['help_id'] = isset($this->requestData->helpId)?$this->requestData->helpId:"2";
				$usrId = isset($this->requestData->usrId)?$this->requestData->usrId:"";
				
				if(empty($usrId))
				{
					$usrId = isset($this->requestData->dmUsrId)?$this->requestData->dmUsrId:"";
				}
				
				//--Call model function for get help
				$response = $this->AdminModel->getCategoryWithKarmaPoint($usrId,$catData);

				if ($response)
				{
					$arrayResponse = array('success' => true, 'data' => $response, 'message' => 'Get successfully');
				}
				else
				{
					$arrayResponse = array('success' => false, 'message' => 'Oops! There is no data to display.');
				}
			}
			else
			{
				$arrayResponse = array("success" => false, "message" => "Your session has timed out, please login again.");
			}

			if(empty($arrayResponse))
			{
				throw new Exception('Server Error, please try again.');
			}
		} 
		catch (Exception $e) 
		{
			$arrayResponse = array('success' => false, 'message' => $e->getMessage());
		}

		//--Convert Response to json
		$this->getJsonData($arrayResponse);
	}

	//--Function for get join group
	public function joinGroupByUser()
	{
		$arrayResponse = array();

		try 
		{ 	
			if($this->isSession())
			{  
				//--Get param
				$joinData['join_grp_id'] = isset($this->requestData->grpId)?$this->requestData->grpId:"";
				$joinData['join_usr_id'] = isset($this->requestData->dmUsrId)?$this->requestData->dmUsrId:"";
				$joinData['join_createdate'] = strtotime(gmdate('Y-m-d h:i:s a').' UTC');
				
				if(empty($joinData['join_grp_id']))
				{
					$arrayResponse = array('success' => false, 'message' => 'Group id is required');
				}
				elseif (empty($joinData['join_usr_id'])) 
				{
					$arrayResponse = array('success' => false, 'message' => 'User id is required');
				}
				else
				{
					//--Call model function for get help
					$response = $this->AdminModel->singleData('join_id','comm_groupJoin',array('join_grp_id' => $joinData['join_grp_id'],'join_usr_id' =>$joinData['join_usr_id']));

					if (empty($response))
					{
						$joinResponse = $this->AdminModel->insertData($joinData,'comm_groupJoin');

						if($joinResponse)
						{
							$arrayResponse = array('success' => true, 'data' => $joinResponse, 'message' => 'Joined successfully');
						}
						else
						{
							$arrayResponse = array('success' => flase, 'message' => 'Error! in inserting data');
						}
					}
					else
					{
						$arrayResponse = array('success' => false, 'message' => 'User already joined.');
					}
				}
			}
			else
			{
				$arrayResponse = array("success" => false, "message" => "Your session has timed out, please login again.");
			}

			if(empty($arrayResponse))
			{
				throw new Exception('Server Error, please try again.');
			}
		} 
		catch (Exception $e) 
		{
			$arrayResponse = array('success' => false, 'message' => $e->getMessage());
		}

		//--Convert Response to json
		$this->getJsonData($arrayResponse);
	}

	//--Function for get join group
	public function removeFromGroup()
	{
		$arrayResponse = array();

		try 
		{ 	
			if($this->isSession())
			{  
				//--Get param
				$joinData['join_grp_id'] = isset($this->requestData->grpId)?$this->requestData->grpId:"";
				$joinData['join_usr_id'] = isset($this->requestData->dmUsrId)?$this->requestData->dmUsrId:"";
				$joinData['join_createdate'] = strtotime(gmdate('Y-m-d h:i:s a').' UTC');
				
				if(empty($joinData['join_grp_id']))
				{
					$arrayResponse = array('success' => false, 'message' => 'Group id is required');
				}
				elseif (empty($joinData['join_usr_id'])) 
				{
					$arrayResponse = array('success' => false, 'message' => 'User id is required');
				}
				else
				{
					//--Call model function for get help
					$response = $this->AdminModel->deleteData('comm_groupJoin',array('join_grp_id' => $joinData['join_grp_id'],'join_usr_id' =>$joinData['join_usr_id']));

					if ($response)
					{
						$arrayResponse = array('success' => true, 'data' => $response, 'message' => 'Removed successfully');
					}
					else
					{
						$arrayResponse = array('success' => false, 'message' => 'Error! in Removing data please try again.');
					}
				}
			}
			else
			{
				$arrayResponse = array("success" => false, "message" => "Your session has timed out, please login again.");
			}

			if(empty($arrayResponse))
			{
				throw new Exception('Server Error, please try again.');
			}
		} 
		catch (Exception $e) 
		{
			$arrayResponse = array('success' => false, 'message' => $e->getMessage());
		}

		//--Convert Response to json
		$this->getJsonData($arrayResponse);
	}
}
