<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        int roomId = int.Parse(Util.GetSafeRequestValue(Request, "roomid", "1"));
        string token = Util.GetSafeRequestValue(Request, "token", "");
        
        int userId = Users.CheckToken(token);
        if (userId <= 0)
        {
            Response.Write("{\"status\": 1 , \"error_message\" : \"Token is unavaliable.\" }");
            return;
        }
        Users user = new Users(userId);
        UserChatRoomRights userChatRoomRight = new UserChatRoomRights(userId, roomId);
        ChatRoom chatRoom = new ChatRoom(roomId);

        if (chatRoom._fields!=null && userChatRoomRight.CanEnter)
        {
            DataTable dt = ChatTimeLine.GetChatList_Admin_Audit(roomId, "text", 2);
            ChatTimeLine[] chatTimeLineArr = new ChatTimeLine[dt.Rows.Count];
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                chatTimeLineArr[i] = new ChatTimeLine();
                chatTimeLineArr[i]._fields = dt.Rows[i];
            }
            string itemJson = "";
            foreach (ChatTimeLine chatTimeLine in chatTimeLineArr)
            {
                itemJson = itemJson + "," + chatTimeLine.Json.Trim();
            }
            if (itemJson.StartsWith(","))
                itemJson = itemJson.Remove(0,1);
            Response.Write("{\"status\":0 , \"room_id\" : " + roomId.ToString() + " , \"count\" : " + chatTimeLineArr.Length.ToString()
                + " , \"chat_time_line\" : [" + itemJson + "] }");
        }
        else
        {
            Response.Write("{\"status\": 1 , \"error_message\" : \"This user can`t enter this chat room.\" }");
        }
    }
</script>