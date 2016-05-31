<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        string token = ((Request["token"] == null) ? "a51ec2c5dc89b56b79efb0ec882d2776a901e901806e59ab2d9f31ac3df19ca20be1fda8" : Request["token"].Trim());
        string type = ((Request["type"] == null) ? "article" : Request["type"].Trim());
        int articleid = int.Parse(Request["articleid"] == null ? "0" : Request["articleid"].ToString());
        int fatherid = int.Parse(Request["fatheruserid"] == null ? "0" : Request["fatheruserid"].ToString());
        int userId = Users.CheckToken(token);
        if (userId > 0)
        {
            DataTable dt = Article.Get(articleid);
            if (dt != null && dt.Rows.Count > 0)
            {
                int integralVal = int.Parse(dt.Rows[0]["article_integral"].ToString());
                if (fatherid != 0)
                    integralVal = 1;
                ModifyIntegral(userId, integralVal, "分享文章 " + articleid, type, articleid, 0);

                Users user = new Users(fatherid);
                if (user._fields != null)
                {
                    ModifyIntegral(fatherid, integralVal, "用户 " + userId + " 转发文章 " + articleid, type, articleid, userId);
                }

                Response.Write("{\"status\":0}");
                Response.End();
            }
        }
        Response.Write("{\"status\":1, \"message\":\"Invalid token!\"}");
    }

    protected void ModifyIntegral(int uid, int integral, string remark, string type, int type_id, int fromuserid)
    {
        DataTable dt_integral = Integral.GetList(uid, -1, type, 0, DateTime.Now.ToString("yyyy-MM-dd"));
        if (dt_integral.Rows.Count < 10)
        {
            DataTable dt_integral1 = Integral.GetList(uid, fromuserid, type, type_id);
            if (dt_integral1.Rows.Count <= 0)
                Integral.AddIntegral(uid, integral, remark, type, type_id, fromuserid);
        }
    }
</script>

