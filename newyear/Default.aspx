<%@ Page Title="" Language="C#" MasterPageFile="~/dingyue/Master.master" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>

<script runat="server">
    public string token = "ad98e490bebe2518000a5164903af833a5319c9f99a07b4564dc4f8387199a7c6e5f2df1";
    public string id = "";
    public string totalCount = "0";
    public string surplusCount = "0";
    public string openedBoxList = "";
    public string isHelp = "1";
    public string code = "G0001";
    protected void Page_Load(object sender, EventArgs e)
    {
        //token = Util.GetSafeRequestValue(Request, "token", "");
        //if (token == null || token == "")
        //{
        //    Response.Redirect("http://weixin.luqinwenda.com/authorize_final.aspx?callback=" + Request.Url.ToString());
        //}

        try
        {
            JavaScriptSerializer json = new JavaScriptSerializer();
            string getUrl="";
            if (Request["id"] != null && Request["id"] != "")
            {
                getUrl = "http://game.luqinwenda.com/api/new_year_box_get_info.aspx?id=" + Request["id"].ToString();
            }
            else
                getUrl = "http://game.luqinwenda.com/api/new_year_box_get_info.aspx?token=" + token;
            string result = HTTPHelper.Get_Http(getUrl);
            Dictionary<string, object> dic = json.Deserialize<Dictionary<string, object>>(result);
            if (dic["status"].Equals(0))
            {
                id = dic["id"].ToString();
                surplusCount = dic["current_support_num"].ToString();
                ArrayList supportList = (ArrayList)dic["support_list"];
                totalCount = supportList.Count.ToString();
                if (dic.ContainsKey("opened_box"))
                {
                    ArrayList boxList = (ArrayList)dic["opened_box"];
                    foreach (var box in boxList)
                    {
                        Dictionary<string, object> ddd = (Dictionary<string, object>)box;
                        openedBoxList += ddd["box_id"].ToString() + ",";
                    }
                }
                openedBoxList = openedBoxList.Length > 0 ? openedBoxList.Substring(0, openedBoxList.Length - 1) : "";

                if (Request["id"] != null && Request["id"] != "")
                {
                    string currentGetUrl = "http://game.luqinwenda.com/api/new_year_box_get_info.aspx?token=" + token;
                    string currentResult = HTTPHelper.Get_Http(currentGetUrl);
                    Dictionary<string, object> currentDic = json.Deserialize<Dictionary<string, object>>(currentResult);
                    if (currentDic["status"].Equals(0))
                    {
                        foreach (var support in supportList)
                        {
                            Dictionary<string, object> sss = (Dictionary<string, object>)support;
                            if (sss["open_id"].ToString() == currentDic["open_id"].ToString())
                            {
                                isHelp = "0";
                                break;
                            }
                        }
                    }
                }
            }
        }
        catch { }
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script src="../script/jquery-2.1.1.min.js"></script>
    <script src="../script/common.js"></script>
    <script src="../script/bootstrap.min.js"></script>
    <link href="../style/bootstrap.min.css" rel="stylesheet" />
    <style type="text/css">
        body, div { font-family:SimSun;}
        .bgContent { background:#595167; max-width: 640px; margin: 0 auto; min-height:600px; padding-bottom:10px; }
        .header { min-height:120px; background:#B6092F; }
        .header #leftlogo { float:left; width:50%; max-height:120px;  }
        .header #rightlogo { float:right; width:45%; max-height:120px; margin-top:5%; margin-right:5%; }
        .header img { width:100%; }
        .maincontent { padding:0 20px 20px; }
        .maincontent div { margin-top:10px;  }
        .maincontent .tab1 { width:33%; float:left; text-align:center; }
        .maincontent .tab2 { width:33%; float:left; text-align:center; }
        .maincontent .tab3 { width:33%; float:left; text-align:center; }
        .maincontent .tab1 img, .maincontent .tab2 img, .maincontent .tab3 img { width:60%; margin:5px auto; }
        .giftprogress { width:40%; float:left; height:25px; margin-top:3px; border:2px solid #332942; border-radius:4px; }
        .giftList { margin-left:20px; margin-top:5px;}
        .giftList div { margin:0; font-size:16px; color:#392D4C; width:100%;  line-height:25px;}
        .giftList div:first-child { color:#FF3C00; }
        .promptDiv { width:180px; height:200px;  color:#000; position:absolute; z-index:20; font-size:14pt; line-height:30pt; text-align:center;}
        .modal-title { height:8px; }
        .modal-dialog { margin-top:100px;}
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="bgContent">
        <div class="header">
            <div id="leftlogo"><img src="images/ny_logo1.png" /></div>
            <div id="rightlogo"><img src="images/ny_logo2.png" /></div>
        </div>
        <div style="margin-top:20px; font-size:20pt; height:50px; line-height:50px; font-family:SimHei; color:#fff; text-align:center; ">您的礼盒号码是：<span><%=code %></span>
        </div>
        <div class="maincontent">
            <div class="tab1"><img src="images/gift_yellow.png" hiddata="0" /></div>
            <div class="tab2"><img src="images/gift_yellow.png" hiddata="1" /></div>
            <div class="tab3"><img src="images/gift_yellow.png" hiddata="2" /></div>
            <div style="clear:both"></div>
            <div class="tab1" style="margin-top:25px;"><img src="images/gift_yellow.png" hiddata="3" /></div>
            <div class="tab2"><img src="images/gift_max.png" hiddata="4" style="width:70%;" /></div>
            <div class="tab3" style="margin-top:25px;"><img src="images/gift_yellow.png" hiddata="5" /></div>
            <div style="clear:both"></div>
            <div class="tab1"><img src="images/gift_yellow.png" hiddata="6" /></div>
            <div class="tab2"><img src="images/gift_yellow.png" hiddata="7" /></div>
            <div class="tab3"><img src="images/gift_yellow.png" hiddata="8" /></div>
            <div style="clear:both"></div>
        </div>
        <div style="padding:10px 20px; font-size:10pt; line-height:18px; color:#fff; text-align:left; font-weight:bold;">
            <div>说明：</div>
            <div>1. 每个礼盒中都有奖品，中奖率100%，且奖品不会重复出现。</div>
            <div>2. 如最大的礼盒中的奖品发完，将提示不再中奖。</div>
        </div>
        <div style="padding:20px 20px; margin-top:10px;">
            <div style="color:#fff; float:left; width:30%; margin-left:8%; margin-right:1%; margin-top:3px; text-align:right;">
                <img src="images/ny_text4.png" style="width:90%;" />
            </div>
            <div class="giftprogress">
                <div id="progressFill" style="height:100%; background:#84B822;"></div>
            </div>
            <div style="width:10%; margin-left:10px; float:left; font-weight:bold; font-size:22px; color:#332942;"><span id="spCount"></span></div>
            <div style="clear:both"></div>
        </div>
        <div style="padding:0px 20px; font-size:10pt; line-height:18px; color:#fff; text-align:center; font-weight:bold;">
            还需要<span id="needCount" style="padding:0 2px;"></span>个朋友帮忙，才能打开下一个礼盒
        </div>
        <div style="margin-top:30px; text-align:center;">
            <img src="images/btn_help.png" style="width:60%; border:0;" onclick="helpYou();" />
        </div>
        <div style="margin-top:10px;  text-align:center;">
            <img src="images/btn_mygift.png" style="width:60%; border:0;" onclick="getMyGift();" />
        </div>
        <div style="padding:10px 20px; font-size:10pt; line-height:18px; color:#fff; text-align:center; font-weight:bold;">
            <div>（本活动将于2016年1月7日12点结束，1月8日后可领奖）</div>
            <a onclick="alert('请在2016年1月8日来领奖！');" style=" margin-top:12px; font-size:12pt; display:inline-table; height:30px; line-height:30px; width:60px; text-align:center; background:#473D56; border-radius:3px; border:1px solid #635F5D; color:#807b7b;">领 奖</a>
            <a href="" style="display:inline-table; text-decoration:none; font-size:12pt; letter-spacing:1px; margin-left:10px; height:30px; line-height:30px; width:90px; text-align:center; background:#473D56; border-radius:3px; border:1px solid #000; color:#ccc;">查看奖品</a>
        </div>
        <div style="margin:30px 20px 20px;">
            <div style="padding:10px 30px;">
                <div style="color:#473D56; ">
                    <img src="images/ny_text2.png" style="width:45%" />
                </div>
                <div id="giftedList" class="giftList">
                    <div><img style="height:15px;" src="images/gift_max.png" /> 111111</div>
                    <div><img style="height:15px;" src="images/gift_yellow.png" /> 22222222</div>
                </div>
            </div>
            <div style="padding:10px 30px;">
                <div style="color:#473D56;">
                    <img src="images/ny_text3.png" style="width:58%" />
                </div>
                <div id="giftnoList" class="giftList">
                    <div><img style="height:15px;" src="images/gift_max.png" /> 微鲸43吋4K高清晰智能电视小钢炮（10台）<br />　 2016夏令营3000元抵用券（10张）</div>
                    <div><img style="height:15px;" src="images/gift_yellow.png" /> 22222222</div>
                </div>
            </div>
        </div>
        <div style="margin-top:10px;  text-align:center;">
            <a href="ActRule.aspx" style="display:inline-block; text-decoration:none; height:30px; line-height:30px; width:180px; text-align:center; background:#473D56; border-radius:3px; border:1px solid #000; color:#ccc;">
                活动规则和领奖办法</a>
        </div>
        <br />
        <br />
        <div style="clear:both"></div>
    </div>

    <!-- Modal -->
    <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
            <h4 class="modal-title" id="myModalLabel">　</h4>
          </div>
          <div class="modal-body">
            <div id="giftText" style="line-height:20px; text-align:left; padding:10px;">长按指纹识别二维码，关注“卢勤问答平台”，帮TA拆礼盒</div>
            <img id="giftCode" src="../images/dyh_code1.jpg" style="width:100%; " />
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-default" data-dismiss="modal">确定</button>
          </div>
        </div>
      </div>
    </div>

    <script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
    <script type="text/javascript">
        var Token = '<%=token %>';
        var percent = [8, 12, 18, 4, 9, 14, 5, 17, 7, 6];
        var openCount = 0;
        var remainCount = parseInt('<%=surplusCount %>');
        var openedBox = '<%=openedBoxList %>';
        var isHelp = '<%=isHelp %>';
        var getCountArr = [5, 10, 20, 20, 20, 30, 40, 100, 200];

        var shareTitle = "我想要新年礼盒，请大家帮帮我"; //标题
        var shareImg = "http://game.luqinwenda.com/newyear/images/ny_share_icon.jpg"; //图片
        var shareContent = '卢勤问答平台新年大礼盒！'; //简介
        var shareLink = 'http://game.luqinwenda.com/newyear/default.aspx'; //链接

        $(document).ready(function () {
            shareLink = 'http://game.luqinwenda.com/newyear/default.aspx?id=<%=id %>';
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

            if (openedBox != "") {
                var boxArr = openedBox.split(',');
                openCount = boxArr.length;
                for (var i = 0; i < boxArr.length; i++) {
                    if (boxArr[i] == '4')
                        $('.maincontent img').eq(boxArr[i]).attr("src", "images/gift_max_gray.png");
                    else
                        $('.maincontent img').eq(boxArr[i]).attr("src", "images/gift_gray.png");
                }
            }

            bindGiftList();
            fillProgress();

            $('.maincontent img').click(function () {
                if ($(this).attr("src") != "images/gift_gray.png" && $(this).attr("src") != "images/gift_max_gray.png") {
                    if($(this).attr("hiddata") == "4" && openCount < 8) {
                        $('#giftText').html("你需要把8个小盒子都打开才能开启这个终极大礼盒！");
                        $('#giftCode').hide();
                        $('.modal-header').hide();
                        $('.modal-footer').show();
                        $('#myModal').modal('show');
                        return;
                    }
                    var cStr = $('#spCount').html();
                    if (cStr != "" && parseInt(cStr.substr(1, 1)) > 0) {
                        OpenBox($(this).attr("hiddata"));
                        if ($(this).attr("hiddata") == "4")
                            $(this).attr("src", "images/gift_max_gray.png");
                        else
                            $(this).attr("src", "images/gift_gray.png");
                    }
                    else {
                        $('#giftText').html("请将当前页面发送给朋友或者发送到朋友圈，请你的朋友帮你开启礼盒！");
                        $('#giftCode').hide();
                        $('.modal-header').hide();
                        $('.modal-footer').show();
                        $('#myModal').modal('show');
                    }
                }
            });
        });

        
    </script>
    <script src="Script.js"></script>
</asp:Content>
