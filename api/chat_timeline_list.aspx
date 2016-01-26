<%@ Page Language="C#" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        int roomId = int.Parse(Util.GetSafeRequestValue(Request, "roomid", "1"));
        string token = Util.GetSafeRequestValue(Request, "token", "");

        int userId = Users.CheckToken(token);
        Users user = new Users(userId);

        UserChatRoomRights userChatRoomRight = new UserChatRoomRights(userId, roomId);

        if (userChatRoomRight.CanEnter)
        {
            ChatTimeLine[] chatTimeLineArr = ChatTimeLine.GetRoomChatList(roomId);
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