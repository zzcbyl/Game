<%@ Control Language="C#" ClassName="ChatViewControl_VRight" %>

<script runat="server">
    public string Chatdata = "{\"id\" : \"5\" ,\"chat_room_id\" : \"1\" ,\"user_id\" : \"18\" ,\"nick\" : \"苍杰\" ,\"avatar\" : \"http://wx.qlogo.cn/mmopen/M13tqMABLia2nXBZuRE1agtKgTkwatRicA02HNwAnzmvVvbppvCV8Zu3FtAHxt8rdgaeZHW7vhkO0VmHAFWiaGibScxM9rard5qo/0\" ,\"message_type\" : \"voice\" ,\"message_content\" : \"http://game.luqinwenda.com/amr/sounds/wAHkRWaWmwua3pzRJuGvXxwQzIZydC7WdUv62cc-lWRSEQuL3qlnnz4XIU6iTNTo.mp3\" ,\"create_date\" : \"\" }";
    public string index = "1";
    public string mp3url = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        System.Web.Script.Serialization.JavaScriptSerializer json = new System.Web.Script.Serialization.JavaScriptSerializer();
        Dictionary<string, object> dic = json.Deserialize<Dictionary<string, object>>(Chatdata);
        this.Img_head.ImageUrl = dic["avatar"].ToString();
        mp3url = dic["message_content"].ToString();
    }
</script>

<div class="text-li-right">
    <div class="left-head">
        <asp:Image ID="Img_head" runat="server" />
    </div>
    <div class="right-content">
        <div id="jquery_jplayer_<%=index %>" class="jp-jplayer"></div>
        <div style="float:left; line-height:40px;">5”</div>
        <div id="jp_container_<%=index %>" class="jp-audio" role="application" aria-label="media player" onclick='changePlay("<%=index %>","R");' style="float:left;">
        <a id="a_jp_play_<%=index %>" class="jp-play" style="display:block;" role="button" tabindex="0">
            <span class="jplay_play_right"></span>
        </a>
        <a id="a_jp_stop_<%=index %>" class="jp-stop" style="display: none;" role="button" tabindex="0">
            <span class="jplay_stop_right jp-stop_right_3"></span>
        </a>
        <div class="jp-duration" role="timer" aria-label="duration" style="display: none;"></div>
        </div>
        <div style="background:url(images/jplayerright.png); width: 6px; height: 30px; right:65px; top:2px; position: absolute; z-index:9999;"></div>
        <div style="clear:both;"></div>
        <script type="text/javascript">
            $("#jquery_jplayer_<%=index %>").jPlayer({
                ready: function () {
                    $(this).jPlayer("setMedia", {
                        wav: "<%=mp3url %>"
                    });
                },
                play: function () {
                    $(this).jPlayer("stopOthers");
                },
                ended: function () {
                    $("#jp_container_<%=index %>").click();
                    $("#jquery_jplayer_<%=Convert.ToInt32(index) + 1 %>").jPlayer("play");
                    $("#jp_container_<%=Convert.ToInt32(index) + 1 %>").click();
                },
                swfPath: "__THEME__/js",
                supplied: "wav",
                cssSelectorAncestor: "#jp_container_<%=index %>",
                wmode: "window",
                globalVolume: true,
                useStateClassSkin: true,
                autoBlur: false,
                smoothPlayBar: true,
                keyEnabled: true
            });

        </script>
    </div>
    <div class="clear"></div>
</div>

