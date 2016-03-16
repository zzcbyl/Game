<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        int crowdid = int.Parse(Util.GetSafeRequestValue(Request, "crowdid", "0"));
        string sql = "select * from m_donate where donate_crowdid = " + crowdid;
        DataTable dt = DBHelper.GetDataTable(sql, Util.ConnectionStringMall);
        if (dt != null && dt.Rows.Count > 0)
        {
            string donateJson = "";
            foreach (DataRow dr in dt.Rows)
            {
                string fieldsJson = "";
                foreach (DataColumn c in dt.Columns)
                {
                    fieldsJson = fieldsJson + ",\"" + c.Caption.Trim() + "\":\"" + dr[c].ToString().Trim() + "\"";
                }
                if (fieldsJson.StartsWith(","))
                    fieldsJson = fieldsJson.Remove(0, 1);
                donateJson = donateJson + ",{" + fieldsJson + " }";
            }
            if (donateJson.StartsWith(","))
                donateJson = donateJson.Remove(0, 1);
            Response.Write("{\"status\":0 , \"count\": " + dt.Rows.Count.ToString() + " , \"donate_list\" : [" + donateJson.Trim() + "] }");
        }
        else
            Response.Write("{\"status\":1 , \"count\":0 }");
    }
</script>
