using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

/// <summary>
/// Summary description for UserChatRoomRights
/// </summary>
public class UserChatRoomRights
{
    public bool canEnter = false;

    public bool canPublishText = false;

    public bool canPublishVoice = false;

    public bool canPublishImage = false;

    public DataRow _fieldsTemplate = null;

    public DataRow _fieldsChatRoom = null;

	public UserChatRoomRights()
	{
		//
		// TODO: Add constructor logic here
		//
	}

    public UserChatRoomRights(int UserId)
    {
        DataTable dt = DBHelper.GetDataTable(" select * from user_rights_template where user_id = " + UserId.ToString(), Util.ConnectionString);
        if (dt.Rows.Count > 0)
        {
            _fieldsTemplate = dt.Rows[0];
        }

    /*
        else
        {
            int i = CreateUserRightTemplate(UserId);
            _fieldsTemplate["can_enter_chat_room"] = "1";
            UpdateUserRightTemplate();
            if (i == 1)
            {
                dt = DBHelper.GetDataTable(" select * from user_right_templage where user_id = " + UserId.ToString(), Util.ConnectionString);
                _fieldsTemplate = dt.Rows[0];
            }
        }
     * */
    }

    public UserChatRoomRights(int UserId, int RoomId)
    {
        DataTable dt = DBHelper.GetDataTable(" select * from user_rights_template where user_id = " + UserId.ToString(), Util.ConnectionString);
        if (dt.Rows.Count > 0)
        {
            _fieldsTemplate = dt.Rows[0];
        }
        if (_fieldsTemplate!=null)
            LoadRoomRights(RoomId);
    }

    public void LoadRoomRights(int RoomId)
    {
        DataTable dt = DBHelper.GetDataTable(" select * from user_chat_room_rights where user_id = " + _fieldsTemplate["user_id"].ToString()
            + " and chat_room_id = " + RoomId.ToString(), Util.ConnectionString);
        if (dt.Rows.Count > 0)
            _fieldsChatRoom = dt.Rows[0];
    }

    public int CreateUserChatRights(int RoomId)
    {
        string[,] insertParameters = { {"user_id", "int", _fieldsTemplate["user_id"].ToString() }, 
                                     {"chat_room_id", "int", RoomId.ToString() },
                                     {"can_enter_chat_room", "int", "0"}, 
                                     {"can_chat_text", "int", "0"}, 
                                     {"can_chat_voice", "int", "0" } };
        int i = DBHelper.InsertData("user_rights_template", insertParameters, Util.ConnectionString);
        return i;
    }

    public static int CreateUserChatRights(int RoomId, int UserId)
    {
        string[,] insertParameters = { {"user_id", "int", UserId.ToString() }, 
                                     {"chat_room_id", "int", RoomId.ToString() },
                                     {"can_enter_chat_room", "int", "1"}, 
                                     {"can_chat_text", "int", "1"}, 
                                     {"can_chat_voice", "int", "0" } };
        int i = DBHelper.InsertData("user_chat_room_rights", insertParameters, Util.ConnectionString);
        return i;
    }

    public int UpdateUserRightTemplate()
    {
        string[,] updateParameters = { { "can_enter_chat_room", "int", _fieldsTemplate["can_enter_chat_room"].ToString() },
                                     {"can_chat_text", "int", _fieldsTemplate["can_chat_text"].ToString()},
                                     {"can_chat_voice", "int", _fieldsTemplate["can_chat_voice"].ToString()},
                                     {"can_chat_image", "int", _fieldsTemplate["can_chat_image"].ToString()}};
        string[,] keyParameters = { { "user_id", "int", _fieldsTemplate["user_id"].ToString().Trim() } };
        int i = DBHelper.UpdateData("user_rights_template", updateParameters, keyParameters, Util.ConnectionString);
        return i;
    }

    public int UpdateUserChatRoomRights()
    {
        string[,] updateParameters = { { "can_enter_chat_room", "int", _fieldsChatRoom["can_enter_chat_room"].ToString() },
                                     {"can_chat_text", "int", _fieldsChatRoom["can_chat_text"].ToString()},
                                     {"can_chat_voice", "int", _fieldsChatRoom["can_chat_voice"].ToString()},
                                     {"can_chat_image", "int", _fieldsChatRoom["can_chat_image"].ToString()}};
        string[,] keyParameters = { { "user_id", "int", _fieldsChatRoom["user_id"].ToString().Trim() },
                                  {"chat_room_id", "int", _fieldsChatRoom["chat_room_id"].ToString().Trim()}};
        int i = DBHelper.UpdateData("user_chat_room_rights", updateParameters, keyParameters, Util.ConnectionString);
        return i;
    }


    public bool CanEnter
    {
        get
        {
            if (_fieldsTemplate != null)
            {
                if (_fieldsChatRoom != null)
                {
                    canEnter = _fieldsChatRoom["can_enter_chat_room"].ToString().Equals("0") ? false : true;
                }
            }
            return canEnter;
        }
    }

    public bool CanPublishText
    {
        get
        {
            if (_fieldsTemplate != null)
            {
                if (_fieldsChatRoom != null)
                {
                    canPublishText = _fieldsChatRoom["can_chat_text"].ToString().Equals("0") ? false : true;
                }

            }
            return canPublishText;
        }
    }

    public bool CanPublishVoice
    {
        get
        {
            if (_fieldsTemplate != null)
            {
                if (_fieldsChatRoom != null)
                {
                    canPublishVoice = _fieldsChatRoom["can_chat_voice"].ToString().Equals("0") ? false : true;
                }

            }
            return canPublishVoice;
        }
    }

    public bool CanPublishImage
    {
        get
        {
            if (_fieldsTemplate != null)
            {
                if (_fieldsChatRoom != null)
                {
                    canPublishImage = _fieldsChatRoom["can_chat_image"].ToString().Equals("0") ? false : true;
                }

            }
            return canPublishVoice;
        }
    }


    public static int CreateUserRightTemplate(int UserId)
    {
        string[,] insertParameters = { {"user_id", "int", UserId.ToString() }, 
                                     {"can_enter_chat_room", "int", "1"}, 
                                     {"can_chat_text", "int", "1"}, 
                                     {"can_chat_voice", "int", "0" } };
        int i = DBHelper.InsertData("user_rights_template", insertParameters, Util.ConnectionString);
        return i;
    }

    public static UserChatRoomRights GetUserRightTemplate(int UserId)
    {
        DataTable dt = DBHelper.GetDataTable(" select * from user_rights_template where user_id = " + UserId.ToString(), Util.ConnectionString);
        UserChatRoomRights userChatRoomRightsTemplate = new UserChatRoomRights();
        if (dt.Rows.Count > 0)
        {
            userChatRoomRightsTemplate._fieldsTemplate = dt.Rows[0];
        }
        return userChatRoomRightsTemplate;
    }

    public static UserChatRoomRights GetUserChatRights(int UserId, int ChatRoomId)
    {
        DataTable dt = DBHelper.GetDataTable(" select * from user_chat_room_rights where user_id = " + UserId.ToString()
            + "  and chat_room_id = " + ChatRoomId.ToString(), Util.ConnectionString);
        UserChatRoomRights userChatRoomRights = new UserChatRoomRights();
        if (dt.Rows.Count > 0)
        {
            userChatRoomRights._fieldsChatRoom = dt.Rows[0];
        }
        return userChatRoomRights;
    }

    public static DataTable GetRoomUserList(int ChatRoomId)
    {
        DataTable dt = DBHelper.GetDataTable(" select top 20 * from user_chat_room_rights where chat_room_id = " + ChatRoomId.ToString() + " order by create_date desc", Util.ConnectionString);
        return dt;
    }

}