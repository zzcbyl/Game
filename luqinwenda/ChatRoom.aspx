<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        string sql = "select top 1 [id] from chat_room where end_date > '" + DateTime.Now.ToString("yyyy-MM-dd") + "' order by end_date";
        DataTable dt = DBHelper.GetDataTable(sql, Util.ConnectionString);
        if (dt == null || dt.Rows.Count <= 0)
        {
            sql = "select top 1 [id] from chat_room order by end_date desc";
            dt = DBHelper.GetDataTable(sql, Util.ConnectionString);
        }
        Response.Redirect("wktIndex_integral.aspx?roomid=" + dt.Rows[0][0].ToString());
    }
</script>

