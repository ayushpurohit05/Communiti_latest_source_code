<?php
class UserModel extends CI_Model
{
    function __construct()
    {
        parent::__construct();
    }

    public function checkToken($token)
    {
        $this->db->select('usr_id,usr_fname,usr_lname,usr_isDelete');
        $this->db->from('comm_users');
        $this->db->where('usr_token',$token);
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

    //--Generate token
    private function generate_unique_number($l = 16)
    {
        return substr(md5(uniqid(mt_rand(), true)), 0, $l);
    }

    public function login($userData,$deviceData)
    {
        $token = $this->generate_unique_number();
        $userData['usr_token'] = $token;

        $select = "usr_id,usr_isDelete,usr_fname,usr_lname,usr_username,usr_email,usr_gender,CASE WHEN usr_image!='' THEN CONCAT('".USER_PROFILE_IMAGE."',usr_image)  ELSE usr_image END as profile_image,usr_image,usr_img_type,usr_dob,usr_token,usr_createddate,usr_updatedate";

        $where = array('usr_social_id' => $userData['usr_social_id']);
        $checkSocialId = $this->singleData($select,'comm_users',$where);

        if(empty($checkSocialId))
        {
            $this->db->insert('comm_users',$userData);

            $deviceData['dev_usr_id'] = $this->db->insert_id();
            $deviceData['dev_createdate'] = $userData['usr_createddate'];

            $this->db->insert('comm_devices',$deviceData);

            $where1 = array('usr_id' => $deviceData['dev_usr_id']);

            $sendResultInsert = $this->singleData($select,'comm_users',$where1);
            $sendResultInsert['usr_new'] = 'YES';


            return $sendResultInsert;
        }
        if ($checkSocialId['usr_isDelete']=='Deactive') 
        {
           return $checkSocialId['usr_isDelete'];
        } 
        else
        {
            $updateToken['usr_token'] = $userData['usr_token'];
            $updateToken['usr_fb_location'] = $userData['usr_fb_location'];
            $updateToken['usr_updatedate'] = $userData['usr_createddate'];

            $this->db->where('usr_id',$checkSocialId['usr_id']);
            $this->db->update('comm_users',$updateToken);

            $deviceData['dev_updatedate'] = $userData['usr_createddate'];

            $this->db->where('dev_usr_id',$checkSocialId['usr_id']);
            $this->db->where('dev_device_type',$deviceData['dev_device_type']);
            $this->db->update('comm_devices',$deviceData);
            $checkSocialId['usr_new'] = 'NO';
            $checkSocialId['usr_token'] = $userData['usr_token'];

            return $checkSocialId;
        }
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
        $sql = "SELECT posts.pst_id,posts.pst_title,posts.pst_description,posts.pst_completed,posts.pst_createdate,posts.pst_updatedate, subcategories.scat_title as grp_title,users.usr_username,users.usr_fname,users.usr_lname,users.usr_id,CASE WHEN upvote.upvote!='' THEN upvote.upvote  ELSE 0 END as upvote_count,CASE WHEN upvote_user.upv_pst_ans_id!='' THEN 'YES'  ELSE 'NO' END as usr_upvote,CASE WHEN users.usr_image!='' THEN CONCAT('".USER_PROFILE_IMAGE."',users.usr_image)  ELSE users.usr_image END as profile_image,CASE WHEN comm_report.rpt_id!='' THEN 'YES' ELSE 'NO' end as usr_report,replies as comment,CASE WHEN comm_groupJoin.join_id!='' THEN 'YES' ELSE 'NO' end as usr_join
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
                AND posts.pst_cat_id =".$filterData['cat_id'].")";
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
        $sql = "SELECT CASE WHEN user_tbl.usr_image!='' THEN CONCAT('".USER_PROFILE_IMAGE."',user_tbl.usr_image)  ELSE user_tbl.usr_image END as profile_image,user_tbl.usr_username,user_tbl.usr_fname,user_tbl.usr_id,answers.ans_updatedate,answers.ans_id,answers.ans_description,answers.ans_createdate,CASE WHEN greatanswer.gta_ans_id!='' THEN 'YES'  ELSE 'NO' END as kudos,CASE WHEN upvote.upvote_count!='' THEN upvote.upvote_count  ELSE '0' END as count_upvote, CASE WHEN usrupvote.upv_id!='' THEN 'YES'  ELSE 'NO' END as user_upvote,CASE WHEN comm_report.rpt_id!='' THEN 'YES' ELSE 'NO' end as usr_report,answers.ans_ntfy_id,subcategories.scat_title as kd_title,subcategories.scat_id as kd_id,greatanswer.gta_ntfy_id
                        FROM comm_answers answers
                        LEFT JOIN comm_users user_tbl ON answers.ans_usr_id = user_tbl.usr_id 
                        LEFT JOIN comm_upvote usrupvote ON answers.ans_id = usrupvote.upv_pst_ans_id AND usrupvote.upv_type = 'Answer' AND usrupvote.upv_usr_id=".$usrId."
                        LEFT JOIN comm_greatanswer greatanswer ON answers.ans_id = greatanswer.gta_ans_id
                        LEFT JOIN comm_subcategories subcategories ON subcategories.scat_id = greatanswer.gta_kd_id
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

                        AND answers.ans_id NOT IN(SELECT CASE WHEN COUNT(comm_report.rpt_pst_ans_usr_id)>=3 THEN comm_report.rpt_pst_ans_usr_id ELSE 0 end AS id FROM comm_answers LEFT JOIN comm_report ON comm_report.rpt_pst_ans_usr_id=comm_answers.ans_id AND comm_report.rpt_type = 'ANSWER' WHERE comm_answers.`and_pst_id`=".$pstId." group by comm_report.rpt_pst_ans_usr_id)

                     ORDER BY answers.ans_createdate ASC LIMIT ".$filterData['start'].",".$filterData['limit'];

        $replyData = $this->db->query($sql)->result_array();

        if($replyData)
        {
            return $replyData;
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

    public function getNotificationList($notifyData)
    {
        $this->db->select("SQL_CALC_FOUND_ROWS comm_notification.ntfy_id,comm_notification.ntfy_from,comm_notification.ntfy_to,comm_notification.ntfy_pst_id as pst_id,comm_notification.ntfy_type,comm_notification.ntfy_pst_type,comm_notification.ntfy_isRead,comm_notification.ntfy_createdate,comm_notification.ntfy_updatedate,comm_posts.pst_usr_id as pst_crtr_id,comm_notification.ntfy_message AS pst_ans_dscptn,comm_users.usr_fname as pst_crtr_name,user_tbl.usr_fname as usr_fname,comm_users.usr_username as pst_crtr_usrname,user_tbl.usr_username as usr_usrname,grt.gta_kd_id,CASE WHEN (grt.gta_comment='' OR grt.gta_comment IS NULL) THEN 'NO' ELSE 'YES' end as kd_note",false);
        $this->db->from('comm_notification');
        $this->db->join('comm_posts','comm_posts.pst_id=comm_notification.ntfy_pst_id','left');
        $this->db->join('comm_users','comm_users.usr_id=comm_posts.pst_usr_id','left');
        $this->db->join('comm_users user_tbl','user_tbl.usr_id=comm_notification.ntfy_from','left');
        $this->db->join('comm_greatanswer grt','grt.gta_ntfy_id=comm_notification.ntfy_id AND ntfy_type="COMMENT_GREAT"','left');
        $this->db->where('comm_notification.ntfy_to',$notifyData['usr_id']);
        $this->db->where('comm_notification.ntfy_from!=',$notifyData['usr_id']);
        $this->db->where('comm_notification.ntfy_pst_type','HIVE');
        $this->db->where("comm_notification.ntfy_pst_id NOT IN(select DISTINCT(CASE WHEN id >=3 THEN comm_posts.pst_id else 0 end) as users from comm_posts left join (SELECT rpt_pst_ans_usr_id,count(*) as id FROM comm_report where rpt_type = 'POST' group by rpt_pst_ans_usr_id) report on comm_posts.pst_id=report.rpt_pst_ans_usr_id)");
        $this->db->limit($notifyData['limit'],$notifyData['start']);
        $this->db->order_by('comm_notification.ntfy_createdate','desc');
        $notifyDataResponse = $this->db->get()->result_array();
        $totalCount = $this->db->query('SELECT FOUND_ROWS() count')->row_array();
        
        if($notifyDataResponse)
        {
           $readCount = $this->notificationCount($notifyData['usr_id']);
           return array('success' => true, 'data' => $notifyDataResponse,'count' => $readCount['count'],'total_count' =>$totalCount['count'], 'message' => 'Get successfully');
        }
        else
        {
            return 0;
        }
    }

    public function getUserProfileDetail($helpId,$hiveId,$usrId)
    {
        $this->db->select("usr_id,usr_fname,usr_lname,usr_username,loc_name,loc_country,CASE WHEN usr_image!='' THEN CONCAT('".USER_PROFILE_IMAGE."',comm_users.usr_image)  ELSE comm_users.usr_image END as profile_image");
        $this->db->from('comm_users');
        $this->db->join('comm_location','comm_location.loc_id=comm_users.usr_app_location','left');
        $this->db->where('usr_id',$usrId);
        $profileData = $this->db->get()->row_array();
        if($profileData)
        {
            $profileData['karmpoint'] = $this->getKarmaPointActionData($usrId,$count =1,$helpId,$hiveId);
            return $profileData;
        }
        else
        {
            return 0;
        }
    }

    public function notificationCount($usrId)
    {
    	$this->db->select('count(ntfy_id) as count');
    	$this->db->from('comm_notification');
    	$this->db->where('ntfy_isRead',0);
    	$this->db->where('ntfy_to',$usrId);
        $this->db->where('ntfy_pst_type','HIVE');
    	$this->db->where("ntfy_pst_id NOT IN(select DISTINCT(CASE WHEN id >=3 THEN comm_posts.pst_id else 0 end) as users from comm_posts left join (SELECT rpt_pst_ans_usr_id,count(*) as id FROM comm_report where rpt_type = 'POST' group by rpt_pst_ans_usr_id) report on comm_posts.pst_id=report.rpt_pst_ans_usr_id)");
    	$notifyCount = $this->db->get()->row_array();

    	if($notifyCount)
    	{
    		return $notifyCount;
    	}
    	else
    	{
    		return 0;
    	}

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

                //$apns = stream_socket_client('ssl://gateway.sandbox.push.apple.com:2195', $error, $errorString, 30, STREAM_CLIENT_CONNECT, $streamContext);
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
        $this->db->order_by('grp.scat_order','ASC');
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
    
    public function getKudosCount($usrId)
    {
        $this->db->select("count(kudos.gta_kd_id) as kd_count,CASE WHEN scat.scat_icon!='' THEN CONCAT('".SUB_CATEGORY_IMAGE."',scat.scat_icon)  ELSE scat.scat_icon END as kudos_image,scat.scat_title as kd_title,scat.scat_id as kd_id,scat.scat_description as kd_description, CASE WHEN sum(kudos.gta_isRead)>0 THEN 'NO' ELSE 'YES' end as kd_isRead");
        $this->db->from('comm_greatanswer kudos');
        $this->db->join('comm_subcategories scat','scat.scat_id = kudos.gta_kd_id','left');
        $this->db->join('comm_answers ans','ans.ans_id = kudos.gta_ans_id','left');
        $this->db->join('comm_posts post','post.pst_id = ans.and_pst_id','left');
        $this->db->where('ans.ans_usr_id',$usrId);
        $this->db->where('ans.ans_isDeleted',0);
        $this->db->where('post.pst_isDeleted',0);
        $this->db->group_by('kudos.gta_kd_id');

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

    public function getUserKudosPost($kudosId,$loginUserId,$paging)
    {
        $this->db->select("SQL_CALC_FOUND_ROWS DISTINCT pst_id,pst_title",false);
        $this->db->from('comm_greatanswer kudos');
        $this->db->join('comm_answers ans','ans.ans_id = kudos.gta_ans_id','left');
        $this->db->join('comm_posts post','post.pst_id = ans.and_pst_id','left');
        $this->db->where('kudos.gta_kd_id',$kudosId);
        $this->db->where('ans.ans_usr_id',$loginUserId);
        $this->db->where('post.pst_isDeleted',0);
        $this->db->limit($paging['limit'],$paging['start']);
        $this->db->order_by('kudos.gta_createdate','desc');
        $kudosPost = $this->db->get()->result_array();
        $totalCount = $this->db->query('SELECT FOUND_ROWS() count')->row_array();

        if($kudosPost)
        {
            return array('success' => true, 'data' => $kudosPost,'total_count' =>$totalCount['count'],'message' => 'Get successfully');
        }
        else
        {
            return 0;
        }
    }

    public function getKudosCommentList($usrId,$paging)
    {
        $this->db->select("SQL_CALC_FOUND_ROWS kudos.gta_id,kudos.gta_comment as kd_note,CASE WHEN usr.usr_image!='' THEN CONCAT('".USER_PROFILE_IMAGE."',usr.usr_image)  ELSE usr.usr_image END as profile_image,kudos.gta_usr_id as usr_id,kudos.gta_createdate as kd_createdate ,usr.usr_username as usr_usrname,ans.and_pst_id as pst_id",false);
        $this->db->from('comm_greatanswer kudos');
        $this->db->join('comm_answers ans','ans.ans_id = kudos.gta_ans_id','left');
        $this->db->join('comm_posts post','post.pst_id = ans.and_pst_id','left');
        $this->db->join('comm_users usr','usr.usr_id=kudos.gta_usr_id','left');
        $this->db->where('kudos.gta_comment!=',"");
        $this->db->where('ans.ans_usr_id',$usrId);
        $this->db->where('ans.ans_isDeleted',0);
        $this->db->where('post.pst_isDeleted',0);
        $this->db->limit($paging['limit'],$paging['start']);
        $this->db->order_by('kudos.gta_id','desc');
        $kudosNote = $this->db->get()->result_array();
        $totalCount = $this->db->query('SELECT FOUND_ROWS() count')->row_array();

        if($kudosNote)
        {
            return array('success' => true, 'total_count' =>$totalCount['count'],'data' => $kudosNote,'message' => 'Get successfully');;
        }
        else
        {
            return 0;
        }
    }

    public function readKudos($loginUserId,$kudosId)
    {
        $sql = "UPDATE comm_greatanswer JOIN comm_answers ON comm_answers.ans_id = comm_greatanswer.gta_ans_id AND comm_answers.ans_usr_id=".$loginUserId." SET comm_greatanswer.gta_isRead = 0 WHERE comm_greatanswer.gta_kd_id = ".$kudosId."";
        $query = $this->db->query($sql);

        if($query) 
        {
            return 1;
        } 
        else 
        {
           return 0;
        }
    }
}

   