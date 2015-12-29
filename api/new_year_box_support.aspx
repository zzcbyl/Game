<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string token = Util.GetSafeRequestValue(Request, "token", "4a6358078da68fc855d2b6949b7e95edc26992a7cef87bf929df11afd99de82c4fc064f5");
        int id = int.Parse(Util.GetSafeRequestValue(Request, "id", "1"));
        
        
        Users user = new Users(Users.CheckToken(token));
        NewYearBox newYearBox = new NewYearBox(id);
        bool ret = false;
        if (newYearBox._field["open_id"].ToString().Trim().Equals(user.OpenId.Trim()))
        {
            ret = false;
        }
        else
        {
            ret = newYearBox.Support(user.OpenId.Trim(),"hit");
        }
        if (ret)
        {
            Response.Redirect("new_year_box_get_info.aspx?id=" + id.ToString(), true);
        }
        else
            Response.Write("{\"status\":1 , \"error_message\":\"Support failed.\" }");
        
    }
</script>
