<%@ Page Title="" Language="C#" MasterPageFile="~/luqinwenda/Master.master" %>
<%@ Register src="UserHeadControl.ascx" tagname="UserHeadControl" tagprefix="uc1" %>
<%@ Import Namespace="System.Data" %>

<script runat="server">
    public string token = "";
    public string FirstDate = DateTime.Now.AddDays(1).ToString("yyyy-MM-dd");
    public int userId = 0;
    public int roomId = 0;
    public DataRow chatdrow = null;
    public DataTable currentCDt = new DataTable();
    public int room_integral = 0;
    public int room_price = 0;
    public string paymethod = "money";
    protected void Page_Load(object sender, EventArgs e)
    {
        roomId = int.Parse(Util.GetSafeRequestValue(Request, "roomid", "0"));
        if (roomId <= 0)
        {
            Response.Write("参数错误");
            Response.End();
            return;
        }

        if (Request["paymethod"] != null)
            paymethod = Request["paymethod"].ToString().ToLower();

        token = Util.GetSafeRequestValue(Request, "token", "");
        userId = Users.CheckToken(token);
        if (userId <= 0)
        {
            string currentUrl = Request.Url.ToString();
            if (token != "")
                currentUrl = currentUrl.Replace("&token=" + token, "").Replace("?token=" + token, "");
            Response.Redirect("http://weixin.luqinwenda.com/authorize_final.aspx?callback=" + Server.UrlEncode(currentUrl), true);
        }
        Users user = new Users(userId);

        this.UserHeadControl1.Token = token;
        this.UserHeadControl1.UserId = userId;

        string rdm = new Random().Next(1, 99999).ToString();
        UserChatRoomRights userChatRoom = new UserChatRoomRights(userId, roomId);
        if (userChatRoom.CanEnter)
        {
            //this.Response.Redirect("Default.aspx?roomid=" + roomId + "&token=" + token + "&rdm=" + rdm);
        }

        ChatRoom chatRoom = new ChatRoom(roomId);
        chatdrow = chatRoom._fields;
        if (chatdrow == null)
        {
            Response.Write("参数错误");
            Response.End();
            return;
        }
        int courseid = -1;
        if (chatdrow["courseid"].ToString().Trim() != "0")
            courseid = int.Parse(chatdrow["courseid"].ToString());
        DataTable CourseDt = Donate.getCourse(courseid);
        if (CourseDt != null && CourseDt.Rows.Count > 0)
        {
            currentCDt = CourseDt;
        }

        int user_integral = int.Parse(user._fields["integral"].ToString());
        room_integral = int.Parse(chatdrow["integral"].ToString());
        room_price = int.Parse(chatdrow["price"].ToString());
        
        if (Request["hidPay"] != null && Request["hidPay"].ToString().Trim() == "1")
        {
            if (paymethod == "money")
            {
                int ticketid = Donate.buyTicket(userId, roomId, room_price, "购买进入 " + roomId + " Room的票");
                string payurl = "http://weixin.luqinwenda.com/payment/payment.aspx?body=卢勤问答平台微课教室&detail=听课费&userid=" + userId + "&product_id=" + ticketid + "&total_fee=" + room_price.ToString()
                        + "&callback=" + Server.UrlEncode("http://game.luqinwenda.com/luqinwenda/wktPaySuccess.aspx?roomid=" + roomId + "&product_id=" + ticketid);
                Response.Redirect(payurl);
            }
            else
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
                            this.Response.Redirect("wktPaySuccess.aspx?roomid=" + roomId + "&token=" + token + "&rdm=" + rdm);
                        }
                    }
                }
                else
                {
                    UserChatRoomRights.SetUserChatRoom(userId, roomId);
                    this.Response.Redirect("wktPaySuccess.aspx?roomid=" + roomId + "&token=" + token + "&rdm=" + rdm);
                }
            }
        }
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <uc1:UserHeadControl ID="UserHeadControl1" runat="server"  />
    <div class="content-couser-block">
        <div><span class="course-title">课程：</span><%=currentCDt.Rows[0]["course_title"].ToString() %></div>
        <div><span class="course-title">时间：</span><%=currentCDt.Rows[0]["course_time"].ToString().Trim() %></div>
        <div><span class="course-title">主讲：</span><%=currentCDt.Rows[0]["course_lecturer"].ToString() %></div>
    </div>
    <div style="padding:10px 30px; color:#e8775c; text-align:center;">
        <% if (paymethod == "integral") { %>
        <div>积分兑换：<%=room_integral %> 积分</div>
        <% } else { %>
        <div>支付金额：<%=float.Parse(room_price.ToString()) / 100 %> 元</div>
        <% } %>
    </div>
    <div style="text-align:center; margin-top:20px; position:relative; height:45px;">
        <a class="btn-action-pay" href="javascript:void(0);" onclick="jumpSubmit();">确认提交</a>
        <input type="hidden" id="hidPay" name="hidPay" value="" />
    </div>
    <script type="text/javascript">
        function jumpSubmit() {
            $('#hidPay').val("1");
            document.forms[0].submit();
        }
    </script>
</asp:Content>

