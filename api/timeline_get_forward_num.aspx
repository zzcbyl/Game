﻿<%@ Page Language="C#" %>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        //string token = Util.GetSafeRequestValue(Request, "token", "");
        int actid = int.Parse(Util.GetSafeRequestValue(Request, "actid", "1"));
        int userId = int.Parse(Util.GetSafeRequestValue(Request, "userid", "16"));
        if (userId > 0)
        {
            TimelineForward timelineForward = new TimelineForward();
            if (timelineForward._fields != null)
            {
                Response.Write("{\"status\":0, \"forward_count\": " + timelineForward.GetSubForwardNum(userId, actid).ToString() + " }");
            }
            else
            {
                Response.Write("{\"status\":1 , \"forward_count\": 0 , \"error_message\":\"User forward is not exists.\" }");
            }
        }
        else
        {
            Response.Write("{\"status\":1 , \"error_message\":\"Token is invalid.\" }");
        }
        
        //TimelineForward timelineForward = new TimelineForward(
    }
</script>
