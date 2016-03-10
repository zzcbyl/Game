<%@ Page Language="C#" ValidateRequest="false" AutoEventWireup="false" %>

<!DOCTYPE html>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        Response.Write("asdfasdfasdfasdf");
        if (Request.Form["hidVal"] != null && Request.Form["hidVal"].ToString().Equals("1"))
        {
            string Title = Request.Form["inputTitle"].ToString();
            string Summary = Request.Form["inputSummary"].ToString();
            string Date = Request.Form["inputDate"].ToString();
            string Contesnt = Request.Form["container"].ToString();
            string Url = Request.Form["inputUrl"].ToString();

            
        }
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <link href="../style/bootstrap.min.css" rel="stylesheet" />
    <script src="../script/jquery-2.1.1.min.js"></script>
    <script src="../script/common.js"></script>
    <script src="../script/bootstrap.min.js"></script>
</head>
<body>
    <form id="form1" runat="server" method="post">
        <div style="height: 60px; background: #C22B2B; line-height: 60px; font-size: 28px; letter-spacing: 0.2em; color: #fff; text-align: center; font-weight: bold;">卢勤问答平台</div>
        <div class="form-horizontal" style="width: 1000px; margin: 0px auto; background: #efefef; min-height: 800px; padding: 20px;">
            <div class="form-group">
                <label for="inputTitle" class="col-sm-2 control-label">标题</label>
                <div class="col-sm-10">
                    <input type="text" class="form-control" id="inputTitle" name="inputTitle" placeholder="标题">
                </div>
            </div>
            <div class="form-group">
                <label for="inputSummary" class="col-sm-2 control-label">简介</label>
                <div class="col-sm-10">
                    <input type="text" class="form-control" id="inputSummary" name="inputSummary" placeholder="简介">
                </div>
            </div>
            <div class="form-group">
                <label for="inputDate" class="col-sm-2 control-label">日期</label>
                <div class="col-sm-10">
                    <input type="text" class="form-control" id="inputDate" name="inputDate" placeholder="2016-03-06">
                </div>
            </div>
            <div class="form-group">
                <label for="container" class="col-sm-2 control-label">内容</label>
                <div class="col-sm-10">
                    <script id="container" name="container" style="height:300px;" type="text/plain">

                    </script>
                    <script src="common/ueditor/ueditor.config.js"></script>
                    <script src="common/ueditor/ueditor.all.js"></script>
                    <!-- 实例化编辑器 -->
                    <script type="text/javascript">
                        var ue = UE.getEditor('container');
                    </script>
                </div>
            </div>
            <div class="form-group">
                <label for="uploadFile1" class="col-sm-2 control-label">头图</label>
                <div class="col-sm-10">
                    <input type="file" id="uploadFile1" name="uploadFile1" />
                    <input type="file" id="uploadFile2" name="uploadFile2" />
                </div>
            </div>
            <div class="form-group">
                <label for="inputUrl" class="col-sm-2 control-label">原文链接</label>
                <div class="col-sm-10">
                    <input type="text" class="form-control" id="inputUrl" name="inputUrl" placeholder="">
                </div>
            </div>
            <div class="form-group">
                <div class="col-sm-offset-2 col-sm-10">
                    <input type="hidden" id="hidVal" value="1" />
                    <button type="submit" class="btn btn-default">提交</button>
                    <input type="button" value="按钮" onclick="textClick();" />
                </div>
            </div>
        </div>
    </form>
    <script type="text/javascript">

        function textClick() {
            //对编辑器的操作最好在编辑器ready之后再做
            ue.ready(function () {
                //获取html内容，返回: <p>hello</p>
                var html = ue.getContent();
                alert(html);
            });
        }
        
    </script>
</body>
</html>
