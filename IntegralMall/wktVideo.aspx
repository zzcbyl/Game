<%@ Page Title="" Language="C#" MasterPageFile="~/IntegralMall/Master.master" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>

<script runat="server">
    public string token = "ca013d0c12977bcafc530fd58f82782901bdb19d2fcb8f85769be0f1c6b57e5445f47401";
    private int article_video_id = 20;
    public string video_title = "";
    public string video_url = "";
    public DataTable dt_userinfo = new DataTable();
    protected void Page_Load(object sender, EventArgs e)
    {
        token = Util.GetSafeRequestValue(Request, "token", "");

        if (token.Trim().Equals(""))
        {
            if (Session["user_token"] != null)
            {
                token = Session["user_token"].ToString().Trim();
            }
        }
        
        if (Request["article_video_id"] == null || Request["article_video_id"].ToString().Equals(""))
        {
            Response.Write("参数错误");
            Response.End();
            return;
        }
        
        article_video_id = int.Parse(Request["article_video_id"].ToString());

        int userId = Users.CheckToken(token);
        if (userId <= 0)
        {
            Response.Redirect("http://weixin.luqinwenda.com/authorize_final.aspx?callback=" + Server.UrlEncode(Request.Url.ToString()), true);
        }
        Session["user_token"] = token;
        
        JavaScriptSerializer json = new JavaScriptSerializer();
        Users user = new Users(userId);
        int user_integral = 0;
        try
        {
            user_integral = int.Parse(user._fields["integral"].ToString());
            if (user_integral > 0)
            {
                DataTable dt = Article.Get(article_video_id);
                if (dt != null && dt.Rows.Count > 0)
                {
                    video_url = dt.Rows[0]["article_url"].ToString();
                    video_title = dt.Rows[0]["article_title"].ToString();
                    this.Title = video_title;
                    int video_integral = int.Parse(dt.Rows[0]["article_integral"].ToString());
                    if (user_integral >= video_integral)
                    {
                        string type = "video";
                        DataTable dt_integral = Integral.GetList(userId, 0, type, article_video_id);
                        if (dt_integral.Rows.Count <= 0)
                            Integral.AddIntegral(userId, (0 - video_integral), "卢勤视频微课堂 " + article_video_id, type, article_video_id, 0);
                    }
                    else
                    {
                        Response.Redirect("wktConfirm.aspx");
                    }
                }
                else
                {
                    Response.Redirect("wktConfirm.aspx");
                }
            }
            else
            {
                Response.Redirect("wktConfirm.aspx");
            }
        }
        catch
        {
            Response.Redirect("wktConfirm.aspx");
        }
        
        string sql = "select top 20 * from dbo.weixin_user_info where CHARINDEX('headimgurl',info_json)>0 order by newid()";
        dt_userinfo = DBHelper.GetDataTable(sql, Util.ConnectionStringWX);
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div style="max-width:640px; background:#FFFDEA; margin:0 auto; min-height:600px;">
        <div style="text-align:center; height:50px; width:100%; background:#C22B2B; font-family:宋体; color:#fff; font-size:14px; line-height:50px; font-weight:bold; letter-spacing:0.1em">
            <%=video_title %>
        </div>
        <div style="margin:0; text-align:center; height:400px;">
            <video preload="meta" src="<%=video_url %>" controls="" 
                style="margin: 0px; padding: 0px; width: 100%; height: 400px; z-index: 1; background-color: black;">
                not support<br>you browser DO NOT support HTML5 video<br></video>
        </div>
        <div style="height:22px; line-height:23px; font-size:12px; color:#fff; background:#8BC7E3; text-align:center;">
            当前在线
        </div>
        <div style="height:50px; line-height:50px; border-bottom:2px solid #B1B1AE;">
            <%
                if (dt_userinfo.Rows.Count > 0)
                {
                    string uinfo="";
                    foreach (DataRow row in dt_userinfo.Rows)
                    {
                        uinfo = row["info_json"].ToString();
                        if (uinfo.IndexOf("http:") < 0)
                            continue;
                        uinfo = uinfo.Substring(uinfo.IndexOf("http:"));
                        uinfo = uinfo.Substring(0, uinfo.IndexOf("subscribe_time"));
                        uinfo = uinfo.Replace("\\", "").Replace("\",\"", "");
                        %>
                        <a style="display:inline-block; margin-right:3px;"><img src="<%=uinfo %>" width="30px" style="border-radius:15px; " /></a>
                        <%
                    }
                }
                 %>
            
        </div>
        <div style="padding:10px px;">
            <iframe id="iframepage" height="500px;" width="100%" frameborder="0" marginheight="0" marginwidth="0" src="http://mp.weixin.qq.com/s?__biz=MzA3MTM1OTIwNg==&mid=405301163&idx=2&sn=ed872e7bb159b354769e1f33422483cc#wechat_redirect"></iframe>
        </div>
    </div>
    
</asp:Content>

