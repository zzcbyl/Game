<%@ Page Language="C#" %>
<%@ Import Namespace="System.Threading" %>
<%@ Import Namespace="System.Data" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        //ThreadStart threadStart = new ThreadStart(ComputeForwardTimesForOriginUsers);
        //Thread thread = new Thread(threadStart);
        //thread.Start();

        DataTable dt = DBHelper.GetDataTable(" select * from timeline_forward where from_uid = 0 order by forward_times desc ", Util.ConnectionStringMall);

        string retSubJson = "";

        foreach (DataRow dr in dt.Rows)
        {
            retSubJson = retSubJson + ",{\"id\" : " + dr["id"].ToString() + " , \"uid\" : " + dr["uid"].ToString().Trim()
                + " , \"forward_times\" : " + dr["forward_times"].ToString().Trim() + " }";
        }
        if (retSubJson.StartsWith(","))
            retSubJson = retSubJson.Remove(0,1);
        string retJson = "{\"status\" : 0 , \"count\": " + dt.Rows.Count.ToString() + " , \"items\":[ " + retSubJson + "] }";
        Response.Write(retJson);
        
    }

    //private void ComputeForwardTimesForOriginUsers()
    //{
    //    TimelineForward.ComputeForwardTimesForOriginUsers(1);
    //}
    
</script>