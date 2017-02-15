<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        DateTime queryMonth = DateTime.Parse(Util.GetSafeRequestValue(Request, "querymonth", DateTime.Now.Year.ToString() 
            + "-" + DateTime.Now.Month.ToString() + "-1"));
        //int classId = int.Parse(Util.GetSafeRequestValue(Request, "classid", "0"));
        DataTable dt = DBHelper.GetDataTable(" select * from chat_room where start_date >= '" + queryMonth.ToString() 
            + "' and start_date < '" + queryMonth.AddMonths(1).ToString() + "'    order by start_date ", Util.ConnectionString );
        Response.Write("{\"status\": 0, \"lessons_array\": " + Util.ConvertDataTableToJson(dt) + "}");
    }
</script>
