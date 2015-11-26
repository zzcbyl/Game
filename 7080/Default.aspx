<%@ Page Title="" Language="C#" MasterPageFile="~/7080/Master7080.master" %>

<script runat="server">

</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        body {
            background:#860000; color:#000;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div style="width: auto; text-align: center;  ">
        <div>
            <img src="../images/logo70.jpg" width="250pt" />
        </div>
        <div style="margin-top:0pt;">
            <a href="page.aspx" style="display:block; width:200px; margin:0 auto;"><img src="../images/start70.jpg" width="200px" /></a>
        </div>
        <div style="margin-top: 10pt; text-align: left; line-height: 16pt; color:#000;">
            游戏说明：<br />
            <table>
                <tr><td style="vertical-align:top;">1、</td><td>根据提示猜出与之相关联的词语；</td></tr>
                <tr><td style="vertical-align:top;">2、</td><td>答案可在提示字库中找到，选择完毕后点“确认”，进行下一题；</td></tr>
                <tr><td style="vertical-align:top;">3、</td><td>点“跳过”按钮，视同放弃本题，本题不得分。</td></tr>
            </table>
        </div>
    </div>
    <script type="text/javascript">
        var shareTitle = "你的童年完整吗？"; //标题
        var imgUrl = "http://game.luqinwenda.com/images/logo70.jpg"; //图片
        var descContent = '你的童年完整吗'; //简介
        var lineLink = "http://game.luqinwenda.com/7080/default.aspx"; //链接
    </script>
</asp:Content>

