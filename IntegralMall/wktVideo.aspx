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
                    this.Title = "微课堂：" + video_title;
                    int video_integral = int.Parse(dt.Rows[0]["article_integral"].ToString());
                    string type = "video";
                    DataTable dt_integral = Integral.GetList(userId, 0, type, article_video_id);
                    if (dt_integral.Rows.Count <= 0)
                    {
                        if (user_integral >= video_integral)
                        {
                            Integral.AddIntegral(userId, (0 - video_integral), "卢勤视频微课堂 " + article_video_id, type, article_video_id, 0);
                        }
                        else
                        {
                            Response.Redirect("wktConfirm.aspx");
                        }
                    }
                    else
                    {
                        
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
    <style type="text/css">
        p { padding:0;}
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div style="max-width:640px; background:#FFFDEA; margin:0 auto; min-height:600px;">
        <div style="text-align:center; height:50px; width:100%; background:#C22B2B; font-family:宋体; color:#fff; font-size:14px; line-height:50px; font-weight:bold; letter-spacing:0.1em">
            <%=video_title %>
        </div>
        <div style="margin:0; text-align:center; height:auto;">
            
             <script type="text/javascript" src="http://js.ku6cdn.com//2015/1030/swfobject.js"></script>
            <div id="player" class="ku-video">
                <p>Flash not installed</p >
            </div>
            <script type="text/javascript">
                var browser = {
                    versions: function () {
                        var u = navigator.userAgent, app = navigator.appVersion;
                        return {//移动终端浏览器版本信息 
                            trident: u.indexOf('Trident') > -1, //IE内核
                            presto: u.indexOf('Presto') > -1, //opera内核
                            webKit: u.indexOf('AppleWebKit') > -1, //苹果、谷歌内核
                            gecko: u.indexOf('Gecko') > -1 && u.indexOf('KHTML') == -1, //火狐内核
                            mobile: !!u.match(/AppleWebKit.*Mobile.*/) || !!u.match(/AppleWebKit/), //是否为移动终端
                            ios: !!u.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/), //ios终端
                            android: u.indexOf('Android') > -1 || u.indexOf('Linux') > -1, //android终端或者uc浏览器
                            iPhone: u.indexOf('iPhone') > -1 || u.indexOf('Mac') > -1, //是否为iPhone或者QQHD浏览器
                            iPad: u.indexOf('iPad') > -1, //是否iPad
                            webApp: u.indexOf('Safari') == -1 //是否web应该程序，没有头部与底部
                        };
                    }(),
                    language: (navigator.browserLanguage || navigator.language).toLowerCase()
                }
                if (browser.versions.ios || browser.versions.iPhone || browser.versions.iPad || browser.versions.android) {
                    document.getElementById("player").innerHTML = '<video preload="meta" src="http://live.show.ku6.com/liveapp/beijing/playlist.m3u8" controls=""  style="margin: 0px; padding: 0px; width: 100%; height: 100%; z-index: 1; background-color: black;">浏览器不支持HTML5视频<br>you browser DO NOT support HTML5 video<br></video>';
                } else {
                    var flashVars = {
                        flvURL: 'http://live.show.ku6.com/liveapp/beijing.flv ',
                        videoW: '680',
                        videoH: '390'
                    };
                    var params = {};
                    params.allowfullscreen = "true";
                    params.allowScriptAccess = "always";
                    params.wmode = "transparent";
                    var attributes = {};
                    swfobject.embedSWF("<%=video_url %>", "player", "680", "390", "9.0.0", null, flashVars, params, attributes);
                }

            </script>
            
            
           
        </div>
        <div style="height:22px; line-height:23px; font-size:12px; color:#fff; background:#8BC7E3; text-align:center;">
            当前在线
        </div>
        <div style="height:50px; line-height:50px; border-bottom:2px solid #B1B1AE; width:100%; overflow:hidden;">
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
        <div style="padding:10px; margin-top:10px; background:#fff; ">
            <%--<iframe id="iframepage" height="500px;" width="100%" frameborder="0" marginheight="0" marginwidth="0" src="http://mp.weixin.qq.com/s?__biz=MzA3MTM1OTIwNg==&mid=405301163&idx=2&sn=ed872e7bb159b354769e1f33422483cc#wechat_redirect"></iframe>--%>

            <h3>【3月14日课程预告】主讲专家：卢勤</h3>
            <p></p>
            <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; font-family: &#39;Helvetica Neue&#39;, Helvetica, &#39;Hiragino Sans GB&#39;, &#39;Microsoft YaHei&#39;, Arial, sans-serif; line-height: 25.6px; max-width: 100%; min-height: 1em;  color: rgb(62, 62, 62); box-sizing: border-box !important; word-wrap: break-word !important; background-color: rgb(255, 255, 255);">
    <img data-id="74" data-ratio="0.12410071942446044" data-w="" width="auto" src="https://mmbiz.qlogo.cn/mmbiz/cZV2hRpuAPjOjIEA1OjSicXHcia9Mj9RQjbhIdPqSm4xrYpL2X7TMSLTZ0KLC4IshAiazU2eZpicjkIPzrSLLblVfg/0?" style="margin: 0px; padding: 0px; max-width: 100%; height: auto !important; text-align: center; font-family: 微软雅黑; line-height: 1.6; box-sizing: border-box !important; word-wrap: break-word !important; width: auto !important; visibility: visible !important;"/><span style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;"></span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; font-family: &#39;Helvetica Neue&#39;, Helvetica, &#39;Hiragino Sans GB&#39;, &#39;Microsoft YaHei&#39;, Arial, sans-serif; line-height: 25.6px; white-space: normal; max-width: 100%; min-height: 1em; color: rgb(62, 62, 62); text-align: center; box-sizing: border-box !important; word-wrap: break-word !important; background-color: rgb(255, 255, 255);">
    <span style="margin: 0px; padding: 0px; max-width: 100%;  line-height: 36px; color: rgb(0, 122, 170); font-family: SimHei; font-size: 12px; font-weight: bold; box-sizing: border-box !important; word-wrap: break-word !important;">每天精选家庭教育资讯和文章，供您浏览。</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; font-family: &#39;Helvetica Neue&#39;, Helvetica, &#39;Hiragino Sans GB&#39;, &#39;Microsoft YaHei&#39;, Arial, sans-serif; line-height: 25.6px; white-space: normal; text-align: center;">
    <img data-s="300,640" data-type="jpeg" src="https://mmbiz.qlogo.cn/mmbiz/2x9sALwpIbXCTlJ500lEvbjbkWibyzWWpkCcFrwURaAgqicibBbwHOtqRoiaQytiatx58utwGVDLfr6rh1mHA5MTovg/0?wx_fmt=jpeg" data-ratio="0.6241007194244604" data-w="" style="margin: 0px; padding: 0px; max-width: 100%; height: auto !important;"/><br style="margin: 0px; padding: 0px;"/>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; font-family: &#39;Helvetica Neue&#39;, Helvetica, &#39;Hiragino Sans GB&#39;, &#39;Microsoft YaHei&#39;, Arial, sans-serif; white-space: normal; text-indent: 2em; line-height: 1.75em;">
    <span style="margin: 0px; padding: 0px;"><br style="margin: 0px; padding: 0px;"/></span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; font-family: &#39;Helvetica Neue&#39;, Helvetica, &#39;Hiragino Sans GB&#39;, &#39;Microsoft YaHei&#39;, Arial, sans-serif; white-space: normal; text-indent: 2em; line-height: 1.75em;">
    <span style="margin: 0px; padding: 0px;">&nbsp;每一个成长中的孩子都渴望得到肯定。</span><span style="margin: 0px; padding: 0px;">责骂，在父母看来是平常的小事，但是对于孩子来说，父母责骂不休，便是自己的“世界末日”。孩子的成长需要肯定，肯定是孩子生命中的阳光。</span><br style="margin: 0px; padding: 0px;"/>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; font-family: &#39;Helvetica Neue&#39;, Helvetica, &#39;Hiragino Sans GB&#39;, &#39;Microsoft YaHei&#39;, Arial, sans-serif; line-height: 25.6px; white-space: normal;">
    <br style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;"/>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; font-family: &#39;Helvetica Neue&#39;, Helvetica, &#39;Hiragino Sans GB&#39;, &#39;Microsoft YaHei&#39;, Arial, sans-serif; line-height: 25.6px; white-space: normal;">
    <span style="margin: 0px; padding: 0px; max-width: 100%; font-size: 15px; box-sizing: border-box !important; word-wrap: break-word !important;">有的父母担心，一味地肯定孩子，会使孩子禁不起批评和挫折，会令孩子很在意别人怎么看自己，影响孩子的发展。这种想法的产生，是因为没有把鼓励和表扬区别开。怎样更好地肯定和鼓励孩子，是每个家长都在探索的课题。</span><strong style="margin: 0px; padding: 0px; font-family: 微软雅黑; font-size: 15px; line-height: 1.75em; text-indent: 2em;">3月14日，著名家庭教育专家卢勤老师将带来《心灵的成长需要肯定》，告诉家长，如何去肯定孩子，给予孩子最好的成长。</strong>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; font-family: &#39;Helvetica Neue&#39;, Helvetica, &#39;Hiragino Sans GB&#39;, &#39;Microsoft YaHei&#39;, Arial, sans-serif; line-height: 25.6px; white-space: normal;">
    <br style="margin: 0px; padding: 0px;"/>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; line-height: 25.6px; white-space: normal; max-width: 100%; min-height: 1em; font-family: 微软雅黑; text-align: center; box-sizing: border-box !important; word-wrap: break-word !important;">
    <span style="margin: 0px; padding: 0px; max-width: 100%; font-size: 20px; color: rgb(0, 176, 240); box-sizing: border-box !important; word-wrap: break-word !important;"><strong style="margin: 0px; padding: 0px; max-width: 100%; color: rgb(234, 96, 124);  box-sizing: border-box !important; word-wrap: break-word !important;">主讲专家</strong></span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; line-height: 25.6px; white-space: normal; max-width: 100%; min-height: 1em; font-family: 微软雅黑; text-align: center; box-sizing: border-box !important; word-wrap: break-word !important;">
    <span style="margin: 0px; padding: 0px; max-width: 100%; color: rgb(0, 176, 240); font-size: 18px; box-sizing: border-box !important; word-wrap: break-word !important;"><strong style="margin: 0px; padding: 0px; max-width: 100%; color: rgb(234, 96, 124);  box-sizing: border-box !important; word-wrap: break-word !important;"><span style="margin: 0px; padding: 0px; max-width: 100%; color: rgb(0, 176, 240); font-family: sans-serif; line-height: normal; box-sizing: border-box !important; word-wrap: break-word !important;">▼</span></strong></span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; font-family: &#39;Helvetica Neue&#39;, Helvetica, &#39;Hiragino Sans GB&#39;, &#39;Microsoft YaHei&#39;, Arial, sans-serif; line-height: 25.6px; white-space: normal;">
    <br style="margin: 0px; padding: 0px;"/>
</p>
<p>
    <section class="135editor" data-id="7313" style="margin: 0px; padding: 0px; line-height: 25.6px; white-space: normal; max-width: 100%; box-sizing: border-box; font-family: 微软雅黑; color: rgb(62, 62, 62); border: 0px none; word-wrap: break-word !important;">
        <section style="margin: 0px 0px 2px 4px; padding: 0px; max-width: 100%; box-sizing: border-box; border: 1px solid rgb(219, 219, 219); word-wrap: break-word !important;">
            <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; text-align: center;">
                <img data-s="300,640" data-type="jpeg" src="https://mmbiz.qlogo.cn/mmbiz/2x9sALwpIbVRywyXJQgJ96pdzb6GictlkSx1KNe8I2Urdak0YZT1T7KagmMYBe7VML0EEpnNa8H76FlurWZJBMQ/0?wx_fmt=jpeg" data-ratio="0.6236363636363637" data-w="550" style="margin: 0px; padding: 0px; max-width: 100%; height: auto !important;"/>
            </p>
            <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; max-width: 100%; min-height: 1em;  box-sizing: border-box !important; word-wrap: break-word !important;">
                <strong style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;"><span style="margin: 0px; padding: 0px; max-width: 100%; line-height: 29px; box-sizing: border-box !important; word-wrap: break-word !important;">卢勤老师</span></strong><br style="margin: 0px; padding: 0px;"/>
            </p>
            <section class="135brush" style="margin: 0px; padding: 3px 10px 15px; max-width: 100%; box-sizing: border-box; word-wrap: break-word !important;">
                <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; max-width: 100%; min-height: 1em;  text-indent: 32px; line-height: 1.75em; box-sizing: border-box !important; word-wrap: break-word !important;">
                    <span style="margin: 0px; padding: 0px; max-width: 100%; font-size: 15px; box-sizing: border-box !important; word-wrap: break-word !important;"><span style="margin: 0px; padding: 0px; max-width: 100%; line-height: 30px; box-sizing: border-box !important; word-wrap: break-word !important;">卢勤老师是中国少年儿童新闻出版总社首席教育专家,深受广大家长和小朋友喜爱的“知心姐姐”，中国家庭教育学会常务理事，中国关心下一代工作委员会专家委员会委员，</span><span style="margin: 0px; padding: 0px; max-width: 100%; line-height: 30px; color: rgb(51, 51, 51); box-sizing: border-box !important; word-wrap: break-word !important;">全国“更新家庭教育观念报告团”成员</span><span style="margin: 0px; padding: 0px; max-width: 100%; line-height: 30px; box-sizing: border-box !important; word-wrap: break-word !important;">，曾担任</span><span style="margin: 0px; padding: 0px; max-width: 100%; line-height: 30px; color: rgb(51, 51, 51); box-sizing: border-box !important; word-wrap: break-word !important;">中国少年儿童新闻出版总社总编辑。</span><span style="margin: 0px; padding: 0px; max-width: 100%; line-height: 30px; box-sizing: border-box !important; word-wrap: break-word !important;">中央电视台、中国教育电视台、北京电视台、腾讯、搜狐等多家传媒名牌栏目的常邀嘉宾。</span></span>
                </p>
                <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; max-width: 100%; min-height: 1em;  text-indent: 32px; line-height: 32px; box-sizing: border-box !important; word-wrap: break-word !important;">
                    <br style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;"/>
                </p>
                <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; max-width: 100%; min-height: 1em;  text-indent: 32px; line-height: 1.75em; box-sizing: border-box !important; word-wrap: break-word !important;">
                    <span style="margin: 0px; padding: 0px; max-width: 100%; font-size: 15px; line-height: 30px; box-sizing: border-box !important; word-wrap: break-word !important;">三十多年来,卢勤老师致力于对少年儿童及家长心理健康的研究。在长期主持《中国少年报》“知心姐姐”栏目过程中，积累了大量的一线家庭教育实践经验，是中国上亿家长及儿童最喜爱、最信任的权威教育专家，深受亿万家长和孩子的爱戴。</span>
                </p>
            </section>
        </section>
    </section>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; font-family: &#39;Helvetica Neue&#39;, Helvetica, &#39;Hiragino Sans GB&#39;, &#39;Microsoft YaHei&#39;, Arial, sans-serif; line-height: 25.6px; white-space: normal;">
    <br style="margin: 0px; padding: 0px;"/>
</p>
<p>
    <section style="margin: 0px; padding: 0px; white-space: normal; max-width: 100%; box-sizing: border-box; font-family: 微软雅黑; color: rgb(62, 62, 62); border-width: 0px; border-style: none; border-top-color: rgb(234, 96, 124); word-wrap: break-word !important;">
        <section style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box; word-wrap: break-word !important;">
            <section style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box; border-width: 0px; border-style: none; border-top-color: rgb(234, 96, 124); word-wrap: break-word !important; background-color: rgb(255, 255, 255);">
                <section style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box; word-wrap: break-word !important;">
                    <p class="wxqq-color wxqq-borderLeftColor" style="margin-bottom: 13px; padding: 0px 10px; clear: both; max-width: 100%; min-height: 1em;  line-height: 25px; border-width: 0px 0px 0px 5px; color: rgb(234, 96, 124); border-left-color: rgb(234, 96, 124); border-left-style: solid; -webkit-font-smoothing: antialiased; box-sizing: border-box !important; word-wrap: break-word !important;">
                        <strong style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;">课程名称：</strong>
                    </p>
                    <p style="padding: 0px; clear: both; max-width: 100%; min-height: 1em;  line-height: 1.6em; box-sizing: border-box !important; word-wrap: break-word !important;">
                        <span style="margin: 0px; padding: 0px; max-width: 100%; color: rgb(61, 170, 214); box-sizing: border-box !important; word-wrap: break-word !important;"><strong style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;">心灵的成长需要肯定</strong></span>
                    </p>
                    <p style="padding: 0px; clear: both; max-width: 100%; min-height: 1em;  line-height: 1.6em; box-sizing: border-box !important; word-wrap: break-word !important;">
                        <br style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;"/>
                    </p>
                    <p class="wxqq-color wxqq-borderLeftColor" style="margin-bottom: 13px; padding: 0px 10px; clear: both; max-width: 100%; min-height: 1em;  line-height: 25px; border-width: 0px 0px 0px 5px; color: rgb(234, 96, 124); border-left-color: rgb(234, 96, 124); border-left-style: solid; -webkit-font-smoothing: antialiased; box-sizing: border-box !important; word-wrap: break-word !important;">
                        <strong style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;">开课时间：</strong>
                    </p>
                    <p style="padding: 0px; clear: both; max-width: 100%; min-height: 1em;  line-height: 1.6em; box-sizing: border-box !important; word-wrap: break-word !important;">
                        <span style="margin: 0px; padding: 0px; max-width: 100%; color: rgb(61, 170, 214); box-sizing: border-box !important; word-wrap: break-word !important;"><strong style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;">3月14日（周一）15:00-16:00</strong></span>
                    </p>
                    <p style="padding: 0px; clear: both; max-width: 100%; min-height: 1em;  line-height: 1.6em; box-sizing: border-box !important; word-wrap: break-word !important;">
                        <br style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;"/>
                    </p>
                    <p class="wxqq-color wxqq-borderLeftColor" style="margin-bottom: 13px; padding: 0px 10px; clear: both; max-width: 100%; min-height: 1em;  line-height: 25px; border-width: 0px 0px 0px 5px; color: rgb(234, 96, 124); border-left-color: rgb(234, 96, 124); border-left-style: solid; -webkit-font-smoothing: antialiased; box-sizing: border-box !important; word-wrap: break-word !important;">
                        <strong style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;">课程形式：</strong>
                    </p>
                    <p style="padding: 0px; clear: both; max-width: 100%; min-height: 1em;  line-height: 1.6em; box-sizing: border-box !important; word-wrap: break-word !important;">
                        <strong style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;"><span style="margin: 0px; padding: 0px; max-width: 100%; color: rgb(61, 170, 214); box-sizing: border-box !important; word-wrap: break-word !important;">卢勤和她的朋友们微课堂群</span></strong>
                    </p>
                    <p style="padding: 0px; clear: both; max-width: 100%; min-height: 1em;  line-height: 1.6em; box-sizing: border-box !important; word-wrap: break-word !important;">
                        <strong style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;"><span style="margin: 0px; padding: 0px; max-width: 100%; color: rgb(61, 170, 214); box-sizing: border-box !important; word-wrap: break-word !important;">合作转播群</span></strong>
                    </p>
                    <p style="padding: 0px; clear: both; max-width: 100%; min-height: 1em;  line-height: 1.6em; box-sizing: border-box !important; word-wrap: break-word !important;">
                        <br style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;"/>
                    </p>
                </section>
            </section>
            <p class="wxqq-color wxqq-borderLeftColor" style="margin-bottom: 13px; padding: 0px 10px; clear: both; max-width: 100%; min-height: 1em;  line-height: 25px; border-width: 0px 0px 0px 5px; color: rgb(234, 96, 124); border-left-color: rgb(234, 96, 124); border-left-style: solid; -webkit-font-smoothing: antialiased; box-sizing: border-box !important; word-wrap: break-word !important; background-color: rgb(255, 255, 255);">
                <strong style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;">适合人群：</strong>
            </p>
            <p style="padding: 0px; clear: both; max-width: 100%; min-height: 1em;  line-height: 1.6em; box-sizing: border-box !important; word-wrap: break-word !important; background-color: rgb(255, 255, 255);">
                7岁以上孩子和<span style="margin: 0px; padding: 0px; max-width: 100%; line-height: 1.6em; box-sizing: border-box !important; word-wrap: break-word !important;">愿意为孩子创造良好家庭教育环境的家长、准家长、教育工作者。建议家长和孩子一起收听。</span>
            </p>
        </section>
    </section>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; font-family: &#39;Helvetica Neue&#39;, Helvetica, &#39;Hiragino Sans GB&#39;, &#39;Microsoft YaHei&#39;, Arial, sans-serif; line-height: 25.6px; white-space: normal;">
    <br style="margin: 0px; padding: 0px;"/>
</p>
<p>
    <section class="135editor" data-id="85583" data-color="rgb(211, 42, 99)" data-custom="rgb(211, 42, 99)" style="margin: 0px; padding: 0px; font-family: &#39;Helvetica Neue&#39;, Helvetica, &#39;Hiragino Sans GB&#39;, &#39;Microsoft YaHei&#39;, Arial, sans-serif; line-height: 25.6px; white-space: normal; box-sizing: border-box; border: 0px none;">
        <section style="margin: 5px; padding: 0px; border: none; text-align: center;">
            <section style="margin: 0px auto -2px; padding: 10px 10px 15px; color: rgb(255, 255, 255); font-size: 20px; border-radius: 5px; display: inline-block; border-color: rgb(85, 85, 85); background-color: rgb(211, 42, 99);">
                <section style="margin: 0px; padding: 2px 5px 0px; box-sizing: border-box; color: inherit; border-top-style: none; text-align: left;">
                    <section style="margin: -5px 0px 2px 7px; padding: 0px; height: 23px; width: 6px; transform: rotate(45deg); display: inline-block; box-sizing: border-box; color: inherit; background-color: rgb(254, 254, 254);"></section>
                    <section style="margin: 2px 0px 0px -17px; padding: 0px; width: 0px; height: 0px; border-width: 5px 3px 0px; border-style: solid; border-color: rgb(254, 254, 254) transparent transparent; display: inline-block; transform: rotate(45deg); box-sizing: border-box; color: inherit;"></section>
                    <section style="margin: -36px 0px 0px 15px; padding: 0px; color: inherit; box-sizing: border-box;">
                        <section style="margin: 0px; padding: 5px 15px 0px; color: inherit; box-sizing: border-box;">
                            <span class="135brush" data-brushtype="text" style="margin: 0px; padding: 0px; box-sizing: border-box; color: inherit; font-size: 18px;">视频微课听课规则</span>
                        </section>
                    </section>
                </section>
            </section>
            <section style="margin: 0px auto; padding: 0px; width: 0px; border-top-width: 0.6em; border-top-style: solid; border-bottom-color: rgb(211, 42, 99); border-top-color: rgb(211, 42, 99); height: 10px; color: inherit; border-left-width: 0.7em !important; border-left-style: solid !important; border-left-color: transparent !important; border-right-width: 0.7em !important; border-right-style: solid !important; border-right-color: transparent !important;"></section>
        </section>
        <section style="margin: 0px; padding: 0px; width: 0px; height: 0px; clear: both;"></section>
    </section>
    <section class="135editor" data-id="24" style="margin: 0px; padding: 0px; font-family: &#39;Helvetica Neue&#39;, Helvetica, &#39;Hiragino Sans GB&#39;, &#39;Microsoft YaHei&#39;, Arial, sans-serif; line-height: 25.6px; white-space: normal; box-sizing: border-box; border: 0px none;">
        <section class="135brush layout" style="margin: 3px auto; padding: 15px; color: rgb(62, 62, 62); line-height: 24px; box-shadow: rgb(170, 170, 170) 0px 0px 3px; border: 2px solid rgb(240, 240, 240);">
            <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both;">
                本次课程可以收听<strong style="margin: 0px; padding: 0px;">视频微课</strong>，快点来<strong style="margin: 0px; padding: 0px;">签到获得积分</strong>吧！
            </p>
            <section class="135editor" data-id="39" style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box; line-height: 25.6px; border: 0px none; word-wrap: break-word !important; background-color: rgb(255, 255, 255);">
                <section style="margin: 0.8em 0px 0.5em; padding: 0px; max-width: 100%; overflow: hidden; box-sizing: border-box !important; word-wrap: break-word !important;">
                    <section class="135brush" data-brushtype="text" placeholder="请输入标题" style="margin: 0px; padding: 0px 10px; max-width: 100%; height: 36px; display: inline-block; color: rgb(255, 255, 255); font-weight: bold; line-height: 36px; float: left; vertical-align: top; box-sizing: border-box !important; word-wrap: break-word !important; background-color: rgb(211, 42, 99);">
                        积分用来做什么？
                    </section>
                    <section style="margin: 0px; padding: 0px; max-width: 100%; display: inline-block; height: 36px; vertical-align: top; border-left-width: 9px; border-left-style: solid; border-left-color: rgb(211, 42, 99); border-right-color: rgb(211, 42, 99); box-sizing: border-box !important; word-wrap: break-word !important; border-top-width: 18px !important; border-top-style: solid !important; border-top-color: transparent !important; border-bottom-width: 18px !important; border-bottom-style: solid !important; border-bottom-color: transparent !important;"></section>
                </section>
            </section>
            <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; max-width: 100%; min-height: 1em; line-height: 25.6px; box-sizing: border-box !important; word-wrap: break-word !important; background-color: rgb(255, 255, 255);">
                <br style="margin: 0px; padding: 0px;"/>
            </p>
            <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; max-width: 100%; min-height: 1em; line-height: 25.6px; box-sizing: border-box !important; word-wrap: break-word !important; background-color: rgb(255, 255, 255);">
                积分可以兑换【卢勤微课堂】视频微课门票。
            </p>
            <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; max-width: 100%; min-height: 1em; line-height: 25.6px; box-sizing: border-box !important; word-wrap: break-word !important; background-color: rgb(255, 255, 255);">
                <br style="margin: 0px; padding: 0px;"/>
            </p>
            <section class="135editor" data-id="39" style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box; line-height: 25.6px; border: 0px none; word-wrap: break-word !important; background-color: rgb(255, 255, 255);">
                <section style="margin: 0.8em 0px 0.5em; padding: 0px; max-width: 100%; overflow: hidden; box-sizing: border-box !important; word-wrap: break-word !important;">
                    <section class="135brush" data-brushtype="text" placeholder="请输入标题" style="margin: 0px; padding: 0px 10px; max-width: 100%; height: 36px; display: inline-block; color: rgb(255, 255, 255); font-weight: bold; line-height: 36px; float: left; vertical-align: top; box-sizing: border-box !important; word-wrap: break-word !important; background-color: rgb(211, 42, 99);">
                        如何获得积分？
                    </section>
                    <section style="margin: 0px; padding: 0px; max-width: 100%; display: inline-block; height: 36px; vertical-align: top; border-left-width: 9px; border-left-style: solid; border-left-color: rgb(211, 42, 99); border-right-color: rgb(211, 42, 99); box-sizing: border-box !important; word-wrap: break-word !important; border-top-width: 18px !important; border-top-style: solid !important; border-top-color: transparent !important; border-bottom-width: 18px !important; border-bottom-style: solid !important; border-bottom-color: transparent !important;"></section>
                </section>
            </section>
            <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; max-width: 100%; min-height: 1em; line-height: 25.6px; box-sizing: border-box !important; word-wrap: break-word !important; background-color: rgb(255, 255, 255);">
                <br style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;"/>
            </p>
            <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; max-width: 100%; min-height: 1em; line-height: 25.6px; box-sizing: border-box !important; word-wrap: break-word !important; background-color: rgb(255, 255, 255);">
                转发<span style="margin: 0px; padding: 0px; max-width: 100%; color: rgb(217, 33, 66); box-sizing: border-box !important; word-wrap: break-word !important;"><strong style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;">签到文章</strong></span>到朋友圈可得1积分；
            </p>
            <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; max-width: 100%; min-height: 1em; line-height: 25.6px; box-sizing: border-box !important; word-wrap: break-word !important; background-color: rgb(255, 255, 255);">
                <span style="margin: 0px; padding: 0px; max-width: 100%; line-height: 1.6; box-sizing: border-box !important; word-wrap: break-word !important;"><br style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;"/></span>
            </p>
            <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; max-width: 100%; min-height: 1em; line-height: 25.6px; box-sizing: border-box !important; word-wrap: break-word !important; background-color: rgb(255, 255, 255);">
                <span style="margin: 0px; padding: 0px; max-width: 100%; line-height: 1.6; box-sizing: border-box !important; word-wrap: break-word !important;">邀请朋友转发您的签到文章到朋友圈，您可以再得到1积分。</span>
            </p>
            <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; max-width: 100%; min-height: 1em; line-height: 25.6px; box-sizing: border-box !important; word-wrap: break-word !important; background-color: rgb(255, 255, 255);">
                <br style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;"/>
            </p>
            <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both;">
                <br style="margin: 0px; padding: 0px;"/>
            </p>
            <section class="135editor" data-id="39" style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box; line-height: 25.6px; border: 0px none; word-wrap: break-word !important; background-color: rgb(255, 255, 255);">
                <section style="margin: 0.8em 0px 0.5em; padding: 0px; max-width: 100%; overflow: hidden; box-sizing: border-box !important; word-wrap: break-word !important;">
                    <section class="135brush" data-brushtype="text" placeholder="请输入标题" style="margin: 0px; padding: 0px 10px; max-width: 100%; height: 36px; display: inline-block; color: rgb(255, 255, 255); font-weight: bold; line-height: 36px; float: left; vertical-align: top; box-sizing: border-box !important; word-wrap: break-word !important; background-color: rgb(211, 42, 99);">
                        如何签到？
                    </section>
                    <section style="margin: 0px; padding: 0px; max-width: 100%; display: inline-block; height: 36px; vertical-align: top; border-left-width: 9px; border-left-style: solid; border-left-color: rgb(211, 42, 99); border-right-color: rgb(211, 42, 99); box-sizing: border-box !important; word-wrap: break-word !important; border-top-width: 18px !important; border-top-style: solid !important; border-top-color: transparent !important; border-bottom-width: 18px !important; border-bottom-style: solid !important; border-bottom-color: transparent !important;"></section>
                </section>
            </section>
            <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both;">
                <br style="margin: 0px; padding: 0px;"/>
            </p>
            <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; max-width: 100%; min-height: 1em;  line-height: 25.6px; box-sizing: border-box !important; word-wrap: break-word !important; background-color: rgb(255, 255, 255);">
                <br style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;"/>
            </p>
            <p style="margin-top: 0px; margin-bottom: 15px; padding: 0px; clear: both; max-width: 100%; min-height: 1em;  font-family: 微软雅黑; line-height: 1.75em; box-sizing: border-box !important; word-wrap: break-word !important; background-color: rgb(255, 255, 255);">
                <span style="margin: 0px; padding: 0px; max-width: 100%; line-height: 1.75em; font-size: 18px; box-sizing: border-box !important; word-wrap: break-word !important;"><strong style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;">1.&nbsp;</strong></span><span style="margin: 0px; padding: 0px; max-width: 100%; font-size: 15px; line-height: 1.75em; box-sizing: border-box !important; word-wrap: break-word !important;">请先关注</span><span style="margin: 0px; padding: 0px; max-width: 100%; font-size: 15px; line-height: 1.75em; color: rgb(255, 76, 65); box-sizing: border-box !important; word-wrap: break-word !important;"><strong style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;">卢勤问答平台微信公众号</strong></span><span style="margin: 0px; padding: 0px; max-width: 100%; font-size: 15px; line-height: 1.75em; box-sizing: border-box !important; word-wrap: break-word !important;">（ID：luqinwendapingtai）；</span>
            </p>
            <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; max-width: 100%; min-height: 1em;  font-family: 微软雅黑; text-align: center; box-sizing: border-box !important; word-wrap: break-word !important; background-color: rgb(255, 255, 255);">
                <span style="margin: 0px; padding: 0px; max-width: 100%; font-size: 15px; box-sizing: border-box !important; word-wrap: break-word !important;"><img data-s="300,640" data-type="jpeg" data-ratio="1" data-w="200" width="auto" src="https://mmbiz.qlogo.cn/mmbiz/2x9sALwpIbXbmYqaSzFZem1doyiapP7FPYUia2yLyU0dplPVErGiccHvVrIe6k5yN4dd6TuPicp8Iriao8icbdGtJqcg/640?wx_fmt=jpeg" style="margin: 0px; padding: 0px; max-width: 100%; height: auto !important; box-sizing: border-box !important; word-wrap: break-word !important; width: auto !important; visibility: visible !important;"/><br style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;"/></span>
            </p>
            <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; max-width: 100%; min-height: 1em;  font-family: 微软雅黑; text-align: center; box-sizing: border-box !important; word-wrap: break-word !important; background-color: rgb(255, 255, 255);">
                <span style="margin: 0px; padding: 0px; max-width: 100%; font-size: 14px; color: rgb(127, 127, 127); line-height: 28.4375px; box-sizing: border-box !important; word-wrap: break-word !important;">长按识别即可关注</span>
            </p>
            <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; max-width: 100%; min-height: 1em; line-height: 25.6px; box-sizing: border-box !important; word-wrap: break-word !important; background-color: rgb(255, 255, 255);">
                <span style="margin: 0px; padding: 0px; max-width: 100%; font-size: 14px; color: rgb(127, 127, 127); line-height: 28.4375px; box-sizing: border-box !important; word-wrap: break-word !important;"><br style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;"/></span>
            </p>
            <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; max-width: 100%; min-height: 1em; line-height: 25.6px; box-sizing: border-box !important; word-wrap: break-word !important; background-color: rgb(255, 255, 255);">
                <strong style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;"><span style="margin: 0px; padding: 0px; max-width: 100%; font-size: 18px; box-sizing: border-box !important; word-wrap: break-word !important;">2.&nbsp;</span><span style="margin: 0px; padding: 0px; max-width: 100%; font-family: 微软雅黑; box-sizing: border-box !important; word-wrap: break-word !important;"><span style="margin: 0px; padding: 0px; max-width: 100%; font-size: 15px; line-height: 26.25px;  box-sizing: border-box !important; word-wrap: break-word !important;"></span></span></strong><span style="margin: 0px; padding: 0px; max-width: 100%; font-family: 微软雅黑; box-sizing: border-box !important; word-wrap: break-word !important;"><span style="margin: 0px; padding: 0px; max-width: 100%; font-size: 15px; line-height: 26.25px;  box-sizing: border-box !important; word-wrap: break-word !important;">在公众号菜单</span></span><span style="margin: 0px; padding: 0px; max-width: 100%; font-family: 微软雅黑; box-sizing: border-box !important; word-wrap: break-word !important;"><span style="margin: 0px; padding: 0px; max-width: 100%; font-size: 15px; line-height: 26.25px;  box-sizing: border-box !important; word-wrap: break-word !important;">点击“签到”，进入签到页面。</span></span>
            </p>
            <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; max-width: 100%; min-height: 1em; line-height: 25.6px; box-sizing: border-box !important; word-wrap: break-word !important; background-color: rgb(255, 255, 255);">
                <br style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;"/>
            </p>
            <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; max-width: 100%; min-height: 1em; line-height: 25.6px; box-sizing: border-box !important; word-wrap: break-word !important; background-color: rgb(255, 255, 255);">
                <img data-s="300,640" data-type="jpeg" data-ratio="1.7758620689655173" data-w="522" src="https://mmbiz.qlogo.cn/mmbiz/2x9sALwpIbVMspW8P8m3hL2J7mKQguax0xpnZKiapKMdibkLopNaW4icT5OSerGNzaMY0zVPTTKL50hfSffQ9E3hw/640?wx_fmt=jpeg" style="margin: 0px; padding: 0px; max-width: 100%; height: auto !important; box-sizing: border-box !important; word-wrap: break-word !important; width: auto !important; visibility: visible !important;"/><br style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;"/>
            </p>
            <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; max-width: 100%; min-height: 1em; line-height: 25.6px; box-sizing: border-box !important; word-wrap: break-word !important; background-color: rgb(255, 255, 255);">
                <br style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;"/>
            </p>
            <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; max-width: 100%; min-height: 1em; line-height: 25.6px; box-sizing: border-box !important; word-wrap: break-word !important; background-color: rgb(255, 255, 255);">
                <strong style="margin: 0px; padding: 0px; max-width: 100%; line-height: 25.6px; box-sizing: border-box !important; word-wrap: break-word !important;"><span style="margin: 0px; padding: 0px; max-width: 100%; font-size: 18px; box-sizing: border-box !important; word-wrap: break-word !important;">3.&nbsp;</span></strong><span style="margin: 0px; padding: 0px; max-width: 100%; font-family: 微软雅黑; line-height: 25.6px; box-sizing: border-box !important; word-wrap: break-word !important;"><span style="margin: 0px; padding: 0px; max-width: 100%; font-size: 15px; line-height: 26.25px;  box-sizing: border-box !important; word-wrap: break-word !important;">分享签到文章到朋友圈，获得积分。</span></span>
            </p>
            <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; max-width: 100%; min-height: 1em; line-height: 25.6px; box-sizing: border-box !important; word-wrap: break-word !important; background-color: rgb(255, 255, 255);">
                <span style="margin: 0px; padding: 0px; max-width: 100%; font-family: 微软雅黑; line-height: 25.6px; box-sizing: border-box !important; word-wrap: break-word !important;"><span style="margin: 0px; padding: 0px; max-width: 100%; font-size: 15px; line-height: 26.25px;  box-sizing: border-box !important; word-wrap: break-word !important;"><br style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;"/></span></span>
            </p>
            <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; max-width: 100%; min-height: 1em; line-height: 25.6px; text-align: center; box-sizing: border-box !important; word-wrap: break-word !important; background-color: rgb(255, 255, 255);">
                <span style="margin: 0px; padding: 0px; max-width: 100%; font-family: 微软雅黑; line-height: 25.6px; box-sizing: border-box !important; word-wrap: break-word !important;"><span style="margin: 0px; padding: 0px; max-width: 100%; font-size: 15px; line-height: 26.25px;  box-sizing: border-box !important; word-wrap: break-word !important;"><img data-s="300,640" data-type="jpeg" data-ratio="1.7758620689655173" data-w="522" src="https://mmbiz.qlogo.cn/mmbiz/2x9sALwpIbVMspW8P8m3hL2J7mKQguaxNKD9ic0WjqxZRC4fssDaWZ7sIj6zdKKMlVfBz1xJewd9smlkXVElEcg/640?wx_fmt=jpeg" style="margin: 0px; padding: 0px; max-width: 100%; height: auto !important; box-sizing: border-box !important; word-wrap: break-word !important; width: auto !important; visibility: visible !important;"/><br style="margin: 0px; padding: 0px;"/></span></span>
            </p>
            <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both;">
                <br style="margin: 0px; padding: 0px;"/>
            </p>
            <section class="135editor" data-id="39" style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box; line-height: 25.6px; border: 0px none; word-wrap: break-word !important; background-color: rgb(255, 255, 255);">
                <section style="margin: 0.8em 0px 0.5em; padding: 0px; max-width: 100%; overflow: hidden; box-sizing: border-box !important; word-wrap: break-word !important;">
                    <section class="135brush" data-brushtype="text" placeholder="请输入标题" style="margin: 0px; padding: 0px 10px; max-width: 100%; height: 36px; display: inline-block; color: rgb(255, 255, 255); font-weight: bold; line-height: 36px; float: left; vertical-align: top; box-sizing: border-box !important; word-wrap: break-word !important; background-color: rgb(211, 42, 99);">
                        其他说明
                    </section>
                    <section style="margin: 0px; padding: 0px; max-width: 100%; display: inline-block; height: 36px; vertical-align: top; border-left-width: 9px; border-left-style: solid; border-left-color: rgb(211, 42, 99); border-right-color: rgb(211, 42, 99); box-sizing: border-box !important; word-wrap: break-word !important; border-top-width: 18px !important; border-top-style: solid !important; border-top-color: transparent !important; border-bottom-width: 18px !important; border-bottom-style: solid !important; border-bottom-color: transparent !important;"></section>
                </section>
            </section>
            <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both;">
                <br style="margin: 0px; padding: 0px;"/>
            </p>
            <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; max-width: 100%; min-height: 1em; line-height: 25.6px; box-sizing: border-box !important; word-wrap: break-word !important; background-color: rgb(255, 255, 255);">
                <br style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;"/>
            </p>
            <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; max-width: 100%; min-height: 1em; line-height: 25.6px; box-sizing: border-box !important; word-wrap: break-word !important; background-color: rgb(255, 255, 255);">
                每位用户每天最多可以获得10积分。
            </p>
            <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; max-width: 100%; min-height: 1em; line-height: 25.6px; box-sizing: border-box !important; word-wrap: break-word !important; background-color: rgb(255, 255, 255);">
                <br style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;"/>
            </p>
            <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; max-width: 100%; min-height: 1em; line-height: 25.6px; box-sizing: border-box !important; word-wrap: break-word !important; background-color: rgb(255, 255, 255);">
                显示“已转”的签到文章再次分享到朋友圈将不会再增加积分。
            </p>
            <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both;">
                <br style="margin: 0px; padding: 0px;"/>
            </p>
        </section>
        <section style="margin: 0px; padding: 0px; width: 0px; height: 0px; clear: both;"></section>
    </section>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; font-family: &#39;Helvetica Neue&#39;, Helvetica, &#39;Hiragino Sans GB&#39;, &#39;Microsoft YaHei&#39;, Arial, sans-serif; line-height: 25.6px; white-space: normal;">
    <br style="margin: 0px; padding: 0px;"/>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; font-family: &#39;Helvetica Neue&#39;, Helvetica, &#39;Hiragino Sans GB&#39;, &#39;Microsoft YaHei&#39;, Arial, sans-serif; line-height: 25.6px; white-space: normal;">
    <br style="margin: 0px; padding: 0px;"/>
</p>
<p>
    <section style="margin: 0px; padding: 0px; white-space: normal; max-width: 100%; box-sizing: border-box; color: rgb(62, 62, 62); font-family: 微软雅黑; border-width: 0px; border-style: none; border-top-color: rgb(234, 96, 124); word-wrap: break-word !important; background-color: rgb(255, 255, 255);">
        <section style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box; word-wrap: break-word !important;">
            <section class="135editor" data-id="85583" data-color="rgb(211, 42, 99)" data-custom="rgb(211, 42, 99)" style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box; border: 0px none; word-wrap: break-word !important;">
                <section style="margin: 5px; padding: 0px; max-width: 100%; box-sizing: border-box; border: none; text-align: center; word-wrap: break-word !important;">
                    <section style="margin: 0px auto -2px; padding: 10px 10px 15px; max-width: 100%; box-sizing: border-box; color: rgb(255, 255, 255); font-size: 20px; border-radius: 5px; display: inline-block; border-color: rgb(85, 85, 85); word-wrap: break-word !important; background-color: rgb(211, 42, 99);">
                        <section style="margin: 0px; padding: 2px 5px 0px; max-width: 100%; box-sizing: border-box; color: inherit; border-top-style: none; text-align: left; word-wrap: break-word !important;">
                            <section style="margin: -5px 0px 2px 7px; padding: 0px; max-width: 100%; box-sizing: border-box; height: 23px; width: 6px; transform: rotate(45deg); display: inline-block; color: inherit; word-wrap: break-word !important; background-color: rgb(254, 254, 254);"></section>
                            <section style="margin: 2px 0px 0px -17px; padding: 0px; max-width: 100%; box-sizing: border-box; width: 0px; height: 0px; border-width: 5px 3px 0px; border-style: solid; border-color: rgb(254, 254, 254) transparent transparent; display: inline-block; transform: rotate(45deg); color: inherit; word-wrap: break-word !important;"></section>
                            <section style="margin: -36px 0px 0px 15px; padding: 0px; max-width: 100%; box-sizing: border-box; color: inherit; word-wrap: break-word !important;">
                                <section style="margin: 0px; padding: 5px 15px 0px; max-width: 100%; box-sizing: border-box; color: inherit; word-wrap: break-word !important;">
                                    <strong style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;"><span style="margin: 0px; padding: 0px; max-width: 100%; font-size: 18px; box-sizing: border-box !important; word-wrap: break-word !important;">微课群报名规则</span></strong>
                                </section>
                            </section>
                        </section>
                    </section>
                    <section style="margin: 0px auto; padding: 0px; max-width: 100%; box-sizing: border-box; width: 0px; border-top-width: 0.6em; border-top-style: solid; border-bottom-color: rgb(211, 42, 99); border-top-color: rgb(211, 42, 99); height: 10px; color: inherit; word-wrap: break-word !important; border-left-width: 0.7em !important; border-left-style: solid !important; border-left-color: transparent !important; border-right-width: 0.7em !important; border-right-style: solid !important; border-right-color: transparent !important;">
                        <br style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;"/>
                    </section>
                </section>
                <section style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box; width: 0px; height: 0px; clear: both; word-wrap: break-word !important;"></section>
            </section>
            <section class="135editor" data-id="24" style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box; border: 0px none; word-wrap: break-word !important;">
                <section class="135brush layout" style="margin: 3px auto; padding: 15px; max-width: 100%; box-sizing: border-box; line-height: 24px; box-shadow: rgb(170, 170, 170) 0px 0px 3px; border: 2px solid rgb(240, 240, 240); word-wrap: break-word !important;">
                    <p style="margin-top: 0px; margin-bottom: 15px; padding: 0px; clear: both; max-width: 100%; min-height: 1em;  line-height: 1.75em; box-sizing: border-box !important; word-wrap: break-word !important;">
                        <span style="margin: 0px; padding: 0px; max-width: 100%; line-height: 1.75em; font-size: 18px; box-sizing: border-box !important; word-wrap: break-word !important;"><strong style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;">1.&nbsp;</strong></span><span style="margin: 0px; padding: 0px; max-width: 100%; font-size: 15px; line-height: 1.75em; box-sizing: border-box !important; word-wrap: break-word !important;">报名在线讲座，请先关注</span><span style="margin: 0px; padding: 0px; max-width: 100%; font-size: 15px; line-height: 1.75em; color: rgb(255, 76, 65); box-sizing: border-box !important; word-wrap: break-word !important;"><strong style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;">卢勤问答平台微信公众号</strong></span><span style="margin: 0px; padding: 0px; max-width: 100%; font-size: 15px; line-height: 1.75em; box-sizing: border-box !important; word-wrap: break-word !important;">（ID：luqinwendapingtai）；</span>
                    </p>
                    <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; max-width: 100%; min-height: 1em;  text-align: center; box-sizing: border-box !important; word-wrap: break-word !important;">
                        <span style="margin: 0px; padding: 0px; max-width: 100%; font-size: 15px; box-sizing: border-box !important; word-wrap: break-word !important;"><img data-s="300,640" data-type="jpeg" data-ratio="1" data-w="200" src="https://mmbiz.qlogo.cn/mmbiz/2x9sALwpIbXbmYqaSzFZem1doyiapP7FPYUia2yLyU0dplPVErGiccHvVrIe6k5yN4dd6TuPicp8Iriao8icbdGtJqcg/640?wx_fmt=jpeg" style="margin: 0px; padding: 0px; max-width: 100%; height: auto !important; box-sizing: border-box !important; word-wrap: break-word !important; width: auto !important; visibility: visible !important;"/><br style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;"/></span>
                    </p>
                    <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; max-width: 100%; min-height: 1em;  text-align: center; box-sizing: border-box !important; word-wrap: break-word !important;">
                        <span style="margin: 0px; padding: 0px; max-width: 100%; font-size: 14px; color: rgb(127, 127, 127); line-height: 28.4375px; box-sizing: border-box !important; word-wrap: break-word !important;">长按识别即可关注</span>
                    </p>
                    <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; max-width: 100%; min-height: 1em;  text-align: center; box-sizing: border-box !important; word-wrap: break-word !important;">
                        <br style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;"/>
                    </p>
                    <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; max-width: 100%; min-height: 1em;  line-height: 1.75em; box-sizing: border-box !important; word-wrap: break-word !important;">
                        <strong style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;"><span style="margin: 0px; padding: 0px; max-width: 100%; font-size: 18px; box-sizing: border-box !important; word-wrap: break-word !important;">2.</span></strong><span style="margin: 0px; padding: 0px; max-width: 100%; font-size: 15px; box-sizing: border-box !important; word-wrap: break-word !important;">&nbsp;在卢勤问答平台微信公众号中回复关键词：<span style="margin: 0px; padding: 0px; max-width: 100%; font-size: 18px; color: rgb(255, 76, 65); box-sizing: border-box !important; word-wrap: break-word !important;"><strong style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;">微课</strong></span>，领取属于自己的邀请码。</span>
                    </p>
                    <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; max-width: 100%; min-height: 1em;  line-height: 1.75em; box-sizing: border-box !important; word-wrap: break-word !important;">
                        <br style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;"/>
                    </p>
                    <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; max-width: 100%; min-height: 1em;  line-height: 1.75em; box-sizing: border-box !important; word-wrap: break-word !important;">
                        <span style="margin: 0px; padding: 0px; max-width: 100%; font-size: 15px; box-sizing: border-box !important; word-wrap: break-word !important;"><span style="margin: 0px; padding: 0px; max-width: 100%; font-size: 18px; box-sizing: border-box !important; word-wrap: break-word !important;"><strong style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;">3.</strong></span><span style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;">&nbsp;将<strong style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;">含有邀请码的支持页面转发到100人以上的微信群或者您的朋友圈</strong>，</span><span style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;">邀请朋友，在公众号中回复您的邀请码，为您投上一票支持。</span></span>
                    </p>
                    <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; max-width: 100%; min-height: 1em;  line-height: 1.75em; box-sizing: border-box !important; word-wrap: break-word !important;">
                        <br style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;"/>
                    </p>
                    <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; max-width: 100%; min-height: 1em;  line-height: 1.75em; box-sizing: border-box !important; word-wrap: break-word !important;">
                        <span style="margin: 0px; padding: 0px; max-width: 100%; font-size: 18px; box-sizing: border-box !important; word-wrap: break-word !important;"><strong style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;">4.</strong></span><span style="margin: 0px; padding: 0px; max-width: 100%; font-size: 15px; box-sizing: border-box !important; word-wrap: break-word !important;">当您的支持票数<span style="margin: 0px; padding: 0px; max-width: 100%; color: rgb(255, 76, 0); box-sizing: border-box !important; word-wrap: break-word !important;"><strong style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;">超过10票</strong></span>后，请<span style="margin: 0px; padding: 0px; max-width: 100%; color: rgb(255, 76, 0); box-sizing: border-box !important; word-wrap: break-word !important;"><strong style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;">将支持票数截图给卢勤问答平台小助手</strong></span>，然后由小助手安排您入群，额满后将不再拉人入群。</span>
                    </p>
                    <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; max-width: 100%; min-height: 1em;  line-height: 1.75em; box-sizing: border-box !important; word-wrap: break-word !important;">
                        <br style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;"/>
                    </p>
                    <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; max-width: 100%; min-height: 1em;  line-height: 1.75em; text-align: center; box-sizing: border-box !important; word-wrap: break-word !important;">
                        <span style="margin: 0px; padding: 0px; max-width: 100%; font-size: 15px; box-sizing: border-box !important; word-wrap: break-word !important;">卢勤问答平台小助手微信（luqinwenda001）。</span>
                    </p>
                    <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; max-width: 100%; min-height: 1em;  text-align: center; box-sizing: border-box !important; word-wrap: break-word !important;">
                        <img data-s="300,640" data-type="jpeg" data-ratio="1" data-w="200" src="https://mmbiz.qlogo.cn/mmbiz/2x9sALwpIbXbmYqaSzFZem1doyiapP7FPFB8KWG1YQHiaIAQGbXhdpq2rH03BVRN8K6qx670bkNcJA0XRKbibVKjw/640?wx_fmt=jpeg" style="margin: 0px; padding: 0px; max-width: 100%; height: auto !important; box-sizing: border-box !important; word-wrap: break-word !important; width: auto !important; visibility: visible !important;"/>
                    </p>
                    <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; max-width: 100%; min-height: 1em;  text-align: center; box-sizing: border-box !important; word-wrap: break-word !important;">
                        <span style="margin: 0px; padding: 0px; max-width: 100%; color: rgb(127, 127, 127); font-size: 14px; line-height: 28.4375px; box-sizing: border-box !important; word-wrap: break-word !important;">长按识别即可关注</span>
                    </p>
                    <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; max-width: 100%; min-height: 1em;  text-align: center; box-sizing: border-box !important; word-wrap: break-word !important;">
                        <br style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;"/>
                    </p>
                    <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; max-width: 100%; min-height: 1em;  line-height: 1.75em; box-sizing: border-box !important; word-wrap: break-word !important;">
                        <span style="margin: 0px; padding: 0px; max-width: 100%; font-size: 18px; color: rgb(255, 0, 0); box-sizing: border-box !important; word-wrap: break-word !important;"><strong style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;">加群必知：</strong></span>
                    </p>
                    <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; max-width: 100%; min-height: 1em;  line-height: 1.75em; box-sizing: border-box !important; word-wrap: break-word !important;">
                        <span style="margin: 0px; padding: 0px; max-width: 100%; color: rgb(217, 33, 66); font-size: 15px; line-height: 1.75em; box-sizing: border-box !important; word-wrap: break-word !important;">已加入卢勤问答平台微课直播群（卢勤和她的朋友们微课堂群）的朋友不用再重复申请入群，可以继续收听。</span>
                    </p>
                </section>
            </section>
            <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; max-width: 100%; min-height: 1em;  box-sizing: border-box !important; word-wrap: break-word !important;">
                <br style="margin: 0px; padding: 0px;"/>
            </p>
            <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; max-width: 100%; min-height: 1em;  box-sizing: border-box !important; word-wrap: break-word !important;">
                <br style="margin: 0px; padding: 0px;"/>
            </p>
        </section>
    </section>
    <section class="135editor" data-id="32290" data-color="rgb(211, 42, 99)" data-custom="rgb(211, 42, 99)" style="margin: 0px; padding: 0px; line-height: 25.6px; white-space: normal; max-width: 100%; box-sizing: border-box; color: rgb(62, 62, 62); font-family: 微软雅黑; border: 0px none; word-wrap: break-word !important; background-color: rgb(255, 255, 255);">
        <section style="margin: 5px 0px; padding: 0px; max-width: 100%; box-sizing: border-box; clear: both; border: 0px none; word-wrap: break-word !important;">
            <section style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box; border-top-width: 2.5px; border-top-style: solid; border-color: rgb(211, 42, 99); font-size: 1em; font-weight: inherit; text-decoration: inherit; color: rgb(255, 255, 255); word-wrap: break-word !important;">
                <section style="margin: 2px 0px 0px; padding: 0px; max-width: 100%; box-sizing: border-box; border: 0px rgb(211, 42, 99); overflow: hidden; color: inherit; word-wrap: break-word !important;">
                    <section style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box; display: inline-block; font-size: 1em; font-family: inherit; font-weight: inherit; text-align: inherit; text-decoration: inherit; color: inherit; border-color: rgb(211, 42, 99); word-wrap: break-word !important;">
                        <section class="135brush" data-bcless="darken" data-brushtype="text" style="margin: 0px; padding: 5px 10px; max-width: 100%; box-sizing: border-box; display: inline-block; line-height: 1.4em; height: 32px; vertical-align: top; font-family: inherit; font-weight: bold; float: left; color: inherit; border-color: rgb(126, 25, 59); word-wrap: break-word !important; background-color: rgb(211, 42, 99);">
                            关于卢勤微课堂
                        </section>
                        <section style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box; display: inline-block; vertical-align: top; width: 0px; height: 0px; border-top-width: 32px; border-top-style: solid; border-top-color: rgb(211, 42, 99); border-right-width: 32px; border-right-style: solid; border-right-color: transparent; border-top-right-radius: 4px; border-bottom-left-radius: 2px; color: inherit; word-wrap: break-word !important;"></section>
                    </section>
                </section>
            </section>
        </section>
    </section>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; font-family: &#39;Helvetica Neue&#39;, Helvetica, &#39;Hiragino Sans GB&#39;, &#39;Microsoft YaHei&#39;, Arial, sans-serif; line-height: 25.6px; max-width: 100%; min-height: 1em;  color: rgb(62, 62, 62); box-sizing: border-box !important; word-wrap: break-word !important; background-color: rgb(255, 255, 255);">
    <br style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;"/>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; line-height: 25.6px; white-space: normal; max-width: 100%; min-height: 1em; color: rgb(62, 62, 62); font-family: 微软雅黑; box-sizing: border-box !important; word-wrap: break-word !important; background-color: rgb(255, 255, 255);">
    <span style="margin: 0px; padding: 0px; max-width: 100%; font-size: 15px; line-height: 1.6em; box-sizing: border-box !important; word-wrap: break-word !important;">卢勤问答平台创办的，每周以微信群的方式进行授课的互动式线上课堂。</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; font-family: &#39;Helvetica Neue&#39;, Helvetica, &#39;Hiragino Sans GB&#39;, &#39;Microsoft YaHei&#39;, Arial, sans-serif; line-height: 25.6px; max-width: 100%; min-height: 1em;  color: rgb(62, 62, 62); box-sizing: border-box !important; word-wrap: break-word !important; background-color: rgb(255, 255, 255);">
    <br style="margin: 0px; padding: 0px;"/>
</p>
<p>
    <section class="135editor" data-id="32290" data-color="rgb(211, 42, 99)" data-custom="rgb(211, 42, 99)" style="margin: 0px; padding: 0px; line-height: 25.6px; white-space: normal; max-width: 100%; box-sizing: border-box; color: rgb(62, 62, 62); font-family: 微软雅黑; border: 0px none; word-wrap: break-word !important; background-color: rgb(255, 255, 255);">
        <section style="margin: 5px 0px; padding: 0px; max-width: 100%; box-sizing: border-box; clear: both; border: 0px none; word-wrap: break-word !important;">
            <section style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box; border-top-width: 2.5px; border-top-style: solid; border-color: rgb(211, 42, 99); font-size: 1em; font-weight: inherit; text-decoration: inherit; color: rgb(255, 255, 255); word-wrap: break-word !important;">
                <section style="margin: 2px 0px 0px; padding: 0px; max-width: 100%; box-sizing: border-box; border: 0px rgb(211, 42, 99); overflow: hidden; color: inherit; word-wrap: break-word !important;">
                    <section style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box; display: inline-block; font-size: 1em; font-family: inherit; font-weight: inherit; text-align: inherit; text-decoration: inherit; color: inherit; border-color: rgb(211, 42, 99); word-wrap: break-word !important;">
                        <section class="135brush" data-bcless="darken" data-brushtype="text" style="margin: 0px; padding: 5px 10px; max-width: 100%; box-sizing: border-box; display: inline-block; line-height: 1.4em; height: 32px; vertical-align: top; font-family: inherit; font-weight: bold; float: left; color: inherit; border-color: rgb(126, 25, 59); word-wrap: break-word !important; background-color: rgb(211, 42, 99);">
                            在这里能学到什么
                        </section>
                        <section style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box; display: inline-block; vertical-align: top; width: 0px; height: 0px; border-top-width: 32px; border-top-style: solid; border-top-color: rgb(211, 42, 99); border-right-width: 32px; border-right-style: solid; border-right-color: transparent; border-top-right-radius: 4px; border-bottom-left-radius: 2px; color: inherit; word-wrap: break-word !important;">
                            <br style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;"/>
                        </section>
                    </section>
                </section>
            </section>
        </section>
    </section>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; font-family: &#39;Helvetica Neue&#39;, Helvetica, &#39;Hiragino Sans GB&#39;, &#39;Microsoft YaHei&#39;, Arial, sans-serif; line-height: 25.6px; white-space: normal;">
    <br style="margin: 0px; padding: 0px;"/>
</p>
<p style="margin-bottom: 15px; padding: 0px; clear: both; white-space: normal; max-width: 100%; min-height: 1em; color: rgb(62, 62, 62); font-family: 微软雅黑; line-height: 2em; box-sizing: border-box !important; word-wrap: break-word !important; background-color: rgb(255, 255, 255);">
    <span style="margin: 0px; padding: 0px; max-width: 100%; font-size: 15px; line-height: 2em; box-sizing: border-box !important; word-wrap: break-word !important;">微课堂集聚了以卢勤老师为首的、国内外诸多一线的教育名家、教育大家；</span>
</p>
<p style="margin-bottom: 20px; padding: 0px; clear: both; white-space: normal; max-width: 100%; min-height: 1em; color: rgb(62, 62, 62); font-family: 微软雅黑; line-height: 2em; box-sizing: border-box !important; word-wrap: break-word !important; background-color: rgb(255, 255, 255);">
    <span style="margin: 0px; padding: 0px; max-width: 100%; font-size: 15px; box-sizing: border-box !important; word-wrap: break-word !important;">每周一期主题，每期60分钟，课堂围绕家庭教育、育儿百科、亲子关系、亲密关系等内容，在课堂上与您实时互动，解决您的各类家庭教育困惑与难题。</span>
</p>
<p>
    <section class="135editor" data-id="32290" data-color="rgb(211, 42, 99)" data-custom="rgb(211, 42, 99)" style="margin: 0px; padding: 0px; line-height: 25.6px; white-space: normal; max-width: 100%; box-sizing: border-box; color: rgb(62, 62, 62); font-family: 微软雅黑; border: 0px none; word-wrap: break-word !important; background-color: rgb(255, 255, 255);">
        <section style="margin: 5px 0px; padding: 0px; max-width: 100%; box-sizing: border-box; clear: both; border: 0px none; word-wrap: break-word !important;">
            <section style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box; border-top-width: 2.5px; border-top-style: solid; border-color: rgb(211, 42, 99); font-size: 1em; font-weight: inherit; text-decoration: inherit; color: rgb(255, 255, 255); word-wrap: break-word !important;">
                <section style="margin: 2px 0px 0px; padding: 0px; max-width: 100%; box-sizing: border-box; border: 0px rgb(211, 42, 99); overflow: hidden; color: inherit; word-wrap: break-word !important;">
                    <section style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box; display: inline-block; font-size: 1em; font-family: inherit; font-weight: inherit; text-align: inherit; text-decoration: inherit; color: inherit; border-color: rgb(211, 42, 99); word-wrap: break-word !important;">
                        <section class="135brush" data-bcless="darken" data-brushtype="text" style="margin: 0px; padding: 5px 10px; max-width: 100%; box-sizing: border-box; display: inline-block; line-height: 1.4em; height: 32px; vertical-align: top; font-family: inherit; font-weight: bold; float: left; color: inherit; border-color: rgb(126, 25, 59); word-wrap: break-word !important; background-color: rgb(211, 42, 99);">
                            近期课程预告：
                        </section>
                        <section style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box; display: inline-block; vertical-align: top; width: 0px; height: 0px; border-top-width: 32px; border-top-style: solid; border-top-color: rgb(211, 42, 99); border-right-width: 32px; border-right-style: solid; border-right-color: transparent; border-top-right-radius: 4px; border-bottom-left-radius: 2px; color: inherit; word-wrap: break-word !important;"></section>
                    </section>
                </section>
            </section>
        </section>
    </section>
    <section class="article135" label="powered by 135editor.com" style="margin: 0px; padding: 0px; line-height: 25.6px; white-space: normal; max-width: 100%; color: rgb(62, 62, 62); font-family: 微软雅黑; box-sizing: border-box !important; word-wrap: break-word !important; background-color: rgb(255, 255, 255);">
        <section class="135editor" data-id="86119" style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box; border: 0px none; word-wrap: break-word !important;">
            <section style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box; width: 0px; height: 0px; clear: both; word-wrap: break-word !important;"></section>
        </section>
        <section class="135editor" data-id="86119" data-color="rgb(211, 42, 99)" data-custom="rgb(211, 42, 99)" style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box; line-height: 25.6px; border: 0px none; word-wrap: break-word !important;">
            <section style="margin: 0px 0px 0px 2.5em; padding: 5px 0px 0px 25px; max-width: 100%; box-sizing: border-box; border-left-width: 1px; border-left-style: solid; border-left-color: rgb(211, 42, 99); word-wrap: break-word !important;">
                <section class="135brush" style="margin: -66px 0px 0px 20px; padding: 0px 0px 20px; max-width: 100%; box-sizing: border-box; color: inherit; word-wrap: break-word !important;">
                    <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; max-width: 100%; min-height: 1em;  box-sizing: border-box !important; word-wrap: break-word !important;">
                        <br style="margin: 0px; padding: 0px;"/>
                    </p>
                </section>
            </section>
        </section>
        <section class="135editor" data-id="86119" data-color="rgb(211, 42, 99)" data-custom="rgb(211, 42, 99)" style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box; line-height: 25.6px; border: 0px none; word-wrap: break-word !important;">
            <section style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box; width: 0px; height: 0px; clear: both; word-wrap: break-word !important;"></section>
        </section>
        <section class="135editor" data-id="86119" style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box; line-height: 25.6px; border: 0px none; word-wrap: break-word !important;">
            <section style="margin: 0px 0px 0px 2.5em; padding: 5px 0px 0px 25px; max-width: 100%; box-sizing: border-box; border-left-width: 1px; border-left-style: solid; border-color: rgb(211, 42, 99); word-wrap: break-word !important;">
                <section style="margin: 10px 0px 10px -4em; padding: 0px; max-width: 100%; box-sizing: border-box; text-align: center; word-wrap: break-word !important;">
                    <section style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box; width: 64px; word-wrap: break-word !important;">
                        <section style="margin: 0px; padding: 0.3em 2px; max-width: 100%; box-sizing: border-box; display: inline-block; font-size: 14px; width: 64px; border-top-right-radius: 4px; border-top-left-radius: 4px; color: rgb(255, 255, 255); word-wrap: break-word !important; background-color: rgb(211, 42, 99);">
                            <span class="135brush" data-brushtype="text" style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;">3月</span>
                        </section>
                    </section>
                    <section style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box; width: 64px; word-wrap: break-word !important;">
                        <section style="margin: 0px; padding: 0.1em 2px; max-width: 100%; box-sizing: border-box; width: 64px; display: inline-block; border: 1px solid rgb(211, 42, 99); border-bottom-right-radius: 4px; border-bottom-left-radius: 4px; word-wrap: break-word !important; background-color: rgb(254, 254, 254);">
                            <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; max-width: 100%; min-height: 1em;  box-sizing: border-box !important; word-wrap: break-word !important;">
                                <strong style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;"><span class="135brush" data-brushtype="text" style="margin: 0px; padding: 0px; max-width: 100%; font-size: 18px; box-sizing: border-box !important; word-wrap: break-word !important;">17</span></strong>
                            </p>
                        </section>
                    </section>
                </section>
                <section class="135brush" style="margin: -66px 0px 0px 20px; padding: 0px 0px 20px; max-width: 100%; box-sizing: border-box; color: inherit; word-wrap: break-word !important;">
                    <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; max-width: 100%; min-height: 1em;  box-sizing: border-box !important; word-wrap: break-word !important;">
                        <span style="margin: 0px; padding: 0px; max-width: 100%; font-size: 14px; box-sizing: border-box !important; word-wrap: break-word !important;">著名钢琴教育家、房产投资人、超级辣爸 &nbsp; 张羽冲</span>
                    </p>
                    <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; max-width: 100%; min-height: 1em;  box-sizing: border-box !important; word-wrap: break-word !important;">
                        <strong style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;">《家有女儿，如何养？》</strong>
                    </p>
                </section>
            </section>
            <section style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box; width: 0px; height: 0px; clear: both; word-wrap: break-word !important;"></section>
        </section>
        <section class="135editor" data-id="86119" style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box; line-height: 25.6px; border: 0px none; word-wrap: break-word !important;">
            <section style="margin: 0px 0px 0px 2.5em; padding: 5px 0px 0px 25px; max-width: 100%; box-sizing: border-box; border-left-width: 1px; border-left-style: solid; border-color: rgb(211, 42, 99); word-wrap: break-word !important;">
                <section style="margin: 10px 0px 10px -4em; padding: 0px; max-width: 100%; box-sizing: border-box; text-align: center; word-wrap: break-word !important;">
                    <section style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box; width: 64px; word-wrap: break-word !important;">
                        <section style="margin: 0px; padding: 0.3em 2px; max-width: 100%; box-sizing: border-box; display: inline-block; font-size: 14px; width: 64px; border-top-right-radius: 4px; border-top-left-radius: 4px; color: rgb(255, 255, 255); word-wrap: break-word !important; background-color: rgb(211, 42, 99);">
                            <span class="135brush" data-brushtype="text" style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;">3月</span>
                        </section>
                    </section>
                    <section style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box; width: 64px; word-wrap: break-word !important;">
                        <section style="margin: 0px; padding: 0.1em 2px; max-width: 100%; box-sizing: border-box; width: 64px; display: inline-block; border: 1px solid rgb(211, 42, 99); border-bottom-right-radius: 4px; border-bottom-left-radius: 4px; word-wrap: break-word !important; background-color: rgb(254, 254, 254);">
                            <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; max-width: 100%; min-height: 1em;  box-sizing: border-box !important; word-wrap: break-word !important;">
                                <strong style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;"><span class="135brush" data-brushtype="text" style="margin: 0px; padding: 0px; max-width: 100%; font-size: 18px; box-sizing: border-box !important; word-wrap: break-word !important;">22</span></strong>
                            </p>
                        </section>
                    </section>
                </section>
                <section class="135brush" style="margin: -66px 0px 0px 20px; padding: 0px 0px 20px; max-width: 100%; box-sizing: border-box; color: inherit; word-wrap: break-word !important;">
                    <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; max-width: 100%; min-height: 1em;  box-sizing: border-box !important; word-wrap: break-word !important;">
                        <span style="margin: 0px; padding: 0px; max-width: 100%; font-size: 14px; box-sizing: border-box !important; word-wrap: break-word !important;">著名家庭教育专家 &nbsp; 卢勤</span>
                    </p>
                    <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; max-width: 100%; min-height: 1em;  box-sizing: border-box !important; word-wrap: break-word !important;">
                        <strong style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;">《家庭教育系列微课三》</strong>
                    </p>
                </section>
            </section>
            <section style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box; width: 0px; height: 0px; clear: both; word-wrap: break-word !important;"></section>
        </section>
        <section class="135editor" data-id="86119" style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box; line-height: 25.6px; border: 0px none; word-wrap: break-word !important;">
            <section style="margin: 0px 0px 0px 2.5em; padding: 5px 0px 0px 25px; max-width: 100%; box-sizing: border-box; border-left-width: 1px; border-left-style: solid; border-color: rgb(211, 42, 99); word-wrap: break-word !important;">
                <section style="margin: 10px 0px 10px -4em; padding: 0px; max-width: 100%; box-sizing: border-box; text-align: center; word-wrap: break-word !important;">
                    <section style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box; width: 64px; word-wrap: break-word !important;">
                        <section style="margin: 0px; padding: 0.3em 2px; max-width: 100%; box-sizing: border-box; display: inline-block; font-size: 14px; width: 64px; border-top-right-radius: 4px; border-top-left-radius: 4px; color: rgb(255, 255, 255); word-wrap: break-word !important; background-color: rgb(211, 42, 99);">
                            <span class="135brush" data-brushtype="text" style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;">3月</span>
                        </section>
                    </section>
                    <section style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box; width: 64px; word-wrap: break-word !important;">
                        <section style="margin: 0px; padding: 0.1em 2px; max-width: 100%; box-sizing: border-box; width: 64px; display: inline-block; border: 1px solid rgb(211, 42, 99); border-bottom-right-radius: 4px; border-bottom-left-radius: 4px; word-wrap: break-word !important; background-color: rgb(254, 254, 254);">
                            <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; max-width: 100%; min-height: 1em;  box-sizing: border-box !important; word-wrap: break-word !important;">
                                <strong style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;"><span class="135brush" data-brushtype="text" style="margin: 0px; padding: 0px; max-width: 100%; font-size: 18px; box-sizing: border-box !important; word-wrap: break-word !important;">24</span></strong>
                            </p>
                        </section>
                    </section>
                </section>
                <section class="135brush" style="margin: -66px 0px 0px 20px; padding: 0px 0px 20px; max-width: 100%; box-sizing: border-box; color: inherit; word-wrap: break-word !important;">
                    <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; max-width: 100%; min-height: 1em;  box-sizing: border-box !important; word-wrap: break-word !important;">
                        <span style="margin: 0px; padding: 0px; max-width: 100%; font-size: 14px; box-sizing: border-box !important; word-wrap: break-word !important;">中华礼仪文化研究会会长 &nbsp;吕艳芝</span>
                    </p>
                    <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; max-width: 100%; min-height: 1em;  box-sizing: border-box !important; word-wrap: break-word !important;">
                        <strong style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;">《修养与家教——妈妈礼仪》</strong>
                    </p>
                </section>
            </section>
            <section style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box; width: 0px; height: 0px; clear: both; word-wrap: break-word !important;"></section>
        </section>
        <section class="135editor" data-id="86119" style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box; line-height: 25.6px; border: 0px none; word-wrap: break-word !important;">
            <section style="margin: 0px 0px 0px 2.5em; padding: 5px 0px 0px 25px; max-width: 100%; box-sizing: border-box; border-left-width: 1px; border-left-style: solid; border-color: rgb(211, 42, 99); word-wrap: break-word !important;">
                <section style="margin: 10px 0px 10px -4em; padding: 0px; max-width: 100%; box-sizing: border-box; text-align: center; word-wrap: break-word !important;">
                    <section style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box; width: 64px; word-wrap: break-word !important;">
                        <section style="margin: 0px; padding: 0.3em 2px; max-width: 100%; box-sizing: border-box; display: inline-block; font-size: 14px; width: 64px; border-top-right-radius: 4px; border-top-left-radius: 4px; color: rgb(255, 255, 255); word-wrap: break-word !important; background-color: rgb(211, 42, 99);">
                            <span class="135brush" data-brushtype="text" style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;">3月</span>
                        </section>
                    </section>
                    <section style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box; width: 64px; word-wrap: break-word !important;">
                        <section style="margin: 0px; padding: 0.1em 2px; max-width: 100%; box-sizing: border-box; width: 64px; display: inline-block; border: 1px solid rgb(211, 42, 99); border-bottom-right-radius: 4px; border-bottom-left-radius: 4px; word-wrap: break-word !important; background-color: rgb(254, 254, 254);">
                            <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; max-width: 100%; min-height: 1em;  box-sizing: border-box !important; word-wrap: break-word !important;">
                                <strong style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;"><span class="135brush" data-brushtype="text" style="margin: 0px; padding: 0px; max-width: 100%; font-size: 18px; box-sizing: border-box !important; word-wrap: break-word !important;">29</span></strong>
                            </p>
                        </section>
                    </section>
                </section>
                <section class="135brush" style="margin: -66px 0px 0px 20px; padding: 0px 0px 20px; max-width: 100%; box-sizing: border-box; color: inherit; word-wrap: break-word !important;">
                    <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; max-width: 100%; min-height: 1em;  box-sizing: border-box !important; word-wrap: break-word !important;">
                        <span style="margin: 0px; padding: 0px; max-width: 100%; font-size: 14px; line-height: 22.4px; box-sizing: border-box !important; word-wrap: break-word !important;">著名家庭教育专家卢勤</span>
                    </p>
                    <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; max-width: 100%; min-height: 1em;  box-sizing: border-box !important; word-wrap: break-word !important;">
                        <strong style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;">《<strong style="margin: 0px; padding: 0px; line-height: 25.6px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;">家庭教育系列微课四</strong>》</strong>
                    </p>
                    <p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; max-width: 100%; min-height: 1em;  box-sizing: border-box !important; word-wrap: break-word !important;">
                        <br style="margin: 0px; padding: 0px;"/>
                    </p>
                </section>
            </section>
        </section>
    </section>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; font-family: &#39;Helvetica Neue&#39;, Helvetica, &#39;Hiragino Sans GB&#39;, &#39;Microsoft YaHei&#39;, Arial, sans-serif; line-height: 25.6px; white-space: normal;">
    <br style="margin: 0px; padding: 0px;"/>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; padding: 0px; clear: both; font-family: &#39;Helvetica Neue&#39;, Helvetica, &#39;Hiragino Sans GB&#39;, &#39;Microsoft YaHei&#39;, Arial, sans-serif; line-height: 25.6px; white-space: normal; max-width: 100%; min-height: 1em; color: rgb(62, 62, 62); text-align: center; box-sizing: border-box !important; word-wrap: break-word !important; background-color: rgb(255, 255, 255);">
    <img data-type="gif" data-ratio="1.116" data-w="500" src="https://mmbiz.qlogo.cn/mmbiz/2x9sALwpIbW7nTa1LwcduxuroxZZjicE7VnLpu8PYx2Fwu3qQRiav2dxYzZMlrS37Y85QENeD510bKokibrcFWpLg/0?wx_fmt=gif" style="margin: 0px; padding: 0px; max-width: 100%; height: auto !important; box-sizing: border-box !important; word-wrap: break-word !important; width: auto !important; visibility: visible !important;"/>
</p>
<p>
    <br/>
</p>

        </div>
    </div>

   
    
</asp:Content>

