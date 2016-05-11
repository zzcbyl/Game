<%@ Page Title="卢勤和她的朋友们视频微课堂" Language="C#" MasterPageFile="~/IntegralMall/Master.master" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>

<script runat="server">
    public string token = "ca013d0c12977bcafc530fd58f82782901bdb19d2fcb8f85769be0f1c6b57e5445f47401";
    public Users user = new Users();
    public string UserHeadImg = "http://game.luqinwenda.com/images/noAvatar.jpg";
    public string NickName = "匿名";
    public DataRow drow = null;
    public int roomId = 0;
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
        UserChatRoomRights userChatRoom;
        if (drow["price"].ToString() == "0")
        {
            int ticketid = Donate.buyTicket(userId, roomId, 0, "购买进入 " + roomId + " Room的票");
            Donate.setBuyTicketState(ticketid);
            DataTable ticketDt = Donate.getTicket(ticketid);
            if (ticketDt != null && ticketDt.Rows.Count > 0)
            {
                if (ticketDt.Rows[0]["paystate"].ToString().Equals("1"))
                {
                    userChatRoom = UserChatRoomRights.GetUserRightTemplate(userId);
                    if (userChatRoom._fieldsTemplate == null)
                        UserChatRoomRights.CreateUserRightTemplate(int.Parse(ticketDt.Rows[0]["userid"].ToString()));
                    else
                    {
                        userChatRoom._fieldsTemplate["can_enter_chat_room"] = "1";
                        userChatRoom._fieldsTemplate["can_chat_text"] = "1";
                        userChatRoom.UpdateUserRightTemplate();
                    }

                    userChatRoom = UserChatRoomRights.GetUserChatRights(int.Parse(ticketDt.Rows[0]["userid"].ToString()), int.Parse(ticketDt.Rows[0]["roomid"].ToString()));
                    if (userChatRoom._fieldsChatRoom == null)
                        UserChatRoomRights.CreateUserChatRights(int.Parse(ticketDt.Rows[0]["roomid"].ToString()), int.Parse(ticketDt.Rows[0]["userid"].ToString()));
                    else
                    {
                        userChatRoom._fieldsChatRoom["can_enter_chat_room"] = "1";
                        userChatRoom._fieldsChatRoom["can_chat_text"] = "1";
                        userChatRoom.UpdateUserChatRoomRights();
                    }

                    this.Response.Redirect("Default.aspx?roomid=" + int.Parse(ticketDt.Rows[0]["roomid"].ToString()));
                }
            }
        }

        userChatRoom = new UserChatRoomRights(userId, roomId);
        if (userChatRoom.CanEnter && userChatRoom.CanPublishText)
        {
            this.Response.Redirect("Default.aspx?roomid=" + roomId);
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


        if (Request.Form["hidPay"] != null && Request.Form["hidPay"].Equals("1"))
        {
            int price = int.Parse(chatRoom._fields["price"].ToString());
            int ticketid = Donate.buyTicket(userId, roomId, price, "购买进入 " + roomId + " Room的票");


            string payurl = "http://weixin.luqinwenda.com/payment/payment.aspx?body=卢勤问答平台微课堂&detail=听课费&userid=" + userId + "&product_id=" + ticketid + "&total_fee=" + price.ToString()
                    + "&callback=" + Server.UrlEncode("http://game.luqinwenda.com/luqinwenda/paySuccess.aspx?product_id=" + ticketid);
            Response.Redirect(payurl);
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
            
        </div>
        <div style="margin:30px 0; text-align:center;">
            <img src="../images/wkt_confirm_icon.png" style="width:40%;" />
        </div>
        <div style="text-align:left; width:70%; margin-left:15%; line-height:25px;">
            <div>欢迎您进入【卢勤和她的朋友们微课堂】</div>
            <div>您需要支付：<%=float.Parse(drow["price"].ToString()) / 100 %>元</div>
            <div></div>
        </div>
        <div style="text-align:center; margin:35px 0 80px;">
            <a class="btn" style="background:#E06F61; color:#fff;" href="javascript:submitPay();">确定</a>　　
            <a class="btn" style="background:#E06F61; color:#fff;" href="javascript:history.go(-1);">取消</a>
        </div>
    </div>
    <input type="hidden" id="hidPay" name="hidPay" value="" />

    <script type="text/javascript">
        function submitPay() {
            $('#hidPay').val("1");
            document.forms[0].submit();
        }
    </script>
</asp:Content>

