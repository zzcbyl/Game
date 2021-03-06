﻿<%@ Page Title="" Language="C#" MasterPageFile="~/7080/Master7080.master" %>

<script runat="server">

</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div id="mainContain" class="mainContent" style="display:">
        <div style="font-weight:bold;">根据下面图片，猜出答案</div>
        <div class="score">
            <div class="titleNumber"><a id="currentNum">1</a>/10</div>
            <a class="scoreResult">
                得分：<span id="scoreVal">0</span>
            </a>
            <!--<div class="next_btn"><a class="yuanjiao beijing">下一提示</a></div>-->
            <div style="clear:both;"></div>
            <div id="addScore" style="left:45%; position:absolute; top:30px; font-size:20px; width:40px; margin:0 auto; display:;"></div>
        </div>

        <div class="QNO"><!--NO.<a id="QANum">1</a>--></div>
        <div class="Prompt">
            <div class="QuestionTitle">问题：</div>
            <div id="Qcontent" class="QuestionContent"></div>
            <div class="clear" style="height:3px;"></div>
            <div class="PromptLeft">提示：</div>
            <div class="PromptRight">
                <div id="PromptRightLi">
                    <!--<div>1、<a></a></div>
                    <div>2、<a></a></div>
                    <div>3、<a></a></div>
                    <div>4、<a></a></div>-->
                    <img style="max-width:90%; max-height:200px;" />
                </div>
            </div>

            <div style="clear:both;"></div>
        </div>
        <div class="input_grid">
            <div class="grid"></div>
            <div class="submit_btn"><a id="btnSubmit" class="yuanjiao beijing">跳过</a></div>
            <div class="openInfo"><a></a></div>
        </div>
        <div class="change_grid">
        </div>
    </div>

    <div id="gameResult" style="position:fixed; top:0px; left:0px; width:100%; height:10000px; background:#FFEA01; z-index:9; display:none; ">
        <div style="width:auto; text-align:center; padding-top:0px; position:relative;">
            <div style="margin-top:10px;"><img id="resultLogoImg" src="images/7080_1.jpg" /></div>
            <div style="font-size:20px; margin-top:10pt">得分：<span id="sp_score"></span></div>
            <div style="margin-top:15px; font-size:18px; font-weight:bold; text-align:center;"><span id="sp_content"></span></div>
            <div style="margin-top:15px;"><a href="Default.aspx" style="font-weight:bold;font-size:18px;text-decoration:underline; color:blue; ">再试一次</a></div>
            <div style="margin-top:15px;"><img src="http://weixin.luqinwenda.com/dingyue/images/qrcode_dingyue.jpg" width="200" height="200" /></div>
        </div>
        <div id="showShare" style="display:none; z-index:10;" onclick="javascript:document.getElementById('showShare').style.display='none';">
            <div style="width:100%; height:100%; background:#ccc; color:#000; position:absolute; top:0px; left:0px; text-align:center; filter:alpha(opacity=90); -moz-opacity:0.9;-khtml-opacity: 0.9; opacity: 0.9;  z-index:9;"></div>
            <div style="width:170px; height:200px;  color:#000; position:absolute;  right:2pt; top:10pt; z-index:10; font-size:20pt;  background:url(../images/jiantou.png) no-repeat"></div>
            <div style="width:200px; height:200px;  color:#000; position:absolute; top:40pt; margin-left:70pt; z-index:20; font-size:15pt; line-height:30pt; text-align:center;">点击右上角“┇”<br />分享到朋友圈</div>
        </div>
    </div>
    <script src="script.js"></script>
</asp:Content>

