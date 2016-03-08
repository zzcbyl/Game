﻿<%@ Page Title="签到" Language="C#" MasterPageFile="~/dingyue/Master.master" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>

<script runat="server">
    public string token = "";
    public Users user = new Users();
    public string UserHeadImg = "";
    public string NickName = "匿名";
    public DataTable dtAll = new DataTable();
    public DataTable dtDate = new DataTable();
    public ArrayList IDList = new ArrayList();
    protected void Page_Load(object sender, EventArgs e)
    {
        token = Util.GetSafeRequestValue(Request, "token", "");

        if (token.Trim().Equals(""))
        {
            if (Session["user_token"] != null)
            {
                token = Session["user_token"].ToString().Trim();
            }
        }

        int userId = Users.CheckToken(token);
        if (userId <= 0)
        {
            Response.Redirect("http://weixin.luqinwenda.com/authorize_final.aspx?callback=" + Server.UrlEncode(Request.Url.ToString()), true);
        }
        Session["user_token"] = token;
        JavaScriptSerializer json = new JavaScriptSerializer();

        user = new Users(userId);
        Dictionary<string, object> dicUser = json.Deserialize<Dictionary<string, object>>(user.GetUserAvatarJson());
        if (dicUser.Keys.Contains("nickname"))
            NickName = dicUser["nickname"].ToString();
        if (dicUser.Keys.Contains("headimgurl"))
            UserHeadImg = dicUser["headimgurl"].ToString();

        
        dtDate = Article.GetDate();
        dtAll = Article.GetAll();

        DataTable MyDt = Integral.GetList(userId, 0, "article");
        foreach (DataRow item in MyDt.Rows)
        {
            if (!IDList.Contains(item["integral_type_id"].ToString()))
                IDList.Add(item["integral_type_id"].ToString());
        }
    }
</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link href="common/wx_dingyue.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div style="max-width:740px; margin:0 auto; background:#efefef; min-height:500px;">
        <div style="height:80px; width:100%; background:#C22B2B; font-family:黑体; font-size:28px; line-height:80px; font-weight:bold; border-bottom:2px solid #73556F;">
            <div style="float:left; width:70px; height:70px; margin:6px 0 0 10px; background:url(<%=UserHeadImg %>) no-repeat; background-size:70px 70px;"><img src="images/headbg.png" width="70px" /></div>
            <div style="float:left; margin-left:10px;"><%=(NickName.Length > 3 ? NickName.Substring(0, 3) + "..." : NickName) %></div>
            <div style="float:right; margin-right:10px;">积分：<span style="color:#D69100"><%=user.Integral %></span></div>
        </div>
        <div style="background:#fff; line-height:25px; padding:8px 10px; font-size:14px; color:#808080;">
            ● 转发签到文章到朋友圈可得1分，朋友转发您的签到文章您可以再得到1分，每天每人最多可积10分。<br />
            ● 集满30分即可获得收听卢勤微课堂视频直播资格。
        </div>
        <% for (int i = 0; i < dtDate.Rows.Count; i++)
           {
               %>
            <div style="margin:5px; border:1px solid #DBDBDB;">
                <div style="height:35px; line-height:35px; font-family:黑体; font-size:18px; font-weight:bold; border:1px solid #fff; padding:0 10px; background:#D9D9D9;">
                    <%=Convert.ToDateTime(dtDate.Rows[i][0].ToString()).ToString("MM月dd日") %>
                </div>
                <div style="background:#fff; font-size:14px; line-height:22px;">

                    <% 
                       DataRow[] drowArr = dtAll.Select("article_date='" + dtDate.Rows[i][0].ToString() + "'");
                       string headImgSrc = "";
                       string RedPoint = "";
                       foreach (var drow in drowArr)
                       {
                           RedPoint = "";
                           headImgSrc = drow["article_headimg"].ToString();
                           if (IDList.Contains(drow["article_id"].ToString()))
                           {
                               //headImgSrc = drow["article_headimg"].ToString().Split('.')[0] + "_gray." + drow["article_headimg"].ToString().Split('.')[1];
                               headImgSrc = drow["article_headimg"].ToString().Substring(0, drow["article_headimg"].ToString().LastIndexOf('.')) + "_gray" + drow["article_headimg"].ToString().Substring(drow["article_headimg"].ToString().LastIndexOf('.'));
                           }
                           else
                           {
                               if (DateTime.Now.ToString("yyyy-MM-dd") == dtDate.Rows[i][0].ToString())
                               {
                                   RedPoint = "<i class=\"i_icon\" style=\"position:absolute; left:55px; top:2px;\"></i>";
                               }
                           }
                           
                      %>
                        <div style="border-top:1px solid #f3f3f3; height:50px; padding:5px 10px;  position:relative;" onclick="jumpUrl(<%=drow["article_id"].ToString() %>);">
                            <div style="width:50px; height:50px;">
                                <img src="<%=headImgSrc %>" width="50px" />
                                <%=RedPoint %>
                            </div>
                            <div style="position:absolute; left:70px; top:5px; "><%=drow["article_title"].ToString() %></div>
                            <div style="clear:both;"></div>
                        </div>
                   <%} %>
                </div>
            </div>

        <%
           } %>
        
    </div>
    <script type="text/javascript">
        function jumpUrl(id) {
            location.href = "activity01.aspx?articleid=" + id;
        }
    </script>
</asp:Content>

