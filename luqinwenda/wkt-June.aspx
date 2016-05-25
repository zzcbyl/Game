<%@ Page Title="" Language="C#" MasterPageFile="~/luqinwenda/MonthMaster.master" %>

<script runat="server">
    public string token = "";
    public int userid = 0;
    public string[] redDay = { "2016-05-31", "2016-06-29", "2016-06-30", "2016-07-01" };
    public string[] greenDay = { "2016-06-14", "2016-06-16", "2016-06-21" };
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
            <img src="images/m-header-title6.png" style="width:60%;" />
            <a href="wkt-May.aspx?token=<%=token %>" class="m-header-left-icon"></a>
            <%--<a class="m-header-right-icon"></a>--%>
        </div>
        <div style="margin-top:-5px; position:relative;">
            <ul class="m-mouth-ul"><li>周日</li><li>周一</li><li>周二</li><li>周三</li><li>周四</li><li>周五</li><li>周六</li></ul>
            <ul class="m-mouth-ul-content">
                <% for (DateTime i = Convert.ToDateTime("2016-5-29"); i <= Convert.ToDateTime("2016-7-2"); i=i.AddDays(1))
                   {
                       string className = "";
                       if (i.Month != 6)
                           className = "class=\"next-li-bg\"";
                       if (Array.IndexOf(redDay, i.ToString("yyyy-MM-dd")) >= 0)
                           className = "class=\"red-bg\" onclick=\"jumpCourse1('" + i.ToString("yyyy-MM-dd") + "');\"";
                       if (Array.IndexOf(greenDay, i.ToString("yyyy-MM-dd")) >= 0)
                           className = "class=\"green-bg\" onclick=\"jumpCourse1('" + i.ToString("yyyy-MM-dd") + "');\"";
                       %>
                    <li <%=className %>><%=i.Day.ToString() %></li>
                <%} %>
            </ul>
            <div class="clear"></div>
        </div>
        <div class="m-course-block-red" onclick="jumpCourse(11);">
            <div class="m-block-left">
                <img src="images/june-1.jpg" />
            </div>
            <div class="m-block-content">
                <img src="images/june-course-1.jpg" />
            </div>
            <a class="m-block-right-icon"></a>
        </div>
        <div class="m-course-block-green" onclick="jumpCourse(12);">
            <div class="m-block-left">
                <img src="images/june-2.jpg" />
            </div>
            <div class="m-block-content">
                <img src="images/june-course-2.jpg" />
            </div>
            <a class="m-block-right-icon"></a>
        </div>
        <div class="m-course-block-green" onclick="jumpCourse(13);">
            <div class="m-block-left">
                <img src="images/june-3.jpg" />
            </div>
            <div class="m-block-content">
                <img src="images/june-course-3.jpg" />
            </div>
            <a class="m-block-right-icon"></a>
        </div>
        <div class="m-course-block-green" onclick="jumpCourse(14);">
            <div class="m-block-left">
                <img src="images/june-4.jpg" />
            </div>
            <div class="m-block-content">
                <img src="images/june-course-4.jpg" />
            </div>
            <a class="m-block-right-icon"></a>
        </div>
        <div class="m-course-block-red" onclick="jumpCourse(15);">
            <div class="m-block-left">
                <img src="images/june-5.jpg" />
            </div>
            <div class="m-block-content">
                <img src="images/june-course-5.jpg"/>
            </div>
            <a class="m-block-right-icon"></a>
        </div>
        <div class="m-course-block-red" onclick="jumpCourse(16);">
            <div class="m-block-left">
                <img src="images/june-6.jpg" />
            </div>
            <div class="m-block-content">
                <img src="images/june-course-6.jpg" />
            </div>
            <a class="m-block-right-icon"></a>
        </div>
        <div class="m-course-block-red" onclick="jumpCourse(17);">
            <div class="m-block-left">
                <img src="images/june-7.jpg" />
            </div>
            <div class="m-block-content">
                <img src="images/june-course-7.jpg" />
            </div>
            <a class="m-block-right-icon"></a>
        </div>
    </div>
    <script type="text/javascript">
        $(document).ready(function () {
            shareTitle = "【卢勤问答平台微课教室】6月精彩微课表！"; //标题
            shareLink = 'http://game.luqinwenda.com/luqinwenda/wkt-June.aspx'; //链接

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
        
        var dayArr = ['2016-05-31', '2016-06-14', '2016-06-16', '2016-06-21', '2016-06-29', '2016-06-30', '2016-07-01'];
        var roomArr = [11, 12, 13, 14, 15, 16, 17];
        function jumpCourse1(num) {
            jumpCourse(roomArr[dayArr.indexOf(num)]);
        }
    </script>
</asp:Content>

