<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-cmn-Hans">
<head>
    <meta charset="utf-8">
    <title>wav播放器</title>
    <style>
        body {
            margin: 0;
        }

        .wav-player__player-box {
            float: left;
            height: 45px;
            width: 80%;
        }

        .wav-player__download-box {
            float: left;
            width: 19%;
            height: 45px;
            line-height: 45px;
        }
        
        .wav-player__download-link {
            margin-left: 15px;
            padding: 4px 10px;

            border: 1px solid #eee;
            border-radius: 4px;
            background-color: #f6f6f8;
            text-decoration: none;
        }

        .wav-player__download-link:link,
        .wav-player__download-link:visited {
            color: #03a9f4;
        }

        .wav-player__download-link:hover,
        .wav-player__download-link:active {
            color: #337ab7;
        }
    </style>
</head>
<body>
<div id="wavPlayer" class="wav-player__player-box"></div>
<div class="wav-player__download-box"><a href="${audioSrc}" class="wav-player__download-link" download>下载录音</a></div>
<script src="<%=request.getContextPath()%>/script/lib/MyPlayer/MyPlayer.js"></script>
<script>
    MyPlayer.init({
        // 使用本地MyPlayer.js
        useLocal : true,
        localUrl : '<%=request.getContextPath()%>/script/lib/MyPlayer',
        baseId: 'wavPlayer',
        audioUrl: '${audioSrc}'
    });
</script>
</body>
</html>
