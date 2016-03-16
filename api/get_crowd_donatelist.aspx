<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        int crowdid = int.Parse(Util.GetSafeRequestValue(Request, "crowdid", "0"));
        string sql = "select * from m_donate where donate_crowdid = " + crowdid;
        DataTable dt = DBHelper.GetDataTable(sql, Util.ConnectionStringMall);
        
    }
</script>
