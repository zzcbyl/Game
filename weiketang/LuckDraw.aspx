<%@ Page Language="C#" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>

<!DOCTYPE html>

<script runat="server">
    public string cName = "IamName_Draw";
    public string ListStr = "";
    public int isAward = 0;
    public string AwardName = "";
    private int AwardType = 1;
    private string CouponCode = "";
    private int CouponAmount = 0;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request["openid"] == null || Request["id"] == null)
        {
            Response.Write("参数错误");
            Response.End();
        }
        string openid = Request["openid"].ToString();
        string id = Request["id"].ToString();
        
        JavaScriptSerializer json = new JavaScriptSerializer();
        string getUrl = "http://game.luqinwenda.com/api/awards_get_info.aspx?id=" + id + "&openid=" + openid;
        string result = HTTPHelper.Get_Http(getUrl);
        Dictionary<string, object> dic = json.Deserialize<Dictionary<string, object>>(result);
        if (dic["status"].Equals(0))
        {
            isAward = 1;
            AwardName = dic["award"].ToString().Trim();
            if (AwardName.IndexOf(":") > -1)
            {
                AwardType = 1;
                string[] AwardArr = AwardName.Split(':');
                CouponAmount = Convert.ToInt32(AwardArr[0].Substring(0, 1)) * 100;
                CouponCode = AwardArr[1];
                AwardName = AwardArr[0].Substring(0, 1) + "元卢勤问答平台书城代金券";
            }
            else
            {
                AwardType = 2;
                AwardName = "卢勤老师亲笔签名《" + AwardName + "》一本";
            }
        }
        else
            isAward = 0;
        
        
        getUrl = "http://game.luqinwenda.com/api/awards_get_list.aspx";
        result = HTTPHelper.Get_Http(getUrl);
        dic = json.Deserialize<Dictionary<string, object>>(result);
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
                    {
                        if (ddd.Keys.Contains("name") && ddd["name"].ToString() != "")
                        {
                            this.btn_Draw.Enabled = false;
                            isAward = 2;
                        }
                    }

                    nickName = getUserName(ddd["open_id"].ToString());
                    if (!nickName.Equals(""))
                    {
                        if (nickName.Length > 2)
                            nickName = nickName.Substring(0, 2) + "**";
                        else
                            nickName = nickName + "**";
                    }
                    else
                        nickName = "匿名网友";

                    string _award = ddd["award"].ToString().Trim();
                    if (_award.IndexOf(":") > -1)
                        _award = _award.Substring(0, 1) + "元代金券";
                    else if (_award == "“我要学演说”冬令营免费参营券")
                    { }
                    else
                        _award = "《" + _award + "》";

                    nickName += " 获得 <span style='color:red;'>" + _award + "</span>";
                }
                if (ddd.Keys.Contains("create_date_time"))
                {
                    dt = ddd["create_date_time"].ToString();
                }

                string str = "<li><div class=\"comment_name\">{0}</div><div class=\"comment_time\">{1}</div></li>";
                ListStr += string.Format(str, nickName, dt);
            }
        }

        HttpCookie cookie = Request.Cookies[cName];
        if (cookie != null && cookie.Value.Equals("1"))
        {
            if (isAward >= 1)
                this.btn_Draw.Visible = true;
            else
                this.btn_Draw.Visible = false;
        }
    }

    private string getUserName(string openid)
    {
        if (openid == "o5gjRtzY3ed3x7eIeLtGqtUSMvvs")
            return "果妈山东";
        if (openid == "o5gjRtzY3ed3x7e56tGq34tUMxyc")
            return "曼曼爸 沈阳";

        string name = "匿名网友";
        try
        {
            JavaScriptSerializer json = new JavaScriptSerializer();
            string getUrl = "http://weixin.luqinwenda.com/dingyue/getuserinfo.aspx?openid=" + openid;
            string result = HTTPHelper.Get_Http(getUrl);
            Dictionary<string, object> dic = json.Deserialize<Dictionary<string, object>>(result);
            if (dic.Keys.Contains("nickname"))
            {
                name = dic["nickname"].ToString();
            }
        }
        catch { }
        return name;
    }

    protected void btn_Draw_Click(object sender, EventArgs e)
    {
        if (Request["openid"] != null)
        {
            if (AwardType == 1)
                Response.Redirect("Coupon_draw.aspx?amount=" + CouponAmount + "&code=" + CouponCode);
            else
                Response.Redirect("SubmitAddr.aspx?id=" + Request["id"].ToString() + "&openid=" + Request["openid"].ToString());
        }
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1,minimum-scale=1,user-scalable=no">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>卢勤微课堂幸运抽奖活动</title>
    <style type="text/css">
        .comment_people { background:#fff; margin-top:5px; padding:5px 0; }
        .comment_people p { margin:0;}
        .comment_people h4 { padding:10px 0 0 10px; margin:0;}
        .comment_people ul {  border-top: 1px solid #C81623; padding:5px 0 0; font-size:10pt; color:#4f4f4f;}
        .comment_people li { padding: 3px 10px; margin:0; border-bottom: 1px dashed #C81623; overflow: hidden; line-height:25px; }
        .comment_people li .comment_name { float:left;}
        .comment_people li .comment_time { float:right;}
        .btnCss { width: 100px; height: 40px; background: #E51925; color: #fff;  font-size: 14pt; border-radius: 5px; border: 0; text-indent:0; line-height:40px;}
    </style>
    <script src="../script/jquery-1.3.2.min.js"></script>
    <script src="../script/common.js"></script>
</head>
<body style="background: #C81623;">
    <div style="max-width: 640px; margin: 0 auto; font-size:11pt; line-height: 22px;">
        <img src="../images/draw_banner.jpg" width="100%" />
        <div style="margin-top: 5px; background: #fff; padding: 10px;">
            　抽奖啦！！！“卢勤公益微课堂”在父母们的关注和热情支持下已经开讲三期，为了回馈父母们的持续热情，我们特地为今天的父母们准备了抽奖活动，欢迎广大听众踊跃参与。
        </div>
        <div style="margin-top: 5px; text-indent: 20px; line-height: 28px; background: #fff; padding: 10px; text-align:center;">
            <a id="ASupported"></a>
            <div style="text-align:center;">
                <form runat="server">
                    <a id="btnSupport" class="btnCss" style="display:inline-block; margin:0 auto;" onclick="SupportVote(this);">抽 奖</a>
                    <asp:Button ID="btn_Draw" runat="server" Text="领 奖" CssClass="btnCss" Style="margin-left:10px;" Visible="false" OnClick="btn_Draw_Click" />
                </form>
                <div style="clear:both;"></div>
            </div>
        </div>
        <div style="margin-top: 5px; background: #fff; padding: 10px;">
            　<b>活动规则：</b><br />
            　1. 活动期间内，用户微信搜索并关注“luqinwendapingtai”，输入“抽奖”；<br />
            　2. 弹出抽奖图文消息，点击进入，进行抽奖；<br />
            　3. 每个用户只可参与一次。
        </div>
        <div style="margin-top: 5px; background: #fff; padding: 10px;">
            　<b>活动奖励：</b><br />
            　1. “我要学演说”冬令营免费参营券2张；<br />
            　参加“我要说演说”让孩子敢说话，会说话，说自己的话，善于运用语言的力量；<br />
            　2. 卢勤老师亲笔签名书《和烦恼说再见》30本；<br />
            　浓缩了卢勤30多年教育思想和方法的精华，全书29个单元，每个单元围绕孩子成长过程中不可回避的一类烦恼，比如歧视、误解、嫉妒、自卑等等；<br />
            　3. 卢勤老师亲笔签名书《长大不容易》10本；<br />
            　书中以数百个生动、鲜活的家教实例，让人深刻体味到“成长有规律，长大不容易”，是家长与孩子可以共同阅读一生的教育书、亲情书；<br />
            　4. 5元代金券；<br />
            　5. 2元代金券。<br />
            　<div style="font-size:10pt">　此次活动最终解释权归卢勤问答平台所有。</div>
        </div>
        <div class="comment_people">
            <h4>中奖用户</h4>
            <ul id="commentlist">
                <%=ListStr %>
            </ul>
            <div id="pageDiv" style="text-align:center; margin-top:10px;">
				<button class="btn btn-danger" >上一页</button>　
				<button class="btn btn-danger" >下一页</button>
			</div>
        </div>
    </div>
    <script type="text/javascript">
        var cookieName = '<%=cName %>';
        var isDraw = '<%=isAward %>';
        var AwardName = '<%=AwardName %>';
        var result = "";
        $(document).ready(function () {
            if (isDraw != null) {
                if (isDraw == "0")
                    result = "很遗憾，您没有中奖。";
                else if (isDraw == "1")
                    result = "恭喜您，获得" + AwardName + "！";
                else if (isDraw == "2") {
                    result = "恭喜您，获得" + AwardName + "，您已领奖！";
                    $('#<%=btn_Draw.ClientID %>').css({ background: "#999", color: "#ccc" });
                }
            }

            if (getCookie(cookieName) != null) {
                setSupportCss()
            }
        });

        function SupportVote() {
            setSupportCss();
            setCookieT(cookieName, "1", 1000000000);
            alert(result);
            if (isDraw == "1")
                document.forms[0].submit();
        }

        function setSupportCss() {
            $("#btnSupport").css({ background: "#999", color: "#ccc" });
            $("#btnSupport").attr("onclick", "");
            $("#ASupported").html(result);
        }
    </script>
</body>
</html>
