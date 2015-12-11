<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        int parentId = (Request["parentid"] == null) ? 1 : int.Parse(Request["parentid"].Trim());
        SqlDataAdapter da = new SqlDataAdapter(" select * from m_area where parentid = " + parentId.ToString(), Util.ConnectionStringMall);
        DataTable dt = new DataTable();
        da.Fill(dt);
        da.Dispose();
        string jsonStr = "{ \"status\" : 0 , \"area\" : [";
        string jsonDetailStr = "";
        foreach (DataRow dr in dt.Rows)
        {
            jsonDetailStr = jsonDetailStr + ",{\"id\":\"" + dr["areaid"].ToString().Trim()
                + "\" , \"name\" : \"" + dr["name"].ToString().Trim() + "\" }";
        }
        if (!jsonDetailStr.Trim().Equals(""))
            jsonDetailStr = jsonDetailStr.Remove(0, 1);
        jsonStr = jsonStr + jsonDetailStr + "] }";
        Response.Write(jsonStr.Trim());
    }
</script>