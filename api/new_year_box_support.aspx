<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string token = Util.GetSafeRequestValue(Request, "token", "0786103e87f09a762b717137d2b463376fed314fea512fd920b333e2bf538f7ad8f0a514");
        int id = int.Parse(Util.GetSafeRequestValue(Request, "id", "5"));

        Users user = new Users(Users.CheckToken(token));
        NewYearBox newYearBox = new NewYearBox(id);
        bool ret = false;
        if (newYearBox._field["open_id"].ToString().Trim().Equals(user.OpenId.Trim()))
        {
            ret = false;
        }
        else
        {
            ret = newYearBox.Support(user.OpenId.Trim());
        }
        if (ret)
        {
            Response.Redirect("new_year_box_get_info.aspx?id=" + id.ToString(), true);
        }
        else
            Response.Write("{\"status\":1 , \"error_message\":\"Support failed.\" }");
        
    }
</script>
