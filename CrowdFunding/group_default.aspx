<%@ Page Title="" Language="C#" MasterPageFile="~/CrowdFunding/Master.master" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>

<script runat="server">
    public string token = "";
    public int userId = 0;
    public int fuserId = 0;
    public int crowd_balance = 0;
    public string group_name = "";
    public int crowdid = 0;
    public string NickName = "匿名";
    protected void Page_Load(object sender, EventArgs e)
    {
        fuserId = int.Parse(Util.GetSafeRequestValue(Request, "fuid", "0"));
        if (fuserId == 0)
        {
            Response.Write("参数错误");
            Response.End();
            return;
        }
        
        token = Util.GetSafeRequestValue(Request, "token", "");
        userId = Users.CheckToken(token);
        if (userId <= 0)
        {
            Response.Redirect("http://weixin.luqinwenda.com/authorize_final.aspx?callback=" + Server.UrlEncode(Request.Url.ToString()), true);
        }

        Users currentUser = new Users(userId);
        string userHeadNick = currentUser.GetUserAvatarJson();
        if (userHeadNick != "")
        {
            try
            {
                JavaScriptSerializer json = new JavaScriptSerializer();
                Dictionary<string, object> dicUser = json.Deserialize<Dictionary<string, object>>(userHeadNick);
                if (dicUser.Keys.Contains("nickname"))
                    NickName = dicUser["nickname"].ToString();
                //if (dicUser.Keys.Contains("headimgurl"))
                //    UserHeadImg = dicUser["headimgurl"].ToString();
            }
            catch { }
        }

        DataTable dt = Donate.getCrowdByUserid(fuserId);
        if (dt != null && dt.Rows.Count > 0)
        {
            group_name = dt.Rows[0]["crowd_name"].ToString();
            crowdid = int.Parse(dt.Rows[0]["crowd_id"].ToString());
            crowd_balance = int.Parse(dt.Rows[0]["crowd_balance"].ToString());
        }
        else
        {
            Response.Write("参数错误");
            Response.End();
            return;
        }
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        .recordli { height:50px; line-height:50px; border-bottom:dashed 1px #ccc; margin-bottom:10px;}
        .avatar { width:30%; float:left; text-align:center; height:55px; }
        .avatar a { width:45px; height:45px; border-radius:5px; display:inline-block;  }
        .nick-name { width:40%; float:left; text-align:center; }
        .donate-price { width:30%; float:left; text-align:center; }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <form id="form1" runat="server" method="post">
        <div class="mainPage">
            <div id="head" style="color:#7e3766; font-weight:normal;">
                <div style="float:left; margin-left:15px; ">群名：<%=group_name %></div>
                <div style="float:right; margin-right:15px; ">申请人：<%=NickName %></div>
            </div>
            <div style="border: 1px solid #E9E9E9; border-radius: 10px; padding:15px; margin:5px;">
                啊岁的法撒旦啊岁的法撒旦<br />
                啊岁的法撒旦啊岁的法撒旦<br />
            </div>
            <div style="color:#7e3766; font-size:14pt; text-align:center; height:50px; line-height:50px;">
                现已有总金额：<%=crowd_balance / 100 %>元
            </div>
            <div style="text-align:center; height:50px; line-height:50px;">
                <input type="button" class="btn btn-warning" value="点击交费听课" style="font-size:16pt;" onclick="submitApply();" />
            </div>
            <div style="border: 1px solid #E9E9E9; border-radius: 15px; margin:20px 5px 5px; padding:0 15px; min-height:100px; font-family:宋体;">
                <div style="background:#7e3766; height:1px; margin:5px 0 0;"></div>
                <div style="margin-top:5px;"><img src="../images/record_head.jpg" width="35%" /></div>
                <div id="recordList" style="margin-top:10px;">
                    
                </div>
                <div style="clear:both; height:50px;"></div>
            </div>
        </div>
    </form>
    <script type="text/javascript">
        var cid = '<%=crowdid %>';
        var PageIndex = 1;
        $(document).ready(function () {

            shareLink = 'http://game.luqinwenda.com/CrowdFunding/group_default.aspx?fuid=<%=fuserId %>';

            window.onscroll = function () {
                if (getScrollTop() + getClientHeight() == getScrollHeight()) {
                    fillList();
                }
            }
            fillList();
        });


        function fillList() {
            $.ajax({
                type: "GET",
                async: false,
                url: "http://game.luqinwenda.com/api/get_crowd_donatelist.aspx",
                data: { crowdid: cid, pageindex: PageIndex, pagesize: 3 },
                dataType: "json",
                success: function (data) {
                    var listhtml = $('#recordList').html();
                    if (data.status == 0) {
                        PageIndex = data.pageindex + 1;
                        for (var i = 0; i < data.donate_list.length; i++) {
                            var nickName = data.donate_list[i].donate_userid.nickname;
                            if (nickName!="") {
                                if (nickName.length > 2)
                                    nickName = nickName.substr(0, 2) + "**";
                                else
                                    nickName = nickName + "**";
                            }
                            else
                                nickName = "匿名网友";

                            listhtml += '<div class="recordli">' +
                                        '<div class="avatar"><a style="background:url(' + data.donate_list[i].donate_userid.headimgurl + '); background-size:45px 45px;"></a></div>' +
                                        '<div class="nick-name">' + nickName + '</div>' +
                                        '<div class="donate-price">' + (parseInt(data.donate_list[i].donate_price) / 100) + '元</div>' +
                                        '<div style="clear:both;"></div></div>';
                        }
                    }
                    $('#recordList').html(listhtml);
                }
            });
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

        function submitApply()
        {
            location.href = "personal_pay.aspx?fuid=<%=fuserId %>";
        }
    </script>
</asp:Content>

