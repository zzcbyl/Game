<%@ Control Language="C#" ClassName="ChatViewControl_VLeft1" %>

<script runat="server">
    public string Chatdata = "{\"id\" : \"5\" ,\"chat_room_id\" : \"1\" ,\"user_id\" : \"18\" ,\"nick\" : \"苍杰\" ,\"avatar\" : \"http://wx.qlogo.cn/mmopen/M13tqMABLia2nXBZuRE1agtKgTkwatRicA02HNwAnzmvVvbppvCV8Zu3FtAHxt8rdgaeZHW7vhkO0VmHAFWiaGibScxM9rard5qo/0\" ,\"message_type\" : \"voice\" ,\"message_content\" : \"http://game.luqinwenda.com/amr/sounds/PEcyJ9rpr5TUu2_pQsO-1HoUG8zc2fgadABFuO4V7ZE1XS38Aex63OyyHEVsEcUN.mp3\" ,\"create_date\" : \"\" }";
    public string index = "1";
    public string mp3url = "";
    
    protected void Page_Load(object sender, EventArgs e)
    {
        System.Web.Script.Serialization.JavaScriptSerializer json = new System.Web.Script.Serialization.JavaScriptSerializer();
        Dictionary<string, object> dic = json.Deserialize<Dictionary<string, object>>(Chatdata);
        this.Img_head.ImageUrl = dic["avatar"].ToString();
        this.lbl_nick.Text = dic["nick"].ToString();
        mp3url = dic["message_content"].ToString();
    }
</script>

<div class="text-li">
    <div class="left-head">
        <asp:Image ID="Img_head" runat="server" />
    </div>
    <div class="right-content">
        <div class="text-nick""><asp:Literal ID="lbl_nick" runat="server"></asp:Literal></div>
        <div class="text-content_radio">
            <div id="jquery_jplayer_<%=index %>" class="jp-jplayer"></div>
            <div style="background:url(images/jplayerleft.png); width: 6px; height: 30px; top:29px; position: absolute;"></div>
            <div id="jp_container_<%=index %>" class="jp-audio" role="application" aria-label="media player" onclick='changePlay("<%=index %>");' style="float:left;">
                <a id="a_jp_play_<%=index %>" class="jp-play" role="button" tabindex="0">
                    <span class="jplay_play"></span>
                </a>
                <a id="a_jp_stop_<%=index %>" class="jp-stop" style="display: none;" role="button" tabindex="0">
                    <span class="jplay_stop"></span>
                </a>
                <div class="jp-duration" role="timer" aria-label="duration" style="display: none;"></div>
            </div>
            <div style="float:left; line-height:36px; margin-left:8px;">5”</div>
            <div style="clear:both;"></div>
            <script type="text/javascript">
                $("#jquery_jplayer_<%=index %>").jPlayer({
                    ready: function () {
                        $(this).jPlayer("setMedia", {
                            mp3: "<%=mp3url %>"
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
                    supplied: "mp3",
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
    </div>
    <div class="clear"></div>
</div>

