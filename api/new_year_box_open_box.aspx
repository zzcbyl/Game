<%@ Page Language="C#" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        int boxId = int.Parse(Util.GetSafeRequestValue(Request, "boxid", "6"));
        string token = Util.GetSafeRequestValue(Request, "token", "527a1ff733375f8074217c73129182ef4be8397b0c398e339c4b2b36bbcdec3fe5782569");
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