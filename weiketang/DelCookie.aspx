<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">
    public string cName = "IamName_Draw";
    protected void Button1_Click(object sender, EventArgs e)
    {
        HttpCookie cookie = Request.Cookies[cName];
        if (cookie != null && cookie.Value.Equals("1"))
        {
            cookie.Expires = DateTime.Now.AddDays(-1);
        }
        Response.Cookies.Add(cookie);
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
    </div>
    </form>
</body>
</html>
