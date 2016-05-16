using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

/// <summary>
/// Summary description for ChatTimeLine
/// </summary>
public class ChatTimeLine
{
    public DataRow _fields;

	public ChatTimeLine()
	{
		//
		// TODO: Add constructor logic here
		//
	}

    public ChatTimeLine(int messageId)
    {
        DataTable dt = DBHelper.GetDataTable(" select * from chat_list where [id] = " + messageId.ToString(), Util.ConnectionString.Trim());
        _fields = dt.Rows[0];
    }

    public void SetVoiceSecond(int second)
    {
        string[,] updateParameters = { { "voice_length", "int", second.ToString() },
                                     {"message_content", "varchar", "http://game.luqinwenda.com/amr/sounds/" + _fields["message_content"].ToString().Trim() + ".mp3"}};
        string[,] keyParameters = { { "id", "int", _fields["id"].ToString().Trim() } };
        DBHelper.UpdateData("chat_list", updateParameters, keyParameters, Util.ConnectionString);
    }

    public void SetImageUrl()
    {
        string[,] updateParameters = { {"message_content", "varchar", "http://game.luqinwenda.com/download/images/" + _fields["message_content"].ToString().Trim() + ".jpg"}};
        string[,] keyParameters = { { "id", "int", _fields["id"].ToString().Trim() } };
        DBHelper.UpdateData("chat_list", updateParameters, keyParameters, Util.ConnectionString);
    }

    public string Json
    {
        get
        {
            if (_fields != null)
            {
                string json = "";
                foreach (DataColumn c in _fields.Table.Columns)
                {
                    json = json + ",\"" + c.Caption.Trim() + "\" : \"" + _fields[c].ToString().Trim() + "\" ";
                }
                if (json.StartsWith(","))
                    json = json.Remove(0, 1);
                return "{" + json + "}";
            }
            else
            {
                return "";
            }
        }
    }

    public static ChatTimeLine[] GetRoomChatList(int roomId, DateTime maxId, int parentId, int state, string expertlist)
    {
        string sql = "select * from chat_list where audit_state = 1 and chat_room_id = " + roomId;
        if (parentId >= 0)
            sql += " and parent_id = " + parentId;
        if (state == 0)
            sql += " and state = 0";
        else if (state > 0)
            sql += " and state > 0";
        if (expertlist.Trim() != "")
            sql += " and user_id not in (" + expertlist + ")";

        sql += " and update_date > '" + maxId + "' order by update_date";

        DataTable dt = DBHelper.GetDataTable(sql, Util.ConnectionString.Trim());
        ChatTimeLine[] chatTimeLineArr = new ChatTimeLine[dt.Rows.Count];
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            chatTimeLineArr[i] = new ChatTimeLine();
            chatTimeLineArr[i]._fields = dt.Rows[i];
        }
        return chatTimeLineArr;
    }



    public static int PublishMessage(int roomId, int userId, string type, string content, int parentid)
    {
        Users users = new Users(userId);
        string avatarJsonStr = users.GetUserAvatarJson();
        string nick = "";
        string headImageUrl = "";
        if (!avatarJsonStr.Trim().Equals(""))
        {
            nick = Util.GetSimpleJsonValueByKey(avatarJsonStr, "nickname");
            headImageUrl = Util.GetSimpleJsonValueByKey(avatarJsonStr, "headimgurl");
        }
        if (type == "text")
        {
            DataTable keywordDt = DBHelper.GetDataTable("select top 1 * from filter_words", Util.ConnectionString);
            if (keywordDt != null && keywordDt.Rows.Count > 0)
            {
                string keyword = keywordDt.Rows[0][0].ToString();
                string[] keywordArr = keyword.Split(',');
                for (int i = 0; i < keywordArr.Length; i++)
                {
                    content = content.Replace(keywordArr[i], "***");
                }
            }
        }

        string auditState = "1";
        ChatRoom chatRoom = new ChatRoom(roomId);
        DataRow drow = chatRoom._fields;
        if (drow == null)
        {
            return 0;
        }

        //string expertlist = drow["expertlist"].ToString();
        //if (parentid != 0 || Array.IndexOf(expertlist.Split(','), userId.ToString()) >= 0)
        //{
        //    auditState = "1";
        //}

        string[,] insertParameter = {{"chat_room_id", "int", roomId.ToString()},
                                    {"user_id", "int", userId.ToString()},
                                    {"nick", "varchar", nick.Trim()},
                                    {"avatar", "varchar", headImageUrl.Trim()},
                                    {"message_type", "varchar", type.Trim()},
                                    {"message_content", "varchar", content.Trim()},
                                    {"audit_state", "int", auditState},
                                    {"parent_id", "int", parentid.ToString()}};
        int result = DBHelper.InsertData("chat_list", insertParameter, Util.ConnectionString);
        int maxId = 0;
        if (result > 0)
        {
            if (parentid > 0)
            {
                //更新为已回答
                ChatTimeLine.Update_State(parentid, 2);
                //回答数+1
                Add_SonCount(parentid);
            }

            DataTable dt = DBHelper.GetDataTable(" select max([id]) from chat_list ", Util.ConnectionString);
            if (dt.Rows.Count > 0)
                maxId = int.Parse(dt.Rows[0][0].ToString());
            dt.Dispose();
        }
        return maxId;
    }

    public static ChatTimeLine[] GetRoomChatListByUserid(int roomId, int maxId, int userid)
    {
        DataTable dt = DBHelper.GetDataTable(" select * from dbo.chat_list where audit_state = 1 and chat_room_id=" + roomId + " and [id] in (select parent_id from dbo.chat_list where parent_id>0) and [id] > " + maxId + " order by [id] ", Util.ConnectionString.Trim());
        ChatTimeLine[] chatTimeLineArr = new ChatTimeLine[dt.Rows.Count];
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            chatTimeLineArr[i] = new ChatTimeLine();
            chatTimeLineArr[i]._fields = dt.Rows[i];
        }
        return chatTimeLineArr;
    }

    public static DataTable GetChatList_Q(int roomId, int userId, DateTime maxDt, string expertlist)
    {
        string sql = "select * from dbo.chat_list where chat_room_id=" + roomId + " and parent_id=0 and son_count=0 and user_id not in (" + expertlist + ") "
            + "and (audit_state=1 or user_id=" + userId + ") and update_date>'" + maxDt + "'  order by update_date";

        DataTable dt = DBHelper.GetDataTable(sql, Util.ConnectionString.Trim());
        return dt;
    }

    public static DataTable GetChatList_QA(int roomId, DateTime maxDt, string expertlist)
    {
        string sql = "select * from dbo.chat_list where chat_room_id=" + roomId + " and audit_state=1 "
            + "and parent_id=0 "
            + "and update_date>'" + maxDt + "'  order by update_date";

        DataTable dt = DBHelper.GetDataTable(sql, Util.ConnectionString.Trim());
        return dt;
    }

    public static DataTable GetSonChatList(int roomId, int maxId, int parentId)
    {
        string sql = "select * from chat_list where audit_state = 1 and chat_room_id = " + roomId;
        if (parentId >= 0)
            sql += " and parent_id = " + parentId;

        sql += " and [id] > " + maxId.ToString() + " order by [id]";

        DataTable dt = DBHelper.GetDataTable(sql, Util.ConnectionString.Trim());
        return dt;
    }


    public static DataTable GetDtChatList(int roomId, int maxId, int parentId, int sonCount)
    {
        string sql = "select * from chat_list where audit_state = 1 and chat_room_id = " + roomId;
        if (parentId >= 0)
            sql += " and parent_id = " + parentId;
        if (sonCount == 0)
            sql += " and son_count = 0";
        else if (sonCount > 0)
            sql += " and son_count > 0";

        sql += " and [id] > " + maxId.ToString() + " order by [id]";

        DataTable dt = DBHelper.GetDataTable(sql, Util.ConnectionString.Trim());
        return dt;
    }

    public static DataTable GetChatList_Admin_Audit(int roomId, string content_type, int audit_state)
    {
        string sql = "select * from chat_list where chat_room_id = " + roomId;
        sql += " and parent_id = 0 and audit_state=" + audit_state + " and message_type='" + content_type + "'";
        sql += "  order by [id]";
        DataTable dt = DBHelper.GetDataTable(sql, Util.ConnectionString.Trim());
        return dt;
    }

    public static void Audit_State(int chatid, int audit_state)
    {
        string sql = "update chat_list set audit_state=" + audit_state + ", update_date='" + DateTime.Now.ToString() + "' where [id] = " + chatid;
        DBHelper.ExecteNonQuery(Util.ConnectionString, CommandType.Text, sql);
    }

    public static void Update_State(int chatid, int state)
    {
        string sql = "update chat_list set state=" + state + ", update_date='" + DateTime.Now.ToString() + "' where [id] = " + chatid;
        if (state == 1)
            sql += " and state=0";
        else if (state == 2)
            sql += " and state=1";
        DBHelper.ExecteNonQuery(Util.ConnectionString, CommandType.Text, sql);
    }


    public static void Add_SonCount(int chatid)
    {
        string sql = "update chat_list set son_count = son_count + 1 where [id] = " + chatid;
        DBHelper.ExecteNonQuery(Util.ConnectionString, CommandType.Text, sql);
    }
}