<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        DataTable dt = DBHelper.GetDataTable(" select * from random_awards where is_win = 1 and act_id = 1 ", Util.ConnectionString);
        string awardedOpenId = "";
        foreach (DataRow dr in dt.Rows)
        {
            awardedOpenId = awardedOpenId + ",{\"open_id\":\"" + dr["open_id"].ToString() + "\" , \"draw_date_time\":\""
                + dr["create_date_time"].ToString() + "\" }";
        }
        if (awardedOpenId.StartsWith(","))
            awardedOpenId = awardedOpenId.Remove(0, 1);
        Response.Write("{\"status\":0 , \"count\": " + dt.Rows.Count.ToString() + " , \"awarded_users\" : [" + awardedOpenId.Trim() + "] }");
        
    }
</script>
