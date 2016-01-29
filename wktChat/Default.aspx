<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="wktChat_Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div class="text-li"><div class="left-head"><img src="{0}" /></div><div class="right-content"><div class="text-nick"">{1}</div><div class="text-content_radio"><div id="jquery_jplayer_{3}" class="jp-jplayer"></div><div style="background:url(images/jplayerleft.png); width: 6px; height: 30px; top:29px; position: absolute;"></div><div id="jp_container_{3}" class="jp-audio" role="application" aria-label="media player" onclick='changePlay("{3}");' style="float:left;"><a id="a_jp_play_{3}" class="jp-play" role="button" tabindex="0"><span class="jplay_play"></span></a><a id="a_jp_stop_{3}" class="jp-stop" style="display: none;" role="button" tabindex="0"><span class="jplay_stop"></span></a><div class="jp-duration" role="timer" aria-label="duration" style="display: none;"></div></div><div style="float:left; line-height:36px; margin-left:8px;">5”</div><div style="clear:both;"></div><script type="text/javascript">$("#jquery_jplayer_{3}").jPlayer({ ready: function () { $(this).jPlayer("setMedia", { mp3: "{2}" }); }, play: function () { $(this).jPlayer("stopOthers"); }, ended: function () { $("#jp_container_{3}").click(); $("#jquery_jplayer_{4}").jPlayer("play"); $("#jp_container_{4}").click(); }, swfPath: "__THEME__/js", supplied: "mp3", cssSelectorAncestor: "#jp_container_{3}", wmode: "window", globalVolume: true, useStateClassSkin: true, autoBlur: false, smoothPlayBar: true, keyEnabled: true });</script></div></div><div class="clear"></div></div>
    </form>
</body>
</html>
