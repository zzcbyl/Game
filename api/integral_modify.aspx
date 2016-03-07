<%@ Page Language="C#" %>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        string token = ((Request["token"] == null) ? "a51ec2c5dc89b56b79efb0ec882d2776a901e901806e59ab2d9f31ac3df19ca20be1fda8" : Request["token"].Trim());
        int userId = Users.CheckToken(token);
        if (userId > 0)
        {
            int integralVal = int.Parse(Request["integralVal"] == null ? "0" : Request["integralVal"].ToString());
            string remark = (Request["Remark"] == null ? "0" : Request["Remark"].ToString());
            int result = Integral.AddIntegral(userId, integralVal, remark);
            if (result > 0)
            {
                Response.Write("{\"status\":0}");
            }
            else
            {
                Response.Write("{\"status\":1, \"message\":\"Integral error!\"}");
            }
        }
        else
            Response.Write("{\"status\":1, \"message\":\"Invalid token!\"}");
    }
</script>

