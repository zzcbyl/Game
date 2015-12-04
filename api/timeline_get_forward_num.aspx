<%@ Page Language="C#" %>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string token = Util.GetSafeRequestValue(Request, "token", "");
        int actid = int.Parse(Util.GetSafeRequestValue(Request, "actid", "1"));
        int userId = Users.CheckToken(token);
        if (userId > 0)
        {
            TimelineForward timelineForward = new TimelineForward(userId, actid);
            Response.Write("{\"status\":0 \"forward_count\": " + timelineForward.GetSubForwardNum().ToString() + " }");
        }
        else
        {
            Response.Write("{\"status\":1 \"error_message\":\"Token is invalid.\" }");
        }
        
        //TimelineForward timelineForward = new TimelineForward(
    }
</script>
