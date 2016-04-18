<%@ Page Language="C#" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>

<!DOCTYPE html>

<script runat="server">
    public string cName = "ActivityDraw6";
    public string ListStr = "";
    public string ListStr1 = "";
    public string ListStr2 = "";
    public int isAward = 0;
    public string AwardName = "";
    public int AwardType = 1;
    public string CouponCode = "";
    public int CouponAmount = 0;
    public string actid = "6";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request["openid"] == null || Request["id"] == null)
        {
            Response.Write("参数错误");
            Response.End();
        }
        string openid = Request["openid"].ToString();
        string id = Request["id"].ToString();

        HttpCookie cookie = Request.Cookies[cName];

        JavaScriptSerializer json = new JavaScriptSerializer();
        string getUrl = "http://game.luqinwenda.com/api/awards_get_info.aspx?actid=" + actid + "&id=" + id + "&openid=" + openid;
        string result = HTTPHelper.Get_Http(getUrl);
        Dictionary<string, object> dic = json.Deserialize<Dictionary<string, object>>(result);
        if (dic["status"].Equals(0))
        {
            isAward = 1;
            AwardName = dic["award"].ToString().Trim();
            if (AwardName.Equals(""))
            {
                isAward = 0;
            }
            else
                if (AwardName.IndexOf(":") > -1)
                {
                    AwardType = 1;
                    string[] AwardArr = AwardName.Split(':');
                    int cAmount = Convert.ToInt32(AwardArr[0].Substring(0, AwardArr[0].IndexOf("元")));
                    CouponAmount = cAmount * 100;
                    CouponCode = AwardArr[1];
                    AwardName = cAmount + "元卢勤问答平台书城代金券";
                    //AwardName = AwardArr[0].Substring(0, 1) + "元卢勤问答平台书城代金券";
                    if (cookie != null && cookie.Value == "1")
                    {
                        this.Response.Redirect("Coupon_draw.aspx?amount=" + CouponAmount + "&code=" + CouponCode);
                    }
                }
                else
                {
                    AwardType = 2;
                    if (AwardName == "发掘孩子的大脑潜能")
                        AwardName = "《发掘孩子的大脑潜能》一本";
                    else
                        AwardName = "卢勤老师所著新书《" + AwardName + "》一本";
                    if (cookie != null && cookie.Value == "1")
                    {
                        if (dic["name"].ToString().Trim().Equals(""))
                            this.Response.Redirect("SubmitAddr.aspx?id=" + id + "&openid=" + openid + "&name=" + AwardName);
                        else
                            this.Response.Redirect("SubmitSuccess.aspx?name=" + AwardName);
                    }
                }
        }
        else
            isAward = 0;


        getUrl = "http://game.luqinwenda.com/api/awards_get_list.aspx?actid=" + actid;
        result = HTTPHelper.Get_Http(getUrl);
        dic = json.Deserialize<Dictionary<string, object>>(result);
        if (dic["status"].Equals(0))
        {
            ArrayList userList = (ArrayList)dic["awarded_users"];
            string nickName = "";
            string dt = "";
            int i = 0;
            foreach (var user in userList)
            {
                i++;
                nickName = "";
                dt = "";
                Dictionary<string, object> ddd = (Dictionary<string, object>)user;
                if (ddd.Keys.Contains("open_id"))
                {
                    if (openid == ddd["open_id"].ToString())
                    {
                        if (ddd.Keys.Contains("name") && ddd["name"].ToString() != "")
                        {
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
                    {
                        string[] _awardArr = _award.Split(':');
                        _award = _awardArr[0];
                    }
                    else if (_award == "“我要学演说”冬令营免费参营券")
                    { }
                    else
                        _award = "《" + _award + "》";

                    nickName += " 获得 <span style=\"color:red;\">" + _award + "</span>";
                }
                if (ddd.Keys.Contains("create_date_time"))
                {
                    dt = ddd["create_date_time"].ToString();
                }

                string str = "<li><div class=\"comment_name\">{0}</div><div class=\"comment_time\">{1}</div></li>";
                if (i < 20)
                    ListStr += string.Format(str, nickName, dt);
                else if (i >= 20 && i < 40)
                    ListStr1 += string.Format(str, nickName, dt);
                else
                    ListStr2 += string.Format(str, nickName, dt);
            }
        }
        if (ListStr1.Equals(""))
            ListStr1 = ListStr;
        if (!ListStr1.Equals("") && ListStr2.Equals(""))
            ListStr2 = ListStr1;
        if (ListStr1.Equals("") && ListStr2.Equals(""))
            ListStr2 = ListStr;

        //ListStr = "<li><div class=\"comment_name\">春暖** 获得 <span style=\"color:red;\">微鲸55吋4K高清晰智能电视</span></div><div class=\"comment_time\">2015/12/31 15:59:51</div></li>"
        //    + "<li><div class=\"comment_name\">阿柯** 获得 <span style=\"color:red;\">iphone 6s plus</span></div><div class=\"comment_time\">2015/12/31 11:21:37</div></li>"
        //    + "<li><div class=\"comment_name\">欣妈** 获得 <span style=\"color:red;\">微鲸55吋4K高清晰智能电视</span></div><div class=\"comment_time\">2015/12/31 10:59:16</div></li>"
        //    + ListStr;
    }

    private string getUserName(string openid)
    {
        string name = "匿名网友";
        try
        {
            JavaScriptSerializer json = new JavaScriptSerializer();
            Dictionary<string, object> dicUser = json.Deserialize<Dictionary<string, object>>(Users.GetUserAvatarJson(openid));
            if (dicUser.Keys.Contains("nickname"))
                name = dicUser["nickname"].ToString();
            
            //string getUrl = "http://weixin.luqinwenda.com/dingyue/get_user_info.aspx?openid=" + openid;
            //string result = HTTPHelper.Get_Http(getUrl);
            //Dictionary<string, object> dic = json.Deserialize<Dictionary<string, object>>(result);
            //if (dic.Keys.Contains("nickname"))
            //{
            //    name = dic["nickname"].ToString();
            //}
        }
        catch { }
        return name;
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1,minimum-scale=1,user-scalable=no">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>卢勤问答平台阅读卡</title>
    <style type="text/css">
        .comment_people { background:#fff; margin-top:5px; padding:5px 0; }
        .comment_people p { margin:0;}
        .comment_people h4 { padding:10px 0 0 10px; margin:0;}
        .comment_people ul {  border-top: 1px solid #C81623; padding:5px 0 0; font-size:10pt; color:#4f4f4f;}
        .comment_people li { padding: 3px 10px; margin:0; border-bottom: 1px dashed #C81623; overflow: hidden; line-height:25px; }
        .comment_people li .comment_name { float:left;}
        .comment_people li .comment_time { float:right;}
        .btnCss { width: 100px; height: 40px; background: #E51925; color: #fff;  font-size: 14pt; border-radius: 5px; border: 0; text-indent:0; line-height:40px;}
        a { text-decoration:none; }
    </style>
    <script src="../script/jquery-1.3.2.min.js"></script>
    <script src="../script/common.js"></script>
</head>
<body style="background: #EFD193; background-image:url(/images/bg_draw.jpg); background-repeat:no-repeat; background-position:center;">
    <div style="max-width: 640px; margin: 0 auto; font-size:11pt; line-height: 22px;">
        <%--<div style="height:100px; line-height:100px; color:#fff; text-align:center; font-weight:bold; font-family:黑体; font-size:26pt; background:#ff7c79; border-radius:5px;">
            卢勤问答平台阅读卡
        </div>--%>
        <img src="../images/draw_banner.jpg" width="100%" />
        <div style="border-radius:5px; background:#fff;">
            <div style="margin-top: 5px;padding: 10px;">
            　    <div style="text-align:center; font-size:12pt;"><b>卢勤和她的朋友们微课堂</b></div>
            　    <div>　为感恩广大家长对“卢勤和她的朋友们微课堂”的支持和厚爱，特邀您参加此次抽奖活动，100%中奖！奖品有限，先到先得哦！</div>
            </div>
            <div style="text-indent: 20px; line-height: 28px; padding: 10px; text-align:center;">
                <a id="ASupported"></a>
                <div style="text-align:center; background:#fff;">
                    <a id="btnSupport" style="display:block; margin:0 auto; background:#fff; color:#C81623;" onclick="SupportVote(this);">
                        <img src="../images/btn_draw.png" /></a>
                    <div style="clear:both;"></div>
                </div>
            </div>
        </div>
        <div style="border-radius:5px; background:#fff; padding:1px 10px 10px; margin-top:10px;">
            <p><a href="http://mp.weixin.qq.com/s?__biz=MzA3MTM1OTIwNg==&mid=405844141&idx=1&sn=fb85317b54adbd207fbb7a56ffd5b4eb#rd"><img src="../images/ying_speak.jpg" style="width:100%;" /></a></p>
            <p style="color:red; text-align:left; ">现在报名“《用眼光创造财富》五一亲子特训营”优惠300元</p>
            <p style="text-align:center;"><a id="btnSupport_ying" class="btnCss" style="display:inline-block; margin:0 auto; background:#FB6C69;" href="http://mp.weixin.qq.com/s?__biz=MzA3MTM1OTIwNg==&mid=405844141&idx=1&sn=fb85317b54adbd207fbb7a56ffd5b4eb#rd">去报名</a></p>
        </div>
        <div class="comment_people" style="border-radius:5px; background:#fff;">
            <h4>中奖用户</h4>
            <ul id="commentlist">
                <%=ListStr %>
            </ul>
            <div id="pageDiv" style="text-align:center; margin-top:10px;">
				<button class="btn btn-danger" onclick="prePage();">上一页</button>　
				<button class="btn btn-danger" onclick="nextPage()" >下一页</button>
			</div>
        </div>
    </div>
    <script type="text/javascript">
        var cookieName = '<%=cName %>';
        var isDraw = '<%=isAward %>';
        var AwardName = '<%=AwardName %>';
        var result = "";
        var type = '<%=AwardType %>';
        var id = 0;
        var openid = '';
        $(document).ready(function () {
            id = QueryString('id');
            openid = QueryString('openid');
            
            if (isDraw != null) {
                if (isDraw == "0"){
                    result = "很遗憾，您没有中奖。";
                }
            }

            if (getCookie(cookieName) != null){
                setSupportCss();
            }
        });

        function SupportVote() {
            setSupportCss();
            setCookieT(cookieName, "1", 1000000000);
            if (isDraw != 0) {
                if (type == '1') {
                    location.href = 'Coupon_draw.aspx?amount=<%=CouponAmount %>&code=<%=CouponCode %>';
                }
                else {
                    location.href = 'SubmitAddr.aspx?id=' + id + '&openid=' + openid + '&name=' + AwardName;
                }
            }
        }

        function setSupportCss() {
            $("#btnSupport img").eq(0).attr("src", "../images/btn_draw_1.png");
            $("#btnSupport").attr("onclick", "");
            $("#ASupported").html(result);
        }
        var m = 0;
        function prePage() {
            if (m > 0) {
                m--;
            }
            if (m == 0) {
                $('#commentlist').html('<%=ListStr %>');
            }
            else if (m == 1) {
                $('#commentlist').html('<%=ListStr1 %>');
            }
            else if (m == 2) {
                $('#commentlist').html('<%=ListStr2 %>');
            }
        }
        function nextPage() {
            if (m < 2) {
                m++;
            }
            if (m == 0) {
                $('#commentlist').html('<%=ListStr %>');
            }
            else if (m == 1) {
                $('#commentlist').html('<%=ListStr1 %>');
            }
            else if (m == 2) {
                $('#commentlist').html('<%=ListStr2 %>');
            }
        }
    </script>
</body>
</html>
