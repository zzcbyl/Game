<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        int crowdid = int.Parse(Util.GetSafeRequestValue(Request, "crowdid", "0"));
        int pagesize = int.Parse(Util.GetSafeRequestValue(Request, "pagesize", "20"));
        int pageindex = int.Parse(Util.GetSafeRequestValue(Request, "pageindex", "1"));

        int intop = pagesize * (pageindex - 1);
        string sql = "SELECT TOP " + pagesize + " * FROM m_donate WHERE donate_state=1 and donate_paystate=1 and donate_crowdid = " + crowdid + " and donate_id NOT IN (SELECT TOP " + intop + " donate_id FROM m_donate where donate_state=1 and donate_paystate=1 and donate_crowdid = " + crowdid + " ORDER BY donate_id) ORDER BY donate_id";
        DataTable dt = DBHelper.GetDataTable(sql, Util.ConnectionStringMall);
        if (dt != null && dt.Rows.Count > 0)
        {
            string donateJson = "";
            JavaScriptSerializer json = new JavaScriptSerializer();
            Users user = null;
            foreach (DataRow dr in dt.Rows)
            {
                string fieldsJson = "";
                //string fieldStr = "";
                foreach (DataColumn c in dt.Columns)
                {
                    if (c.Caption.Trim().Equals("donate_userid"))
                    {
                        user = new Users(int.Parse(dr[c].ToString().Trim()));
                        string userAvatarJson = "";
                        try
                        {
                            userAvatarJson = user.GetUserAvatarJson();
                        }
                        catch { }
                        if (userAvatarJson.Trim() == "")
                            userAvatarJson = "{}";

                        fieldsJson = fieldsJson + ",\"" + c.Caption.Trim() + "\":" + userAvatarJson;
                    }
                    else
                        fieldsJson = fieldsJson + ",\"" + c.Caption.Trim() + "\":\"" + dr[c].ToString().Trim() + "\"";
                }
                if (fieldsJson.StartsWith(","))
                    fieldsJson = fieldsJson.Remove(0, 1);
                donateJson = donateJson + ",{" + fieldsJson + " }";
            }
            if (donateJson.StartsWith(","))
                donateJson = donateJson.Remove(0, 1);
            Response.Write("{\"status\":0 , \"count\": " + dt.Rows.Count.ToString() + " ,\"pageindex\":" + pageindex + " , \"donate_list\" : [" + donateJson.Trim() + "] }");
        }
        else
            Response.Write("{\"status\":1 , \"count\":0, \"pageindex\":" + pageindex + " }");
    }
</script>
