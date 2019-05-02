<?php
defined('BASEPATH') OR exit('No direct script access allowed');
class UserController extends CI_Controller 
{
	public function __construct()
    {
        parent::__construct();
        header("Access-Control-Allow-Headers: Content-Type");
		header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
		header("Access-Control-Allow-Origin: *");
		//--set user time zone
		$headers = $this->input->request_headers();
		$this->userTimeZone = isset($headers['User-Time-Zone'])?$headers['User-Time-Zone']:"US/Eastern";
		date_default_timezone_set($this->userTimeZone);
		//--Load model
		$this->load->model('UserModel');

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

		//--Get and check token
		$token = isset($this->requestData->usrToken)?$this->requestData->usrToken:"";
		$this->tokenData = $this->UserModel->checkToken($token); 

		if($this->tokenData['usr_isDelete'] == 'Deactive')
		{
			$arrayResponse = array('success' => false, 'data' => BLOCKED_MESSAGES, 'message' =>$this->tokenData['usr_isDelete']);
			//--Convert Response to json
			$this->getJsonData($arrayResponse);
			die;
		}
    }

	//-- index function
	public function index()
	{
		$this->load->view('welcome_message');
	}

	//-- Common function for convert  base64 image string to jpg
	public function base64_to_jpeg($data,$imageName) 
	{
		$output_file = $imageName.".jpg";
		$pos  = strpos($data, ';');
		$type = explode(':', substr($data, 0, $pos));
		$type = $type[1];
		$type = explode('/',$type );
		$imgstring = trim( str_replace('data:image/'.$type[1].';base64,', "", $data));
		$imgstring = str_replace( ' ', '+', $imgstring );
		$img_data = base64_decode( $imgstring );
		$imageName = "./upload/profile_image/".$output_file;
		if(file_put_contents($imageName, $img_data))
		{
			return $output_file;
		}
		else
		{
			return 0;
		}
	}

	public function base641_to_jpeg($base64_string, $output_file)
    {
  		$pos  = strpos($base64_string, ';');
		$typeImg = explode(':', substr($base64_string, 0, $pos));
		$typeImg = $typeImg[1];
		$typeImg = explode('/',$typeImg );
		list($type, $data) = explode(';', $base64_string);
		list(, $data)      = explode(',', $base64_string);
		$data = base64_decode($data);

		file_put_contents("./upload/profile_image/".$output_file.".".$typeImg[1], $data);

		return $output_file.".".$typeImg[1];
    }

	//-- function for converting time according to timezone
	public function changeTime($time,$fromTimeZone,$toTimeZone)
	{
 		if ($time == '') 
    	{
    		return $time;
    	}

  		$dateFormat = 'Y-m-d';

		$headers = $this->input->request_headers();
		$userTimeZone = isset($headers['User-Time-Zone'])?$headers['User-Time-Zone']:"US/Eastern";

		if($fromTimeZone=='')
		{
			$isUTC = true;
			$fromTimeZone = $userTimeZone;
		}
		else
		{
			$isUTC = false;
			$toTimeZone = $userTimeZone;
			
			$cTime = $this->isValidTimeStamp($time);
			if ($cTime) 
			{
				$time = gmdate($dateFormat.' h:i:s a',$time);
			}
		}

		$date = new DateTime($time, new DateTimeZone($fromTimeZone)); //-- assign timezone to time
		$date->format($dateFormat.' h:i:s');

		$date->setTimezone(new DateTimeZone($toTimeZone)); //-- change time according to required timezone
		
		$returnTime = $date->format($dateFormat.' h:i:s');
		if($isUTC==true)
		{
			return strtotime($returnTime.' UTC');
		}
		else
		{
			return strtotime($returnTime.' UTC');
		}
	}

	public function isValidTimeStamp($timestamp)
	{
	    return ((string) (int) $timestamp === $timestamp) 
	        && ($timestamp <= PHP_INT_MAX)
	        && ($timestamp >= ~PHP_INT_MAX);
	}
   
    //--Function for return json encoded data
    public function getJsonData($arrayResponse)
    {   
        echo json_encode($arrayResponse);
        die();
    }

	//--Function for login
	public function login()
	{
		$arrayResponse = array();

		try 
		{ 	
			//--user param
			$userData['usr_fname'] = isset($this->requestData->fname)?$this->requestData->fname:"";
			$userData['usr_lname'] = isset($this->requestData->lname)?$this->requestData->lname:"";
			$userData['usr_email'] = isset($this->requestData->email)?$this->requestData->email:"";
			$userData['usr_dob'] = isset($this->requestData->dob)?$this->requestData->dob:"";
			$userData['usr_gender'] = isset($this->requestData->gender)?$this->requestData->gender:"";
			$userData['usr_social_id'] = isset($this->requestData->socialId)?$this->requestData->socialId:"";
			$userData['usr_social_name'] = isset($this->requestData->socialNm)?$this->requestData->socialNm:"";
			$userData['usr_fb_location'] = isset($this->requestData->fbLocation)?$this->requestData->fbLocation:"";
			$userData['usr_createddate'] = strtotime(gmdate('Y-m-d h:i:s a').' UTC');

			//--Device param
			$deviceData['dev_device_token'] = isset($this->requestData->dvcToken)?$this->requestData->dvcToken:"";
			$deviceData['dev_device_id'] = isset($this->requestData->dvcId)?$this->requestData->dvcId:"";
			$deviceData['dev_device_type'] = isset($this->requestData->dvcTyp)?$this->requestData->dvcTyp:"";

			if(empty($userData['usr_social_id']))
			{
				$arrayResponse = array('success' => false, 'message' =>'Social id is required');
			}
			else
			{
				//--Call model function for login
				$response = $this->UserModel->login($userData,$deviceData);

				//--Check user block and not
				if($response =='Deactive')
				{
					$arrayResponse = array('success' => false, 'data' => BLOCKED_MESSAGES, 'message' =>$response);
				}
				elseif ($response)
				{
            		$groupResult= $this->UserModel->singleData('CASE WHEN count(join_usr_id)>0 THEN "YES" else "NO" END as count','comm_groupJoin',array('join_usr_id' => $response['usr_id']));

            		$response['grp_join'] = $groupResult['count'];
					$arrayResponse = array('success' => true, 'data' => $response, 'message' =>'Login successfully');
				}
				else
				{
					$arrayResponse = array('success' => false, 'message' => 'Oops! There is no data to display.');
				}

				if(empty($arrayResponse))
				{
					throw new Exception('Server Error, please try again.');
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

	//--Function for logout
	public function userLogout()
	{
		$arrayResponse = array();

		try 
		{ 	
			if($this->tokenData)
			{  
				$deviceData['dev_device_token'] = "";

				//--Call model function for  logout
				$response = $this->UserModel->updateData('comm_devices',array('dev_usr_id' =>$this->tokenData['usr_id']),$deviceData);

				if ($response)
				{
					$arrayResponse = array('success' => true, 'data' => $response,'message' => 'Logout successfully');
				}
				else
				{
					$arrayResponse = array('success' => false, 'message' => 'Error! in logout, Please try again.');
				}
			}
			else
			{
				$arrayResponse=array("success" => false, "message" => "Your session has timed out, please login again.");
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
			if($this->tokenData)
			{  
				$select = "cat_id,cat_name,cat_description,CASE WHEN cat_icon!='' THEN CONCAT('".CATEGORY_IMAGE."',cat_icon)  ELSE cat_icon END as cat_image";
				$where = array('cat_type' =>'CATEGARY');

				//--Call model function for get category
				$response = $this->UserModel->selectMultipleData($select,'comm_categories',$where);

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
			if($this->tokenData)
			{  
				//--Get param
				$hiveData['pst_cat_id'] = isset($this->requestData->catId)?$this->requestData->catId:"";
				$hiveData['pst_usr_id'] = $this->tokenData['usr_id'];
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
				else
				{
					//--Call model function for add hive post
					$response = $this->UserModel->addUserHive($hiveData,$hiveTags);

					if ($response)
					{
						$userActivity['usr_lastActivity'] = strtotime(gmdate('Y-m-d h:i:s a').' UTC');
						$this->UserModel->updateData('comm_users', array('usr_id' => $this->tokenData['usr_id']), $userActivity);

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
			if($this->tokenData)
			{  
				//--Get param
				$pstId = isset($this->requestData->pstId)?$this->requestData->pstId:"";
				$hiveData['pst_grp_id'] = isset($this->requestData->grpId)?$this->requestData->grpId:"";
				$hiveData['pst_title'] = isset($this->requestData->ttl)?$this->requestData->ttl:"";
				$hiveData['pst_description'] = isset($this->requestData->dscptn)?$this->requestData->dscptn:"";
				$hiveData['pst_updatedate'] = strtotime(gmdate('Y-m-d h:i:s a').' UTC');
				$hiveTags = isset($this->requestData->tags)?$this->requestData->tags:array(); 

				if(empty($pstId))
				{
					$arrayResponse = array('success' => false, 'message' => 'Post id is required.');
				}
				elseif (empty($hiveData['pst_grp_id'])) 
				{
					$arrayResponse = array('success' => false, 'message' => 'Group id is required.');
				}
				else
				{
					//--Call model function for edit hive post
					$response = $this->UserModel->editUserHiveById($pstId,$hiveData,$hiveTags);

					if ($response)
					{
						$userActivity['usr_lastActivity'] = strtotime(gmdate('Y-m-d h:i:s a').' UTC');
						$this->UserModel->updateData('comm_users', array('usr_id' => $this->tokenData['usr_id']), $userActivity);

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
			if($this->tokenData)
			{  
				//--Get param
				$pstId = isset($this->requestData->pstId)?$this->requestData->pstId:"";
				$postData['pst_isDeleted'] = 1;
				$postData['pst_updatedate'] = strtotime(gmdate('Y-m-d h:i:s a').' UTC');

				if(empty($pstId))
				{
					$arrayResponse = array('success' => false, 'message' => 'Post id is required.');
				}
				else
				{
					//--Call model function for hide post
					$response = $this->UserModel->updateData('comm_posts',array('pst_id' =>$pstId), $postData);

					if ($response)
					{
						//--Remove notification data
						$this->UserModel->deleteData('comm_notification', array('ntfy_pst_id' => $pstId));

						$userActivity['usr_lastActivity'] = strtotime(gmdate('Y-m-d h:i:s a').' UTC');
						$this->UserModel->updateData('comm_users', array('usr_id' => $this->tokenData['usr_id']), $userActivity);

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

	//--Function for get post data with filter
	public function getOrFilterAllHivePost()
	{
		$arrayResponse = array();

		try 
		{ 	
			if($this->tokenData)
			{  
				//--Get param
				$filterData['pst_id'] = isset($this->requestData->pstId)?$this->requestData->pstId:"";
				$filterData['cat_id'] = isset($this->requestData->catId)?$this->requestData->catId:"";
				$filterData['trend'] = isset($this->requestData->trndPst)?$this->requestData->trndPst:"";
				$filterData['usr_id'] = $this->tokenData['usr_id'];
				$filterData['limit'] = isset($this->requestData->limit)?$this->requestData->limit:"10";
				$filterData['start'] = isset($this->requestData->page)?$this->requestData->page:"0";
				$filterData['pst_grp_id'] = isset($this->requestData->grpId)?$this->requestData->grpId:"";
				
				if(empty($filterData['cat_id']) && empty($filterData['pst_id']))
				{
					$arrayResponse = array('success' => false, 'message' => 'Category or Post id is required.');
				}
				else
				{
					//--Call model function for get help data
					$response = $this->UserModel->getOrFilterAllHivePost($filterData);

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
			if($this->tokenData)
			{  
				//--Get param
				$postData['and_pst_id'] = isset($this->requestData->pstId)?$this->requestData->pstId:"";
				$postData['ans_usr_id'] = $this->tokenData['usr_id'];
				$postData['ans_description'] = isset($this->requestData->dscptn)?$this->requestData->dscptn:"";
				$postData['ans_createdate'] = strtotime(gmdate('Y-m-d h:i:s a').' UTC');
				$postTitle = isset($this->requestData->pstTtl)?$this->requestData->pstTtl:"";
				$pstUsrNm = isset($this->requestData->pstUsrNm)?$this->requestData->pstUsrNm:"";
				$pstUsrId = isset($this->requestData->pstUsrId)?$this->requestData->pstUsrId:"";

				if(empty($postData['and_pst_id']))
				{
					$arrayResponse = array('success' => false, 'message' => 'Post id is required.');
				}
				else
				{
					//--Call model function for add comment on post
					$response = $this->UserModel->addCommentOnPost($postData,$postTitle,$pstUsrId,$this->tokenData['usr_fname'],$pstUsrNm);

					if ($response)
					{
						$userActivity['usr_lastActivity'] = strtotime(gmdate('Y-m-d h:i:s a').' UTC');
						$this->UserModel->updateData('comm_users', array('usr_id' => $this->tokenData['usr_id']), $userActivity);

						$dataResponse[0]['ans_description'] = $postData['ans_description'];
						$dataResponse[0]['ans_createdate'] = (string)$postData['ans_createdate'];
						$dataResponse[0]['ans_updatedate'] = (string)$postData['ans_createdate'];
						$dataResponse[0]['ans_id'] = (string)$response['ans_id'];
						$dataResponse[0]['great'] = "NO";
						$dataResponse[0]['user_upvote'] = "NO";
						$dataResponse[0]['count_upvote'] = "0";
						$dataResponse[0]['usr_id'] = $this->tokenData['usr_id'];
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
			if($this->tokenData)
			{  
				//--Get param
				$ansId = isset($this->requestData->ansId)?$this->requestData->ansId:"";
				$commentData['ans_description'] = isset($this->requestData->dscptn)?$this->requestData->dscptn:"";
				$commentData['ans_updatedate'] = strtotime(gmdate('Y-m-d h:i:s a').' UTC');

				if(empty($ansId))
				{
					$arrayResponse = array('success' => false, 'message' => 'Answer id is required.');
				}
				else
				{
					//--Call model function for edit comments
					$response = $this->UserModel->updateData('comm_answers',array('ans_id' =>$ansId), $commentData);

					if ($response)
					{
						$userActivity['usr_lastActivity'] = strtotime(gmdate('Y-m-d h:i:s a').' UTC');
						$this->UserModel->updateData('comm_users', array('usr_id' => $this->tokenData['usr_id']), $userActivity);

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
			if($this->tokenData)
			{  
				//--Get param
				$ansId = isset($this->requestData->ansId)?$this->requestData->ansId:"";
				$ntfyId = isset($this->requestData->ntfyId)?$this->requestData->ntfyId:"";
				$commentData['ans_isDeleted'] = 1;
				$commentData['ans_updatedate'] = strtotime(gmdate('Y-m-d h:i:s a').' UTC');

				if(empty($ansId))
				{
					$arrayResponse = array('success' => false, 'message' => 'Answer id is required.');
				}
				else
				{
					//--Call model function for hide comment
					$response = $this->UserModel->updateData('comm_answers',array('ans_id' => $ansId), $commentData);

					if ($response)
					{
						$userActivity['usr_lastActivity'] = strtotime(gmdate('Y-m-d h:i:s a').' UTC');
						$this->UserModel->updateData('comm_users', array('usr_id' => $this->tokenData['usr_id']), $userActivity);

						//--Remove notification data
						$where = array('ntfy_id' =>$ntfyId);

						$this->UserModel->deleteData('comm_notification',$where);

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
			if($this->tokenData)
			{  
				//--Get param
				$voteData['upv_type'] = isset($this->requestData->voteTyp)?$this->requestData->voteTyp:"";
				$voteData['upv_usr_id'] = $this->tokenData['usr_id'];
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
				else
				{
					if($voteData['upv_type'] =='Post')
					{
						//--get user post detail for notification
						$where1 = array('pst_id' => $voteData['upv_pst_ans_id']);
						$pstUsrDetail = $this->UserModel->singleData('pst_usr_id,pst_title','comm_posts',$where1);
   				    }
   				    else if ($voteData['upv_type'] =='Answer') 
   				    {
   				    	//--get user post comment detail for notification
   				    	$where3 = array('ans_id' =>$voteData['upv_pst_ans_id']);
						$usrDetail = $this->UserModel->singleData('ans_usr_id,ans_description,and_pst_id','comm_answers',$where3);
   				    }

					//--Make where condition for query
					$where = array('upv_type' => $voteData['upv_type'], 'upv_usr_id' => $voteData['upv_usr_id'],'upv_pst_ans_id' => $voteData['upv_pst_ans_id']);

					//--Call model function for check vote status
					$checkFeedback = $this->UserModel->singleData('upv_id','comm_upvote',$where); 

					if(empty($checkFeedback))
					{ 
						//--Call model function for add upvote
						$response = $this->UserModel->insertData($voteData,'comm_upvote');

						if ($response)
						{
							$userActivity['usr_lastActivity'] = strtotime(gmdate('Y-m-d h:i:s a').' UTC');
							$this->UserModel->updateData('comm_users', array('usr_id' => $this->tokenData['usr_id']), $userActivity);

								if(isset($pstUsrDetail))
								{
									//--Get user device data
									$where2 = array('dev_usr_id' =>$pstUsrDetail['pst_usr_id']);
									$deviceData = $this->UserModel->singleData('dev_device_token','comm_devices',$where2);

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
		                    			$this->UserModel->sendNotification($deviceData['dev_device_token'], $notifyMessage);

		                    		//--Save notification data
						            $this->UserModel->insertData($notData,'comm_notification');
	           					}

								if(isset($usrDetail))
								{
									//--Get user device data
									$where4 = array('dev_usr_id' =>$usrDetail['ans_usr_id']);
									$deviceData = $this->UserModel->singleData('dev_device_token','comm_devices',$where4);

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
			                    		$this->UserModel->sendNotification($deviceData['dev_device_token'], $notifyMessage);

		                    		//--Save notification detail
						            $this->UserModel->insertData($notData,'comm_notification');
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
						$response = $this->UserModel->deleteData('comm_upvote',$where);

						if ($response)
						{
							if($voteData['upv_type'] =='Post')
							{	
								//--Remove notification data
								$where5 = array('ntfy_from' =>$voteData['upv_usr_id'],'ntfy_to' =>$pstUsrDetail['pst_usr_id'],'ntfy_pst_id' =>$voteData['upv_pst_ans_id'],'ntfy_type' =>'HIVE_UPVOTE');
								$this->UserModel->deleteData('comm_notification',$where5);
							}
							else if ($voteData['upv_type'] =='Answer') 
							{
								//--Remove notification data
								$where6 = array('ntfy_from' =>$voteData['upv_usr_id'],'ntfy_to' =>$usrDetail['ans_usr_id'],'ntfy_pst_id' =>$usrDetail['and_pst_id'] ,'ntfy_type'=>'COMMENT_UPVOTE');
								$this->UserModel->deleteData('comm_notification',$where6);
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
		//$notifyId ="";
		try 
		{ 	
			if($this->tokenData)
			{  
				//--Get param
				$likeData['gta_usr_id'] = $this->tokenData['usr_id'];
				$likeData['gta_ans_id'] = isset($this->requestData->ansId)?$this->requestData->ansId:"";
				$likeData['gta_kd_id'] = isset($this->requestData->kudoId)?$this->requestData->kudoId:"";
				$likeData['gta_comment'] = isset($this->requestData->kudoCmnt)?$this->requestData->kudoCmnt:"";

				$grtNtfyId = isset($this->requestData->grtNtfyId)?$this->requestData->grtNtfyId:"";
				
				$likeData['gta_createdate'] = strtotime(gmdate('Y-m-d h:i:s a').' UTC');

				$pstTtl = isset($this->requestData->pstTtl)?$this->requestData->pstTtl:"";

				if(empty($likeData['gta_ans_id']))
				{
					$arrayResponse = array('success' => false, 'message' => 'Answer id is required.');
				}
				else
				{
					//--get user post comment detail for notification
					$where1 = array('ans_id' =>$likeData['gta_ans_id']);
					$usrDetail = $this->UserModel->singleData('ans_usr_id,ans_description,and_pst_id','comm_answers',$where1);
					
					//--Call model function for check user answer status
					$where2 = array('gta_usr_id' => $likeData['gta_usr_id'], 'gta_ans_id' => $likeData['gta_ans_id']);
					$checkStatus = $this->UserModel->singleData('gta_id','comm_greatanswer',$where2);

					if(empty($checkStatus))
					{
						//--Call model function for like answer
						$response = $this->UserModel->insertData($likeData,'comm_greatanswer');

						if ($response)
						{
							$userActivity['usr_lastActivity'] = strtotime(gmdate('Y-m-d h:i:s a').' UTC');
							$this->UserModel->updateData('comm_users', array('usr_id' => $this->tokenData['usr_id']), $userActivity);

							if(isset($usrDetail))
							{
								//--Get user device data
								$where3 = array('dev_usr_id' =>$usrDetail['ans_usr_id']);
								$deviceData = $this->UserModel->singleData('dev_device_token','comm_devices',$where3);

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
	                    		$this->UserModel->sendNotification($deviceData['dev_device_token'], $notifyMessage);

	                    		//--Save notification detail
					            $notifyIdData['gta_ntfy_id'] = $this->UserModel->insertData($notData,'comm_notification');
					            
					            if($notifyIdData['gta_ntfy_id'])
					            {
					            	$this->UserModel->updateData('comm_greatanswer', array('gta_id' => $response), $notifyIdData);
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
						$checkNotyId = $this->UserModel->singleData('gta_ntfy_id,','comm_greatanswer',$where2);

						//--Call model function for unlike answer
						$response = $this->UserModel->deleteData('comm_greatanswer',$where2);

						if ($response)
						{
							//--Remove notification data
							 if($checkNotyId)
							 {
								$dataresponse = $this->UserModel->deleteData('comm_notification',array('ntfy_id' => $checkNotyId['gta_ntfy_id']));
							}
								$arrayResponse = array('success' => true, 'message' => 'Unlike successfully.', 'data' => 0,'ntfy_id' =>$grtNtfyId);
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
			if($this->tokenData)
			{  
				//--Get param
				$pstId = isset($this->requestData->pstId)?$this->requestData->pstId:"";
				$filterData['limit'] = isset($this->requestData->limit)?$this->requestData->limit:"50";
				$filterData['start'] = isset($this->requestData->page)?$this->requestData->page:"0";
				$usrId = $this->tokenData['usr_id'];

				if(empty($pstId))
				{
					$arrayResponse = array('success' => false, 'message' => 'Post id is required.');
				}
				else
				{
					//--Call model function for get help
					$response = $this->UserModel->getAllPostComments($pstId,$usrId,$filterData);

					if ($response)
					{
						$arrayResponse = array('success' => true, 'data' => $response, 'message' => 'Comments get successfully');
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
			if($this->tokenData)
			{  
				//--Get param
				$count = isset($this->requestData->count)?$this->requestData->count:"";
				$helpId = isset($this->requestData->helpId)?$this->requestData->helpId:"2";
				$hiveId = isset($this->requestData->hiveId)?$this->requestData->hiveId:"1";
				$usrId = isset($this->requestData->usrId)?$this->requestData->usrId:"";

				if(empty($usrId))
				{
					$usrId = $this->tokenData['usr_id'];
				}
				//--Call model function for get help
				$response = $this->UserModel->getKarmaPointActionData($usrId,$count,$helpId,$hiveId);

				if ($response)
				{
					$readCount = $this->UserModel->notificationCount($this->tokenData['usr_id']);
					$arrayResponse = array('success' => true, 'data' => $response, 'message' => 'Get successfully','count' =>$readCount['count']);
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
			if($this->tokenData)
			{  
				//--Get param
				$filterData['cat_id'] = isset($this->requestData->catId)?$this->requestData->catId:"1";
				$filterData['usr_id'] = $this->tokenData['usr_id'];
			
				if(empty($filterData['cat_id']))
				{
					$arrayResponse = array('success' => false, 'message' => 'Category id is required.');
				}
				else
				{
					//--Call model function for get hive contribution karma points
					$response = $this->UserModel->hiveContributionKarmaPoint($filterData);

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
	
	//--Function for update profile
	public function editUserProfile()
	{
		$arrayResponse = array();
		$response = array();
		try 
		{ 	
			if($this->tokenData)
			{  
				//--Get param
				$userEmail = isset($this->requestData->email)?$this->requestData->email:"";
				$userName = isset($this->requestData->userName)?$this->requestData->userName:"";
				$usrId = $this->tokenData['usr_id'];
				$userData['usr_updatedate'] = strtotime(gmdate('Y-m-d h:i:s a').' UTC');

				//--base_64 image string
				$imageString = isset($this->requestData->pImg)?$this->requestData->pImg:"";

				if(!empty($userEmail))
				{
					$checkEmail = $this->UserModel->singleData('usr_email', 'comm_users',array('usr_id!='=>$usrId,'usr_email' =>$userEmail,'usr_email!=' =>''));

					 if($checkEmail)
					 {
					 	 $arrayResponse = array('success' => false, 'message' => 'Email id already exist.');
					 	 $this->getJsonData($arrayResponse);
					 }
					 else
					 {
						$userData['usr_email'] = $userEmail;
					 }
				}
				elseif (!empty($userName)) 
				{
					$checkUsername = $this->UserModel->singleData('usr_username', 'comm_users',array('usr_id!='=>$usrId,'usr_username' =>$userName,'usr_username!=' =>''));

					 if($checkUsername)
					 {
					 	 $arrayResponse = array('success' => false, 'message' => 'User name already exist.');
					 	 $this->getJsonData($arrayResponse);
					 }
					 else
					 {
						$userData['usr_username'] = $userName;
					 }
				}
				elseif (!empty($imageString)) 
				{
					if($imageString)
					{
						$checkImage = $this->UserModel->singleData('usr_image', 'comm_users',array('usr_id='=>$usrId));

						if($checkImage)
						{
							//--Remove old image
							@unlink('./upload/profile_image/'.$checkImage['usr_image']);
						}

				         $imageName = $this->base641_to_jpeg($imageString, $usrId);
				            
						if($imageName)
						{
							$userData['usr_image'] = $imageName;
							$userData['usr_img_type'] = 'APP_IMG';
							$userImageName = USER_PROFILE_IMAGE.$imageName;
						}
					}
				}

				//--Call model function for update user profile
				$response = $this->UserModel->updateData('comm_users',array('usr_id' =>$usrId),$userData);

				if ($response)
				{
					if(isset($userImageName))
					{
						$responseData['imageName'] = $userImageName;
					}
					else
					{
						$responseData =$response;
					}

					$arrayResponse = array('success' => true, 'data' => $responseData,'message' => 'Updated successfully');
				}
				else
				{
					$arrayResponse = array('success' => false, 'message' => 'Error! in updating data, Please try again');
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
			if($this->tokenData)
			{  
				$scatType = isset($this->requestData->scatType)?$this->requestData->scatType:"KUDOS";

				//--Call model function for get report list
				$select = "scat_id,scat_title,CASE WHEN scat_icon!='' THEN CONCAT('".SUB_CATEGORY_IMAGE."',scat_icon)  ELSE scat_icon END as scat_icon";
				$where = "scat_cat_id in (SELECT cat_id FROM comm_categories where cat_type = '".$scatType."')";

				$response = $this->UserModel->selectMultipleData($select,'comm_subcategories',$where);

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
			if($this->tokenData)
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
					$rptData['rpt_usr_id'] = $this->tokenData['usr_id'];

					//--Call model function for  add user report
					$response = $this->UserModel->insertData($rptData,'comm_report');

					if ($response)
					{
						$userActivity['usr_lastActivity'] = strtotime(gmdate('Y-m-d h:i:s a').' UTC');
						$this->UserModel->updateData('comm_users', array('usr_id' => $this->tokenData['usr_id']), $userActivity);

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

	//--Function for get notification list
	public function getNotificationList()
	{
		$arrayResponse = array();
		try 
		{ 	
			if($this->tokenData)
			{  
				$notifyData['usr_id'] = $this->tokenData['usr_id'];
				$notifyData['limit'] = isset($this->requestData->limit)?$this->requestData->limit:"10";
				$notifyData['start'] = isset($this->requestData->page)?$this->requestData->page:"0";
				$response = $this->UserModel->getNotificationList($notifyData);

				if ($response)
				{
					$arrayResponse = $response;
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

	//--Function for change notification status
	public function changeNotificationStatus()
	{
		$arrayResponse = array();
		try 
		{ 	
			if($this->tokenData)
			{  
				$ntfyId = isset($this->requestData->ntfyId)?$this->requestData->ntfyId:"";
				$changeStatus['ntfy_isRead'] =1;
				$changeStatus['ntfy_updatedate'] = strtotime(gmdate('Y-m-d h:i:s a').' UTC');
				
				$where = array('ntfy_id' =>$ntfyId);

				$response = $this->UserModel->updateData('comm_notification',$where,$changeStatus);
				
				if ($response)
				{
					$userActivity['usr_lastActivity'] = strtotime(gmdate('Y-m-d h:i:s a').' UTC');
						$this->UserModel->updateData('comm_users', array('usr_id' => $this->tokenData['usr_id']), $userActivity);
						
					$arrayResponse = array('success' => true, 'data' => $response,'message' => 'updated successfully');
				}
				else
				{
					$arrayResponse = array('success' => false, 'message' => 'Error! in updating data please try again');
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
	
	//--Function for get admin detail
	public function getAdminDetail()
	{
		$arrayResponse = array();
		try 
		{ 	
			if($this->tokenData)
			{  
				$select = "adm_id,adm_name,adm_username,adm_email,CASE WHEN adm_image!='' THEN CONCAT('".ADMIN_PROFILE_IMAGE."',adm_image)  ELSE adm_image END as admin_image";

       			 $response = $this->UserModel->singleData($select,'comm_admin');

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

	//--Function for send fire based messages
	public function sendFirebaseMsg()
	{
		$arrayResponse = array();

		try 
		{ 	
			if($this->tokenData)
			{  
				//--Get param
				$usrId = isset($this->requestData->usrId)?$this->requestData->usrId:"2";
				$msg = isset($this->requestData->msg)?$this->requestData->msg:"";
				$usrfName = $this->tokenData['usr_fname'];
				$usrlName = $this->tokenData['usr_lname'];

				if(empty($usrId))
				{
					$arrayResponse = array('success' => false, 'message' => 'User id is required.');
				}
				else
				{
					//--Call model function for end help request
					$response = $this->UserModel->singleData('dev_device_token','comm_devices',array('dev_usr_id' => $usrId));

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
			            $notifyMessage['ntfy_pst_type'] = 'FIREBASE_CHAT_MSG';

			            //-call function for send notification
                		$this->UserModel->sendNotification($response['dev_device_token'], $notifyMessage);

						$arrayResponse = array('success' => true, 'data' => '', 'message' => 'Send successfully');
					}
					else
					{
						$arrayResponse = array('success' => false, 'message' => 'Not sent');
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

	//--Function for end help request
	public function checkCommunityApp()
	{
		//--Get param
		$data['pstId'] = $this->input->get('pstId');
		$data['type'] = $this->input->get('type');
		$this->load->view('communiti',$data);
	}

	//--Function for get user detail
	public function getUserProfileDetail()
	{
		$arrayResponse = array();
		try 
		{ 	
			if($this->tokenData)
			{  
				$helpId = isset($this->requestData->helpId)?$this->requestData->helpId:"";
				$hiveId = isset($this->requestData->hiveId)?$this->requestData->hiveId:"";
				$usrId = isset($this->requestData->usrId)?$this->requestData->usrId:"";

				if(empty($helpId))
				{
					$arrayResponse = array('success' => false, 'message' => 'Help id is required');
				}
				else if(empty($hiveId))
				{
					$arrayResponse = array('success' => false, 'message' => 'Hive id is required');
				}
				else if(empty($usrId))
				{
					$arrayResponse = array('success' => false, 'message' => 'User id is required');
				}
				else
				{
	       			$response = $this->UserModel->getUserProfileDetail($helpId,$hiveId,$usrId);

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

	//--Function for get group list data
	public function getHiveGroupList()
	{
		$arrayResponse = array();
		try 
		{ 	
			if($this->tokenData)
			{  
				$pstDetail['usr_id'] = $this->tokenData['usr_id'];
				$pstDetail['login_usr_id'] = isset($this->requestData->usrId)?$this->requestData->usrId:"";
				$pstDetail['hive_id'] = isset($this->requestData->hiveId)?$this->requestData->hiveId:"1";
				//--Call model function for get report list
				$response = $this->UserModel->getHiveGroupList($pstDetail);

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
	
	//--Function for get karma point count
	public function getCategoryWithKarmaPoint()
	{
		$arrayResponse = array();

		try 
		{ 	
			if($this->tokenData)
			{  
				//--Get param
				$catData['hive_id'] = isset($this->requestData->hiveId)?$this->requestData->hiveId:"1";
				$catData['help_id'] = isset($this->requestData->helpId)?$this->requestData->helpId:"2";
				$usrId = isset($this->requestData->usrId)?$this->requestData->usrId:"";
				
				if(empty($usrId))
				{
					$usrId = $this->tokenData['usr_id'];
				}
				
				//--Call model function for get help
				$response = $this->UserModel->getCategoryWithKarmaPoint($usrId,$catData);

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

	//--Function for join group
	public function joinGroupByUser()
	{
		$arrayResponse = array();

		try 
		{ 	
			if($this->tokenData)
			{  
				//--Get param
				$joinData['join_grp_id'] = isset($this->requestData->grpId)?$this->requestData->grpId:"";
				$joinData['join_usr_id'] = $this->tokenData['usr_id'];
				$joinData['join_createdate'] = strtotime(gmdate('Y-m-d h:i:s a').' UTC');
				
				if(empty($joinData['join_grp_id']))
				{
					$arrayResponse = array('success' => false, 'message' => 'Group id is required');
				}
				else
				{
					//--Call model function for get help
					$response = $this->UserModel->singleData('join_id','comm_groupJoin',array('join_grp_id' => $joinData['join_grp_id'],'join_usr_id' =>$joinData['join_usr_id']));

					if (empty($response))
					{
						$joinResponse = $this->UserModel->insertData($joinData,'comm_groupJoin');

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

	//--Function for remove from group
	public function removeFromGroup()
	{
		$arrayResponse = array();

		try 
		{ 	
			if($this->tokenData)
			{  
				//--Get param
				$joinData['join_grp_id'] = isset($this->requestData->grpId)?$this->requestData->grpId:"";
				$joinData['join_usr_id'] = $this->tokenData['usr_id'];
				$joinData['join_createdate'] = strtotime(gmdate('Y-m-d h:i:s a').' UTC');
				
				if(empty($joinData['join_grp_id']))
				{
					$arrayResponse = array('success' => false, 'message' => 'Group id is required');
				}
				else
				{
					//--Call model function for get help
					$response = $this->UserModel->deleteData('comm_groupJoin',array('join_grp_id' => $joinData['join_grp_id'],'join_usr_id' =>$joinData['join_usr_id']));

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

	//--Function for get kudos data with kudos count
	public function getKudosCount()
	{
		$arrayResponse = array();
		try 
		{ 	
			if($this->tokenData)
			{  
				$usrId = isset($this->requestData->usrId)?$this->requestData->usrId:"";
				
				if(empty($usrId))
				{
					$arrayResponse = array('success' => false, 'message' => 'User id is required');
				}
				else
				{
					//--Call model function for get report list
					$response = $this->UserModel->getKudosCount($usrId);

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

	//--Function for get individual kudos post list
	public function getUserKudosPost()
	{
		$arrayResponse = array();
		try 
		{ 	
			if($this->tokenData)
			{  
				$loginUserId = isset($this->requestData->usrId)?$this->requestData->usrId:"";
				$kudosId = isset($this->requestData->kudosId)?$this->requestData->kudosId:"";
				$paging['limit'] = isset($this->requestData->limit)?$this->requestData->limit:"2";
				$paging['start'] = isset($this->requestData->page)?$this->requestData->page:"0";

				if(empty($kudosId))
				{
					$arrayResponse = array('success' => false, 'message' => 'Kudos id is required');
				}
				else
				{
					//--Call model function for get report list
					$response = $this->UserModel->getUserKudosPost($kudosId,$loginUserId,$paging);

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

	//--Function for get individual kudos post list
	public function getKudosCommentList()
	{
		$arrayResponse = array();
		try 
		{ 	
			if($this->tokenData)
			{  
				$usrId = isset($this->requestData->usrId)?$this->requestData->usrId:"";
				$paging['limit'] = isset($this->requestData->limit)?$this->requestData->limit:"10";
				$paging['start'] = isset($this->requestData->page)?$this->requestData->page:"0";
				
				//--Call model function for get report list
				$response = $this->UserModel->getKudosCommentList($usrId,$paging);

				if ($response)
				{
					$arrayResponse = $response;
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

	//--Function for change kudos read status
	public function readKudos()
	{
		$arrayResponse = array();
		try 
		{ 	
			if($this->tokenData)
			{  
				$loginUserId = $this->tokenData['usr_id'];
				$kudosId = isset($this->requestData->kudosId)?$this->requestData->kudosId:"";
				
				if(empty($kudosId))
				{
					$arrayResponse = array('success' => false, 'message' => 'Kudos id is required');
				}
				else
				{
					//--Call model function for get report list
					$response = $this->UserModel->readKudos($loginUserId,$kudosId);

					if ($response)
					{
						$arrayResponse = array('success' => true, 'data' => $response,'message' => 'Update successfully');
					}
					else
					{
						$arrayResponse = array('success' => false, 'message' => 'Error! in update status, please try again.');
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





