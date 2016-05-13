<%@ Page Title="" Language="C#" MasterPageFile="~/IntegralMall/Master.master" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>

<script runat="server">
    public string token = "e90477e2f0993c8cea841471d157caad237cfd776919dc0b28c5b51ee601b782f51f69fc";
    public Users user = new Users();
    public string UserHeadImg = "http://game.luqinwenda.com/images/noAvatar.jpg";
    public string NickName = "匿名";
    public DataRow drow = null;
    public int roomId = 0;
    public int user_integral = 0;
    public int room_integral = 0;
    protected void Page_Load(object sender, EventArgs e)
    {
        roomId = int.Parse(Util.GetSafeRequestValue(Request, "roomid", "0"));
        if (roomId <= 0)
        {
            Response.Write("参数错误");
            Response.End();
            return;
        }
        
        token = Util.GetSafeRequestValue(Request, "token", "");
        int userId = Users.CheckToken(token);
        if (userId <= 0)
        {
            string currentUrl = Request.Url.ToString();
            if (token != "")
                currentUrl = currentUrl.Replace("&token=" + token, "").Replace("?token=" + token, "");
            Response.Redirect("http://weixin.luqinwenda.com/authorize_final.aspx?callback=" + Server.UrlEncode(currentUrl), true);
        }

        ChatRoom chatRoom = new ChatRoom(roomId);
        drow = chatRoom._fields;
        if (drow == null)
        {
            Response.Write("参数错误");
            Response.End();
            return;
        }
        room_integral = int.Parse(drow["integral"].ToString());

        UserChatRoomRights userChatRoom = new UserChatRoomRights(userId, roomId);
        if (userChatRoom.CanEnter && userChatRoom.CanPublishText)
        {
            this.Response.Redirect("Default.aspx?roomid=" + roomId);
        }

        if (drow["price"].ToString().Trim() == "0" && drow["integral"].ToString().Trim() == "0")
        {
            int ticketid = Donate.buyTicket(userId, roomId, 0, "购买进入 " + roomId + " Room的票");
            Donate.setBuyTicketState(ticketid);
            DataTable ticketDt = Donate.getTicket(ticketid);
            if (ticketDt != null && ticketDt.Rows.Count > 0)
            {
                if (ticketDt.Rows[0]["paystate"].ToString().Equals("1"))
                {
                    UserChatRoomRights.SetUserChatRoom(userId, roomId);
                    this.Response.Redirect("Default.aspx?roomid=" + int.Parse(ticketDt.Rows[0]["roomid"].ToString()));
                }
            }
        }

        if (drow["integral"].ToString().Trim() == "0")
        {
            Response.Write("参数错误");
            Response.End();
            return;
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
        catch { }
        user_integral = int.Parse(user._fields["integral"].ToString());

        if (Request.Form["hidPay"] != null && Request.Form["hidPay"].Equals("1"))
        {
            string type = "room";
            DataTable dt_integral = Integral.GetList(userId, 0, type, roomId);
            if (dt_integral.Rows.Count <= 0)
            {
                if (user_integral >= room_integral)
                {
                    int result = Integral.AddIntegral(userId, (0 - room_integral), "卢勤问答平台微课教室 " + roomId, type, roomId, 0);
                    if (result > 0)
                    {
                        UserChatRoomRights.SetUserChatRoom(userId, roomId);
                        this.Response.Redirect("Default.aspx?roomid=" + roomId);
                    }
                }
            }
            else
            {
                UserChatRoomRights.SetUserChatRoom(userId, roomId);
                this.Response.Redirect("Default.aspx?roomid=" + roomId);
            }
        }
    }

</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div style="max-width:640px; background:#FFFDEA; margin:0 auto; min-height:600px;">
        <div style="height:50px; width:100%; background:#C22B2B; font-family:宋体; color:#fff; font-size:14px; line-height:50px; font-weight:bold; letter-spacing:0.1em">
            <div style="float:left; width:40px; height:40px; margin:6px 0 0 10px; background:url(<%=UserHeadImg %>) no-repeat; background-size:40px 40px;"><img src="../dingyue/images/headbg.png" style="vertical-align:top; width:40px;" /></div>
            <div style="float:left; margin-left:10px; margin-top:2px;"><%=(NickName.Length > 5 ? NickName.Substring(0, 5) + "..." : NickName) %></div>
            <div style="float:right; margin-right:20px; font-size:16px;">积分：<span style="color:#D69100"><%=user.Integral %></span></div>
        </div>
        <div style="margin:30px 0; text-align:center;">
            <img src="../images/wkt_confirm_icon.png" style="width:40%;" />
        </div>
        <div style="text-align:left; width:70%; margin-left:15%; line-height:25px;">
            <div>欢迎您进入【卢勤问答平台微课教室】</div>
            <div>需要扣除您 <%=drow["integral"].ToString() %> 积分</div>
            <div>您目前的积分余额是：<%=user.Integral %></div>
        </div>
        <div style="text-align:center; margin:35px 0 80px;">
            <a class="btn" style="background:#E06F61; color:#fff;" href="javascript:submitPay();">确定</a>　　
            <a class="btn" style="background:#E06F61; color:#fff;" href="javascript:history.go(-1);">取消</a>
        </div>
    </div>
    <input type="hidden" id="hidPay" name="hidPay" value="" />

    <script type="text/javascript">
        var uintegral = parseInt('<%=user_integral %>');
        var integral = parseInt('<%=room_integral %>');
        function submitPay() {
            if (uintegral > 0) {
                if (uintegral >= integral) {
                    $('#hidPay').val("1");
                    document.forms[0].submit();
                    return;
                }
            }
            alert("您的积分不足，请先签到获取积分");
            location.href = 'http://game.luqinwenda.com/dingyue/default.aspx';
        }
    </script>
</asp:Content>

