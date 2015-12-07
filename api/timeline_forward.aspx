<%@ Page Language="C#" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string token = Util.GetSafeRequestValue(Request, "token", "31cd4d73a3bb0be15fa03b64e704b2fc02d0f6f973901078d34093f2ba7929e6746413f0");

        int fatherUserId = int.Parse(Util.GetSafeRequestValue(Request, "fatheruserid", "0"));

        int userId = Users.CheckToken(token);

        int actId = int.Parse(Util.GetSafeRequestValue(Request, "actid", "1"));
        
        TimelineForward timelineForward = new TimelineForward(fatherUserId, actId);

        int fatherId = 0;

        if (timelineForward._fields != null)
        {
            fatherId = timelineForward.ID;
        }
        
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