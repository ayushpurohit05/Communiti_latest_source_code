<?php
class AdminModel extends CI_Model
{
    function __construct()
    {
        parent::__construct();

    }

    //--Common update function
    public function updateData($table, $where, $data)
    {
        $this->db->where($where);
        $this->db->update($table,$data);
        if($this->db->affected_rows())
        {
            return 1;
        }
        else
        {
            return 0;
        }
    }

        //--Function for select single result form db
    public function singleData($select, $table, $where = Null)
    {
        $this->db->select($select);
        $this->db->from($table);
        if ($where != Null) 
        {
            $this->db->where($where);
        }
        $query = $this->db->get();
        if ($query->num_rows() > 0) 
        {
            return $query->row_array();
        } 
        else 
        {
            return 0;
        }
    }

    //--Function for select multiple result form db
    public function selectMultipleData($select, $table, $where = Null)
    {
        $this->db->select($select);
        $this->db->from($table);
        if ($where != Null) 
        {
            $this->db->where($where);
        }
       
        $query = $this->db->get();
        if ($query->num_rows() > 0) 
        {
            return $query->result_array();
        } 
        else 
        {
            return 0;
        }
    }

    //--Common insert function
    public function insertData($data, $table)
    {
        $this->db->insert($table,$data);
        $insertId = $this->db->insert_id();

        if($insertId)
        {
            return $insertId;
        }
        {
            return 0;
        }
    }

    //--Common delete function
    public function deleteData($table, $where)
    {
        $this->db->where($where);
        $this->db->delete($table);

        if($this->db->affected_rows())
        {
            return 1;
        }
        else
        {
            return 0;
        }
    }

    //api for show Dashboard hive and help count
    public function help_hive_count($table)
    {
        $sql = "select count(case when $table.pst_cat_id =1 then $table.pst_cat_id end)  as hiveCount,count(case when $table.pst_cat_id =2 then $table.pst_cat_id end) as helpCount from $table , comm_users where pst_isDeleted =0 and $table.pst_usr_id = comm_users.usr_id";
        $postData = $this->db->query($sql)->result_array();

        if ($postData)
        {
            return $postData;
        }
        else
        {
            return 0;
        }

    }

    public function login($admData)
    {
        $this->db->select("adm_id,adm_name,adm_email,adm_username,adm_createdate,CASE WHEN adm_image!='' THEN CONCAT('".ADMIN_PROFILE_IMAGE."',adm_image)  ELSE adm_image END as profile_image");
        $this->db->from('comm_admin');
        $this->db->where('adm_email',$admData['adm_email']);
        $this->db->where('adm_password',$admData['adm_password']);
        $resultResponse = $this->db->get()->row_array();

        if($resultResponse)
        {
            return $resultResponse;
        }
        else
        {
            return 0;
        }
    }

    public function changeEmail($table, $admData)
    {
        $this->db->select('*');
        $this->db->from($table);
        $this->db->where('adm_id',$admData['adm_id']);
        $query = $this->db->get();
        $result =  $query->result_array();

        $admData['img']= isset($admData['img'])?$admData['img']:$result[0]['adm_image'];
        $where = array('adm_id' => $admData['adm_id']);
        $data = array('adm_email' =>$admData['adm_email'],'adm_image'=>$admData['img'] ,'adm_name'=>$admData['adm_name'] ,'adm_updatedate' =>date('Y-m-d'));
        $this->db->where($where);
        $status = $this->db->update($table, $data);
        if($status)
        {
            return TRUE;
        }
        else
        {
            return FALSE;
        }
    }

    //get admin record
    public function adminRecord($table, $admData)
    {
        $this->db->select("adm_email,adm_name,CASE WHEN adm_image!='' THEN CONCAT('".ADMIN_PROFILE_IMAGE."',adm_image)  ELSE adm_image END as profile_image");
        $this->db->from($table);
        $this->db->where('adm_id',$admData['adm_id']);
        $query = $this->db->get();
        $result = $query->result_array();
        if($this->db->affected_rows())
        {
            return $result;
        }
        else
        {
            return 0;
        }
    }

    //funtion to get email of user to send password
    public function ForgotPassword($email)
    {
        $this->db->from('comm_admin');
        $this->db->where('adm_email', $email);
        $query=$this->db->get();
        return $query->row_array();
    }

     // send password on user mail
    public function sendpassword($data)
    {
        $email = $data['adm_email'];
        $query1=$this->db->query("SELECT *  from comm_admin where adm_email = '".$email."' ");
        $row=$query1->result_array();
        if ($query1->num_rows()>0)
        {
            $passwordplain = "";
            $passwordplain  = rand(99,99);
            $newpass['adm_password'] = md5($passwordplain);
            $this->db->where('adm_email', $email);
            $this->db->update('comm_admin', $newpass);
            $mail_message='Dear '.$row[0]['adm_name'].','. "\r\n";
            $mail_message.='Thanks for contacting regarding to forgot password,<br> Your <b>Password</b> is <b>'.$passwordplain.'</b>'."\r\n";
            $mail_message.='<br>Please Update your password.';
            $mail_message.='<br>Thanks & Regards';

            ini_set('SMTP', "ssl://smtp.gmail.com");
            ini_set('smtp_port', "465");
            ini_set('sendmail_from', "phpproject99939@gmail.com");
            $this->load->library('email');
            $this->email->set_newline("\r\n");

            $config['protocol'] = 'smtp';
            $config['smtp_user'] = 'phpproject99939@gmail.com';
            $config['smtp_from_name'] = 'commynity';
            $config['smtp_pass'] = 'php99939';
            $config['wordwrap'] = TRUE;
            $config['newline'] = "\r\n";
            $config['mailtype'] = 'html';

            $this->email->initialize($config);
            $to = $email;
            $subject  = "First PHPMailer Message";
            $this->email->from($config['smtp_user'], $config['smtp_from_name']);
            $this->email->to('sachin.tambe@aplitetech.com');
            $this->email->subject($subject);

            $this->email->message($mail_message);

            if($this->email->send()) {
                return true;
            } else {
                return false;
            }
        }
    }

    //change password
    public function changePassword($table, $admData)
    {
        if($admData['adm_id']){
            $this->db->select('*');
            $this->db->from($table);
            $this->db->where('adm_password',$admData['adm_password']);
            $this->db->where('adm_id',$admData['adm_id']);
            $query = $this->db->get();
            if($query->num_rows() == 0)
            {
                return '0';
            }
            else
            {
                $where = array('adm_id' => $admData['adm_id']);
                $data = array('adm_password' =>$admData['adm_npassword'],'adm_updatedate' =>date('Y-m-d'));
                $this->db->where($where);
                $this->db->update($table, $data);
                if($this->db->affected_rows())
                {
                    return 1;
                }
                else
                {
                    return 0;
                }
            }
        }
    }

    //api for show Dashboard hive and help count
    public function communityProfile($filterData)
    {
        $this->db->select('cat_id');
        $this->db->from('comm_categories');
        $this->db->where('cat_type','CATEGARY');
        $dataCategory = $this->db->get()->result_array();
        $hiveId =$dataCategory[0]['cat_id'];
        $helpId =$dataCategory[1]['cat_id'];

        $sql = "SELECT users.usr_id,users.usr_fname as Profile_Name,users.usr_social_id as Profile_Id,users.usr_email as Email,users.usr_gender as Sex,comm_location.loc_name as CommunitiCity,users.usr_fb_location as LocationfromFB,users.usr_createddate as DateTimeofaccountcreation,users.usr_updatedate as DateTimeoflastlogin,CASE WHEN posts_hive.hive_count!='' THEN posts_hive.hive_count ELSE '0' END as HiveCreated,CASE WHEN posts_help.help_count!='' THEN posts_help.help_count ELSE '0' END as HelpCreated,CASE WHEN posts_comment.comment_count!='' THEN posts_comment.comment_count ELSE '0' END as HiveCommented,CASE WHEN help_applied.help_count!='' THEN help_applied.help_count ELSE '0' END as HelpApplied,CASE WHEN report_given.report_count!='' THEN report_given.report_count ELSE '0' END as FlagNoOfFlagGiven,CASE WHEN great_given.great_count!='' THEN great_given.great_count ELSE '0' END as GreatAnswerGiven,CASE WHEN great_received.grt_rcv_count!='' THEN great_received.grt_rcv_count ELSE '0' END as GreatAnswerRecived, CASE WHEN flag_received.flag_rcv_count+flag_ans_received.flag_rcv_count!='' THEN flag_received.flag_rcv_count+flag_ans_received.flag_rcv_count ELSE '0' END as FlagNoOfFlagRecived
                        FROM comm_users users
                        LEFT JOIN comm_location ON comm_location.loc_id=users.usr_app_location
                        LEFT JOIN 
                        ( 
                             SELECT pst_usr_id, COUNT(*) AS hive_count 
                             FROM comm_posts
                             WHERE pst_cat_id = ".$hiveId."
                             AND pst_isDeleted=0 
                             GROUP BY pst_usr_id 
                        )
                        posts_hive ON users.usr_id = posts_hive.pst_usr_id
                        LEFT JOIN 
                        ( 
                             SELECT pst_usr_id, COUNT(*) AS help_count 
                             FROM comm_posts
                             WHERE pst_cat_id = ".$helpId."
                             AND pst_isDeleted=0 
                             GROUP BY pst_usr_id 
                        )
                        posts_help ON users.usr_id = posts_help.pst_usr_id
                        LEFT JOIN 
                        ( 
                             SELECT ans_usr_id, COUNT(*) AS comment_count 
                             FROM comm_answers
                             WHERE ans_isDeleted = 0
                             GROUP BY ans_usr_id 
                        )
                        posts_comment ON users.usr_id = posts_comment.ans_usr_id
                        LEFT JOIN 
                        ( 
                             SELECT hlp_usr_id_frm, COUNT(*) AS help_count 
                             FROM comm_help
                             GROUP BY hlp_usr_id_frm 
                        )
                        help_applied ON users.usr_id = help_applied.hlp_usr_id_frm
                        LEFT JOIN 
                        ( 
                             SELECT rpt_usr_id, COUNT(*) AS report_count 
                             FROM comm_report
                             GROUP BY rpt_usr_id 
                        )
                        report_given ON users.usr_id = report_given.rpt_usr_id
                        LEFT JOIN 
                        ( 
                             SELECT gta_usr_id, COUNT(*) AS great_count 
                             FROM comm_greatanswer
                             GROUP BY gta_usr_id 
                        )great_given ON users.usr_id = great_given.gta_usr_id
                        LEFT JOIN 
                        ( 
                            SELECT ans_usr_id, COUNT(gta_ans_id) as grt_rcv_count 
                            FROM `comm_answers` 
                            LEFT JOIN comm_greatanswer ON comm_greatanswer.gta_ans_id=comm_answers.ans_id
                            WHERE ans_isDeleted=0
                            GROUP BY ans_usr_id 
                        )
                        great_received ON users.usr_id = great_received.ans_usr_id
                        LEFT JOIN 
                        ( 
                            SELECT pst_usr_id, COUNT(rpt_pst_ans_usr_id) as flag_rcv_count 
                            FROM comm_posts 
                            LEFT JOIN comm_report ON comm_report.rpt_pst_ans_usr_id=comm_posts.pst_id
                            where comm_posts.pst_isDeleted=0
                            AND comm_report.rpt_type!='ANSWER'
                            GROUP BY pst_usr_id 
                        )
                        flag_received ON users.usr_id = flag_received.pst_usr_id
                        LEFT JOIN 
                        ( 
                            SELECT ans_usr_id, COUNT(rpt_pst_ans_usr_id) as flag_rcv_count 
                            FROM comm_answers 
                            LEFT JOIN comm_report ON comm_report.rpt_pst_ans_usr_id=comm_answers.ans_id
                            where comm_answers.ans_isDeleted=0
                            AND comm_report.rpt_type='ANSWER'
                            GROUP BY ans_usr_id 
                        )
                        flag_ans_received ON users.usr_id = flag_ans_received.ans_usr_id
                        ORDER BY users.usr_id desc LIMIT ".$filterData['page'].",".$filterData['limit'];

        $replyData = $this->db->query($sql)->result_array();

        $i=0;
        foreach ($replyData as $userID) 
        {
            $this->db->select("COUNT(*) * comm_points_master.pma_points as help_count");
            $this->db->from('comm_help');
            $this->db->join('comm_points_master','comm_points_master.pma_shortcode="COMPLETED_HELP"','left');
            $this->db->where('hlp_usr_id_frm',$userID['usr_id']);
            $this->db->where('hlp_completed','Yes');
            $completed = $this->db->get()->row_array();
            $actionData['successfully_completed_help_request'] = isset($completed['help_count'])?$completed['help_count']:"0";

            $this->db->select("COUNT(*) * comm_points_master.pma_points as post_count");
            $this->db->from('comm_posts');
            $this->db->join('comm_points_master','comm_points_master.pma_shortcode="CREATE_HELP"','left');
            $this->db->where('pst_usr_id',$userID['usr_id']);
            $this->db->where('pst_cat_id',$helpId);
            $this->db->where('comm_posts.pst_id IN (select hlp_pst_id from comm_help where hlp_usr_id_to='.$userID['usr_id'].' AND hlp_completed ="Yes" AND hlp_pst_id IN (select pst_id from comm_posts where pst_usr_id='.$userID['usr_id'].' AND pst_cat_id ='.$helpId.'))');
            $this->db->where('comm_posts.pst_completed','Yes');
            $created = $this->db->get()->row_array();
            $actionData['successfully_created_help_request'] = isset($created['post_count'])?$created['post_count']:"0";

            //CAST(COUNT(*)/5 as UNSIGNED)

            $sql = "SELECT sum(karma.count) as points
            FROM
            (
            SELECT COUNT(*) * comm_points_master.pma_points as count
            FROM comm_greatanswer
            LEFT JOIN comm_points_master ON comm_points_master.pma_shortcode ='GREAT_ANSWER'
            WHERE comm_greatanswer.gta_ans_id IN (select ans_id from comm_answers where ans_usr_id=".$userID['usr_id'].") 
            UNION all
            SELECT COUNT(*) DIV 5* comm_points_master.pma_points as ans_upvote_count
            FROM comm_upvote
            LEFT JOIN comm_answers ON comm_answers.ans_id=comm_upvote.upv_pst_ans_id
            LEFT JOIN comm_points_master ON comm_points_master.pma_shortcode ='ANSWER_UPVOTE'
            WHERE comm_upvote.upv_pst_ans_id IN (select ans_id from comm_answers where ans_usr_id=".$userID['usr_id'].")
            AND comm_upvote.upv_type = 'Answer'
            AND comm_answers.ans_usr_id = ".$userID['usr_id']. " GROUP by (comm_upvote.upv_pst_ans_id)
            UNION all
            SELECT COUNT(*) DIV 5* comm_points_master.pma_points as pst_upvote_count
            FROM comm_upvote as tbl_upvote
            LEFT JOIN comm_posts ON comm_posts.pst_id=tbl_upvote.upv_pst_ans_id
            LEFT JOIN comm_points_master ON comm_points_master.pma_shortcode='POST_UPVOTE'
            WHERE tbl_upvote.upv_pst_ans_id IN (select pst_id from comm_posts where pst_usr_id=".$userID['usr_id']." and pst_id in(select pst_id from comm_posts where pst_usr_id=".$userID['usr_id']."))
            AND tbl_upvote.upv_type = 'Post'
            AND comm_posts.pst_usr_id = ".$userID['usr_id']. " GROUP by (tbl_upvote.upv_pst_ans_id)
            ) as karma";

            $hivePoint = $this->db->query($sql)->row_array();
            $actionData['helpful_hive_contribution'] = isset($hivePoint['points'])?$hivePoint['points']:"0";
            $this->db->select('pma_points');
            $this->db->from('comm_points_master');
            $this->db->where('pma_shortcode','SIGN_UP');
            $signUp = $this->db->get()->row_array();
            $actionData['sign_up'] = isset($signUp['pma_points'])?$signUp['pma_points']:"0";

            $replyData[$i]['Karma_Points'] = $actionData['successfully_completed_help_request']+$actionData['successfully_created_help_request']+$actionData['helpful_hive_contribution']+$actionData['sign_up'];
        $i++;
        }

        return $replyData;
    }


    function countRows()
    {
        $query="select count(usr_id) as count from comm_users";
        $result = $this->db->query($query);
        return $result->result_array();
    }

    public function getUserslist($filterData)
    {
        $actionData = array();
        $this->db->select("SQL_CALC_FOUND_ROWS usr_id,comm_location.loc_name,usr_username,usr_fname,usr_lname,usr_email,usr_social_id,usr_createddate,CASE WHEN usr_image!='' THEN CONCAT('".USER_PROFILE_IMAGE."',usr_image)  ELSE usr_image END as profile_image, usr_isDelete as Status,usr_app_location ",false);
        $this->db->from('comm_users');
        $this->db->join('comm_location','comm_location.loc_id=comm_users.usr_app_location','left');

        if($filterData['search'])
        {
             $this->db->like('usr_fname',$filterData['search']);
        }

        if($filterData['social_name'])
        {
            $this->db->where('usr_social_name',$filterData['social_name']);
        }

        if($filterData['limit'])
        {
             $this->db->limit($filterData['limit'],$filterData['page']);
        }

        $this->db->order_by('usr_id','asc');
        $responseResult = $this->db->get()->result_array();
        $totalCount = $this->db->query('SELECT FOUND_ROWS() count')->row_array();

        if($responseResult)
        {
            //--Call model function for get category
            $categoryName = $this->AdminModel->selectMultipleData('cat_id,cat_name','comm_categories',array('cat_type' =>'CATEGARY'));
            return array('success' => true, 'data' => $responseResult,'total_count' =>$totalCount['count'], 'message' => 'Users List','category' => $categoryName);
        }
        else
        {
            return 0;
        }
    }

    function countUsers()
    {
        $query="select count(usr_id) as count from comm_users order by usr_id asc";
        $result=$this->db->query($query);
        return $result->result_array();
    }

    public function viewUser($usrData)
    {
        $this->db->select("usr_id,usr_isDelete,usr_username,comm_location.loc_name,usr_fb_location,usr_fname,usr_lname,usr_email,usr_gender,CASE WHEN usr_image!='' THEN CONCAT('".USER_PROFILE_IMAGE."',usr_image)  ELSE usr_image END as profile_image,usr_img_type,usr_dob,usr_token,usr_createddate,usr_updatedate,usr_app_location");
        $this->db->from('comm_users');
        $this->db->join('comm_location','comm_location.loc_id=comm_users.usr_app_location','left');
        $this->db->where('usr_id',$usrData['usr_id']);
        $responseResult = $this->db->get()->row_array();

        if($responseResult)
        {
            return $responseResult;
        }
        else
        {
            return 0;

        }
    }

    public function flagAgainstUserlist($filterData)
    {
        $actionData_count   = array();
        //query for get users
        $actionData =array();
        $this->db->select('usr_id,usr_fname,usr_social_id ');
        $this->db->from('comm_users');

        if($filterData['limit']){
        $this->db->limit($filterData['limit'],$filterData['page']);
        }
        $userData = $this->db->get();
        $userData = $userData->result_array();
        if($userData)
        {

        foreach($userData as $value){
        $actionData['userid'] = isset($value['usr_id'])?$value['usr_id']:"";
        $actionData['Profile_Name'] = isset($value['usr_fname'])?$value['usr_fname']:"";
        $actionData['Profile_Id'] = isset($value['usr_social_id'])?$value['usr_social_id']:"0";

        //query for get Flag For post
        $this->db->select("comm_categories.cat_name as Type,comm_categories.cat_id as ID");
        $this->db->from('comm_categories');
        $this->db->where('comm_categories.cat_name !=','REPORT');
        $this->db->group_by('comm_categories.cat_id','asc');
        $FlagFor = $this->db->get();
        $FlagFor = $FlagFor->result_array();
        $flagforarraychat = array('3'=>array('Type'=>'Chat','ID'=>$actionData['userid']));
        $flagforarraycom = array('4'=>array('Type'=>'Hive Comment','ID'=>$actionData['userid']));
        $flag1=array_merge($flagforarraycom,$flagforarraychat);
        $for = array_merge($FlagFor,$flag1);

        if($for)
        {
            $i=0;
            $result = array();
            foreach ($for as $item)
            {
                if (!isset($result[$item['Type']]))
                {
                    $result[$i] = $item;
                }
                $i++;
            }
            $actionData['FlagFor'] = $result;
        }
        else {
            $actionData['FlagFor'] =  0;
        }
        $actionData_count[] = $actionData;
        }
        }
        else {
             $actionData['userData'] =  0;
         }
        return array_values($actionData_count);
    }


    //api for flag against user
    public function getflagAgainstlist($filterData )
    {

        //query for get users
        $actionData =array();
        $usr_id =  isset($filterData['usr_id'])?$filterData['usr_id']:'';
        $id     =  isset($filterData['ID'])?$filterData['ID']:'';
        $type   =  isset($filterData['Type'])?$filterData['Type']:'';

         
         if($type == 'HIVE')
         {
             //query for get Flags
             $this->db->select("pst_title as title ,scat_title as FlagOption,concat(usr_fname,usr_lname) as Reportedby,rpt_usr_id as ReportedbyID");
             $this->db->from('comm_report');
             $this->db->join('comm_users','comm_users.usr_id=comm_report.rpt_usr_id','left');
             $this->db->join('comm_subcategories','comm_subcategories.scat_id=comm_report.rpt_scat_id','left');
             $this->db->join('comm_posts','comm_posts.pst_id=comm_report.rpt_pst_ans_usr_id','left');
             $this->db->where('pst_cat_id',$id);
             $this->db->where('rpt_type','POST');
             $this->db->where('pst_usr_id',$usr_id);
         }

         if($type == 'HELP REQUEST')
         {
             //query for get Flags
             $this->db->select("pst_title as title ,scat_title as FlagOption,concat(usr_fname,usr_lname) as Reportedby,rpt_usr_id as ReportedbyID");
             $this->db->from('comm_report');
             $this->db->join('comm_users','comm_users.usr_id=comm_report.rpt_usr_id','left');
             $this->db->join('comm_subcategories','comm_subcategories.scat_id=comm_report.rpt_scat_id','left');
             $this->db->join('comm_posts','comm_posts.pst_id=comm_report.rpt_pst_ans_usr_id','left');
             $this->db->where('pst_cat_id',$id);
             $this->db->where('rpt_type','POST');
             $this->db->where('pst_usr_id',$usr_id);
         }

         if($type == 'Hive Comment')
         {
             //query for get Flags
             $this->db->select("ans_description as title ,scat_title as FlagOption,concat(usr_fname,usr_lname) as Reportedby,rpt_usr_id as ReportedbyID");
             $this->db->from('comm_report');
             $this->db->join('comm_users','comm_users.usr_id=comm_report.rpt_usr_id','left');
             $this->db->join('comm_subcategories','comm_subcategories.scat_id=comm_report.rpt_scat_id','left');
              $this->db->join('comm_answers','comm_answers.ans_id=comm_report.rpt_pst_ans_usr_id','left');
             $this->db->where('comm_report.rpt_type','ANSWER');
             $this->db->where('comm_answers.ans_usr_id',$usr_id);
         }

        if($type == 'Chat')
         {
             //query for get Flags
             $this->db->select("pst_title as title ,scat_title as FlagOption,concat(usr_fname,usr_lname) as Reportedby,rpt_usr_id as ReportedbyID");
             $this->db->from('comm_report');
             $this->db->join('comm_users','comm_users.usr_id=comm_report.rpt_usr_id','left');
             $this->db->join('comm_subcategories','comm_subcategories.scat_id=comm_report.rpt_scat_id','left');
             $this->db->join('comm_posts','comm_posts.pst_id=comm_report.rpt_pst_ans_usr_id','left');
             $this->db->where('pst_cat_id',$id);
             $this->db->where('rpt_type','CHAT');
             $this->db->where('pst_usr_id',$usr_id);
         }

        $title = $this->db->get();
        $title = $title->result_array();

        if($title)
        {
            $i=0;
            $result = array();
            foreach ($title as $key=>$item)
            {
                if (!isset($result[$key]))
                {
                    $result[$i] = $item;
                }
                $i++;
            }
            $actionData['Content'] = $result;

        }
        else {
            $actionData['Content'] =  '';
        }

        return array_values($actionData);
    }

    public function joinDefaultAppGroup($usrId)
    {
        $groupData = $this->selectMultipleData("scat_id as join_grp_id,CASE WHEN scat_id!='' THEN ".$usrId." END as join_usr_id",'comm_subcategories',array('scat_cat_id' => 4));
        
        $this->db->insert_batch('comm_groupJoin',$groupData);
    }

    public function addUserHive($hiveData,$hiveTags)
    {
        $this->db->insert('comm_posts',$hiveData);
        $postId = $this->db->insert_id();

        if($postId)
        {
            if($hiveTags)
            {  
                $i=0;
                foreach ($hiveTags as $tagName) 
                {
                    $hashData[$i]['htag_pst_id'] = $postId;
                    $hashData[$i]['htag_text'] = $tagName;
                    $hashData[$i]['htag_createdate'] = $hiveData['pst_createdate'];
                    $i++;           
                }
                $this->db->insert_batch('comm_hashtags',$hashData);
            }
            
            return $postId;
        }
        else
        {
            return 0;
        }
    }

    public function editUserHiveById($pstId,$hiveData,$hiveTags)
    {
        $this->db->where('pst_id',$pstId);
        $this->db->update('comm_posts',$hiveData);

        if($this->db->affected_rows())
        {
            $this->db->where('htag_pst_id',$pstId);
            $this->db->delete('comm_hashtags');

            if($hiveTags)
            {
                $i=0;
                foreach ($hiveTags as $tagName) 
                {
                    $hashData['htag_pst_id'] = $pstId;
                    $hashData['htag_text'] = $tagName;
                    $hashData['htag_createdate'] = $hiveData['pst_updatedate'];

                    $this->db->insert('comm_hashtags',$hashData); 

                    $tagsDetail[$i]['htag_id'] = $this->db->insert_id();
                    $tagsDetail[$i]['htag_text'] = $tagName;  
                $i++;        
                }
                $responseData[0]['tags'] = $tagsDetail;
                return $responseData;
            }
            $responseData[0]['tags'] = array();

            return $responseData;
        }
        else
        {
            return 0;
        }
    }

    public function getOrFilterAllHivePost($filterData)
    {
        $sql = "SELECT posts.pst_id,posts.pst_title,posts.pst_description,posts.pst_completed,posts.pst_createdate,posts.pst_updatedate, subcategories.scat_title as grp_title,users.usr_fname,users.usr_lname,users.usr_id,CASE WHEN upvote.upvote!='' THEN upvote.upvote  ELSE 0 END as upvote_count,CASE WHEN upvote_user.upv_pst_ans_id!='' THEN 'YES'  ELSE 'NO' END as usr_upvote,CASE WHEN users.usr_image!='' THEN CONCAT('".USER_PROFILE_IMAGE."',users.usr_image)  ELSE users.usr_image END as profile_image,CASE WHEN comm_report.rpt_id!='' THEN 'YES' ELSE 'NO' end as usr_report,replies as comment,CASE WHEN comm_groupJoin.join_id!='' THEN 'YES' ELSE 'NO' end as usr_join
            FROM comm_posts posts
            LEFT JOIN comm_subcategories subcategories ON subcategories.scat_id=posts.pst_grp_id
            LEFT JOIN comm_groupJoin ON comm_groupJoin.join_grp_id=posts.pst_grp_id AND join_usr_id = ".$filterData['usr_id']."
            LEFT JOIN comm_users users ON users.usr_id=posts.pst_usr_id
            LEFT JOIN 
                        ( 
                             SELECT and_pst_id, COUNT(*) AS replies
                             FROM comm_answers as answers1
                             WHERE ans_isDeleted = 0
                             GROUP BY and_pst_id 
                        ) as
                        answers ON posts.pst_id = answers.and_pst_id
            LEFT JOIN 
                        ( 
                             SELECT upv_pst_ans_id, COUNT(*) AS upvote
                             FROM comm_upvote
                             WHERE upv_type = 'Post'
                             GROUP BY upv_pst_ans_id 
                        )
                        upvote ON posts.pst_id = upvote.upv_pst_ans_id
            LEFT JOIN  comm_report ON posts.pst_id = comm_report.rpt_pst_ans_usr_id AND comm_report.rpt_type = 'Post' AND comm_report.rpt_usr_id =".$filterData['usr_id']."
            LEFT JOIN 
                       ( 
                             SELECT upv_pst_ans_id
                             FROM comm_upvote as upvote_user1
                             WHERE upv_type = 'Post'
                             and upv_usr_id = ".$filterData['usr_id']."
                             GROUP BY upv_pst_ans_id 
                        )
                        upvote_user ON posts.pst_id = upvote_user.upv_pst_ans_id 
                        
            WHERE posts.pst_isDeleted = 0";

        //--Get single post detail
        if($filterData['pst_id'])
        {
            $sql .= " AND posts.pst_id = ".$filterData['pst_id']."";
        }
        else if ($filterData['pst_grp_id'])
        {
            $sql .= " AND posts.pst_grp_id = ".$filterData['pst_grp_id']."";
        }
        else
        {
            $sql .= " AND posts.pst_grp_id IN (SELECT join_grp_id FROM comm_groupJoin WHERE join_usr_id =".$filterData['usr_id'].")";

            $sql .= " AND posts.pst_id NOT IN(SELECT CASE WHEN COUNT(comm_report.rpt_pst_ans_usr_id) >=3 THEN comm_report.rpt_pst_ans_usr_id ELSE 0 end as id FROM comm_posts LEFT JOIN comm_report on comm_report.rpt_pst_ans_usr_id=comm_posts.pst_id AND comm_report.rpt_type = 'POST' WHERE comm_posts.`pst_cat_id`=".$filterData['cat_id']." group by comm_report.rpt_pst_ans_usr_id)";
             $sql .= " AND posts.pst_cat_id = ".$filterData['cat_id']."";
        }

        if($filterData['trend']=="TREND")
        {
            $date = strtotime(gmdate('Y-m-d h:i:s a').' UTC');

            $sql .= " AND posts.pst_id IN(SELECT DISTINCT CASE WHEN answers.cmt_replies*upvote.pst_upvote/DATEDIFF(from_unixtime('$date', '%Y-%m-%d'),  from_unixtime(posts.pst_createdate, '%Y-%m-%d'))>=1 THEN posts.pst_id END as usr_upvote
                FROM comm_posts posts
                LEFT JOIN 
                            ( 
                                 SELECT and_pst_id, COUNT(*) AS cmt_replies
                                 FROM comm_answers as answers1
                                 WHERE ans_isDeleted = 0
                                 GROUP BY and_pst_id 
                            ) as
                            answers ON posts.pst_id = answers.and_pst_id
                LEFT JOIN 
                            ( 
                                 SELECT upv_pst_ans_id, COUNT(*) AS pst_upvote
                                 FROM comm_upvote
                                 WHERE upv_type = 'Post'
                                 GROUP BY upv_pst_ans_id 
                            )
                            upvote ON posts.pst_id = upvote.upv_pst_ans_id
                            
                WHERE posts.pst_isDeleted = 0
                AND posts.pst_cat_id =1)";
        }

        if($filterData['filter'])
        {
            $sql .= " AND users.usr_fname LIKE '%".$filterData['filter']."%' OR users.usr_lname LIKE '%".$filterData['filter']."%'";
        }
    
        $sql .= " ORDER BY posts.pst_updatedate desc";

        $total_record = $this->db->query($sql);
        $totalCount = $total_record->num_rows();

        if($filterData['limit'])
        {
             $sql .=  " LIMIT ".$filterData['start'].",".$filterData['limit'];
        }


        $postData = $this->db->query($sql)->result_array();
       
        if($postData)
        {
            $i=0;
            foreach ($postData as $postId) 
            {
                //--Get post tags
                $this->db->select('htag_id,htag_text');
                $this->db->from('comm_hashtags');
                $this->db->where('htag_pst_id',$postId['pst_id']);
                $postData[$i]['tags']= $this->db->get()->result_array();

                $sql2 = "SELECT COUNT(and_pst_id) AS replies
                         FROM comm_answers
                         WHERE ans_isDeleted = 0
                         AND comm_answers.`and_pst_id`=".$postId['pst_id']."
                         AND ans_id NOT IN(SELECT CASE WHEN COUNT(comm_report.rpt_pst_ans_usr_id)>=3 THEN comm_report.rpt_pst_ans_usr_id ELSE 0 end AS id FROM comm_answers LEFT JOIN comm_report ON comm_report.rpt_pst_ans_usr_id=comm_answers.ans_id AND comm_report.rpt_type = 'ANSWER' WHERE comm_answers.and_pst_id=".$postId['pst_id']." group by comm_report.rpt_pst_ans_usr_id) 
                         GROUP BY and_pst_id";
               $replyCount = $this->db->query($sql2)->row_array();
               $postData[$i]['replies_count'] = isset($replyCount['replies'])?$replyCount['replies']:"0";
            $i++;
            }
            return array('success' => true, 'total_count' =>(string)$totalCount,'data' => $postData,'message' => 'Get successfully');
        }
        else
        {
            return 0;
        }
    }

    public function addCommentOnPost($postData,$postTitle,$pstUsrId,$LoginUserName,$pstUsrNm)
    {
        //--Get post user for notification
        $this->db->select('DISTINCT(comm_answers.ans_usr_id) AS usr_id,comm_devices.dev_device_token');
        $this->db->from('comm_answers');
        $this->db->join('comm_devices','comm_devices.dev_usr_id = comm_answers.ans_usr_id','left');
        $this->db->join('comm_users','comm_users.usr_id = comm_devices.dev_usr_id','left');
        $this->db->where('comm_answers.and_pst_id',$postData['and_pst_id']);
        $this->db->where('comm_answers.ans_usr_id!=',$pstUsrId);
        $this->db->where('comm_answers.ans_usr_id!=',$postData['ans_usr_id']);
        $this->db->where('comm_users.usr_isDelete',0);
        $postedUserData = $this->db->get()->result_array();

        //--Insert comment on post
        $response = $this->insertData($postData,'comm_answers');

        if($response)
        {
            if(strlen($postTitle)>60)
            {
                $message = substr($postTitle, 0, 57).'...';
            }
            else
            {
                $message = $postTitle;
            }

            $pushMessage = 'People are commenting on a discussion you participated in';

            $notData['ntfy_from'] = $postData['ans_usr_id'];
            $notData['ntfy_pst_id'] = $postData['and_pst_id'];
            $notData['ntfy_message'] = $message;
            $notData['ntfy_type'] ='HIVE_COMMENT';
            $notData['ntfy_pst_type'] ='HIVE';
            $notData['ntfy_createdate'] = $postData['ans_createdate'];
            
            //--msg for notification
            $notifyMessage['ntfy_message'] = $pushMessage;
            $notifyMessage['ntfy_pst_type'] ='HIVE';

            if($postedUserData)
            {
                //-- send notification
                foreach ($postedUserData as $userData) 
                {
                    //-call function for send notification
                    $this->sendNotification($userData['dev_device_token'],$notifyMessage);

                    $notData['ntfy_to'] = $userData['usr_id'];
                    $this->db->insert('comm_notification', $notData);
                    $notfyAnsId['ans_ntfy_id'] = $this->db->insert_id();
                    //--Update notification id
                    if($notfyAnsId)
                        $this->db->where(array('ans_id' => $response));
                        $this->db->update('comm_answers',$notfyAnsId);

                }
            }

            if($postData['ans_usr_id']!=$pstUsrId)
            {
                $userDeviceData = $this->singleData('dev_device_token','comm_devices',array('dev_usr_id' =>$pstUsrId));
                $notifyMessage['ntfy_message']= 'Your post just got a comment';
                $this->sendNotification($userDeviceData['dev_device_token'], $notifyMessage);
                $notData['ntfy_to'] = $pstUsrId;
                $this->db->insert('comm_notification', $notData);
                $notfyAnsId['ans_ntfy_id'] = $this->db->insert_id();
                    //--Update notification id
                    if($notfyAnsId)
                        $this->db->where(array('ans_id' => $response));
                        $this->db->update('comm_answers',$notfyAnsId);
            }
            else
            {
                $notData['ntfy_to'] = $pstUsrId;
                $this->db->insert('comm_notification', $notData);
                $notfyAnsId['ans_ntfy_id'] = $this->db->insert_id();
                    //--Update notification id
                    if($notfyAnsId)
                        $this->db->where(array('ans_id' => $response));
                        $this->db->update('comm_answers',$notfyAnsId);
            }
            
            $responseResult['ans_id']=$response;
            $responseResult['ntfy_id'] = $notfyAnsId['ans_ntfy_id'];
            return $responseResult;
        }
        else
        {
            return 0;
        }
    }

    public function getAllPostComments($pstId,$usrId,$filterData)
    {
        $sql = "SELECT CASE WHEN user_tbl.usr_image!='' THEN CONCAT('".USER_PROFILE_IMAGE."',user_tbl.usr_image)  ELSE user_tbl.usr_image END as profile_image,user_tbl.usr_fname,user_tbl.usr_id,answers.ans_updatedate,answers.ans_id,answers.ans_description,answers.ans_createdate,CASE WHEN greatanswer.gta_ans_id!='' THEN 'YES'  ELSE 'NO' END as great,CASE WHEN upvote.upvote_count!='' THEN upvote.upvote_count  ELSE '0' END as count_upvote, CASE WHEN usrupvote.upv_id!='' THEN 'YES'  ELSE 'NO' END as user_upvote,CASE WHEN comm_report.rpt_id!='' THEN 'YES' ELSE 'NO' end as usr_report,answers.ans_ntfy_id
                        FROM comm_answers answers
                        LEFT JOIN comm_users user_tbl ON answers.ans_usr_id = user_tbl.usr_id 
                        LEFT JOIN comm_upvote usrupvote ON answers.ans_id = usrupvote.upv_pst_ans_id AND usrupvote.upv_type = 'Answer' AND usrupvote.upv_usr_id=".$usrId."
                        LEFT JOIN comm_greatanswer greatanswer ON answers.ans_id = greatanswer.gta_ans_id
                        LEFT JOIN 
                        ( 
                             SELECT upv_pst_ans_id, COUNT(*) AS upvote_count 
                             FROM comm_upvote
                             WHERE upv_type = 'Answer'
                             GROUP BY upv_pst_ans_id 
                        )
                        upvote ON answers.ans_id = upvote.upv_pst_ans_id
                        LEFT JOIN  comm_report ON answers.ans_id = comm_report.rpt_pst_ans_usr_id AND comm_report.rpt_type = 'Answer' AND comm_report.rpt_usr_id =".$usrId."

                        WHERE answers.and_pst_id = ".$pstId." AND answers.ans_isDeleted = 0

                        AND answers.ans_id NOT IN(SELECT CASE WHEN COUNT(comm_report.rpt_pst_ans_usr_id)>=3 THEN comm_report.rpt_pst_ans_usr_id ELSE 0 end AS id FROM comm_answers LEFT JOIN comm_report ON comm_report.rpt_pst_ans_usr_id=comm_answers.ans_id AND comm_report.rpt_type = 'ANSWER' WHERE comm_answers.`and_pst_id`=".$pstId." group by comm_report.rpt_pst_ans_usr_id)";

        $total_record = $this->db->query($sql);
        $totalCount = $total_record->num_rows();

                        $sql .=" ORDER BY answers.ans_createdate ASC LIMIT ".$filterData['start'].",".$filterData['limit'];

        $replyData = $this->db->query($sql)->result_array();

        if($replyData)
        {
            return array('success' => true, 'data' => $replyData,'total_count' =>$totalCount, 'message' => 'Comments get successfully');
        }
        else
        {
            return 0;
        }
    }

    public function getKarmaPointActionData($usrId,$count,$helpId,$hiveId)
    {
        $sql = "SELECT sum(karma.count) as points
                FROM
                (
                    SELECT COUNT(*) * comm_points_master.pma_points as count
                    FROM comm_greatanswer
                    LEFT JOIN comm_points_master ON comm_points_master.pma_shortcode ='GREAT_ANSWER'
                    WHERE comm_greatanswer.gta_ans_id IN (select ans_id from comm_answers where ans_usr_id=".$usrId.") GROUP by (gta_ans_id)
                UNION all
                    SELECT COUNT(*) DIV 5* comm_points_master.pma_points as ans_upvote_count
                    FROM comm_upvote
                    LEFT JOIN comm_answers ON comm_answers.ans_id=comm_upvote.upv_pst_ans_id
                    LEFT JOIN comm_points_master ON comm_points_master.pma_shortcode ='ANSWER_UPVOTE'
                    WHERE comm_upvote.upv_pst_ans_id IN (select ans_id from comm_answers where ans_usr_id=".$usrId.")
                    AND upv_type = 'Answer'
                    AND comm_answers.ans_usr_id = ".$usrId." GROUP by (upv_pst_ans_id)
                UNION all
                    SELECT COUNT(*) DIV 5* comm_points_master.pma_points as pst_upvote_count
                    FROM comm_upvote as tbl_upvote
                    LEFT JOIN comm_posts ON comm_posts.pst_id=tbl_upvote.upv_pst_ans_id
                    LEFT JOIN comm_points_master ON comm_points_master.pma_shortcode='POST_UPVOTE'
                    WHERE tbl_upvote.upv_pst_ans_id IN (select pst_id from comm_posts where pst_usr_id=".$usrId." and pst_cat_id=".$hiveId.")
                    AND upv_type = 'Post'
                    AND comm_posts.pst_usr_id = ".$usrId." GROUP by (upv_pst_ans_id)
                ) as karma";

        $hivePoint = $this->db->query($sql)->row_array();
        $actionData['helpful_hive_contribution'] = isset($hivePoint['points'])?$hivePoint['points']:"0";
        $signUp = $this->singleData('pma_points','comm_points_master',array('pma_shortcode' =>'SIGN_UP'));
        $actionData['sign_up'] = isset($signUp['pma_points'])?$signUp['pma_points']:"0";

        if(empty($count))
        {
            return $actionData;
        }
        else
        {
            return (string)$total_count = $actionData['helpful_hive_contribution']+$actionData['sign_up'];
        }
    }

    public function hiveContributionKarmaPoint($filterData)
    {
        $this->db->select('count(comm_upvote.upv_pst_ans_id) DIV 5*comm_points_master.pma_points as points, comm_posts.pst_id,comm_posts.pst_title,comm_posts.pst_createdate,comm_subcategories.scat_title as grp_title,comm_posts.pst_isDeleted');
        $this->db->from('comm_upvote');
        $this->db->join('comm_posts','comm_posts.pst_id=comm_upvote.upv_pst_ans_id','left');
        $this->db->join('comm_subcategories','comm_subcategories.scat_id=comm_posts.pst_grp_id','left');
        $this->db->join('comm_points_master','comm_points_master.pma_shortcode= "POST_UPVOTE"','left');
        $this->db->where("comm_upvote.upv_pst_ans_id IN(SELECT comm_posts.pst_id
                FROM comm_posts
                WHERE pst_usr_id = ".$filterData['usr_id']."
                AND pst_cat_id = ".$filterData['cat_id'].")");
        $this->db->where('comm_upvote.upv_type','Post');
        $this->db->where('comm_posts.pst_usr_id',$filterData['usr_id']);
        $this->db->group_by('upv_pst_ans_id');
        $postUpvoteCount = $this->db->get()->result_array();

        $this->db->select('count(comm_upvote.upv_pst_ans_id) DIV 5*comm_points_master.pma_points as points, comm_posts.pst_id,comm_posts.pst_title,comm_posts.pst_createdate,comm_subcategories.scat_title as grp_title,comm_posts.pst_isDeleted');
        $this->db->from('comm_upvote');
        $this->db->join('comm_answers','comm_answers.ans_id=comm_upvote.upv_pst_ans_id','left');
        $this->db->join('comm_posts','comm_posts.pst_id=comm_answers.and_pst_id','left');
        $this->db->join('comm_subcategories','comm_subcategories.scat_id=comm_posts.pst_grp_id','left');
        $this->db->join('comm_points_master','comm_points_master.pma_shortcode= "ANSWER_UPVOTE"','left');
        $this->db->where("comm_upvote.upv_pst_ans_id IN(SELECT comm_answers.ans_id
                FROM comm_answers
                WHERE ans_usr_id = ".$filterData['usr_id'].")");
        $this->db->where('comm_upvote.upv_type','Answer');
        $this->db->where('comm_answers.ans_usr_id',$filterData['usr_id']);
        $this->db->group_by('comm_upvote.upv_pst_ans_id');
        $ansUpvoteCount = $this->db->get()->result_array();

        $this->db->select('count(comm_greatanswer.gta_ans_id)*comm_points_master.pma_points as points,comm_posts.pst_id,comm_posts.pst_title,comm_posts.pst_createdate,comm_subcategories.scat_title as grp_title,comm_posts.pst_isDeleted');
        $this->db->from('comm_greatanswer');
        $this->db->join('comm_answers','comm_answers.ans_id=comm_greatanswer.gta_ans_id','left');
        $this->db->join('comm_posts','comm_posts.pst_id =comm_answers.and_pst_id','left');
        $this->db->join('comm_subcategories','comm_subcategories.scat_id =comm_posts.pst_grp_id','left');
        $this->db->join('comm_points_master','comm_points_master.pma_shortcode= "GREAT_ANSWER"','left');
        $this->db->where("comm_greatanswer.gta_ans_id IN(SELECT comm_answers.ans_id
                FROM comm_answers
                WHERE ans_usr_id = ".$filterData['usr_id'].")");
        $this->db->group_by('comm_greatanswer.gta_ans_id');
        $greatAnsCount = $this->db->get()->result_array();
       
        $newHiveArray = array_merge($postUpvoteCount,$ansUpvoteCount);

        $newHiveArray2 = array_merge($newHiveArray,$greatAnsCount);

        foreach($newHiveArray2 as $subKey => $subArray)
        {
            if($subArray['points'] == 0)
            {
                unset($newHiveArray2[$subKey]);
            }
        }

        $result = array();
        foreach ($newHiveArray2 as $item) 
        {
            if (!isset($result[$item['pst_id']])) 
            {
                $result[$item['pst_id']] = $item;
            }
            else 
            {
                $result[$item['pst_id']]["points"] += $item["points"];
                $result[$item['pst_id']]["points"] = (string)$result[$item['pst_id']]["points"];
            }
        }
        return array_values($result);
    }
    //-- function for send notification
    public function sendNotification($usr_deviceId='',$notifyMessage='',$notifyDataArray='')
    {  
        if($usr_deviceId)
        {
            $devices = $usr_deviceId;
            $msg = $notifyMessage['ntfy_message'];
            $body = isset($notifyMessage['title'])?$notifyMessage['title']:"";
            $type = $notifyMessage['ntfy_pst_type'];
            $pstId =  isset($notifyMessage['hlp_pst_id'])?$notifyMessage['hlp_pst_id']:"";
            $usrIdTO = isset($notifyMessage['hlp_usr_id_to'])?$notifyMessage['hlp_usr_id_to']:"";
            $usrIdFrm = isset($notifyMessage['hlp_usr_id_frm'])?$notifyMessage['hlp_usr_id_frm']:"";
            $usrName = isset($notifyMessage['usr_fname'])?$notifyMessage['usr_fname']:"";
            $Days = isset($notifyMessage['Day'])?$notifyMessage['Day']:"";
            $MainHiveId = isset($notifyMessage['Main_Hive_Id'])?$notifyMessage['Main_Hive_Id']:"";
           
            $error = "";
            if($devices=="")
            {
                $error = "device id not found,Please send id in proper format";
                die;
            }
            //$payload['aps'] = array('alert' => $msg, 'badge' => 1, 'sound' => 'default'); 

            $payload['aps'] = array('alert' => array('title' => $body,'body' => $msg), 'badge' => 1, 'sound' => 'default','type'=>$type,'hlp_pst_id' => $pstId,'pst_usr_id' =>$usrIdTO,'hlp_usr_id_frm' =>$usrIdFrm,'usr_fname'=>$usrName,'date_day' =>$Days,'main_hive_id' =>$MainHiveId);

            $payload = json_encode($payload);
            $options = array('ssl' => array(
              //'local_cert' =>realpath(dirname(__FILE__)).'/Push_dev.pem',
              'local_cert' =>realpath(dirname(__FILE__)).'/Push_distri.pem',/// developer certificate
              'passphrase' => ''
            ));

            $streamContext = stream_context_create();
            stream_context_set_option($streamContext, $options);

            //$apns = stream_socket_client('ssl://gateway.sandbox.push.apple.com:2195', $error, $errorString, 30, STREAM_CLIENT_CONNECT, $streamContext);
            $apns = stream_socket_client('ssl://gateway.push.apple.com:2195', $error, $errorString, 30, STREAM_CLIENT_CONNECT, $streamContext);
            stream_set_blocking ($apns, 1);

            //$apns = stream_socket_client('ssl://gateway.sandbox.push.apple.com:2195', $error, $errorString, 60, STREAM_CLIENT_CONNECT, $streamContext);
            //$apns = stream_socket_client('ssl://gateway.push.apple.com:2195', $error, $errorString, 60, STREAM_CLIENT_CONNECT, $streamContext);

            // Use for production
            if (!$apns)
            {
                $error =  json_encode(array('success' => false, "message"=>"Failed to connect: $err $errstr") );
            }
             else
              {
                $apple_expiry = time() + (90 * 24 * 60 * 60);
                $apnsMessage = chr(1) . pack("N", 'community') . pack("N", $apple_expiry) . pack('n', 32) . pack('H*', $devices) . pack('n', strlen($payload)) . $payload;

                //$apnsMessage = chr(0) . chr(0) . chr(32) . pack('H*', str_replace(' ', '', $devices)) . chr(0) . chr(strlen($payload)) . $payload;
                
                $result = fwrite($apns, $apnsMessage);
                //print_r("----->".$result);
                    if (!$result) {
                        $error = json_encode(array('success' => false, "message"=>"Message not delivered"));
                    }else{
                        $error = json_encode(array('success' => true, "message"=>"Message successfully delivered" ));
                    }
                    fclose($apns);
                    flush();
            }

            return $error;
        }
        else if($notifyDataArray!="")
        {
            $i=0;
            foreach ($notifyDataArray as $key)
            {
                $payload = array();
                $devices = $key['dev_device_token'];
                $msg = $key['ntfy_message'];
                $type = $key['ntfy_pst_type'];
                $Days = $key['Day'];
                $MainHiveId = $key['Main_Hive_Id'];
               
                $payload['aps'] = array('alert' => array('title' => '','body' => $msg), 'badge' => 1, 'sound' => 'default','type'=>$type,'hlp_pst_id' => '','pst_usr_id' =>'','hlp_usr_id_frm' =>'','usr_fname'=>'','date_day' =>$Days,'main_hive_id' =>$MainHiveId);

                $payload = json_encode($payload);
                $options = array('ssl' => array(
                  //'local_cert' =>realpath(dirname(__FILE__)).'/Push_dev.pem',
                   'local_cert' =>realpath(dirname(__FILE__)).'/Push_distri.pem',/// developer certificate
                  'passphrase' => ''
                ));

                $streamContext = stream_context_create();
                stream_context_set_option($streamContext, $options);

               // $apns = stream_socket_client('ssl://gateway.sandbox.push.apple.com:2195', $error, $errorString, 30, STREAM_CLIENT_CONNECT, $streamContext);
                $apns = stream_socket_client('ssl://gateway.push.apple.com:2195', $error, $errorString, 30, STREAM_CLIENT_CONNECT, $streamContext);
                stream_set_blocking ($apns, 1);

                // Use for production
                if (!$apns)
                {
                    $error =  json_encode(array('success' => false, "message"=>"Failed to connect: $err $errstr") );
                }
                else
                {
                    $apple_expiry = time() + (90 * 24 * 60 * 30);
                    $apnsMessage = chr(1) . pack("N", 'community') . pack("N", $apple_expiry) . pack('n', 32) . pack('H*', $devices) . pack('n', strlen($payload)) . $payload;

                    
                    $result = fwrite($apns, $apnsMessage);
                    fclose($apns);
                    flush();
                }
            }
            return true;
        }
        else
        {
            return array('message' => "Device is empty");
        }
    }

    public function getHiveGroupList($pstDetail)
    {
        $this->db->select("grp.scat_id as grp_id,grp.scat_title as grp_title,grp.scat_description as grp_description,CASE WHEN grp.scat_icon!='' THEN CONCAT('".SUB_CATEGORY_IMAGE."',grp.scat_icon)  ELSE grp.scat_icon END as grp_image, CASE WHEN usr_join.usr_id!='' THEN 'YES'  ELSE 'NO' END as usr_join,CASE WHEN usr_cat.usr_count!='' THEN usr_cat.usr_count  ELSE 0 END as usr_count,CASE WHEN pst_grp.pst_count!='' THEN pst_grp.pst_count  ELSE 0 END as pst_count");
        $this->db->from('comm_subcategories grp');
        $this->db->join('(SELECT join_grp_id, COUNT(*) AS usr_id 
                            FROM comm_groupJoin
                            WHERE join_usr_id = '.$pstDetail['usr_id'].' 
                            GROUP BY join_grp_id 
                        )
                        usr_join','grp.scat_id = usr_join.join_grp_id','left');
        $this->db->join('(SELECT join_grp_id,COUNT(*) AS usr_count 
                            FROM comm_groupJoin
                            GROUP BY join_grp_id 
                        )
                        usr_cat','grp.scat_id = usr_cat.join_grp_id','left');
        $this->db->join("(SELECT pst_grp_id, COUNT(*) AS pst_count 
                            FROM comm_posts
                            WHERE pst_cat_id =".$pstDetail['hive_id']."
                            AND pst_isDeleted=0
                            AND pst_id NOT IN(SELECT CASE WHEN COUNT(comm_report.rpt_pst_ans_usr_id) >=3 THEN comm_report.rpt_pst_ans_usr_id ELSE 0 end as id FROM comm_posts LEFT JOIN comm_report on comm_report.rpt_pst_ans_usr_id=comm_posts.pst_id AND comm_report.rpt_type = 'POST' WHERE comm_posts.pst_cat_id=".$pstDetail['hive_id']." group by comm_report.rpt_pst_ans_usr_id)
                            GROUP BY pst_grp_id 
                        )
                        pst_grp",'grp.scat_id = pst_grp.pst_grp_id','left');

        if($pstDetail['login_usr_id'])
        {
             $this->db->where("grp.scat_id IN (SELECT join_grp_id FROM comm_groupJoin where join_usr_id = ".$pstDetail['login_usr_id'].")");
        }
        else
        {
             $this->db->where("grp.scat_cat_id IN (SELECT cat_id FROM comm_categories where cat_type = 'HIVE_GROUP')");
        }

        $notifyCount = $this->db->get()->result_array();

        if($notifyCount)
        {
            return $notifyCount;
        }
        else
        {
            return 0;
        }
    }

    public function getCategoryWithKarmaPoint($usrId,$catData)
    {
        $this->db->select('count(comm_upvote.upv_pst_ans_id) DIV 5*comm_points_master.pma_points as Count,comm_subcategories.scat_title as cat');
        $this->db->from('comm_upvote');
        $this->db->join('comm_posts','comm_posts.pst_id=comm_upvote.upv_pst_ans_id','left');
        $this->db->join('comm_subcategories','comm_subcategories.scat_id=comm_posts.pst_grp_id','left');
        $this->db->join('comm_points_master','comm_points_master.pma_shortcode= "POST_UPVOTE"','left');
        $this->db->where("comm_upvote.upv_pst_ans_id IN(SELECT comm_posts.pst_id
                FROM comm_posts
                WHERE pst_usr_id = ".$usrId."
                AND pst_cat_id = ".$catData['hive_id'].")");
        $this->db->where('comm_upvote.upv_type','Post');
        $this->db->where('comm_posts.pst_usr_id',$usrId);
        $this->db->group_by('upv_pst_ans_id');
        $upvoteHiveCount = $this->db->get()->result_array();

        $this->db->select('count(comm_upvote.upv_pst_ans_id) DIV 5*comm_points_master.pma_points as Count, comm_subcategories.scat_title as cat');
        $this->db->from('comm_upvote');
        $this->db->join('comm_answers','comm_answers.ans_id=comm_upvote.upv_pst_ans_id','left');
        $this->db->join('comm_posts','comm_posts.pst_id=comm_answers.and_pst_id','left');
        $this->db->join('comm_subcategories','comm_subcategories.scat_id=comm_posts.pst_grp_id','left');
        $this->db->join('comm_points_master','comm_points_master.pma_shortcode= "ANSWER_UPVOTE"','left');
        $this->db->where("comm_upvote.upv_pst_ans_id IN(SELECT comm_answers.ans_id
                FROM comm_answers
                WHERE ans_usr_id = ".$usrId.")");
        $this->db->where('comm_upvote.upv_type','Answer');
        $this->db->where('comm_answers.ans_usr_id',$usrId);
        $this->db->group_by('comm_upvote.upv_pst_ans_id');
        $ansUpvoteCount = $this->db->get()->result_array();

        $this->db->select('count(comm_greatanswer.gta_ans_id)*comm_points_master.pma_points as Count,comm_subcategories.scat_title as cat');
        $this->db->from('comm_greatanswer');
        $this->db->join('comm_answers','comm_answers.ans_id=comm_greatanswer.gta_ans_id','left');
        $this->db->join('comm_posts','comm_posts.pst_id=comm_answers.and_pst_id','left');
        $this->db->join('comm_subcategories','comm_subcategories.scat_id=comm_posts.pst_grp_id','left');
        $this->db->join('comm_points_master','comm_points_master.pma_shortcode= "GREAT_ANSWER"','left');
        $this->db->where("comm_greatanswer.gta_ans_id IN(SELECT comm_answers.ans_id
                FROM comm_answers
                WHERE ans_usr_id = ".$usrId.")");
        $this->db->group_by('comm_greatanswer.gta_ans_id');
        $greatAnsCount = $this->db->get()->result_array();

        $newCatArray = array_merge($upvoteHiveCount,$ansUpvoteCount);

        $newCatArray3 = array_merge($newCatArray,$greatAnsCount);

        foreach($newCatArray3 as $subKey => $subArray)
        {
            if($subArray['Count'] == 0)
            {
                unset($newCatArray3[$subKey]);
            }
        }

        $result = array();
        foreach (array_values($newCatArray3) as $subKey => $item) 
        {
            if (!isset($result[$item['cat']])) 
            {
                $result[$item['cat']] = $item;
            }
            else 
            {
                $result[$item['cat']]['Count'] += $item['Count'];
                $result[$item['cat']]['Count'] = (string)$result[$item['cat']]['Count'];
            }
        }

        $signUp = $this->singleData('pma_points','comm_points_master',array('pma_shortcode' =>'SIGN_UP'));
        $signUpData[0]['Count'] = isset($signUp['pma_points'])?$signUp['pma_points']:"0";
        $signUpData[0]['cat'] = 'Sign Up';
        $categoryKarma = array_merge($result,$signUpData);

        return array_values($categoryKarma);
    }
}