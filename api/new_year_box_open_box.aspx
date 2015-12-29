<%@ Page Language="C#" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        int boxId = int.Parse(Util.GetSafeRequestValue(Request, "boxid", "0"));
        string token = Util.GetSafeRequestValue(Request, "token", "ad98e490bebe2518000a5164903af833a5319c9f99a07b4564dc4f8387199a7c6e5f2df1");
        int actId = int.Parse(Util.GetSafeRequestValue(Request, "actid", "1"));

        Users user = new Users(Users.CheckToken(token));
        NewYearBox newYearBox = new NewYearBox(user.OpenId.ToString().Trim(), actId);

        bool ret = newYearBox.OpenABox(boxId);

        if (ret)
        {
            string json = Util.GetWebContent("http://game.luqinwenda.com/api/new_year_box_get_info.aspx?id=" + newYearBox.ID.ToString(), "get", "", "text/html");
            Response.Write(json);
        }
        else
            Response.Write("{\"status\" 1 , \"error_message\" : \"Open box error.\" }");
        
        
    }
</script>