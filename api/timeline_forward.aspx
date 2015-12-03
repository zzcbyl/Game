<%@ Page Language="C#" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string token = Util.GetSafeRequestValue(Request, "token", "");

        int fatherId = int.Parse(Util.GetSafeRequestValue(Request, "fatherid", "0"));

        int userId = Users.CheckToken(token);

        int actId = int.Parse(Util.GetSafeRequestValue(Request, "actid", "1"));

        TimelineForward timelineForward;

        if (userId > 0)
        {
            timelineForward = new TimelineForward(userId, actId);
            if (timelineForward._fields == null)
            {
                timelineForward = TimelineForward.CreateForward(userId, actId, fatherId);
            }
            
            Response.Write("{\"status\" : 0 , \"timeline_forward_id\" : " + timelineForward.ID.ToString()+"}");
        }
        else
        { 
            Response.Write("{\"status\":1, \"error_message\":\"User is not exists.\"}");
        }
        
    }
    
</script>