<%@ Page Title="卢勤支招：如何让孩子告别磨蹭、拖拉的坏习惯" Language="C#" MasterPageFile="~/dingyue/Master.master" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>
<script runat="server">
    public string token = "";
    public int userId = 0;
    public string forward_count = "0";
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

        userId = Users.CheckToken(token);
        if (userId <= 0)
        {
            Response.Redirect("http://weixin.luqinwenda.com/authorize_final.aspx?callback=" + Request.Url.ToString(), true);
        }
        Session["user_token"] = token;
        
        //读取转发数
        JavaScriptSerializer json = new JavaScriptSerializer();
        string getNumUrl = "http://game.luqinwenda.com/api/timeline_get_forward_num.aspx?actid=1&userid=" + Util.GetSafeRequestValue(Request, "fuid", "0");
        string resultNum = HTTPHelper.Get_Http(getNumUrl);
        Dictionary<string, object> dicNum = json.Deserialize<Dictionary<string, object>>(resultNum);
        if (dicNum["status"].Equals("0"))
        {
            forward_count = dicNum["forward_count"].ToString();
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
                    <h2 id="activity-name" class="rich_media_title">卢勤支招：如何让孩子告别磨蹭、拖拉的坏习惯</h2>
                    <div class="rich_media_meta_list">
                        <em class="rich_media_meta rich_media_meta_text" id="post-date">2015-12-07</em>
                        <a id="post-user" href="javascript:void(0);" class="rich_media_meta rich_media_meta_link rich_media_meta_nickname">卢勤问答平台</a>
                    </div>
                    <div id="js_content" class="rich_media_content ">

                        <p style="">
                            <span style="max-width: 100%; color: rgb(62, 62, 62); white-space: pre-wrap; font-family: SimHei; font-size: 12px; font-weight: bold; line-height: 36px; background-color: rgb(255, 255, 255); box-sizing: border-box !important; word-wrap: break-word !important;">微信搜索（卢勤问答平台拼音）“luqinwendapingtai”</span><span style="max-width: 100%; white-space: pre-wrap; font-family: SimHei; font-size: 12px; font-weight: bold; line-height: 36px; color: rgb(255, 0, 0); background-color: rgb(255, 255, 255); box-sizing: border-box !important; word-wrap: break-word !important;">关注我</span><span style="max-width: 100%; color: rgb(62, 62, 62); white-space: pre-wrap; font-family: SimHei; font-size: 12px; font-weight: bold; line-height: 36px; background-color: rgb(255, 255, 255); box-sizing: border-box !important; word-wrap: break-word !important;">。每天精选教育资讯和文章，供您浏览。</span>
                            <img data-w="" data-ratio="0.75" data-type="jpeg" style="margin: 1em auto; border: 0px none; font-family: inherit; font-size: inherit; font-style: inherit; font-variant: inherit; font-weight: inherit; font-stretch: inherit; line-height: inherit; vertical-align: baseline; display: block; border-radius: 4px; width: auto ! important; visibility: visible ! important; height: auto ! important;" img_height="450" img_width="600" src="images/act1_1.jpg">
                        </p>
                        <p style=""><span style="color: rgb(0, 209, 0); font-size: 16px;"><strong><span style="color: rgb(0, 209, 0); border: 0px; font-family: inherit; font-style: inherit; font-variant: inherit; font-weight: 700; font-stretch: inherit; line-height: inherit; vertical-align: baseline;"></span></strong></span></p>
                        <p style="line-height: 2em; margin-bottom: 20px;"><span style="color: rgb(122, 68, 66);">中小学生过重的课业负担，不仅来自学校，也来自家长。</span></p>

                        <p style="line-height: 2em; margin-bottom: 20px;"><span style="color: rgb(122, 68, 66);">家长总是把孩子的时间装在自己的口袋里，用“施舍”的办法逼孩子学这个学那个，结果令孩子失去了自己支配时间的能力，减负赢得的时间又白白浪费掉了。</span></p>

                        <p style="line-height: 2em; margin-bottom: 20px;">假期开始了。“假期太长了，我都不知道该干什么！”有的孩子说。</p>

                        <p style="line-height: 2em; margin-bottom: 20px;">“假期太短了，我要做的事情太多了！”也有的孩子这样说。</p>

                        <p style="line-height: 2em; margin-bottom: 20px;">假期究竟是长还是短呢？</p>

                        <p style="line-height: 2em; margin-bottom: 20px;">《伊索寓言》里有这样一个故事：一位过路人问智者，要走几小时才能到达某城。智者先是默不作声，等过路人走了一段路以后，才又把那人叫回来，根据他行走的速度，告诉他所需的时间。</p>

                        <p style="line-height: 2em; margin-bottom: 20px;">这个故事启示人们，人生道路离不开时间，而时间又决定于人的行动。生命给予每一个人一生的时间，<span style="color: rgb(122, 68, 66);">在这笔数以亿计的财富中，孩子将摘取什么样的人生之果，完全取决于他一生的行动。假期里，孩子的收获多与少，完全取决于孩子自己对时间的利用和支配。</span></p>
                        <p>
                            <img data-w="550" data-ratio="0.7581818181818182" data-type="jpeg" data-s="300,640" style="width: 550px ! important; visibility: visible ! important; height: 417px ! important;" src="images/act1_2.jpg"><br>
                        </p>

                        <p style="line-height: 2em; margin-bottom: 20px;"><span style="color: rgb(122, 68, 66);">每一个爱孩子的父母，都会爱惜孩子的时间；每一个有责任感的父母，都会从小对孩子进行严守时间的训练。而假期正是为孩子上“时间利用课”的极好机会。</span></p>
                        <p style="line-height: 2em; margin-bottom: 20px;">把时间全部交给孩子，教他们自己支配，告诉孩子：<span style="color: rgb(122, 68, 66);">你的心爱之物，可以珍藏在家里，锁在箱子里，但是时间藏不住、锁不住。世上没有时间的收藏家，但每个人都可以做时间的主人。</span></p>
                        <p style="line-height: 2em; margin-bottom: 20px;">减负以后，学生的作业量减少了，假期里都做些什么？每天的生活怎么安排？必做的事情有哪些？争取做的事有哪些？这些都可以指导孩子早作计划。让孩子明白，<span style="color: rgb(122, 68, 66);">假期里的一切时间都属于他自己，节省下来的时间完全由他自己支配，这样孩子就会主动去做事，不会再磨磨蹭蹭、拖拖拉拉了。</span></p>
                        <p style="line-height: 2em; margin-bottom: 20px;">家长还要告诉孩子，一旦定下来的计划，就要严格执行。如按时起床睡觉，按时学习游戏，没有特殊情况，绝不可以改动，这样孩子就会慢慢养成分秒必计的严格习惯了。反之，磨磨蹭蹭、拖拖拉拉的不良习惯一旦形成，改起来就难了。</p>
                        <p style="line-height: 2em; margin-bottom: 20px;">爱生命，就要爱时间，懂得珍惜和利用时间的人才会创造出生命的奇观。</p>
                        <p>
                            <img data-w="450" data-ratio="0.5266666666666666" data-type="jpeg" data-s="300,640" style="width: 450px ! important; visibility: visible ! important; height: 237px ! important;" src="images/act1_3.jpg"><br>
                        </p>
                        <p>
                            <br>
                        </p>
                        <p style="line-height: 2em; margin-bottom: 20px;">做家长的，都希望自己的孩子从小努力学习，长大成为有用的人，这是对的。问题是，有的家长把“努力学习”片面地理解为死读书，让孩子整天做题、补习、考试……有位父亲为了让孩子考上大学，竟把孩子锁在家中，不许他上学。他让孩子每天清晨5点起床，深夜12点才准睡觉，逼着孩子把课本、习题、答案全背下来，其他的书一律不准看。结果孩子虽然在13岁时就考上了大学，但好像早已与世隔绝，连长江的源头在哪里这些基本的地理常识都不知道……</p>
                        <p style="line-height: 2em; margin-bottom: 20px;">对中小学生的家长来说，培养孩子要弄清一个问题：什么是有用的人？我们说，真正有用的人，是那些有理想、有道德、有知识、有体力的人，是懂得终身学习的人。只有这样，他们才能适应21世纪飞速发展的变化。</p>
                        <p style="line-height: 2em; margin-bottom: 20px;">联合国教科文组织在《学会生存宣言》中指出：“未来的文盲不是不识字的人，而是不会学习的人。”这就说明，教会孩子学习，教会孩子终身学习是一个被全人类所关注的问题。</p>
                        <p style="">
                            <span style="color: rgb(255, 76, 65); font-size: 14px; line-height: 27px;">文章属于原创，如需转载请注明出处；觉得文章还不错，分享给需要的朋友吧。</span>
                            <span style="font-size: 16px;"></span>
                        </p>
                        <p>
                            <img data-w="500" data-ratio="1.116" data-type="gif" style="width: 500px ! important; visibility: visible ! important; height: auto ! important;" src="images/guanzhu.gif"><br>
                        </p>
                    </div>
                    <div class="rich_media_tool" id="js_toobar3">
                        <div style="text-align:center; font-size:16pt;"><img src="images/zan_icon_0.png" style="width:57px; height:57px;" onclick="showShare();" onmouseover="zanUp(this);" onmouseout ="zanDown(this);" /></div>
                        <div style="text-align:center; font-size:10pt; color:#808080; font-family:微软雅黑;">已有<%=forward_count %>人赞过</div>

                        <%--<a class="media_tool_meta meta_primary" id="js_view_source" href="javascript:void(0);">阅读原文</a>
                        <a id="js_report_article3" class="media_tool_meta tips_global meta_extra" href="javascript:void(0);" onclick="showShare();">
                            <span style="margin-right:10px;" class="media_tool_meta meta_primary tips_global meta_praise" id="like3">
                                <i class="icon_praise_gray"></i><span class="praise_num" id="likeNum3">5</span>
                            </span>
                        </a>--%>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script>
        var shareTitle = "卢勤支招：如何让孩子告别磨蹭、拖拉的坏习惯"; //标题
        var shareImg = "http://game.luqinwenda.com/dingyue/images/act1_1.jpg"; //图片
        var shareContent = '中小学生过重的课业负担，不仅来自学校，也来自家长。家长总是把孩子的时间装在自己的口袋里，用“施舍”的办法逼孩子学这个学那个，结果令孩子失去了自己支配时间的能力，减负赢得的时间又白白浪费掉了。'; //简介
        var shareLink = "http://game.luqinwenda.com/dingyue/activity01_share.aspx?fuid=0"; //链接
        var Token = '<%=token %>';
        var Fatheruid = 0;

        $(document).ready(function () {
            if(QueryString("fuid")!=null)
            {
                Fatheruid = QueryString("fuid");
                shareLink = "http://game.luqinwenda.com/dingyue/activity01_share.aspx?fuid=" + Fatheruid;
            }
        });

        wx.ready(function () {
            //分享到朋友圈
            wx.onMenuShareTimeline({
                title: shareContent, // 分享标题
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
    </script>
    <script src="common/activity_js.js"></script>
</asp:Content>
