# @charset "utf-8";
#= require 'jquery/form'
#= require 'jquery/scrollTo'
#= require 'jquery/autoresize'
#= require "jquery/ba-throttle-debounce"
# old comment handler
#console.debug(xhr)
#.hide().slideDown(500);
#console.debug(xhr)
#      alignTo: 'target',
window.replyComment = (comment_id, article_id, flr) ->
  article = $("#comments_article_" + article_id)
  editorTextPosition = -1
  commentArea = $("#post_content", article)
  editorPositionFunc = ->
    editorTextPosition = $(this).textPosition()

  commentArea.mouseup(editorPositionFunc).keyup editorPositionFunc
  editorTextPosition = commentArea.textPosition()  if editorTextPosition is -1
  floor = $("#post_parent_id", article).val()
  if parseInt(floor) > 0
    $("#post_content", article).textPosition $("#post_content", article).val().length, "  @" + $.trim($("#post_" + comment_id + " .nickname").text() + " ")
    $("#post_content", article).focus()
  else
    $("#post_parent_id", article).val flr
    nv = "回复" + flr + "L " + $.trim($("#post_" + comment_id + " .nickname").text()) + ": "
    $("#post_content", article).val(nv + $("#post_content", article).val()).focus().setCursorPosition nv.length

#查看某人对帖子的评论
window.show_comment_of = (me, user_login) ->
  target = "user-" + user_login
  to_show = []
  to_hide = []

  me.parents(".comments_article:first").find("ul.comments li.comment").each ->
    if @className.indexOf(target) >= 0
      to_show.push this
    else
      to_hide.push this

  $(to_show).slideDown 500
  $(to_hide).slideUp 500
window.show_all = (article_id) ->
  a = $("#comments_article_" + article_id).find("ul.comments li")
  if a.size() < 50
    a.slideDown 500
  else
    a.show()
$ ->
  return  if $("body").hasClass("my-inbox") or $("body").hasClass("my-latest")
  $("form#new_post").autoResize
    animate: true
    animateDuration: 600
    extraSpace: 0

  $("body").on "submit", "form#new_post", ->
    return false  if $.trim($("textarea", this).val()) is "" and $("input[type=file]").val() is ""
    submit_botton = $("form#new_post input[type=submit]")
    f = $(this)
    submit_botton.attr "disabled", "disabled"
    submit_botton.val "..."
    responseHandler = (data, status, xhr) ->
      if xhr.status is 200
        f.parents(".comments_article:first").find("ul.comments").append data
      else
        alert xhr.responseText
      submit_botton.removeAttr "disabled"
      submit_botton.val "回复"
      f.clearForm()
      $("#post_parent_id", f).val ""

    if f.find("input[type=file]").val() is ""
      $.post f.attr("action"), f.serialize() + "&use_theme=" + use_theme, responseHandler, "html"
    else
      $("input[name=from_xhr]", f).val 1
      f.ajaxSubmit
        data: f.serialize() + "&use_theme=" + use_theme
        success: responseHandler

    false

  $(".articles-list").on "click", "li.comment-status a", ->
    A = $(this)
    article = A.parents(".article:first")
    comments = $(".comments_article", A.parents(".article:first"))
    if comments.length > 0
      comments.toggle()
      return false
    else
      A.text "..."
      $.ajax
        type: "get"
        data:
          use_theme: use_theme

        url: A.attr("href").split("#")[0] + "/comments"
        success: (data, status, xhr) ->
          if xhr.status is 200
            $(data).appendTo article
            if article.find("ul.comments li.comment").length > 0
              A.text article.find("ul.comments li.comment").length + "条评论"
            else
              A.text "暂无评论"
          else
            alert xhr.responseText
          article.trigger "comments_loaded"

      return false

  $(".in-reply-to").click(->
    target = $(this).attr("href").replace("#", "")
    fl = $("." + target)
    fl.slideDown 1000  if fl.is(":hidden")
    $.scrollTo fl, 1000,
      offset:
        top: -100

      axis: "y"

    false
  ).poshytip
    className: "tip-green"
    offsetX: -7
    offsetY: 16
    liveEvents: true
    content: ->
      target = $(this).attr("href").replace("#", "")
      $("." + target, $(this).parents("ul.comments:first")).html()

  $(".comment .reply").poshytip
    liveEvents: true
    className: "tip-green"
    offsetX: -7
    offsetY: 16
    content: ->
      result = ""
      commented = $(".comment[data-parent_id=" + $(this).data("floor") + "]", $(this).parents("ul.comments:first"))
      if commented.length
        commented.each ->
          result += $(this).html()

      else
        result = "暂时没有针对这条评论的回复"
      result

  $("#content").on("click", "a.show_readed", ->
    myself = $(this)
    return false  if myself.hasClass("loading")
    read = myself.nextAll("li.read")
    if read.size() < 50
      read.slideDown 500
    else
      read.css "display", "block"
    myself.removeClass("show_readed").addClass "hide_readed"
    false
  ).on "click", "a.hide_readed", ->
    read = $(this).nextAll("li.read")
    if read.size() < 50
      read.slideUp 500
    else
      read.css "display", "none"
    $(this).removeClass("hide_readed").addClass "show_readed"
    false



#鼠标移到评论区域，才显示回复，删除等等链接
#$(function(){
#   $("ul.comments li").hover(function(){
#     $(this).find(".operator").show();
#   },function(){
# $(this).find(".operator").hide();
#   });
#})
#