<%@ Page Title="" Language="C#" MasterPageFile="~/CrowdFunding/Master.master" %>

<script runat="server">

</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <form id="form1" runat="server" method="post">
    <div class="mainPage">
        <img src="../images/main_head.jpg" width="100%" />
        <div style="border:3px solid #E9E9E9; border-radius:15px; margin:5px; margin-top:10px;">
            <div style="background:#ECECEC; margin:5px;  padding:30px 20px;">
                <div style="background:#fff; width:100%; padding:20px 10px; line-height:22px;">
                    <div style="text-align:center; font-size:13pt; font-weight:bold; padding:10px;">您好！您的众筹申请已提交。</div>
                    <div style="text-indent:25px;">您设置的最小众筹金额是：<span id="sp_price" style="font-weight:bold;"></span> 元</div>
                    <div style="text-indent:25px;">请将众筹页面分享到您的群里，开始众筹，众筹的所有金额都将用于支付悦长大家庭教育专家问答平台付费微课。</div>
                </div>
                <div style="margin:20px 0; text-align:center;">
                    <input id="btn_apply" type="button" class="btn btn-warning" value="确定" style="font-size:16pt;" onclick="submitDefault();" />
                    <input id="btn_return" type="button" class="btn btn-warning" value="返回" style="font-size:16pt; margin-left:15px;" onclick="ReturnApply();" />
                </div>
            </div>
        </div>
    </div>
    </form>
    <script type="text/javascript">
        var courseid;
        var fuid;
        $(document).ready(function () {
            courseid = QueryString('courseid');
            fuid = QueryString('fuid');
            $('#sp_price').html(QueryString("price"));

            shareLink = 'http://game.luqinwenda.com/CrowdFunding/group_default.aspx?fuid=' + fuid + '&courseid=' + courseid;
        });
        function submitDefault() {
            location.href = "group_default.aspx?courseid=" + courseid + "&fuid=" + fuid;
        }
        function ReturnApply() {
            location.href = 'group_apply.aspx?config=set&courseid=' + courseid;
        }
    </script>
</asp:Content>

