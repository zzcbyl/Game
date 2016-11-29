<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        DataTable dt = DBHelper.GetDataTable(" select * from wechatapp_vote_test ", Util.ConnectionString.Trim());
        Response.Write("{ \"status\" :0, \"vote_items\": " + Util.ConvertDataTableToJson(dt) + "  }");
    }
</script>