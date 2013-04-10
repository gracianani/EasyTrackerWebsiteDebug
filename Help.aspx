<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Help.aspx.cs" Inherits="EasyTrackerSolution.Help" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>店铺助手 - 帮助</title> 
	<meta name="viewport" content="width=device-width, initial-scale=1"> 
	<link rel="stylesheet" href="http://code.jquery.com/mobile/1.2.1/jquery.mobile-1.2.1.min.css" />
	<script src="http://code.jquery.com/jquery-1.8.2.min.js"></script>
	<script src="http://code.jquery.com/mobile/1.2.1/jquery.mobile-1.2.1.min.js"></script>
</head>
<body>
    <form id="form1" runat="server">
    <div data-role="page" id="page1">
    <div data-role="content">
        <div data-role="collapsible-set">

        <div data-role="collapsible">
	    <h3>使用须知</h3>
	    <p>使用“店铺助手”时，您需要注意：<br />
          1. <strong style="font-weight:bold">全程</strong>开启3G或者wifi功能。<br />
          2. 建议一直开启GPS，签到更准确<br />
          3. 每天早晨登陆“店铺助手”，获取今日任务。 <br />
          4. 每天工作结束后，查看是否有未上传的签到或照片。<br /><br />
          您可以在“店铺助手”的“设置”中开启3G或GPS。
          </p>
        
	    </div>

        <div data-role="collapsible" >
	    <h3>门店签到流程</h3>
	    <p>1. 刷新任务 <br />
                每天早晨登陆“店铺助手”，查看当日任务。 </p>
        <p>2. 签到 <br />
                根据“今日任务”，到指定门店访查。<br />
                如果访查的门店不在“今日任务”中，可以使用“附近的店”功能找到该门店，并提交访查信息。
        </p>
        <p>
           3. 拍照片 <br />
               到达店铺后，需要拍摄店铺及货物码放状况的照片。请在“店铺助手”中进入您访查的门店，点击“拍照片”按钮。您可以添加多张照片后一起提交。
        </p>
        <p>
           4. 提交总结 <br />
              请点击“提交总结"按钮，提交对店铺情况的描述。
        </p>
        
	    </div>

	    <div data-role="collapsible" >
	    <h3>踩点</h3>
	    <p>
            <p>您可以通过“今日任务”和“附近店铺”找到店铺，进行踩点。</p>
            <p>一般来说，进入店铺周围1000米内时，您就能通过“店铺助手”签到。 </p>
            <p>如果您已经到达店铺，仍然不能签到，您可以通过“短信签到”按钮，发送手机短信进行签到。</p>
            <p>如果您访查的店铺不在“今日任务”中，可以在“附近的店”中查找。<br />如果还是未能列出该店铺，您还可以点击“手工输入门店”，进行签到。
        </p>
	    </div>
	
	    <div data-role="collapsible">
	    <h3>上传踩点和图片</h3>
	    <p>
        	您的工作情况需要上传到服务器才能被管理员查看到，请您务必每晚查看是否有未提交的图片。</p>
        <p>店铺助手会定期自动上传您的大部分踩点信息。但为了节省通讯费用，只有连接wifi时才会上传“照片”。</p>
            <p>在“上传踩点信息”中，如果右侧一栏的数字有非零项，您可以点击“立即上传”按钮。
        </p>
	    </div>
    </div>
    </div>
</div>
    </form>
</body>
</html>
