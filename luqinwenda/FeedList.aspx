<%@ Page Title="" Language="C#" MasterPageFile="~/luqinwenda/Master.master" %>

<script runat="server">
    public string roomid = "2";
    public string domainName = System.Configuration.ConfigurationManager.AppSettings["domain_name"].ToString();
    protected void Page_Load(object sender, EventArgs e)
    {
        
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div id="mydiv">
        <ul id="feed_file_list" class="feed_file_list">

        </ul>
        <div style="clear:both; height:60px;"></div>
    </div>
    <script type="text/javascript">
        var textLeft = "<div class=\"text-li\"><div class=\"left-head\"><img src=\"{0}\" /></div>"
                + "<div class=\"right-content\"><div class=\"text-nick\">{1}</div>"
                + "<div class=\"text-content\">{2}</div>"
                + "<div style=\"position:absolute; left:65px; top:28px;\"><img src=\"images/jt_icon_left.png\" /></div></div>"
                + "<div class=\"clear\"></div></div>";
        var textRight = "<div class=\"text-li-right\"><div class=\"left-head\"><img src=\"{0}\" /></div>"
            + "<div class=\"right-content\"><div class=\"text-content\">{1}</div>"
            + "<div style=\"position:absolute; right:65px; top:0px;\"><img src=\"images/jt_icon_right.png\" /></div></div></div>"
            + "<div class=\"clear\"></div>";
        var voiceLeft = "<div class=\"text-li\"><div class=\"left-head\"><img src=\"{0}\" /></div>"
            + "<div class=\"right-content\"><div class=\"text-nick\">{1}</div>"
            + "<div class=\"text-content_radio\"><div id=\"jquery_jplayer_{3}\" class=\"jp-jplayer\"></div>"
            + "<div style=\"background:url(images/jplayerleft.png); width: 6px; height: 30px; top:29px; position: absolute;\"></div>"
            + "<div id=\"jp_container_{3}\" class=\"jp-audio\" role=\"application\" aria-label=\"media player\" onclick='changePlay(\"{3}\");' style=\"float:left;{6}\">"
            + "<a id=\"a_jp_play_{3}\" class=\"jp-play\" role=\"button\" tabindex=\"0\"><span class=\"jplay_play\"></span></a>"
            + "<a id=\"a_jp_stop_{3}\" class=\"jp-stop\" style=\"display: none;\" role=\"button\" tabindex=\"0\"><span class=\"jplay_stop\"></span></a>"
            + "<div class=\"jp-duration\" role=\"timer\" aria-label=\"duration\" style=\"display: none;\"></div></div>"
            + "<div style=\"float:left; line-height:36px; margin-left:8px;\">{5}”</div>"
            + "<div id=\"dot_{3}\" class=\"dots\"><img src=\"images/dots.png\"></div>"
            + "<div style=\"clear:both;\"></div><script type=\"text/javascript\">$(\"#jquery_jplayer_{3}\").jPlayer({ready: function () {$(this).jPlayer(\"setMedia\", {mp3: \"{2}\"});},play: function () {$(this).jPlayer(\"stopOthers\");},ended: function () {$(\"#jp_container_{3}\").click();$(\"#jquery_jplayer_{4}\").jPlayer(\"play\");$(\"#jp_container_{4}\").click();},swfPath: \"__THEME__/js\",supplied: \"mp3\",cssSelectorAncestor: \"#jp_container_{3}\",wmode: \"window\",globalVolume: true,useStateClassSkin: true,autoBlur: false,smoothPlayBar: true,keyEnabled: true});&lt;/script&gt;</div></div><div class=\"clear\"></div></div>";
        var voiceRight = "<div class=\"text-li-right\"><div class=\"left-head\"><img src=\"{0}\" /></div><div class=\"right-content\"><div id=\"jquery_jplayer_{2}\" class=\"jp-jplayer\"></div><div id=\"dot_{2}\" class=\"dots\"><img src=\"images/dots.png\"></div><div style=\"float:left; line-height:40px; margin-top: 5px;\">{4}”</div><div id=\"jp_container_{2}\" class=\"jp-audio\" role=\"application\" aria-label=\"media player\" onclick='changePlay(\"{2}\",\"R\");' style=\"float:left; margin-top:5px; {5}\"><a id=\"a_jp_play_{2}\" class=\"jp-play\" style=\"display:block;\" role=\"button\" tabindex=\"0\"><span class=\"jplay_play_right\"></span></a><a id=\"a_jp_stop_{2}\" class=\"jp-stop\" style=\"display: none;\" role=\"button\" tabindex=\"0\"><span class=\"jplay_stop_right jp-stop_right_3\"></span></a><div class=\"jp-duration\" role=\"timer\" aria-label=\"duration\" style=\"display: none;\"></div></div><div class=\"jt_right\"></div><div style=\"clear:both;\"></div><script type=\"text/javascript\">$(\"#jquery_jplayer_{2}\").jPlayer({ready: function () {$(this).jPlayer(\"setMedia\", {wav: \"{1}\"});},play: function () {$(this).jPlayer(\"stopOthers\");},ended: function () {$(\"#jp_container_{2}\").click();$(\"#jquery_jplayer_{3}\").jPlayer(\"play\");$(\"#jp_container_{3}\").click();},swfPath: \"__THEME__/js\",supplied: \"wav\",cssSelectorAncestor: \"#jp_container_{2}\",wmode: \"window\",globalVolume: true,useStateClassSkin: true,autoBlur: false,smoothPlayBar: true,keyEnabled: true});&lt;/script&gt;</div></div><div class=\"clear\"></div>";
        var maxid = 0;
        var roomid = '<%=roomid %>';
        var domainName = '<%=domainName %>';
        var token = '';
        var parentid = 0;
        var voiceIndex = '1';
        $(document).ready(function () {
            fillList();

            //var movepx = $('#mydiv').css('height').replace("px", "");
            //$wd = $(window);
            //$wd.scrollTop($wd.scrollTop() + parseInt(movepx));

            //var wh = document.body.clientWidth;
            //$("#textContent").css("width", (wh - 180).toString() + "px");

            //setDots();

            //setInterval("fillList()", 5000);
        });

    </script>
</asp:Content>

