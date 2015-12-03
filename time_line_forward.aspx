<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string token = "";

        if (Session["user_token"] != null)
        {
            token = Session["user_token"].ToString().Trim();
        }
        else
        {
            token = Util.GetSafeRequestValue(Request, "token", "");
        }
        int userId = Users.CheckToken(token);

        if (userId <= 0)
        {
            Response.Redirect("authorize.aspx", true);
        }
        
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
    </div>
    </form>
</body>
</html>
