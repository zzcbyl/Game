<%@ Page Title="" Language="C#" MasterPageFile="~/luqinwenda/MonthMaster.master" %>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="m-mainpage">
        <div class="m-header">
            <img src="images/m-header-title.png" style="width:60%;" />
            <a class="m-header-left-icon"></a>
            <a class="m-header-right-icon"></a>
        </div>
        <div style="margin-top:-5px; position:relative;">
            <ul class="m-mouth-ul"><li>周日</li><li>周一</li><li>周二</li><li>周三</li><li>周四</li><li>周五</li><li>周六</li></ul>
            <ul class="m-mouth-ul-content">
                <% for (int i = 1; i <= Convert.ToDateTime("2016-6-1").AddDays(-1).Day; i++) { %>
                    <li><%=i.ToString() %></li>
                <% } %>
                
                <% for (int i = 1; i <= 11; i++) { %>
                    <li class="next-li-bg"><%=i.ToString() %></li>
                <% } %>
            </ul>
            <div class="clear"></div>
        </div>
        <div class="m-course-block-red">
            <div class="m-block-left">
                <img src="images/may-1.jpg" width="60%" />
            </div>
            <div class="m-block-content">
                <img src="images/may-course-1.jpg" height="50px" />
            </div>
            <a class="m-block-right-icon"></a>
        </div>
        <div class="m-course-block-green">
            <div class="m-block-left">
                <img src="images/may-2.jpg" width="60%" />
            </div>
            <div class="m-block-content">
                <img src="images/may-course-2.jpg" height="50px" />
            </div>
            <a class="m-block-right-icon"></a>
        </div>
        <div class="m-course-block-red">
            <div class="m-block-left">
                <img src="images/may-3.jpg" width="60%" />
            </div>
            <div class="m-block-content">
                <img src="images/may-course-3.jpg" height="50px" />
            </div>
            <a class="m-block-right-icon"></a>
        </div>
    </div>
    <script type="text/javascript">
        $(document).ready(function () {
            var winWidth = $(window).width();
            var wh = (parseFloat(winWidth - 20) / 7).toString() + 'px'
            $('.m-mouth-ul li').css({ "width": wh });
            $('.m-mouth-ul-content li').css({ "width": wh, "height": wh, "line-height": wh });
        });
    </script>
</asp:Content>

