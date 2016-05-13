<%@ Page Title="" Language="C#" MasterPageFile="~/luqinwenda/Master.master" %>
<%@ Import Namespace="System.Data" %>

<script runat="server">
    public string token = "e90477e2f0993c8cea841471d157caad237cfd776919dc0b28c5b51ee601b782f51f69fc";
    public string roomid = "0";
    public ArrayList chatList = new ArrayList();
    public int userid = 0;
    public string liHtml = "";
    public string domainName = System.Configuration.ConfigurationManager.AppSettings["domain_name"].ToString();
    public string canText = "0";
    public string canVoice = "0";
    public string expertlist = "";
    public DataTable dt_userinfo;
    public DataRow chatDrow = null;
    public DataTable courseDt = new DataTable();
    protected void Page_Load(object sender, EventArgs e)
    {
        roomid = Util.GetSafeRequestValue(Request, "roomid", "0");
        if (int.Parse(roomid) <= 0)
        {
            Response.Write("参数错误");
            Response.End();
            return;
        }
        
        token = Util.GetSafeRequestValue(Request, "token", "");
        userid = Users.CheckToken(token);
        if (userid <= 0)
        {
            string currentUrl = Request.Url.ToString();
            if (token != "")
                currentUrl = currentUrl.Replace("&token=" + token, "").Replace("?token=" + token, "");
            Response.Redirect("http://weixin.luqinwenda.com/authorize_final.aspx?callback=" + Server.UrlEncode(currentUrl), true);
        }

        ChatRoom chatRoom = new ChatRoom(int.Parse(roomid));
        chatDrow = chatRoom._fields;
        if (chatDrow == null)
        {
            Response.Write("参数错误");
            Response.End();
            return;
        }
        expertlist = chatDrow["expertlist"].ToString();

        if (Convert.ToDateTime(chatDrow["start_date"].ToString()) > DateTime.Now)
        {
            Response.Redirect("nostart.aspx?roomid=" + roomid);
            return;
        }

        UserChatRoomRights userChatRoom = new UserChatRoomRights(userid, int.Parse(roomid));
        if (!userChatRoom.CanEnter || !userChatRoom.CanPublishText)
        {
            Response.Redirect("wktConfirm_Integral.aspx?roomid=" + roomid);
            return;
        }

        int courseid = -1;
        if (chatDrow["courseid"].ToString().Trim() != "0")
            courseid = int.Parse(chatDrow["courseid"].ToString());
        DataTable CourseDt = Donate.getCourse(courseid);
        if (CourseDt != null && CourseDt.Rows.Count > 0)
        {
            courseDt = CourseDt;
        }
    }
    
    
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="main-header" style="">
        <div class="header-loginuser">
        </div>
        <div class="header-total">当前人数<br /><span id="personCount">-</span></div>
        <div class="header-userlist">
            
        </div>
        <div style="clear:both;"></div>

        <div style="height:180px; text-align:center; background:url(/dingyue/upload/fm_room_bg<%=roomid %>.jpg) no-repeat; background-size:100% auto; background-position-y:center;" onclick="playAudio();">
            <img id="audio_bg" style="height:100px; margin-top:50px;" src="/dingyue/upload/fm_room_bg.gif" />
            <div style="display:none;"><audio id="audio_1" controls="controls" autoplay="autoplay" src="<%=chatDrow["audio_url"].ToString() %>"></audio></div>
        </div>
    </div>
    <div id="mydiv" class="main-page" style="margin-top:240px;">
        <iframe id="iframe_list" style="width:100%; height:500px; border:none;"></iframe>
        <div id="bottomDiv" style="height: 1px; clear: both;"></div>
        <%--<div style="position: fixed; bottom: 45px; left: 0; width: 100%; text-align: center; line-height: 55px; z-index: 100;">
            <div id="input_text" style="width: auto; margin: 0 15px; background: #fff; ">
                <div style="width: auto; float: left; margin-left: 10px;">
                    <input id="textContent" type="text" style="border: 2px solid #CACACA; border-radius: 5px; width: 100%; height: 30px; line-height: 30px; padding: 2px 5px;" /></div>
                <div style="width: 90px; float: right;">
                    <input type="button" class="btn-feed-send" onclick="inputText(0);" /></div>
                <div style="clear: both;"></div>
            </div>
        </div>--%>
        <div style="position: fixed; bottom: 0; left: 0; width: 100%; background: #71b4ff; text-align: center; line-height: 45px; z-index: 100; color: #fff; font-weight: bold; font-size: 12pt; letter-spacing: 0.05em;">
            <div id="div_all" style="float: left; width: 50%; text-align: center; background: #0259bb;" onclick="Redirect(1);">全部问题</div>
            <div id="div_my" style="float: right; width: 50%; text-align: center;" onclick="Redirect(0);">我的问题</div>
        </div>
    </div>
    <script type="text/javascript">
        var userid = '<%=userid %>';
        var token = '<%=token %>';
        var roomid = '<%=roomid %>';
        var domainName = '<%=domainName %>';
        var audio;
        $(document).ready(function () {
            var winHeight = $(window).height();
            $('#iframe_list').css('height', (winHeight - 285).toString() + 'px');
            $('#iframe_list').attr('src', 'All_list.aspx?roomid=' + roomid + '&token=' + token);
            audio = document.getElementById('audio_1');
            fillHeader();
        });

        function playAudio() {
            changAudioBg();
            if (audio.paused) {
                audio.play();
                return;
            }
            audio.pause();
        }

        function changAudioBg() {
            if (!audio.paused) {
                $('#audio_bg').attr('src', '/dingyue/upload/fm_room_bg_paused.png');
            }
            else {
                $('#audio_bg').attr('src', '/dingyue/upload/fm_room_bg.gif');
            }
        }

        function Redirect(m) {
            if (m == 1) {
                $('#div_all').css('background', '#0259bb');
                $('#div_my').css('background', '');
                $('#iframe_list').attr('src', 'All_list.aspx?roomid=' + roomid + '&token=' + token);
            }
            else {
                $('#div_all').css('background', '');
                $('#div_my').css('background', '#0259bb');
                $('#iframe_list').attr('src', 'My_list.aspx?roomid=' + roomid + '&token=' + token);
            }
        }

    </script>
</asp:Content>

