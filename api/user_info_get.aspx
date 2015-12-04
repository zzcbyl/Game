<%@ Page Language="C#" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string token = Util.GetSafeRequestValue(Request, "token", "");

        int userId = Users.CheckToken(token);

        Users user = new Users(userId);

        if (user._fields != null)
        {
            string jsonStr = "{\"status\":0 ";
            foreach (System.Data.DataColumn c in user._fields.Table.Columns)
            {
                jsonStr = jsonStr + " , \"" + c.Caption.Trim() + "\" : \"" + user._fields[c].ToString() + "\" ";
            }
            jsonStr = jsonStr + " } ";
            Response.Write(jsonStr.Trim());
        }
        else
        {
            Response.Write("{\"status\": 1 , \"error_message\":\"User is not exists!\"}");
        }
    }
</script>