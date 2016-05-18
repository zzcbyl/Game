<%@ Page Title="" Language="C#" MasterPageFile="~/luqinwenda/MonthMaster.master" %>

<script runat="server">
    public string token = "";
    public int userid = 0;
    public int[] redDay = { 5, 12, 19 };
    public int[] greenDay = { 10, 17, 24, 26 };
    protected void Page_Load(object sender, EventArgs e)
    {
        token = Util.GetSafeRequestValue(Request, "token", "");
        userid = Users.CheckToken(token);
        if (userid <= 0)
        {
            string currentUrl = Request.Url.ToString();
            if (token != "")
                currentUrl = currentUrl.Replace("&token=" + token, "").Replace("?token=" + token, "");
            Response.Redirect("http://weixin.luqinwenda.com/authorize_final.aspx?callback=" + Server.UrlEncode(currentUrl), true);
        }
        
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="m-mainpage">
        <div class="m-header">
            <img src="images/m-header-title.png" style="width:60%;" />
            <%--<a class="m-header-left-icon"></a>
            <a class="m-header-right-icon"></a>--%>
        </div>
        <div style="margin-top:-5px; position:relative;">
            <ul class="m-mouth-ul"><li>周日</li><li>周一</li><li>周二</li><li>周三</li><li>周四</li><li>周五</li><li>周六</li></ul>
            <ul class="m-mouth-ul-content">
                <% for (int i = 1; i <= Convert.ToDateTime("2016-6-1").AddDays(-1).Day; i++) { %>
                    <li <%=Array.IndexOf(redDay, i) >= 0 ? "class=\"red-bg\" onclick=\"jumpCourse1(" + i + ");\"" : Array.IndexOf(greenDay, i) >= 0 ? "class=\"green-bg\" onclick=\"jumpCourse1(" + i + ");\"" : "" %>><%=i.ToString() %></li>
                <% } %>
                
                <% for (int i = 1; i <= 4; i++) { %>
                    <li class="next-li-bg"><%=i < 7 ? i.ToString() : "" %></li>
                <% } %>
            </ul>
            <div class="clear"></div>
        </div>
        <div class="m-course-block-red" onclick="jumpCourse(5);">
            <div class="m-block-left">
                <img src="images/may-1.jpg" />
            </div>
            <div class="m-block-content">
                <img src="images/may-course-1.jpg" />
            </div>
            <a class="m-block-right-icon"></a>
        </div>
        <div class="m-course-block-green" onclick="jumpCourse(6);">
            <div class="m-block-left">
                <img src="images/may-2.jpg" />
            </div>
            <div class="m-block-content">
                <img src="images/may-course-2.jpg" />
            </div>
            <a class="m-block-right-icon"></a>
        </div>
        <div class="m-course-block-red" onclick="jumpCourse(7);">
            <div class="m-block-left">
                <img src="images/may-3.jpg" />
            </div>
            <div class="m-block-content">
                <img src="images/may-course-3.jpg" />
            </div>
            <a class="m-block-right-icon"></a>
        </div>
        <div class="m-course-block-green" onclick="jumpCourse(4);">
            <div class="m-block-left">
                <img src="images/may-4.jpg" />
            </div>
            <div class="m-block-content">
                <img src="images/may-course-4.jpg" />
            </div>
            <a class="m-block-right-icon"></a>
        </div>
        <div class="m-course-block-red" onclick="jumpCourse(8);">
            <div class="m-block-left">
                <img src="images/may-5.jpg" />
            </div>
            <div class="m-block-content">
                <img src="images/may-course-5.jpg"/>
            </div>
            <a class="m-block-right-icon"></a>
        </div>
        <div class="m-course-block-green" onclick="jumpCourse(9);">
            <div class="m-block-left">
                <img src="images/may-6.jpg" />
            </div>
            <div class="m-block-content">
                <img src="images/may-course-6.jpg" />
            </div>
            <a class="m-block-right-icon"></a>
        </div>
        <div class="m-course-block-green" onclick="jumpCourse(10);">
            <div class="m-block-left">
                <img src="images/may-7.jpg" />
            </div>
            <div class="m-block-content">
                <img src="images/may-course-7.jpg" />
            </div>
            <a class="m-block-right-icon"></a>
        </div>
    </div>
    <script type="text/javascript">
        $(document).ready(function () {
            shareTitle = "【卢勤问答平台微课教室】5月精彩微课表！"; //标题
            shareLink = 'http://game.luqinwenda.com/luqinwenda/wkt-May.aspx'; //链接

            var winWidth = $(window).width();
            //alert(winWidth);
            var wh = (parseFloat(winWidth - 20) / 7).toString() + 'px'
            $('.m-mouth-ul li').css({ "width": wh });
            $('.m-mouth-ul-content li').css({ "width": wh, "height": wh, "line-height": wh });
            $('.red-bg').css('background-size', wh + ' ' + wh);
            $('.green-bg').css('background-size', wh + ' ' + wh);
            $('.m-block-content img').css('max-width', (winWidth - 20 - 61 - 60).toString() + "px");
        });

        function jumpCourse(num) {
            location.href = '/luqinwenda/wktIndex_integral.aspx?roomid=' + num + '&token=<%=token %>';
        }
        
        var dayArr = [5, 10, 12, 17, 19, 24, 26];
        var roomArr = [5, 6, 7, 4, 8, 9, 10];
        function jumpCourse1(num) {
            jumpCourse(roomArr[dayArr.indexOf(num)]);
        }
    </script>
</asp:Content>

