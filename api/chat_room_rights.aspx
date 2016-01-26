<%@ Page Language="C#" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        int roomId = int.Parse(Util.GetSafeRequestValue(Request, "roomid", "0"));
        string token = Util.GetSafeRequestValue(Request, "token", "");
        int userId = Users.CheckToken(token);
        UserChatRoomRights userChatRoomRight;
        if (roomId==0)
            userChatRoomRight = new UserChatRoomRights(userId);
        else
            userChatRoomRight = new UserChatRoomRights(userId, roomId);
        Response.Write("{\"status\" : 0 ,   \"room_id\" : " + roomId.ToString()
            + " , \"can_enter\" : " + (userChatRoomRight.CanEnter ? "1" : "0")
            + " , \"can_publish_text\" : " + (userChatRoomRight.CanPublishText ? "1" : "0")
            + " , \"can_publish_image\" : " + (userChatRoomRight.CanPublishImage ? "1" : "0")
            + " , \"can_publish_voice\" : " + (userChatRoomRight.CanPublishVoice ? "1" : "0") + "  } ");
    }
</script>