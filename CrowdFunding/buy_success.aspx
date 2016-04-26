<%@ Page Title="购买门票成功" Language="C#" MasterPageFile="~/CrowdFunding/Master.master" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>

<script runat="server">
    public string token = "";
    public int userId = 0;
    public int fuserId = 0;
    public int courseId = 0;
    public int userBalance = 0;
    public int courseprice = 0;
    public int coursepriceadd = 0;
    public int crowdid = 0;
    public string countStr = "";
    public string NickName = "";
    public string groupName = "";
    public string buyedTime = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        int count = int.Parse(Util.GetSafeRequestValue(Request, "count", "0"));
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
        if (fuserId != userId)
        {
            Response.Write("参数错误");
            Response.End();
            return;
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
        
        DataTable dt = Donate.getCrowdByOnlyUserid(fuserId);
        if (dt != null && dt.Rows.Count > 0)
        {
            groupName = dt.Rows[0]["crowd_name"].ToString();
            groupName = (groupName.Length > 12 ? groupName.Substring(0, 12) + "..." : groupName);
            userBalance = int.Parse(dt.Rows[0]["crowd_balance"].ToString()) / 100; 
            crowdid = int.Parse(dt.Rows[0]["crowd_id"].ToString());  
        }
        else
        {
            Response.Write("参数错误");
            Response.End();
            return;
        }


        DataTable crouseDt = Donate.getCourse(courseId);
        if (crouseDt != null && crouseDt.Rows.Count > 0)
        {
            DataTable donateCrowdDt = Donate.getDonateByCrowdCourseid(crowdid, courseId, 2);
            if (donateCrowdDt != null && donateCrowdDt.Rows.Count > 0)
                courseprice = int.Parse(crouseDt.Rows[0]["course_priceadd"].ToString()) / 100;
            else
            {
                DataTable donateUserDt = Donate.getDonateByUserid(fuserId, 2);
                if (donateUserDt != null && donateUserDt.Rows.Count > 0)
                    courseprice = int.Parse(crouseDt.Rows[0]["course_price"].ToString()) / 100 / 2;
                else
                    courseprice = int.Parse(crouseDt.Rows[0]["course_price"].ToString()) / 100;
            }
            coursepriceadd = int.Parse(crouseDt.Rows[0]["course_priceadd"].ToString()) / 100;
        }
        else
        {
            Response.Write("参数错误");
            Response.End();
            return;
        }
        
        //DataTable crouseDt = Donate.getCourse(courseId);
        //if (crouseDt != null && crouseDt.Rows.Count > 0)
        //{
        //    courseprice = int.Parse(crouseDt.Rows[0]["course_price"].ToString()) / 100;
        //    coursepriceadd = int.Parse(crouseDt.Rows[0]["course_priceadd"].ToString()) / 100;
        //}
        //else
        //{
        //    Response.Write("参数错误");
        //    Response.End();
        //    return;
        //}

        if (count > 0)
        {
            countStr = count.ToString() + "个";
            int cost = courseprice + (count - 1) * coursepriceadd;
            if (userBalance >= cost)
            {
                int Donateid = Donate.addDonate(crowdid, userId, (0 - cost * 100), 2, courseId, "购买" + count + "个直播群");
                if (Donateid > 0)
                {
                    int result = Donate.setTotal(Donateid);
                    buyedTime = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
                    if (result > 0)
                        Donate.updPayState(Donateid);
                }
            }
            else
                Response.Redirect("balance_error.aspx");
        }
        else
        {
            Response.Write("参数错误");
            Response.End();
            return;
        }

          
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <form id="form1" runat="server" method="post">
    <div class="mainPage">
        <img src="../images/main_head.jpg" width="100%" />
        <div style="border:3px solid #E9E9E9; border-radius:15px; margin:5px;">
            <div style="background:#ECECEC; margin:5px;  padding:20px;">
                <div style="height:35px; line-height:35px; font-size:13pt;">购买门票成功</div>
                <div style="background:#fff; width:100%; padding:20px; line-height:25px;">
                    <div>群名：<%=groupName %></div>
                    <div>申请人：<%=NickName %></div>
                    <div>购买群数：<%=countStr %></div>
                    <div>购买时间：<%=buyedTime %></div>
                    <div style="text-indent:30px;">
                        感谢您的支持！请将本页面截图作为购买凭证，发送给卢勤问答平台戴老师（ID:luqinwenda007）,安排听课事宜。
                    </div>
                    <div style="text-align:center; margin-top:10px;">
                        <img src="../images/xiaozhubo.jpg" width="80%" />
                    </div>
                </div>
                <div style="margin:50px 0; text-align:center;">
                    
                </div>
            </div>
        </div>
    </div>
    </form>
</asp:Content>

