<%@ Page Language="C#" %>
<%@ Import Namespace="NAudio.Wave" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string token = Util.GetSafeRequestValue(Request, "token", "06517cbfb31f5fe5645c4d3138f2f9e9473c932a16727cfacec5416e5947362b44193b0d");
        int roomId = int.Parse(Util.GetSafeRequestValue(Request, "roomid", "1"));
        string content = Util.GetSafeRequestValue(Request, "content", "aU5LcIhVfCt7RQZh-2Ye_v5WU97lzxSa8AcJyTFtBSOd0tIIcCsyZNnkT7oPrtSZ");
        string type = Util.GetSafeRequestValue(Request, "type", "voice");
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
                        /*
                        if (type.Equals("voice"))
                        {
                            Util.GetWebContent("http://game.luqinwenda.com/api/down_load_sound.aspx?mediaid=" + content.Trim(),
                                "get", "", "html/text");
                            string mp3Path = Server.MapPath("../amr/sounds/" + content.Trim() + ".mp3");
                            Mp3FileReader reader = new Mp3FileReader(mp3Path);
                            //double totalSeconds = reader.TotalTime.TotalSeconds;

                            double seconds = reader.TotalTime.TotalSeconds;

                            ChatTimeLine chatTimeLine = new ChatTimeLine(newMessageId);
                            chatTimeLine.SetVoiceSecond((int)seconds);
                            
                        }
                         
                        */
                        
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