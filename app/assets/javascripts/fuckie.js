$('<DIV id="fuckie" style="BACKGROUND: url(/assets/fuckie_bg.png) #ffed9a repeat-x; HEIGHT: 86px;position:absolute;WIDTH:100%;top:0px;left:0px;"><DIV style="BACKGROUND: url(/assets/fuckie.png) no-repeat; LEFT: -2px; MARGIN: 13px auto 14px; WIDTH: 530px; POSITION: relative; HEIGHT: 59px"><A title="下载 Chrome 最新版" style="RIGHT: 158px; WIDTH: 42px; TEXT-INDENT: -9999em; POSITION: absolute; HEIGHT: 59px" href="http://www.google.com/chrome/" target=_blank  >Chrome</A> <A title="下载 Firefox 最新版" style="RIGHT: 106px; WIDTH: 43px; TEXT-INDENT: -9999em; POSITION: absolute; HEIGHT: 59px" href="http://www.mozilla.com/firefox/" target=_blank >Firefox</A> <A  title="下载 Safari 最新版" style="RIGHT: 56px; WIDTH: 38px; TEXT-INDENT: -9999em; POSITION: absolute; HEIGHT: 59px" href="http://www.apple.com/safari/download/" target=_blank  >Safari</A> <A class=IE title="下载 Internet Explorer 最新版" style="RIGHT: 0px; WIDTH: 44px; TEXT-INDENT: -9999em; POSITION: absolute; HEIGHT: 59px" href="http://windows.microsoft.com/zh-CN/internet-explorer/downloads/ie/" target=_blank>Internet Explorer</A> </DIV><S id="close_me" title=关闭 style="RIGHT: 12px; BACKGROUND: url(/assets/close_me.png) no-repeat; WIDTH: 16px; CURSOR: pointer; TEXT-INDENT: -9999em; POSITION: absolute; TOP: 12px; HEIGHT: 16px" >关闭</S> </DIV>').insertBefore($("#top"));
$("#top").css("top","86px")
$("#main").css("padding-top","188px")
$("#close_me").live("click",function(){
  $("#fuckie").remove();
  $("#top").css("top","0px")
$("#main").css("padding-top","102px")
})