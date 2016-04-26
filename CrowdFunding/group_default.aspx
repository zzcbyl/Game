<%@ Page Title="卢勤微课堂" Language="C#" MasterPageFile="~/CrowdFunding/Master.master" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>
<%@ Import Namespace="System.Threading" %>

<script runat="server">
    public string token = "";
    public int userId = 0;
    public int fuserId = 0;
    public int crowd_balance = 0;
    public string group_name = "";
    public int crowdid = 0;
    public string crowd_remark = "";
    public string NickName = "匿名";
    public string UserHeadImg = "http://game.luqinwenda.com/images/noAvatar.jpg";
    public int courseId = 0;
    public DataTable currentCDt = new DataTable();
    public string buyedCount = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        fuserId = int.Parse(Util.GetSafeRequestValue(Request, "fuid", "0"));
        courseId = int.Parse(Util.GetSafeRequestValue(Request, "courseid", "0"));

        if (fuserId == 0 || courseId == 0)
        {
            Response.Write("参数错误");
            Response.End();
            return;
        }

        token = Util.GetSafeRequestValue(Request, "token", "");
        userId = Users.CheckToken(token);
        if (userId <= 0)
        {
            string currentUrl = Request.Url.ToString();
            if (token != "")
                currentUrl = currentUrl.Replace("&token=" + token, "").Replace("?token=" + token, "");
            Response.Redirect("http://weixin.luqinwenda.com/authorize_final.aspx?callback=" + Server.UrlEncode(currentUrl), true);
        }

        if (fuserId == userId)
            this.groupMaster.Visible = true;

        Users currentUser = new Users(fuserId);
        string userHeadNick = currentUser.GetUserAvatarJson();
        if (userHeadNick != "")
        {
            try
            {
                JavaScriptSerializer json = new JavaScriptSerializer();
                Dictionary<string, object> dicUser = json.Deserialize<Dictionary<string, object>>(userHeadNick);
                if (dicUser.Keys.Contains("nickname"))
                    NickName = dicUser["nickname"].ToString();
                if (dicUser.Keys.Contains("headimgurl"))
                    UserHeadImg = dicUser["headimgurl"].ToString();
            }
            catch { }
        }

        DataTable CourseDt = Donate.getCourse(courseId);
        if (CourseDt != null && CourseDt.Rows.Count > 0)
        {
            currentCDt = CourseDt;
        }

        //DataTable dt = Donate.getCrowdByUserid(fuserId, courseId);
        DataTable dt = Donate.getCrowdByOnlyUserid(fuserId);
        if (dt != null && dt.Rows.Count > 0)
        {
            group_name = dt.Rows[0]["crowd_name"].ToString();
            crowdid = int.Parse(dt.Rows[0]["crowd_id"].ToString());
            crowd_balance = int.Parse(dt.Rows[0]["crowd_balance"].ToString());
            crowd_remark = dt.Rows[0]["crowd_remark"].ToString();

            paystate ps = new paystate();
            ps.course_id = courseId;
            ps.crowd_id = crowdid;
            Thread th = new Thread(new ThreadStart(ps.UpdPayState));
            th.Start();
        }
        else
        {
            Response.Write("参数错误");
            Response.End();
            return;
        }
        //购买个数
        DataTable donateDt = Donate.getDonateByCrowdid(crowdid, courseId, 2);
        if (donateDt != null && donateDt.Rows.Count > 0)
        {
            string remark="";
            int groupCount = 0;
            foreach (DataRow row in donateDt.Rows)
            {
                remark = row["donate_remark"].ToString();
                remark = remark.Replace("购买", "").Replace("个直播群", "");
                groupCount += int.Parse(remark);
            }
            buyedCount = "已购群：" + groupCount + "个";
        }
    }

    public class paystate
    {
        public int crowd_id, course_id;

        public void UpdPayState()
        {
            DataTable unpayDt = Donate.getDonateByCrowdid(this.crowd_id, this.course_id, 1, 0);
            if (unpayDt != null && unpayDt.Rows.Count > 0)
            {
                foreach (DataRow row in unpayDt.Rows)
                {
                    try
                    {
                        string payresult = Util.GetWebContent("http://weixin.luqinwenda.com/payment/payment_get_result.aspx?body=卢勤问答平台微课堂&productid=" + row["donate_id"].ToString() + "&amount=" + row["donate_price"].ToString(), "get", "", "text/html");
                        if (payresult.Equals("PAID"))
                        {
                            int result = Donate.updPayState(int.Parse(row["donate_id"].ToString()));
                            if (result > 0)
                            {
                                Donate.setTotal(int.Parse(row["donate_id"].ToString()));
                            }
                        }
                    }
                    catch { }
                }
            }
        }
    }

    protected void btn_with_Click(object sender, EventArgs e)
    {
        this.Response.Redirect("withdraw.aspx?uid=" + userId);
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        .recordli { height:50px; line-height:50px; border-bottom:dashed 1px #ccc; margin-bottom:10px;}
        .avatar { width:20%; float:left; text-align:left; height:50px; }
        .avatar a { width:45px; height:45px; border-radius:5px; display:inline-block;}
        .nick-name { width:20%; float:left; text-align:center; }
        .donate-price { width:20%; float:left; text-align:center; }
        .donate-time { width:40%; float:left; text-align:right; }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <form id="form1" runat="server" method="post">
        <div class="mainPage">
            <img src="../images/main_head.jpg" width="100%" />
            <div id="head" style="color:#7e3766; font-weight:normal; text-align:left; margin-top:10px;">
                <div style="float:left; margin-left:10px;">申请人：</div>
                <div style="float:left; width:30px; height:30px; margin:2px 0 0; background:url(<%=UserHeadImg %>) no-repeat; background-size:30px 30px; border-radius:15px;">　</div>
                <div style="float:left; margin-left:10px; margin-top:2px;"><%=(NickName.Length > 5 ? NickName.Substring(0, 5) + "..." : NickName) %></div>
                <div style="float:right; margin-right:10px; color:#808080;"><%=buyedCount %></div>
                <div style="clear:both;"></div>
            </div>
            <div id="head" style="color:#7e3766; font-weight:normal; text-align:left; margin-top:2px;">
                <div style="float:left; margin-left:10px; height:35px; overflow:hidden;">群名：<%=(group_name.Length > 15 ? group_name.Substring(0, 15) + "..." : group_name) %></div>
            </div>
            <% if (currentCDt.Rows.Count>0) { %>
            <div style="border: 1px solid #E9E9E9; border-radius: 10px; padding:15px; margin:5px; line-height:22px;" 
                onclick="location.href='<%=currentCDt.Rows[0]["course_link"].ToString() %>';">
                <div><img src="<%=currentCDt.Rows[0]["course_headimg"].ToString() %>" width="100%" /></div>
                <div style="margin-top:5px;">主题：<%=currentCDt.Rows[0]["course_title"].ToString() %></div>
                <div>主讲人：<%=currentCDt.Rows[0]["course_lecturer"].ToString() %>　　时间：<%=currentCDt.Rows[0]["course_time"].ToString() %></div>
            </div>
            <% } %>
            <div style="padding:10px; margin:5px; line-height:22px;">
                <b>群主：</b><%=crowd_remark %>
            </div>
            <div style="text-align:center; height:50px; line-height:50px;" id="groupMaster" runat="server" visible="false">
                <input type="button" class="btn btn-warning" value="设置" style="font-size:16pt;" onclick="setConfig();" />　
                <input type="button" class="btn btn-warning" value="买门票" style="font-size:16pt;" onclick="buyTicket();" />
            </div>
            <div style="color:#7e3766; font-size:14pt; text-align:center; height:50px; line-height:50px;">
                现已有总金额：<%=crowd_balance / 100 %>元
            </div>
            <div style="text-align:center; height:50px; line-height:50px;">
                <input type="button" class="btn btn-success" value="点击交费听课" style="font-size:16pt;" onclick="submitApply();" />
                <%--<asp:Button ID="btn_with" runat="server" Text="提现" CssClass="btn btn-success" Font-Size="14pt" style="margin-left:15px;" Visible="false" OnClick="btn_with_Click" />--%>
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

            shareLink = 'http://game.luqinwenda.com/CrowdFunding/group_default.aspx?fuid=<%=fuserId %>&courseid=<%=courseId %>';

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
                url: "http://192.168.1.38:8002/api/get_crowd_donatelist.aspx",
                data: { crowdid: cid, pageindex: PageIndex, pagesize: 20 },
                dataType: "json",
                success: function (data) {
                    var listhtml = $('#recordList').html();
                    if (data.status == 0) {
                        PageIndex = data.pageindex + 1;
                        
                        for (var i = 0; i < data.donate_list.length; i++) {
                            var nickName = data.donate_list[i].donate_userid.nickname;
                            if (nickName && nickName != "") {
                                if (nickName.length > 2)
                                    nickName = nickName.substr(0, 2) + "**";
                                else
                                    nickName = nickName + "**";
                            }
                            else
                                nickName = "匿名网友";
                            var headimgurl = data.donate_list[i].donate_userid.headimgurl;
                            if (headimgurl) { }
                            else
                                headimgurl = '/images/noAvatar.jpg';
                            listhtml += '<div class="recordli">' +
                                        '<div class="avatar"><a style="background:url(' + headimgurl + '); background-size:45px 45px;"></a></div>' +
                                        '<div class="nick-name">' + nickName + '</div>' +
                                        '<div class="donate-price">' + (parseInt(data.donate_list[i].donate_price) / 100) + '元</div>' +
                                        '<div class="donate-time">' + data.donate_list[i].donate_creattime + '</div>' +
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
            location.href = "personal_pay.aspx?fuid=<%=fuserId %>&courseid=<%=courseId %>";
        }

        function setConfig()
        {
            location.href = 'group_apply.aspx?config=set&courseid=<%=courseId %>';
        }
        function buyTicket()
        {
            location.href = "buyticket.aspx?fuid=<%=fuserId %>&courseid=<%=courseId %>";
        }
    </script>
</asp:Content>

