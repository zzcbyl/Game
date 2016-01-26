<%@ Page Language="C#" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string token = Util.GetSafeRequestValue(Request, "token", "f334c058df5b85510d4ce22789d0c44ee53e59c658d1b35ccb0130abb92079a1f5c3e280");
        int roomId = int.Parse(Util.GetSafeRequestValue(Request, "roomid", "1"));
        string content = Util.GetSafeRequestValue(Request, "content", "rdfsseefsadfsdf");
        string type = Util.GetSafeRequestValue(Request, "type", "text");
        string errorMessage = "";
        int newMessageId = 0;
        if (content.Trim().Equals(""))
        {
            errorMessage = "Can`t pulish an empty timeline.";
        }
        else
        {
            int userId = Users.CheckToken(token);
            if (userId <= 0)
            {
                errorMessage = "Token is unavaliable.";
            }
            else
            {
                Users user = new Users(userId);
                if (user._fields == null)
                {
                    errorMessage = "User with user id is " + userId.ToString() + " is not found.";
                }
                else
                {
                    UserChatRoomRights userChatRoomRights = new UserChatRoomRights(user.ID, roomId);

                    switch (type)
                    { 
                        case "image":
                            if (!userChatRoomRights.CanPublishImage)
                            {
                                errorMessage = "Can't publish image message.";
                            }
                            break;
                        case "voice":
                            if (!userChatRoomRights.CanPublishVoice)
                            {
                                errorMessage = "Can`t publish voice message.";
                            }
                            break;
                        default:
                            if (!userChatRoomRights.CanPublishText)
                            {
                                errorMessage = "Can`t publish text message.";
                            }
                            break;
                    }

                    if (errorMessage.Trim().Equals(""))
                    {
                        newMessageId = ChatTimeLine.PublishMessage(roomId, userId, type, content);
                    }
                    
                }
            }
            
        }

        if (newMessageId == 0)
        {
            Response.Write("{\"status\":1, \"error_message\":\"" + errorMessage + "\"  }");
        }
        else
        {
            Response.Write("{\"status\":0 , \"new_message_id\": " + newMessageId.ToString() + "  }");
        }
        
        
        
    }
    
    
</script>