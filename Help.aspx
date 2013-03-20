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
	    <p>
            负责人需要开启手机的GPS，3G和wifi，以正常使用“店铺助手”。如果负责人未开启GPS，3G或wifi，可通过手机的系统设置页面，或点击“店铺助手”的“设置”按钮进行设置。 <br />
            负责人需要每天早晨登陆店铺助手，以获取今日任务。 <br />
            负责人需要每晚查看是否有未上传的踩点和照片。
        </p>
	    </div>

        <div data-role="collapsible" >
	    <h3>门店签到具体流程</h3>
	    <p>1. 刷新任务 <br />
                负责人需要每天早晨登陆“店铺助手”，查看当日任务。 </p>
        <p>2. 签到 <br />
                负责人需要根据“今日任务”，到指定门店访查。<br />
                负责人也可以通过“附近的店”，到达附近的店铺访查。
        </p>
        <p>
           3. 拍照片 <br />
                负责人到达店铺后，需要拍摄店铺及货物码放状况的照片。负责人需点击“拍照片”并进入拍照页面。负责人可以拍摄多张照片，并提交。
        </p>
        <p>
           4. 提交总结 <br />
                负责人可以使用“提交总结"按钮，提交对店铺情况的描述。
        </p>
        
	    </div>

	    <div data-role="collapsible" >
	    <h3>踩点</h3>
	    <p>
            踩点分为任务踩点和附近店铺踩点 <br />
            门店正常签到的范围为1000米。 <br />
            如果负责人已经到达店铺附近，但是仍然不能签到，负责人可以通过“短信签到”按钮，发送手机短信进行签到。<br />
            如果负责人未能找到店铺，可以点击进入“附近的店”。如果负责人仍未找到店铺，可以通过点击手工输入门店，进行签到。
        </p>
	    </div>
	
	    <div data-role="collapsible">
	    <h3>上传踩点和图片</h3>
	    <p>
            上传图片需要在有wifi的情况下 <br />
            负责人需要每晚查看是否有未提交的图片。<br/>
            在“上传踩点信息”中，如果右侧一栏的数字有非零项，负责人需点击“立即上传”按钮。
        </p>
	    </div>
    </div>
    </div>
</div>
    </form>
</body>
</html>
