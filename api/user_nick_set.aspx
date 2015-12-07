<%@ Page Language="C#" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string token = Util.GetSafeRequestValue(Request, "token", "875e17d8dae4d48bd0d4dc2da5db5ee6b8736cb53be092a8a0c87a59c537588fe9d9a7de");
        string nick = Util.GetSafeRequestValue(Request, "nick", "苍杰");
        if (!nick.Trim().Equals(""))
        {
            int userId = Users.CheckToken(token);
            if (userId > 0)
            {
                Users user = new Users(userId);
                try
                {
                    user.Nick = nick.Trim();
                    Response.Write("{\"status\" : 0 }");
                }
                catch
                {
                    Response.Write("{\"status\":1 , \"error_message\": \"Duplicate nick.\"}");
                }
                
            }
            else
            {
                Response.Write("{\"status\" : 1 , \"error_message\": \"Token is invalid\" }");
            }
        }
        else
        {
            Response.Write("{\"status\" : 1 , \"error_message\": \"Nick is not allowed blank\" }");
        }
    }
</script>
