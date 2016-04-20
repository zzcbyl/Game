<%@ Page Language="C#" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        int roomId = int.Parse(Util.GetSafeRequestValue(Request, "roomid", "1"));
        string token = Util.GetSafeRequestValue(Request, "token", "");

        DateTime maxId = DateTime.Parse(Util.GetSafeRequestValue(Request, "maxid", "2016-1-1")).AddSeconds(1);
        int messageid = int.Parse(Util.GetSafeRequestValue(Request, "messageid", "0"));
        
        
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
            ChatTimeLine message = new ChatTimeLine(messageid);
            string fatherJson = message.Json.Trim();
            
            string itemJson = "";
            ChatTimeLine[] chatTimeLineArr = ChatTimeLine.GetRoomChatList(roomId, maxId, messageid, -1, "");
            if (chatTimeLineArr.Length > 0)
                maxId = DateTime.Parse(chatTimeLineArr[chatTimeLineArr.Length - 1]._fields["update_date"].ToString());
            foreach (ChatTimeLine chatTimeLine in chatTimeLineArr)
            {
                itemJson = itemJson + "," + chatTimeLine.Json.Trim();
            }
            if (itemJson.StartsWith(","))
                itemJson = itemJson.Remove(0,1);

            Response.Write("{\"status\":0 , \"room_id\" : " + roomId.ToString() + " ,  \"max_id\" : \"" + maxId + "\", \"count\" : " + chatTimeLineArr.Length.ToString()
                + " , \"chat_time_line_father\" : " + fatherJson + " , \"chat_time_line\" : [" + itemJson + "] }");
        }
        else
        {
            Response.Write("{\"status\": 1 , \"error_message\" : \"This user can`t enter this chat room.\" }");
        }
    }

    
</script>