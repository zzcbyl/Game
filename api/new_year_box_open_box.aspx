<%@ Page Language="C#" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        int boxId = int.Parse(Util.GetSafeRequestValue(Request, "boxid", "5"));
        string token = Util.GetSafeRequestValue(Request, "token", "0aa811b8076b797c667d75afb31554a35572e925580ea9977dbcaa4a03712f9c0e1ddd99");
        int actId = int.Parse(Util.GetSafeRequestValue(Request, "actid", "1"));

        Users user = new Users(Users.CheckToken(token));
        NewYearBox newYearBox = new NewYearBox(user.OpenId.ToString().Trim(), actId);

        bool ret = newYearBox.OpenABox(boxId);

        if (ret)
            Response.Redirect("new_year_box_get_info.aspx?id=" + newYearBox.ID.ToString(), true);
        else
            Response.Write("{\"status\" 1 , \"error_message\" : \"Open box error.\" }");
        
        
    }
</script>