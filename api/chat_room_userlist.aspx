<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        int roomId = int.Parse(Util.GetSafeRequestValue(Request, "roomid", "0"));
        string token = Util.GetSafeRequestValue(Request, "token", "");
        int userId = Users.CheckToken(token);
        if (userId <= 0)
        {
            Response.Write("{\"status\": 1 , \"error_message\" : \"Token is unavaliable.\" }");
            return;
        }
        if (roomId == 0)
        {
            Response.Write("{\"status\": 1 , \"error_message\" : \"Roomid is error.\" }");
            return;
        }
        else
        {
            int uid = 0;
            Users user;
            DataTable dt = UserChatRoomRights.GetRoomUserList(roomId);
            string chatListJson = "";
            foreach (DataRow drow in dt.Rows)
            {
                string dJson = "";
                foreach (DataColumn dcolumn in dt.Columns)
                {
                    dJson = dJson + ",\"" + dcolumn.Caption.Trim() + "\" : \"" + drow[dcolumn.ColumnName].ToString().Trim() + "\" ";
                }
                uid = int.Parse(drow["user_id"].ToString());
                user = new Users(uid);
                if (user._fields != null && user.ID > 0)
                {
                    string userAvatarJson = "";
                    try
                    {
                        userAvatarJson = user.GetUserAvatarJson();
                    }
                    catch { }
                    if (userAvatarJson.Trim() == "")
                        userAvatarJson = "{}";
                    dJson = dJson + ",\"userinfo\" : " + userAvatarJson;
                }
                
                if (dJson.StartsWith(","))
                    dJson = dJson.Remove(0, 1);
                chatListJson += ", {" + dJson + "}";
            }
            if (chatListJson.StartsWith(","))
                chatListJson = chatListJson.Remove(0, 1);

            Response.Write("{\"status\":0 , \"room_id\" : " + roomId.ToString()
                + "    , \"count\" : " + dt.Rows.Count + ", \"chatUserList\" : [" + chatListJson + "] }");
            
        }
        
    }
</script>