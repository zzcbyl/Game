<%@ Page Language="C#" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>

<!DOCTYPE html>

<script runat="server">
    public string cName = "IamName_Draw";
    public string ListStr = "";
    public int isAward = 0;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request["openid"] == null)
        {
            Response.Write("参数错误");
            Response.End();
        }
        string openid = Request["openid"].ToString();
        
        JavaScriptSerializer json = new JavaScriptSerializer();
        string getUrl = "http://game.luqinwenda.com/api/awards_get_list.aspx";
        string result = HTTPHelper.Get_Http(getUrl);
        Dictionary<string, object> dic = json.Deserialize<Dictionary<string, object>>(result);
        if (dic["status"].Equals(0))
        {
            ArrayList userList = (ArrayList)dic["awarded_users"];
            string nickName = "";
            string dt = "";
            foreach (var user in userList)
            {
                nickName = "";
                dt = "";
                Dictionary<string, object> ddd = (Dictionary<string, object>)user;
                if (ddd.Keys.Contains("open_id"))
                {
                    if (openid == ddd["open_id"].ToString())
                        isAward = 1;
                    
                    nickName = getUserName(ddd["open_id"].ToString());
                    if (!nickName.Equals(""))
                    {
                        if (nickName.Length > 2)
                        {
                            nickName = nickName.Substring(0, 2) + "**";
                        }
                    }
                    else
                        nickName = "匿名网友";
                }
                if (ddd.Keys.Contains("draw_date_time"))
                {
                    dt = ddd["draw_date_time"].ToString();
                }

                string str = "<li><div class=\"comment_name\">{0}</div><div class=\"comment_time\">{1}</div></li>";
                ListStr += string.Format(str, nickName, dt);
            }
        }

        HttpCookie cookie = Request.Cookies[cName];
        if (cookie != null && cookie.Value.Equals("1"))
        {
            if (isAward == 1)
                this.btn_Draw.Visible = true;
            else
                this.btn_Draw.Visible = false;
        }
    }

    private string getUserName(string openid)
    {
        string name = "";
        JavaScriptSerializer json = new JavaScriptSerializer();
        string getUrl = "http://weixin.luqinwenda.com/dingyue/getuserinfo.aspx?openid=" + openid;
        string result = HTTPHelper.Get_Http(getUrl);
        Dictionary<string, object> dic = json.Deserialize<Dictionary<string, object>>(result);
        if (dic.Keys.Contains("nickname"))
        {
            name = dic["nickname"].ToString();
        }
        return name;
    }

    protected void btn_Draw_Click(object sender, EventArgs e)
    {
        if (Request["openid"] != null)
            Response.Redirect("SubmitAddr.aspx?openid=" + Request["openid"].ToString());
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1,minimum-scale=1,user-scalable=no">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>卢勤微课堂幸运抽奖活动</title>
    <style type="text/css">
        .comment_people { background:#fff; margin-top:5px; padding:10px 0; }
        .comment_people p { margin:0;}
        .comment_people h4 { padding:10px 0 0 10px; margin:0;}
        .comment_people ul {  border-top: 1px solid #C81623; padding:10px 0 0; font-size:11pt; color:#4f4f4f;}
        .comment_people li { padding: 3px 10px; margin:0; border-bottom: 1px dashed #C81623; overflow: hidden; line-height:30px; }
        .comment_people li .comment_name { float:left;}
        .comment_people li .comment_time { float:right;}
        .btnCss { width: 100px; height: 40px; background: #E51925; color: #fff;  font-size: 14pt; border-radius: 5px; border: 0;}
    </style>
    <script src="../script/jquery-1.3.2.min.js"></script>
    <script src="../script/common.js"></script>
</head>
<body style="background: #C81623;">
    <div style="max-width: 640px; margin: 0 auto;">
        <img src="../images/draw_banner.jpg" width="100%" />
        <div style="margin-top: 5px; text-indent: 20px; line-height: 28px; background: #fff; padding: 10px;">
            感谢大家参加“卢勤公益微课堂”，迄今为止，“微课堂”已经讲了三期，感谢父母们对“微课堂”的关注和热情支持，为了回馈广大听众，我们特地为今天的听众准备了抽奖活动，中奖用户可获得卢勤老师亲笔签名书一本，以感谢广大听众的热情参与，中奖的听众请及时填写邮寄信息，未中奖听众也不要灰心，请持续关注下期的回馈活动。
        </div>
        <div style="margin-top: 5px; text-indent: 20px; line-height: 28px; background: #fff; padding: 10px; text-align:center;">
            <a id="ASupported"></a>
            <div style="text-align:center;">
                <form runat="server">
                    <button id="btnSupport" class="btnCss" onclick="SupportVote(this);">抽 奖</button>
                    <asp:Button ID="btn_Draw" runat="server" Text="领 奖" CssClass="btnCss" Style="margin-left:10px;" Visible="false" OnClick="btn_Draw_Click" />
                </form>
            </div>
        </div>
        <div class="comment_people">
            <h4>中奖用户</h4>
            <ul id="commentlist">
                <%=ListStr %>
            </ul>
        </div>
    </div>
    <script type="text/javascript">
        var cookieName = '<%=cName %>';
        var isDraw = <%=isAward %>;
        var result = "";
        $(document).ready(function () {
            if (isDraw != null) {
                if (isDraw == "0")
                    result = "很遗憾，您没有中奖。";
                else
                    result = "恭喜您，已中奖！";
            }

            if (getCookie(cookieName) != null) {
                setSupportCss()
            }
        });
        function SupportVote() {
            setSupportCss();
            setCookieT(cookieName, "1", 1000000000);
            alert(result);
        }
        function setSupportCss() {
            $("#btnSupport").css({ background: "#999", color: "#ccc" });
            $("#btnSupport").attr("onclick", "");
            $("#ASupported").html(result);
        }
    </script>
</body>
</html>
