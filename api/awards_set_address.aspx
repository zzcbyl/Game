<%@ Page Language="C#" %>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string address = Util.GetSafeRequestValue(Request, "address", "");
        string name = Util.GetSafeRequestValue(Request, "name", "");
        string cell = Util.GetSafeRequestValue(Request, "cell", "");
        string openId = Util.GetSafeRequestValue(Request, "openid", "asdfasdfasdf");
        int actId = int.Parse(Util.GetSafeRequestValue(Request, "actid", "1"));
        string[,] updateParameters = { { "name", "varchar", name.Trim() }, { "cell", "varchar", cell.Trim() }, { "address", "varchar", address.Trim() } };
        string[,] keyParameters = { { "act_id", "int", actId.ToString() }, { "open_id", "varchar", openId.Trim() } };
        int i = DBHelper.UpdateData("random_awards", updateParameters, keyParameters, Util.ConnectionString.Trim());
        if (i == 1)
            Response.Write("{\"status\":0}");
        else
            Response.Write("{\"status\":1}");
    }
</script>
