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

    public string type = "text";

    public string content = "";

	public ChatTimeLine()
	{
		//
		// TODO: Add constructor logic here
		//
	}



    public static int PublishMessage(int roomId, int userId, string type, string content)
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
                                    {"message_content", "varchar", content.Trim()}};
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

    

}