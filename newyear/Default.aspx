﻿<%@ Page Title="" Language="C#" MasterPageFile="~/newyear/Master.master" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>

<script runat="server">
    public string token = ""; //"781fbb44ee129f33aa643a894d72888cc0c7244440b774f81d4ac1badab35a250ea0c232";
    public string id = "";
    public string totalCount = "0";
    public string surplusCount = "0";
    public string openedBoxList = "";
    public string isHelp = "1";
    public string code = "G0001";
    public string allJson = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        token = Util.GetSafeRequestValue(Request, "token", "");
        if (token == null || token == "")
        {
            Response.Redirect("http://weixin.luqinwenda.com/authorize_final.aspx?callback=" + Request.Url.ToString());
        }

        try
        {
            JavaScriptSerializer json = new JavaScriptSerializer();
            string getUrl = "";
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
                allJson = result;
                id = dic["id"].ToString();
                code = dic["code"].ToString().ToUpper();
                surplusCount = dic["current_support_num"].ToString();
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
            }
        }
        catch { }
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
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
            <div class="tab1" style="margin-top:25px;"></div>
            <div class="tab2"><img src="images/gift_max.png" hiddata="3" style="width:70%;" /></div>
            <div class="tab3" style="margin-top:25px;"></div>
            <div style="clear:both"></div>
            <div class="tab1"><img src="images/gift_yellow.png" hiddata="4" /></div>
            <div class="tab2"><img src="images/gift_yellow.png" hiddata="5" /></div>
            <div class="tab3"><img src="images/gift_yellow.png" hiddata="6" /></div>
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
        </div>
        <div style="margin:30px 20px 20px;">
            <div style="padding:10px">
                <div style="color:#473D56; ">
                    <img src="images/ny_text2.png" style="width:45%" />
                    <a onclick="alert('请在2016年1月8日来领奖！');" style="text-decoration:none; float:right; margin-top:-5px; font-size:12pt; display:inline-table; height:30px; line-height:30px; width:70px; text-align:center; background:#473D56; border-radius:3px; border:1px solid #635F5D; color:#807b7b;">领 奖</a>
                </div>
                <div id="giftedList" class="giftList">
                </div>
            </div>
            <div style="padding:10px">
                <div style="color:#473D56;">
                    <img src="images/ny_text3.png" style="width:58%" />
                </div>
                <div id="giftnoList" class="giftList">
                </div>
            </div>
        </div>
        <div style="margin-top:10px;  text-align:center;">
            <a href="Awardlist.aspx?id=<%=id %>" style=" text-decoration:underline; font-size:12pt; margin-left:10px; height:30px; line-height:30px; width:150px; text-align:center; color:#ccc;">查看奖品详情</a>
            <br />
            <br />
            <a href="ActRule.aspx?id=<%=id %>" style="display:inline-block; text-decoration:none; height:30px; line-height:30px; width:180px; text-align:center; background:#473D56; border-radius:3px; border:1px solid #000; color:#ccc;">
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
            <div id="giftText" style="line-height:20px; text-align:left; padding:10px;">长按指纹识别二维码，关注“悦长大家庭教育专家问答平台”，帮TA拆礼盒</div>
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
        var openCount = 0;
        var remainCount = parseInt('<%=surplusCount %>');
        var openedBox = '<%=openedBoxList %>';
        var percent = [8, 12, 18, 4, 9, 14, 5, 17, 7, 6];
        var getCountArr = [5, 15, 20, 25, 40, 100, 200];
        var alljson = <%=allJson %>;

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
                    if (boxArr[i] == '3')
                        $('.maincontent img').eq(boxArr[i]).attr("src", "images/gift_max_gray.png");
                    else
                        $('.maincontent img').eq(boxArr[i]).attr("src", "images/gift_gray.png");
                }
            }

            bindGiftList();
            fillProgress();

            $('.maincontent img').click(function () {
                if ($(this).attr("src") != "images/gift_gray.png" && $(this).attr("src") != "images/gift_max_gray.png") {
                    if($(this).attr("hiddata") == "3" && openCount < 6) {
                        $('#giftText').html("你需要把6个小盒子都打开才能开启这个终极大礼盒！");
                        $('#giftCode').hide();
                        $('.modal-header').hide();
                        $('.modal-footer').show();
                        $('#myModal').modal('show');
                        return;
                    }
                    var cStr = $('#spCount').html();
                    if (cStr != "" && parseInt(cStr.substr(1, 1)) > 0) {
                        OpenBox($(this).attr("hiddata"));
                        if ($(this).attr("hiddata") == "3")
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
