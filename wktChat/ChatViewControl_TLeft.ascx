<%@ Control Language="C#" ClassName="ChatViewControl_Left1" %>

<script runat="server">
    public string Chatdata = "{\"id\" : \"4\" ,\"chat_room_id\" : \"1\" ,\"user_id\" : \"18\" ,\"nick\" : \"苍杰\" ,\"avatar\" : \"http://wx.qlogo.cn/mmopen/M13tqMABLia2nXBZuRE1agtKgTkwatRicA02HNwAnzmvVvbppvCV8Zu3FtAHxt8rdgaeZHW7vhkO0VmHAFWiaGibScxM9rard5qo/0\" ,\"message_type\" : \"text\" ,\"message_content\" : \"阿德斯犯规撒旦法撒旦弃我而去围啊撒旦发射点发岁的弃我而去围绕区委我去而且为人情味儿请问我去而且为人情味儿去绕区委asdfasdfasd阿萨德人情味儿请问\" ,\"create_date\" : \"\" }";
    protected void Page_Load(object sender, EventArgs e)
    {
        System.Web.Script.Serialization.JavaScriptSerializer json = new System.Web.Script.Serialization.JavaScriptSerializer();
        Dictionary<string, object> dic = json.Deserialize<Dictionary<string, object>>(Chatdata);
        this.Img_head.ImageUrl = dic["avatar"].ToString();
        this.lbl_nick.Text = dic["nick"].ToString();
        this.lbl_content.Text = dic["message_content"].ToString();
    }
</script>

<div class="text-li">
    <div class="left-head">
        <asp:Image ID="Img_head" runat="server" />
    </div>
    <div class="right-content">
        <div class="text-nick""><asp:Literal ID="lbl_nick" runat="server"></asp:Literal></div>
        <div class="text-content"><asp:Literal ID="lbl_content" runat="server"></asp:Literal></div>
        <div style="position:absolute; left:65px; top:28px;"><img src="images/jt_icon_left.png" /></div>
    </div>
    <div class="clear"></div>
</div>

