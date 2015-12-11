<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        DataTable dt = DBHelper.GetDataTable(" select * from random_awards where is_win = 1 and act_id = 1 ", Util.ConnectionString);
        string awardedOpenId = "";
        foreach (DataRow dr in dt.Rows)
        {
            string fieldsJson = "";
            foreach (DataColumn c in dt.Columns)
            {
                fieldsJson = fieldsJson + ",\"" + c.Caption.Trim() + "\":\"" + dr[c].ToString().Trim() + "\""; 
            }
            if (fieldsJson.StartsWith(","))
                fieldsJson = fieldsJson.Remove(0,1);
            awardedOpenId = awardedOpenId + ",{" + fieldsJson  + " }";
        }
        if (awardedOpenId.StartsWith(","))
            awardedOpenId = awardedOpenId.Remove(0, 1);
        Response.Write("{\"status\":0 , \"count\": " + dt.Rows.Count.ToString() + " , \"awarded_users\" : [" + awardedOpenId.Trim() + "] }");
        
    }
</script>
