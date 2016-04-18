<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        int roomId = int.Parse(Util.GetSafeRequestValue(Request, "roomid", "1"));
        string token = Util.GetSafeRequestValue(Request, "token", "");
        DateTime maxDt = DateTime.Parse(Util.GetSafeRequestValue(Request, "maxdt", "2016-1-1")).AddSeconds(1);
        
        int userId = Users.CheckToken(token);
        if (userId <= 0)
        {
            Response.Write("{\"status\": 1 , \"error_message\" : \"Token is unavaliable.\" }");
            return;
        }
        Users user = new Users(userId);

        UserChatRoomRights userChatRoomRight = new UserChatRoomRights(userId, roomId);
        
        if (userChatRoomRight.CanEnter)
        {
            string JsonStr = "";
            DataTable dt_parent = ChatTimeLine.GetChatList_Q(roomId, userId, maxDt, Util.LuqinwendaExpertList);
            if (dt_parent.Rows.Count > 0)
                maxDt = DateTime.Parse(dt_parent.Rows[dt_parent.Rows.Count - 1]["update_date"].ToString());
            foreach (DataRow row in dt_parent.Rows)
            {
                string json = "";
                foreach (DataColumn c in dt_parent.Columns)
                {
                    json = json + ",\"" + c.Caption.Trim() + "\" : \"" + row[c.ColumnName].ToString().Trim() + "\" ";
                }
                if (json.StartsWith(","))
                    json = json.Remove(0, 1);
                JsonStr += ", {" + json + "}";
            }
            if (JsonStr.StartsWith(","))
                JsonStr = JsonStr.Remove(0, 1);
            Response.Write("{\"status\":0 , \"room_id\" : " + roomId.ToString() + " ,  \"maxdt\" : \"" + maxDt.ToString().Trim()
                + "\"    , \"count\" : " + dt_parent.Rows.Count + " , \"chat_time_line\" : [" + JsonStr + "] }");
        }
        else
        {
            Response.Write("{\"status\": 1 , \"error_message\" : \"This user can`t enter this chat room.\" }");
        }
    }
</script>