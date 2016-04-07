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

    public static ChatTimeLine[] GetRoomChatList(int roomId, int maxId)
    {
        DataTable dt = DBHelper.GetDataTable(" select * from chat_list where chat_room_id = " + roomId + " and [id] > " + maxId.ToString() + "   order by [id] ", Util.ConnectionString.Trim());
        ChatTimeLine[] chatTimeLineArr = new ChatTimeLine[dt.Rows.Count];
        for(int i = 0 ; i < dt.Rows.Count ; i++)
        {
            chatTimeLineArr[i] = new ChatTimeLine();
            chatTimeLineArr[i]._fields = dt.Rows[i];
        }
        return chatTimeLineArr;
    }

    public static ChatTimeLine[] GetRoomChatList(int roomId, int maxId, int parentId)
    {
        string sql = "select * from chat_list where chat_room_id = " + roomId ;
        if (parentId >= 0)
            sql += " and parent_id=" + parentId;

        sql += " and [id] > " + maxId.ToString() + " order by [id]";

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
        string[,] insertParameter = {{"chat_room_id", "int", roomId.ToString()},
                                    {"user_id", "int", userId.ToString()},
                                    {"nick", "varchar", nick.Trim()},
                                    {"avatar", "varchar", headImageUrl.Trim()},
                                    {"message_type", "varchar", type.Trim()},
                                    {"message_content", "varchar", content.Trim()},
                                    {"parent_id", "int", parentid.ToString()}};
        int i = DBHelper.InsertData("chat_list", insertParameter, Util.ConnectionString);
        int maxId = 0;
        if (i > 0)
        {
            DataTable dt = DBHelper.GetDataTable(" select max([id]) from chat_list ", Util.ConnectionString);
            if (dt.Rows.Count > 0)
                maxId = int.Parse(dt.Rows[0][0].ToString());
            dt.Dispose();
        }
        return maxId;
    }

    public static ChatTimeLine[] GetRoomChatListByUserid(int roomId, int maxId, int userid)
    {
        DataTable dt = DBHelper.GetDataTable(" select * from dbo.chat_list where chat_room_id=" + roomId + " and [id] in (select parent_id from dbo.chat_list where parent_id>0) and [id] > " + maxId + " order by [id] ", Util.ConnectionString.Trim());
        ChatTimeLine[] chatTimeLineArr = new ChatTimeLine[dt.Rows.Count];
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            chatTimeLineArr[i] = new ChatTimeLine();
            chatTimeLineArr[i]._fields = dt.Rows[i];
        }
        return chatTimeLineArr;
    }

}