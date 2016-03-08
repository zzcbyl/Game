<%@ Page Title="签到" Language="C#" MasterPageFile="~/dingyue/Master.master" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>
<script runat="server">
    public int IsUName = 1;
    public string token = "";
    public int userId = 0;
    public string forward_count = "0";
    public int articleid = 1;
    public int integral = 1;
    public string pv = "0";
    public string title = "";
    public string summary = "";
    public string content = "";
    public string headimg = "";
    public string dt = "";
    public string originalurl = "http://mp.weixin.qq.com/s?__biz=MzA3MTM1OTIwNg==&mid=405120644&idx=1&sn=e4f50b0afcf95720357bfc60fe3638d9#rd";
    protected void Page_Load(object sender, EventArgs e)
    {
        token = Util.GetSafeRequestValue(Request, "token", "");
        articleid = int.Parse(Util.GetSafeRequestValue(Request, "articleid", ""));

        if (token.Trim().Equals(""))
        {
            if (Session["user_token"] != null)
            {
                token = Session["user_token"].ToString().Trim();
            }
        }
        
        userId = Users.CheckToken(token);
        if (userId <= 0)
        {
            Response.Redirect("http://weixin.luqinwenda.com/authorize_final.aspx?callback=" + Server.UrlEncode(Request.Url.ToString()), true);
        }
        Session["user_token"] = token;


        if (Request.Cookies["articleid_opened"] != null)
        {
            string articleid_opened = Request.Cookies["articleid_opened"].Value;
            articleid_opened += articleid + ",";
            Response.Cookies["articleid_opened"].Value = articleid_opened;
        }
        else
        {
            HttpCookie cookie = new HttpCookie("articleid_opened");
            cookie.Value = articleid + ",";
            cookie.Expires = DateTime.Now.AddYears(100);
            Response.Cookies.Add(cookie);
        }
        
        JavaScriptSerializer json = new JavaScriptSerializer();
        //string getUrl = "http://game.luqinwenda.com/api/user_info_get.aspx?token=" + token;
        //string result = HTTPHelper.Get_Http(getUrl);
        //Dictionary<string, object> dic = json.Deserialize<Dictionary<string, object>>(result);
        //if (dic["status"].Equals("1") || dic["nick"].Equals(""))
        //{
        //    IsUName = 0;
        //}
        
        //读取转发数
        //string getNumUrl = "http://game.luqinwenda.com/api/timeline_get_forward_num.aspx?actid=1&userid=" + userId;
        //string resultNum = HTTPHelper.Get_Http(getNumUrl);
        //Dictionary<string, object> dicNum = json.Deserialize<Dictionary<string, object>>(resultNum);
        //if (dicNum["status"].Equals(0))
        //{
        //    forward_count = dicNum["forward_count"].ToString();
        //}
        
        //更新阅读量
        Article.AddPv(articleid);
        //Random ran = new Random();
        //int RandCount = ran.Next(1, 10);
        //Article.AddPv_manual(articleid, RandCount);
        
        DataTable dtable = Article.Get(articleid);
        if (dtable != null && dtable.Rows.Count > 0)
        {
            title = dtable.Rows[0]["article_title"].ToString();
            this.Title = dtable.Rows[0]["article_title"].ToString();
            summary = dtable.Rows[0]["article_summary"].ToString();
            content = dtable.Rows[0]["article_content"].ToString();
            dt = dtable.Rows[0]["article_date"].ToString();
            headimg = dtable.Rows[0]["article_headimg"].ToString();
            integral = int.Parse(dtable.Rows[0]["article_integral"].ToString());
            if (dtable.Rows[0]["article_url"].ToString().Trim() != "")
                originalurl = dtable.Rows[0]["article_url"].ToString();

            pv = (int.Parse(dtable.Rows[0]["article_pv"].ToString())).ToString();
            
            //pv = (int.Parse(dtable.Rows[0]["article_pv"].ToString()) + int.Parse(dtable.Rows[0]["article_pv_manual"].ToString())).ToString();

            //if (int.Parse(pv) > 100000)
            //    pv = "100000+";
        }
            
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link href="common/wx_dingyue.css" rel="stylesheet" />
    <link href="common/wx_dingyue1.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div id="js_article" class="rich_media">
        <div class="rich_media_inner">
            <div id="page-content">
                <div class="rich_media_area_primary" id="img-content">
                    <h2 id="activity-name" class="rich_media_title"><%=title %></h2>
                    <div class="rich_media_meta_list">
                        <em class="rich_media_meta rich_media_meta_text" id="post-date"><%=dt %></em>
                        <a id="post-user" href="<%=originalurl %>" class="rich_media_meta rich_media_meta_link rich_media_meta_nickname">卢勤问答平台</a>
                    </div>
                    <div id="js_content" class="rich_media_content ">

                        <%=content %>
                    </div>
                    <div class="rich_media_tool" id="js_toobar3" style="font-size:14px;">
                        <%--<div style="text-align:center; font-size:16pt;"><img src="images/zan_icon_0.png" style="width:57px; height:57px;" onclick="showShare();" onmouseover="zanUp(this);" onmouseout ="zanDown(this);" /></div>
                        <div style="text-align:center; font-size:10pt; color:#808080; font-family:微软雅黑;">已有<%=forward_count %>人赞过</div>--%>

                        <a class="media_tool_meta meta_primary" id="js_view_source" href="<%=originalurl %>">阅读原文</a>
                        <a class="media_tool_meta meta_primary" id="js_view_number" style="color:#ababab;" href="javascript:void(0);">阅读 <span id="sp_count"><%=pv %></span></a>
                        <a id="js_report_article3" class="media_tool_meta meta_primary" href="javascript:void(0);" onclick="showShare();">
                            <span style="margin-right:10px;" class="media_tool_meta meta_primary tips_global meta_praise" id="like3">
                                <i class="icon_praise_gray"></i><span class="praise_num" id="likeNum3"></span>
                            </span>
                        </a>
                        <a id="js_report_tousu" class="media_tool_meta tips_global meta_extra" href="javascript:void(0);">
                            投诉
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="showUName" style="display:none; z-index:10;">
        <div style="width:100%; height:100%; background:#ccc; color:#000; position:absolute; top:0px; left:0px; text-align:center; filter:alpha(opacity=90); -moz-opacity:1;-khtml-opacity: 1; opacity: 1;  z-index:9;"></div>
        <div style="width:200px; height:200px;  color:#000; position:absolute; top:40pt; z-index:20; font-size:12pt; line-height:20pt; text-align:center;">
            请输入昵称：<br /><input type="text" id="uname" value="" style="padding:5px; margin:10px 0;" /><span style="display:none; color:red; padding-bottom:10px;" id="errorMsg"></span><br /><button style="padding:3px 10px;" onclick="submitUName();">提交</button>
        </div>
    </div>
    <script>
        var shareTitle = "<%=title %>"; //标题
        var shareImg = "<%=headimg %>"; //图片
        var shareContent = '<%=summary %>'; //简介
        var shareLink = 'http://game.luqinwenda.com/dingyue/activity01.aspx?articleid=<%=articleid %>&fuid=<%=userId %>'; //链接
        var ExitName = '<%=IsUName %>';
        var Token = '<%=token %>';
        var Fatheruid = 0;
        var articleid = '<%=articleid %>';
        $(document).ready(function () {
            //if(ExitName == 0)
            //    inputName();
            increase();
            if (QueryString("fuid") != null) {
                Fatheruid = QueryString("fuid");
            }

            wx.ready(function () {
                //分享到朋友圈
                wx.onMenuShareTimeline({
                    title: shareTitle, // 分享标题
                    link: shareLink, // 分享链接
                    imgUrl: shareImg, // 分享图标
                    success: function () {
                        // 用户确认分享后执行的回调函数
                        shareSuccess();
                    }
                });

                //分享给朋友
                wx.onMenuShareAppMessage({
                    title: shareTitle, // 分享标题
                    desc: shareContent, // 分享描述
                    link: shareLink, // 分享链接
                    imgUrl: shareImg, // 分享图标
                    success: function () {
                        // 用户确认分享后执行的回调函数
                        
                    }
                });
            });
        });

        //function inputName() {
        //    if (document.documentElement.scrollTop == 0) {
        //        $('#showUName div').eq(1).css({ top: document.body.scrollTop + 50 + "px" });
        //    }
        //    else {
        //        $('#showUName div').eq(1).css({ top: document.documentElement.scrollTop + 50 + "px" });
        //    }
        //    $('#showUName div').eq(1).css({ left: bw / 2 - 100 + "px" });
        //    $('#showUName div').eq(0).css({ 'height': bh + 'px' });
        //    $('#showUName').show();
        //}

        //function submitUName()
        //{
        //    if($('#uname').val().Trim()=="")
        //    {
        //        $('#errorMsg').show();
        //        $('#errorMsg').html('<br />昵称不能为空');
        //        return;
        //    }
        //    $('#errorMsg').html('');
        //    $('#errorMsg').hide();
        //    $.ajax({
        //        type: "GET",
        //        async: false,
        //        url: "http://game.luqinwenda.com/api/user_nick_set.aspx",
        //        data: { token: Token, nick: $('#uname').val().Trim() },
        //        success: function (data) {
        //            var jsonData = JSON.parse(data);
        //            if (jsonData.status == 0) {
        //                $('#showUName').hide();
        //            }
        //            else {
        //                $('#errorMsg').show();
        //                $('#errorMsg').html('<br />昵称已存在');
        //            }
        //        }
        //    });
        //}

        

        function increase() {

            var hit_num = parseInt(document.getElementById("sp_count").innerText);
            var result_num = 100000;
            if (hit_num < 20) {
                result_num = Math.round(-2.777777777777782 * hit_num * hit_num + 283.3333333333333 * hit_num + 444.44444444444446 + Math.random() * 100);
            }
            else {
                if (hit_num < 200) {
                    result_num = Math.round(-0.09722222222222232 * hit_num * hit_num + 49.16666666666666 * hit_num + 4055.5555555555557 + Math.random() * 10);
                }
                else {
                    if (hit_num < 2000) {
                        result_num = Math.round(-0.0027777777777778026 * hit_num * hit_num + 28.333333333333332 * hit_num + 4444.444444444444 + Math.random() * 5);
                    }
                    else {
                        if (hit_num < 20000) {
                            result_num = Math.round(-0.00009722222222221903 * hit_num * hit_num + 4.916666666666629 * hit_num + 40555.55555555562);
                        }
                    }
                }

            }
            document.getElementById("sp_count").innerText = result_num.toString();
        }
        
    </script>
    <script src="common/activity_js.js"></script>
</asp:Content>

