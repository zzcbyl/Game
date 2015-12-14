<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string openId = Util.GetSafeRequestValue(Request, "openId", "abcdef");
        int id = int.Parse(Util.GetSafeRequestValue(Request, "id", "15"));

        DataTable dt = DBHelper.GetDataTable(" select * from random_awards where open_id = '" + openId.Trim() + "'  and id = " + id.ToString() + "  ", Util.ConnectionString.Trim());

        if (dt.Rows.Count > 0)
        {
            string attributeJsonStr = "";
            foreach (DataColumn c in dt.Columns)
            {
                attributeJsonStr = attributeJsonStr + ", \"" + c.Caption.Trim() + "\":\"" + dt.Rows[0][c].ToString().Trim() + "\" ";
            }

            Response.Write("{\"status\":0 " + attributeJsonStr.Trim() + " } ");
        }
        else
        {
            Response.Write("{\"status\" : 1 }");
        }
    }
</script>