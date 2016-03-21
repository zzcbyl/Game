<%@ Page Title="" Language="C#" MasterPageFile="~/CrowdFunding/Master.master" %>

<script runat="server">

</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <form id="form1" runat="server" method="post">
    <div class="mainPage">
        <img src="../images/main_head.jpg" width="100%" />
        <div style="border:3px solid #E9E9E9; border-radius:15px; margin:5px;">
            <div style="background:#ECECEC; margin:5px;  padding:20px;">
                <div style="height:35px; line-height:35px; font-size:13pt;">购买门票</div>
                <div style="background:#fff; width:100%; padding:20px 10px;">
                    <div>
                        余额不足！
                    </div>
                </div>
                <div style="margin:50px 0; text-align:center;">
                    <input type="hidden" id="hidIndex" name="hidIndex" value="" />
                    <input type="button" class="btn btn-success" value="确认购买" style="font-size:16pt;" onclick="submitBuy();" />
                </div>
            </div>
        </div>
    </div>
    </form>
</asp:Content>

