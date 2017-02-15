<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        int classId = int.Parse(Util.GetSafeRequestValue(Request, "classid", "50"));
        DataTable dt = DBHelper.GetDataTable(" select * from chat_room where [id] = " + classId.ToString(), Util.ConnectionString);
        Response.Write("{\"status\": 0, \"lessons_array\": " + Util.ConvertDataTableToJson(dt) + " }");
    }
</script>