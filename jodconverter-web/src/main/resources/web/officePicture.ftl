<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>PDF图片预览</title>
    <script src="js/lazyload.js"></script>
    <style>
        * {
            margin: 0;
            padding: 0;
        }
        html, body {
            height: 100%;
            width: 100%;
        }
        body {
            background-color: #ffffff;
        }
        .container {
            width: 100%;
            height: 100%;
        }
        .img-area {
            text-align: center
        }
        .img-scale{
            position: fixed;
            top:50%;
            right:3%;

        }
        .img-scale ul{
            list-style: none;
        }
        .img-scale ul .hide{
            display:none;
        }
        .img-scale ul .show{
            display:inline-block;
        }

    </style>
</head>
<body>
<div class="container">
    <#list imgurls as img>
        <div class="img-area">
            <img class="my-photo" alt="loading" title="查看大图" style="cursor: pointer;" data-src="${img}" src="images/loading.gif" onclick="changePreviewType('allImages')">
        </div>
    </#list>
</div>

<div class="img-scale">
    <ul>
        <li onclick="scaleImg()" class="hide"><img src="images/i-original@2x.png" alt=""></li>
        <li onclick="scaleImg()" class="show"><img src="images/i-adapt@2x.png" alt=""></li>
        <li onclick="amplifier()"><img src="images/i-enlarge@2x.png" alt=""></li>
        <li onclick="shrink()"><img src="images/i-narrow@2x.png" alt=""></li>
    </ul>
</div>

<#--
<img src="images/pdf.svg" width="63" height="63" style="position: fixed; cursor: pointer; top: 40%; right: 48px; z-index: 999;"
     alt="使用PDF预览" title="使用PDF预览" onclick="changePreviewType('pdf')"/>
-->

<script src="js/watermark.js" type="text/javascript"></script>
<script src="js/jquery-3.0.0.min.js" type="text/javascript"></script>
<script>
    window.onload = function () {
        /*初始化水印*/
        var watermarkTxt = '${watermarkTxt}';
        if (watermarkTxt !== '') {
            watermark.init({
                watermark_txt: '${watermarkTxt}',
                watermark_x: 0,
                watermark_y: 0,
                watermark_rows: 0,
                watermark_cols: 0,
                watermark_x_space: ${watermarkXSpace},
                watermark_y_space: ${watermarkYSpace},
                watermark_font: '${watermarkFont}',
                watermark_fontsize: '${watermarkFontsize}',
                watermark_color:'${watermarkColor}',
                watermark_alpha: ${watermarkAlpha},
                watermark_width: ${watermarkWidth},
                watermark_height: ${watermarkHeight},
                watermark_angle: ${watermarkAngle},
            });
        }
        checkImgs();
    };
    window.onscroll = throttle(checkImgs);
    function changePreviewType(previewType) {
        var url = window.location.href;
        if (url.indexOf("officePreviewType=image") != -1) {
            url = url.replace("officePreviewType=image", "officePreviewType="+previewType);
        } else {
            url = url + "&officePreviewType="+previewType;
        }
        if ('allImages' == previewType) {
            window.open(url)
        } else {
            window.location.href = url;
        }
    }

    var fullscreen = false;
    // 放大
    var proportion = 1;
    function amplifier() {
        proportion = proportion + 0.1;
        $(".img-area img").css("transform", "scale("+ proportion +")")
//        proportion = proportion + 0.2;
//        var Scale = document.getElementById("box-contanier");
//        Scale.style.transform = "scale("+ proportion +")";
    }
    // 缩小
    function shrink() {
        proportion = proportion - 0.1;
        $(".img-area img").css("transform", "scale("+ proportion +")")
//        $(".img-area img").css("width", width * proportion)
//        proportion = proportion - 0.2;
//        var Scale = document.getElementById("box-contanier");
//        Scale.style.transform = "scale("+ proportion +")";
    }
    // 切换图片100% 和 自适应
    function scaleImg(){
        if (fullscreen) {
            $(".img-scale li:first-child").addClass("hide").removeClass('show')
            $(".img-scale li:nth-child(2)").addClass("show").removeClass('hide')
            $(".img-area img").css("transform", "scale(1)")
            $(".img-area img").width("auto")
        }else{
            $(".img-scale li:first-child").addClass("show").removeClass('hide')
            $(".img-scale li:nth-child(2)").addClass("hide").removeClass('show')
            $(".img-area img").css("transform", "scale(1)")
            $(".img-area img").width("90%")
        }
        // 改变当前全屏状态
        fullscreen = !fullscreen;
    }
    // 切换全屏和还原
    function handleFullScreen(){
        var element = document.documentElement;
        // 判断是否已经是全屏
        // 如果是全屏，退出
        if (fullscreen) {
            $(".img-scale li:first-child").addClass("hide").removeClass('show')
            $(".img-scale li:nth-child(2)").addClass("show").removeClass('hide')
            if (document.exitFullscreen) {
                document.exitFullscreen();
            } else if (document.webkitCancelFullScreen) {
                document.webkitCancelFullScreen();
            } else if (document.mozCancelFullScreen) {
                document.mozCancelFullScreen();
            } else if (document.msExitFullscreen) {
                document.msExitFullscreen();
            }
            console.log('已还原！');
        } else {    // 否则，进入全屏
            $(".img-scale li:first-child").addClass("show").removeClass('hide')
            $(".img-scale li:nth-child(2)").addClass("hide").removeClass('show')
            if (element.requestFullscreen) {
                element.requestFullscreen();
            } else if (element.webkitRequestFullScreen) {
                element.webkitRequestFullScreen();
            } else if (element.mozRequestFullScreen) {
                element.mozRequestFullScreen();
            } else if (element.msRequestFullscreen) {
                // IE11
                element.msRequestFullscreen();
            }
            console.log('已全屏！');
        }
        // 改变当前全屏状态
        fullscreen = !fullscreen;
    }
</script>
</body>
</html>