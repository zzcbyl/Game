﻿<%@ Page Title="" Language="C#" MasterPageFile="~/luqinwenda/MonthMaster.master" %>

<script runat="server">
    public string token = "";
    public int userid = 0;
    public string[] redDay = { "2016-09-01", "2016-09-06", "2016-09-29" };
    public string[] greenDay = {"2016-09-13", "2016-09-22" };
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
            <img src="images/m-header-title9.png" style="width:60%;" />
            <a href="wkt-August.aspx?token=<%=token %>" class="m-header-left-icon"></a>
            <a href="wkt-Oct.aspx?token=<%=token %>" class="m-header-right-icon"></a>
        </div>
        <div style="margin-top:-5px; position:relative;">
            <ul class="m-mouth-ul"><li>周日</li><li>周一</li><li>周二</li><li>周三</li><li>周四</li><li>周五</li><li>周六</li></ul>
            <ul class="m-mouth-ul-content">
                <% for (DateTime i = Convert.ToDateTime("2016-8-28"); i <= Convert.ToDateTime("2016-10-1"); i=i.AddDays(1))
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
        <div class="m-course-block-red" onclick="jumpCourse(33);">
            <div class="m-block-left">
                <img src="images/sep-1.png" />
            </div>
            <div class="m-block-content">
                <img src="images/sep-course-1.png" />
            </div>
            <a class="m-block-right-icon"></a>
        </div>
        <div class="m-course-block-red" onclick="jumpCourse(34);">
            <div class="m-block-left">
                <img src="images/sep-2.png" />
            </div>
            <div class="m-block-content">
                <img src="images/sep-course-2.png" />
            </div>
            <a class="m-block-right-icon"></a>
        </div>
        <div class="m-course-block-green" onclick="jumpCourse(35);">
            <div class="m-block-left">
                <img src="images/sep-3.png" />
            </div>
            <div class="m-block-content">
                <img src="images/sep-course-3.png" />
            </div>
            <a class="m-block-right-icon"></a>
        </div>
        <div class="m-course-block-green" onclick="jumpCourse(36);">
            <div class="m-block-left">
                <img src="images/sep-4.png" />
            </div>
            <div class="m-block-content">
                <img src="images/sep-course-4.png" />
            </div>
            <a class="m-block-right-icon"></a>
        </div>
        <div class="m-course-block-red" onclick="jumpCourse(37);">
            <div class="m-block-left">
                <img src="images/sep-5.png" />
            </div>
            <div class="m-block-content">
                <img src="images/sep-course-5.png" />
            </div>
            <a class="m-block-right-icon"></a>
        </div>
    </div>
    <script type="text/javascript">
        $(document).ready(function () {
            shareTitle = "【悦长大家庭教育专家问答平台微课教室】9月精彩微课表！"; //标题
            shareLink = 'http://game.luqinwenda.com/luqinwenda/wkt-Sep.aspx'; //链接

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

        var dayArr = ['2016-09-01', '2016-09-06','2016-09-13', '2016-09-22', '2016-09-29' ];
        var roomArr = [33, 34, 35, 36, 37];
        function jumpCourse1(num) {
            jumpCourse(roomArr[dayArr.indexOf(num)]);
        }
    </script>
</asp:Content>