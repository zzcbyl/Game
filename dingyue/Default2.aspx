<%@ Page Title="签到" Language="C#" MasterPageFile="~/dingyue/Master.master" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>

<script runat="server">
    public string token = "";
    public Users user = new Users();
    public string UserHeadImg = "http://game.luqinwenda.com/images/noAvatar.jpg";
    public string NickName = "匿名";
    public string FirstDate = DateTime.Now.AddDays(1).ToString("yyyy-MM-dd");
    protected void Page_Load(object sender, EventArgs e)
    {
        token = Util.GetSafeRequestValue(Request, "token", "");
        int userId = Users.CheckToken(token);
        if (userId <= 0)
        {
            Response.Redirect("http://weixin.luqinwenda.com/authorize_final.aspx?callback=" + Server.UrlEncode(Request.Url.ToString()), true);
        }
        JavaScriptSerializer json = new JavaScriptSerializer();

        user = new Users(userId);
        try
        {
            Dictionary<string, object> dicUser = json.Deserialize<Dictionary<string, object>>(user.GetUserAvatarJson());
            if (dicUser.Keys.Contains("nickname"))
                NickName = dicUser["nickname"].ToString();
            if (dicUser.Keys.Contains("headimgurl"))
                UserHeadImg = dicUser["headimgurl"].ToString();
        }
        catch
        {

        }
    }
</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link href="common/wx_dingyue.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div style="max-width:740px; margin:0 auto; background:#efefef; min-height:500px;">
        <div style="height:50px; width:100%; background:#C22B2B; font-family:宋体; color:#fff; font-size:14px; line-height:50px; font-weight:bold; letter-spacing:0.1em">
            <div style="float:left; width:40px; height:40px; margin:6px 0 0 10px; background:url(<%=UserHeadImg %>) no-repeat; background-size:40px 40px;"><img src="images/headbg.png" width="40px" /></div>
            <div style="float:left; margin-left:10px; margin-top:2px;"><%=(NickName.Length > 5 ? NickName.Substring(0, 5) + "..." : NickName) %></div>
            <div style="float:right; margin-right:20px; font-size:16px;">积分：<span style="color:#D69100"><%=user.Integral %></span></div>
        </div>
        <div style="background:#fff; line-height:25px; padding:8px 10px; font-size:14px; color:#808080;">
            ● 积分可以兑换【卢勤微课堂】视频微课门票。<br />
            ● 转发签到文章到朋友圈可得1积分；邀请朋友转发您的签到文章到朋友圈您可以再得到1积分。每位用户每天最多可以获得10积分。<br />
            ● 显示“已转”的签到文章再次分享到朋友圈将不会再增加积分。
        </div>
        <div id="article-List">
            <%--<div style="margin:5px; border:1px solid #DBDBDB;">
                <div style="height:35px; line-height:35px; font-family:黑体; font-size:14px; color:#666; font-weight:bold; border:1px solid #fff; padding:0 10px; background:#D9D9D9;">
                    03月21日
                </div>
                <div style="background:#fff; font-size:14px; line-height:22px;">
                    <div style="border-top:1px solid #f3f3f3; height:50px; padding:5px 10px;  position:relative;" onclick="jumpUrl(43);">
                        <div style="width:50px; height:50px;">
                            <img src="http://game.luqinwenda.com/dingyue/upload/20160321102702_gray.jpg" width="50px" height="50px" />
                            <i id="point_43" class="i_icon" style="position:absolute; left:55px; top:2px; display:none;"></i>
                        </div>
                        <div style="position:absolute; left:70px; top:5px; right:5px; height:44px; line-height:22px; overflow:hidden; color:#999; ">一个小学生的伤心日记：妈妈，我爱你时，你注意到了吗...</div>
                        <div style="position:absolute; top:30px; right:15px; background:#fff; color:#b7b7b7; padding-left:10px;">已转</div>
                        <div style="clear:both;"></div>
                    </div>
                   
                    <div style="border-top:1px solid #f3f3f3; height:50px; padding:5px 10px;  position:relative;" onclick="jumpUrl(44);">
                        <div style="width:50px; height:50px;">
                            <img src="http://game.luqinwenda.com/dingyue/upload/20160318025342.jpg" width="50px" height="50px" />
                            <i id="point_44" class="i_icon" style="position:absolute; left:55px; top:2px;"></i>
                        </div>
                        <div style="position:absolute; left:70px; top:5px; right:5px; height:44px; line-height:22px; overflow:hidden;  ">【3月22日课程预告】主讲专家：卢勤</div>
                        <div style="position:absolute; top:30px; right:15px; background:#fff; color:#b7b7b7; padding-left:10px;"></div>
                        <div style="clear:both;"></div>
                    </div>
                </div>
            </div>--%>
        </div>
    </div>
    <script type="text/javascript">
        var shareTitle = "卢勤问答平台签到"; //标题
        var shareImg = "http://game.luqinwenda.com/dingyue/images/qiandao.jpg"; //图片
        var shareContent = '转发签到文章到朋友圈可获得积分'; //简介
        var shareLink = 'http://game.luqinwenda.com/dingyue/default.aspx'; //链接
        $(document).ready(function () {
            
            //window.onscroll = function () {
            //    if (getScrollTop() + getClientHeight() == getScrollHeight()) {
            //        fillArticleList();
            //    }
            //}
            fillArticleList();

            showRedPoint();

            wx.ready(function () {
                //分享到朋友圈
                wx.onMenuShareTimeline({
                    title: shareTitle, // 分享标题
                    link: shareLink, // 分享链接
                    imgUrl: shareImg, // 分享图标
                    success: function () {
                        // 用户确认分享后执行的回调函数
                        
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

        function showRedPoint() {
            var pointstr = getCookie("redPointList");
            if (pointstr != null) {
                var pointarr = pointstr.split(';');
                for (var i = 0; i < pointarr.length; i++) {
                    if ($("#point_" + pointarr[i]))
                        $("#point_" + pointarr[i]).hide();
                }
            }
        }

        var maxdate = '<%=FirstDate %>';
        var pagesize = 10;
        function fillArticleList() {
            $.ajax({
                type: "GET",
                async: false,
                url: "Handler_Article.ashx",
                data: { pagesize: pagesize, maxdate: maxdate, random: Math.random() },
                dataType: "json",
                success: function (data) {
                    if (data.status == 0) {
                        var articleHtml = "";
                        maxdate = data.maxdate;
                        for (var i = 0; i < data.article_list.length; i++) {
                            articleHtml += '<div style="margin:5px; border:1px solid #DBDBDB;">' +
                                        '<div style="height:35px; line-height:35px; font-family:黑体; font-size:14px; color:#666; font-weight:bold; border:1px solid #fff; padding:0 10px; background:#D9D9D9;">' +
                                        data.article_list[i].article_date +
                                        '</div>' +
                                        '<div style="background:#fff; font-size:14px; line-height:22px;">';

                            for (var j = 0; j < data.article_list[i].date_article_list.length; j++) {
                                var articleObj = data.article_list[i].date_article_list[j];

                                articleHtml += '<div style="border-top:1px solid #f3f3f3; height:50px; padding:5px 10px;  position:relative;" onclick="jumpUrl(' + articleObj.article_id + ');">' +
                                        '<div style="width:50px; height:50px;">' +
                                        '<img src="' + articleObj.article_headimg + '" width="50px" height="50px" />' +
                                        '<i id="point_43" class="i_icon" style="position:absolute; left:55px; top:2px; display:none;"></i>' +
                                        '</div>' +
                                        '<div style="position:absolute; left:70px; top:5px; right:5px; height:44px; line-height:22px; overflow:hidden; color:#999; ">' + (articleObj.article_title.length > 25 ? articleObj.article_title.substr(0, 25) + "..." : articleObj.article_title) + '</div>' +
                                        '<div style="position:absolute; top:30px; right:15px; background:#fff; color:#b7b7b7; padding-left:10px;">已转</div>' +
                                        '<div style="clear:both;"></div>' +
                                        '</div>';
                            }

                            articleHtml += '</div></div>';
                        }
                        $("#article-List").append(articleHtml);
                    }
                }
            });
        }

        function jumpUrl(id) {
            location.href = "activity01.aspx?articleid=" + id;
        }



        //获取滚动条当前的位置 
        function getScrollTop() {
            var scrollTop = 0;
            if (document.documentElement && document.documentElement.scrollTop) {
                scrollTop = document.documentElement.scrollTop;
            }
            else if (document.body) {
                scrollTop = document.body.scrollTop;
            }
            return scrollTop;
        }

        //获取当前可是范围的高度 
        function getClientHeight() {
            var clientHeight = 0;
            if (document.body.clientHeight && document.documentElement.clientHeight) {
                clientHeight = Math.min(document.body.clientHeight, document.documentElement.clientHeight);
            }
            else {
                clientHeight = Math.max(document.body.clientHeight, document.documentElement.clientHeight);
            }
            return clientHeight;
        }

        //获取文档完整的高度 
        function getScrollHeight() {
            return Math.max(document.body.scrollHeight, document.documentElement.scrollHeight);
        }

    </script>
</asp:Content>
