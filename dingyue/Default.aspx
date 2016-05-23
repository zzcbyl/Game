<%@ Page Title="签到" Language="C#" MasterPageFile="~/dingyue/Master.master" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>

<script runat="server">
    public string token = "";
    public Users user = new Users();
    public string UserHeadImg = "http://game.luqinwenda.com/images/noAvatar.jpg";
    public string NickName = "匿名";
    public string FirstDate = DateTime.Now.AddDays(1).ToString("yyyy-MM-dd");
    public int userId = 0;
    protected void Page_Load(object sender, EventArgs e)
    {
        token = Util.GetSafeRequestValue(Request, "token", "");
        userId = Users.CheckToken(token);
        if (userId <= 0)
        {
            string currentUrl = Request.Url.ToString();
            if (token != "")
                currentUrl = currentUrl.Replace("&token=" + token, "").Replace("?token=" + token, "");
            Response.Redirect("http://weixin.luqinwenda.com/authorize_final.aspx?callback=" + Server.UrlEncode(currentUrl), true);
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
    <div style="max-width:740px; margin:0 auto; background:#F9F5E9; min-height:500px;">
        <div style="height:80px; width:100%; background:#e8775c; font-family:SimHei; color:#fceadd;">
            <div style="float:left; width:50%; height:80px; line-height:80px; border:none; border-right:1px solid #c85c41;">
                <div style="float:left; border-radius:4px; width:40px; height:40px; margin:20px 0 0 20px; background:url(<%=UserHeadImg %>) no-repeat; background-size:40px 40px;"></div>
                <div style="margin-left:70px; height:80px; overflow:hidden; font-size:16px;"><%=(NickName.Length > 5 ? NickName.Substring(0, 5) + "..." : NickName) %></div>
            </div>
            <div style="float:right; width:49%;">
                <div style="text-align:center; font-size:40px; line-height:40px; font-weight:bold; margin-top:12px; letter-spacing:0.05em;"><%=user.Integral %></div>
                <div style="text-align:center; color:#c85c41; font-size:14px;">积分余额</div>
            </div>
        </div>
        <div style="height:55px; line-height:50px; font-weight:bold; text-align:center; font-family:SimHei; color:#6f6b61; background:url(images/head_nav_bg.jpg) repeat-x; background-size:auto 55px;">
            如何获得积分
        </div>
        <div style="line-height:25px; padding:8px 10px; font-size:14px; color:#808080;">
            ● 积分可以兑换【卢勤微课堂】微课门票。<br />
            ● 转发签到文章到朋友圈可得1积分；邀请朋友转发您的签到文章到朋友圈您可以再得到1积分。每位用户每天最多可以获得10积分。<br />
            ● 显示“已转”的签到文章再次分享到朋友圈将不会再增加积分。
        </div>
        <%--<div style="border-top:1px solid #e8775c; text-align:center; color:#fff;">
            <span style="background:#e8775c; display:inline-block;padding:2px 10px;">签到文章</span></div>--%>
        <div style="height:25px; line-height:25px; font-weight:bold; text-align:center; font-family:SimHei; color:#6f6b61;">
            转发下列文章可获得积分
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
            $('#article-List').html('<div class="loading"><img src="/images/loading.gif" /><br />加载中...</div>');
            window.onscroll = function () {
                if (getScrollTop() + getClientHeight() == getScrollHeight()) {
                    fillArticleList();
                }
            }
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

        var uid = '<%=userId %>';
        var maxdate = '<%=FirstDate %>';
        var pagesize = 10;
        function fillArticleList() {
            $.ajax({
                type: "GET",
                async: false,
                url: "Handler_Article.ashx",
                data: { userid: uid, pagesize: pagesize, maxdate: maxdate, random: Math.random() },
                dataType: "json",
                success: function (data) {
                    if (data.status == 0) {
                        var articleHtml = "";
                        maxdate = data.maxdate;
                        for (var i = 0; i < data.article_list.length; i++) {
                            articleHtml += '<div style="margin:5px; border:1px solid #e8775c;">' +
                                        '<div style="height:35px; line-height:35px; font-family:黑体; font-size:14px; color:#fff; font-weight:bold; border:1px solid #e8775c; padding:0 10px; background:#e8775c;">' +
                                        data.article_list[i].article_date +
                                        '</div>' +
                                        '<div style="background:#fff; font-size:14px; line-height:22px;">';

                            for (var j = 0; j < data.article_list[i].date_article_list.length; j++) {
                                var articleObj = data.article_list[i].date_article_list[j];
                                var headImg = articleObj.article_headimg;
                                var forwardstr = '';
                                var titleColor = '';
                                var pointI = '';
                                if (articleObj.forward == 1) {
                                    headImg = headImg.substr(0, headImg.lastIndexOf('.')) + "_gray" + headImg.substr(headImg.lastIndexOf('.'));
                                    forwardstr = '已转';
                                    titleColor = 'color:#999;';
                                }
                                else {
                                    pointI = '<i id="point_' + articleObj.article_id + '" class="i_icon" style="position:absolute; left:55px; top:2px;"></i>';
                                }

                                articleHtml += '<div style="border-top:1px solid #f3f3f3; height:50px; padding:5px 10px;  position:relative;" onclick="jumpUrl(' + articleObj.article_id + ');">' +
                                        '<div style="width:50px; height:50px;">' +
                                        '<img src="' + headImg + '" width="50px" height="50px" />' +
                                         pointI +
                                        '</div>' +
                                        '<div style="position:absolute; left:70px; top:5px; right:5px; height:44px; line-height:22px; overflow:hidden; ' + titleColor + ' ">' + (articleObj.article_title.length > 25 ? articleObj.article_title.substr(0, 25) + "..." : articleObj.article_title) + '</div>' +
                                        '<div style="position:absolute; top:30px; right:15px; background:#fff; color:#b7b7b7; padding-left:10px;">' + forwardstr + '</div>' +
                                        '<div style="clear:both;"></div>' +
                                        '</div>';
                            }

                            articleHtml += '</div></div>';
                        }
                        $('.loading').hide();
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
