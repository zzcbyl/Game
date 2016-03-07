<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        string token = ((Request["token"] == null) ? "a51ec2c5dc89b56b79efb0ec882d2776a901e901806e59ab2d9f31ac3df19ca20be1fda8" : Request["token"].Trim());
        string type = ((Request["type"] == null) ? "article" : Request["type"].Trim());
        int userId = Users.CheckToken(token);
        if (userId > 0)
        {
            DataTable dt = Integral.GetList(userId, 0, type);
            string jsonRecord = "";
            foreach (DataRow dr in dt.Rows)
            {
                string jsonRecordRow = "";
                foreach (DataColumn c in dt.Columns)
                {
                    jsonRecordRow = jsonRecordRow + ", \"" + c.Caption.Trim() + "\" : \"" + dr[c].ToString().Trim() + "\" ";
                }
                if (jsonRecordRow.StartsWith(","))
                    jsonRecordRow = jsonRecordRow.Remove(0, 1);
                jsonRecord = jsonRecord + ",{" + jsonRecordRow + "}";
            }
            if (jsonRecord.StartsWith(","))
                jsonRecord = jsonRecord.Remove(0, 1);
            Response.Write("{\"status\":0, \"integrallist\":[" + jsonRecord.Trim() + "]}");
        }
        else
        {
            Response.Write("{\"status\":1, \"message\":\"Invalid token!\"}");
        }
    }
</script>
