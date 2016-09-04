$(function() {

  if($.cookie("total")!=undefined&&$.cookie("total")!='NaN'&&$.cookie("total")!='null'){//cookie存在倒计时
    timekeeping();
  }else{//cookie 没有倒计时
    $('#send_verification_code').attr("disabled", false);
  }

  $("#send_verification_code").click(function() {
    phoneNumber = $.trim($("#user_phone_number").val())
    if(phoneNumber != undefined && phoneNumber != "") {
      $('#send_verification_code').attr("disabled", true);
      send_verification_code(phoneNumber);
    } else {
      alert("请先输入手机号码")
    }
  })

})

function timekeeping(){
    //把按钮设置为不可以点击
    $('#send_verification_code').attr("disabled", true);
    var interval=setInterval(function(){//每秒读取一次cookie
      //从cookie 中读取剩余倒计时
      total=$.cookie("total");
      //在发送按钮显示剩余倒计时
      $('#send_verification_code').val('请等待'+total+'秒');
      //把剩余总倒计时减掉1
      total--;

      if(total==0){//剩余倒计时为零，则显示 重新发送，可点击
      //清除定时器
      clearInterval(interval);
      //删除cookie
      total=$.cookie("total",total, { expires: -1 });

      //显示重新发送
      $('#send_verification_code').val('重新发送');
      //把发送按钮设置为可点击
      $('#send_verification_code').attr("disabled", false);
      }else{//剩余倒计时不为零

      //重新写入总倒计时
      $.cookie("total",total);
      }
    },1000);

  }

function send_verification_code(phoneNumber) {
  geetestChallenge = $("input[name='geetest_challenge']").val();
  geetestValidate = $("input[name='geetest_validate']").val();
  geetestSeccode = $("input[name='geetest_seccode']").val();

  $.ajax({
    url: "/account/users/"+ Math.floor((Math.random() * 10) + 1) +"/send_verification_code",
    method: "post",
    data: {phone_number: phoneNumber, geetest_challenge: geetestChallenge, geetest_validate: geetestValidate, geetest_seccode: geetestSeccode},
    dataType: "json",
    success: function(data){
      if(data.status == "n") {
        // window.location.href = data.url;
        // console.log($("#flashmessage").html())
        $(".navbar-fixed-top").next(".row").prepend("<div class='alert alert-dismissable alert-danger'><button class='close' data-dismiss='alert'>×</button>请先滑动滑块</div>")
        $('#send_verification_code').attr("disabled", false);
      } else {
        $.cookie("total", 60);
        timekeeping();
      }
    }
  });
}
;
var planIndex = 1;
var projectId;
var planQueue = [-1, 0];
var flowType = "";

function showError(error, containerId) {
  $(".alert-danger").remove();
  $("#" + containerId).find(".row:visible").first().prepend("<div class='alert alert-dismissable alert-danger'><button class='close' data-dismiss='alert'>×</button>" + error + "</div>");
  $("html, body").animate({
      scrollTop: 0
  }, 200);
  return false;
}

$(function() {
  flowType = $("#flowType").val();
  projectId = $("#projectId").val();
  if (flowType == "edit") {
    $("input[name='_method']").val("post");
  }
  var fromId = (flowType == "edit" ? "#edit_project_" + projectId : "#new_project");
  $("#nextStep").click(function() {
    $(fromId).attr("action", "/account/projects");
    $(fromId).submit();
  });

  $("#preStep").click(function() {
    containerToggle();
    stepToggle();
  });

  $("#preview").click(function() {
    window.open(
      "/projects/" + projectId + "/preview",
      '_blank' // <- This is what makes it open in a new window.
    );
  });

  $("#generateNewPlanContainer").click(function() {
    fillPlanInfo(showPlan(flowType));
    increaseNum();
    $("html, body").animate({
        scrollTop: (0,document.body.scrollHeight)
    }, 600);

    return false;
    // $("#plan" + (planIndex) + "container").siblings().each(function(index) {
    //   $(this).children().each(function(index) {
    //     console.log($(this))
    //     console.log(index)
    //     if (index == 0) {
    //       $(this).show();
    //     } else {
    //       $(this).hide();
    //     }
    //   });
    // });
  });

  $("#applyVerify").click(function() {
    $(this).attr("disabled", true);
    var postUrl = "/account/projects/" + projectId + "/apply_for_verification_new/";
    $.ajax({
      type: "POST",
      url: postUrl,
      dataType: "json",
      success: function(data) {
        $("#applyVerify").attr("disabled", false);
        if (data.status == "y") {
          showSuccess(data.message);
        } else if (data.status == "e") {
          showError(data.message, "plansInfor");
        } else if (data.status == "verifyID") {
          // alert("身份认证");
          showMobileVerify();
          showError(data.message, "mobileContainer");
        }else {
          alert("What?");
        }
      }
    });
  });

  $(fromId).ajaxForm({
    success: function(data) {
      $("#new_project").find(":submit").attr("disabled", false);
      if (data.status == "y") {
        $("#projectInfor").hide();
        fillPlanInfo(showPlan(flowType));
        increaseNum();
        // $("#plansInfor").append(showPlan())
        stepToggle();
        projectId = data.project_id;
        $(".newPlan").show();
      } else if(data.status == "r") {
        if (flowType == "edit") {
          generatePlans();
        }
        containerToggle();
        stepToggle();
      } else {
        var errors = data.errors
        if (data.message != undefined) {
          showError(data.message, "projectInfor");
        }
        if (errors.name != undefined) {
          showError("项目名称不能为空", "projectInfor");
        } else if (errors.description != undefined) {
          showError("项目描述不能为空", "projectInfor");
        } else if (errors.fund_goal != undefined) {
          showError("筹款目标要大于 0 小于 1_000_000", "projectInfor");
        }
        window.scrollTo(0, 0);
      }
    }
  });

})
// TODO: 实现当为编辑状态时去后台获得 plan 信息，然后填充页面，改变 planQueue
function generatePlans() {

}


function increaseNum() {
  planIndex++;
  var index = getCurrentPlanIndex(flowType, planIndex);
  planQueue[index] = 1;
  planQueue.push(0);
}

// TODO: 实现当为编辑状态时去后台获得 plan 信息，然后填充页面，改变 planQueue
function generatePlans() {
  $.ajax({
    url: "/account/projects/" + projectId + "/plans/get_plans/",
    method: "get",
    dataType: "json",
    success: function(data){
      if (data.length == 0) {
        fillPlanInfo(showPlan(""));
        flowType = "";
        increaseNum();
      } else {
        planIndex = 0;
        planQueue = [-1];
        $.each(data, function(index, item) {
          planIndex++;
          planQueue.push(1);
          fillPlanInfo(showPlan("edit", item));
          showPlanInforB(planIndex);
        });
        flowType = "";
        planQueue.push(0);
      }
    }
  });
}

function showSuccess(message) {
  // $("#successContainer").siblings().hide();
  $(".addflow-container").not($("#successContainer")).hide();
  var content = "";
  content = "<div class='row'>" +
              "<div class='col-md-4 col-md-offset-4 well project-well text-center'>" +
                "<p><i class='fa fa-check-circle project-circle fa-5x' aria-hidden='true'></i></p>" +
                "<p>" + message + "</p>"
              "</div>" +
            "</div>";

  $("#successContainer").append(content);
  $("#successContainer").show();
}

function showMobileVerify() {
  $(".addflow-container").not($("#mobileContainer")).hide();
  // $("#mobileContainer").siblings().hide();
  var content = "";
  content = "<div class='row'>" +
              "<div class='col-md-4 col-md-offset-4 well project-well text-center'>" +
                "<h2>验证手机</h2>" +
                "<form id='verify_phone_number' action='/account/users/2/verify_phone_number_new' method='post'>" +
                  "<div class='form-group'>" +
                   "<input type='tel' placeholder='请输入手机号码' id='user_phone_number' name='user[phone_number]' class='string tel required form-control'>" +
                  "</div>" +
                  "<div class='form-inline'>" +
                    "<input type='text' id='user_captcha' name='user[captcha]' placeholder='请输入验证码' class='string required form-control '>" +
                    "<input type='button' class='btn btn-sm btn-default' value='发送短信验证码' id='send_verification_code'>" +
                  "</div><br />" +
                  "<div class='form-inline'>" +
                    "<input type='submit' class='btn btn-success form-control' value='提交'/>" +
                    "<a href='/account/projects/' class='btn btn-default form-control'>返回用户中心</a>" +
                  "</div>" +
                "</form>" +
              "</div>" +
            "</div>";
  $("#mobileContainer").append(content);
$("#mobileContainer").show();
  $("#verify_phone_number").ajaxForm({
    success: function(data) {
      var status = data.status
      var message = data.message
      if (status == "y") {
        // showSuccess(message)
        $("#applyVerify").click()

      } else if (status == "n") {
        showError(message, "mobileContainer");
      } else {
        showError(message, "mobileContainer");
      }
    }
  });


  $("#send_verification_code").bind("click", function() {
    phoneNumber = $.trim($("#user_phone_number").val())
    if(phoneNumber != undefined && phoneNumber != "") {
      $('#send_verification_code').attr("disabled", true);
      send_verification_code(phoneNumber);
    } else {
      alert("请先输入手机号码");
    }
  });
}

function showMobileVerify() {
  $(".addflow-container").hide();
  $("#mobileContainer").siblings().hide();
  var content = "";
  content = "<div class='row'>" +
              "<div class='col-md-4 col-md-offset-4 well project-well text-center'>" +
                "<h2>验证手机</h2>" +
                "<form>" +
                  "<div class='form-group'>" +
                   "<input type='tel' placeholder='请输入手机号码' id='user_phone_number' name='user[phone_number]' class='string tel required form-control'>" +
                  "</div>" +
                  "<div class='form-inline'>" +
                    "<input type='text' id='user_captcha' name='user[captcha]' placeholder='请输入验证码' class='string required form-control '>" +
                    "<input type='button' class='btn btn-sm btn-default' value='发送短信验证码' id='send_verification_code'>" +
                  "</div>" +
                  "<div class='form-group'>" +
                    "<a href='/account/projects/' class='btn btn-default'>返回用户中心</a>"
                  "</div>" +
                "</form>" +
              "</div>" +
            "</div>";
  $("#mobileContainer").append(content);
  $("#send_verification_code").bind("click", function() {
    phoneNumber = $.trim($("#user_phone_number").val())
    if(phoneNumber != undefined && phoneNumber != "") {
      $('#send_verification_code').attr("disabled", true);
      send_verification_code(phoneNumber);
    } else {
      alert("请先输入手机号码");
    }
  });
}

function fillPlanInfo(content) {
  $("#plansInfor").append(content);
  $("#generateNewPlanContainer").hover(function() {
    $(this).css('cursor', 'pointer');
  });

  $("#savePlan" + planIndex).bind("click", function() {
    var planNum = $(this).attr("planNum");
    createPlan(projectId, planNum);
  });
  $(".removePlan" + planIndex).bind("click", function() {
    var planNum = $(this).attr("planNum");
    var planId = $(".removePlan" + planNum).first().attr("planId");
    removePlan(planId, planNum);
  });
}

function showPlanInforB(planNum) {
  $("#plan" + planNum + "A").hide();
  var planPrice = $("#plan_price" + planNum).val();
  var planGoal = $("#plan_plan_goal" + planNum).val();
  var planDescription = $("#plan_descrition" + planNum).val();
  var planIndex = $("#plan" + planNum + "A").find("h1").text().match(/\d/g).join("");
  var content = generatePlanB(planPrice, planGoal, planDescription, planIndex, planNum);
  $("#plan" + planNum + "B").append(content);
  refreshPlanNum();

  $(".removePlan" + planNum).bind("click", function() {
    var planNum = $(this).attr("planNum");
    var planId = $(".removePlan" + planNum).first().attr("planId");
    removePlan(planId, planNum);
  });


  $("#showPlan" + planNum + "A").bind("click", function() {
    planABToggle(planNum);
  });

  $("#plan" + planNum + "B").show();
}

function createPlan(projectId, planNum) {
  var postData = $("#plan" + planNum + "InforForm").serializeArray();
  $.ajax({
    url: "/account/projects/" + projectId + "/plans/create_plan/",
    method: "post",
    data: postData,
    dataType: "json",
    success: function(data){
      // $("#applyVerify").attr("disabled", false);
      if (data.status == "y") {
        $(".removePlan" + planNum).attr("planId", data.plan_id);
        $("#plan" + planNum + "InforForm").append("<input type='hidden' name='plan_id' value='" + data.plan_id + "'>");
        showPlanInforB(planNum);
      } else if (data.status == "customerror") {
        showError(data.message, "plansInfor");
      } else if (data.status == "r") {
        planABToggle(planNum);
      } else {
        var errors = data.errors
        if (errors.description != undefined) {
          showError("回报内容不能为空", "plansInfor");
        } else if (errors.price != undefined) {
          showError("支持金额不能为空", "plansInfor");
        } else if (errors.plan_goal != undefined) {
          showError("人数上限不能为空", "plansInfor");
        }
      }
    }
  });
}

function getCurrentPlanIndex(flowType, planIndex) {
  if (flowType == "edit") {
    return planIndex;
  } else {
    var planIndex = planQueue.indexOf(0);
    return planIndex;
  }
}

function showPlan(flowType, data) {
  var content = '';
  content = "<div id=plan" + planIndex + "container>" +
            "<div id='plan" + planIndex + "B'></div>" +
            "<div id='plan" + planIndex + "A'>" +
              "<div class='row'>" +
                "<div class='col-md-4 col-md-offset-4 well project-well'>" +
                  "<h1>回报" + getCurrentPlanIndex(flowType, planIndex) + "设置</h1>" +
                    generateForm(flowType, data) +
                "</div>" +
              "</div>" +
            "</div>"+
            "</div>";

            // console.log(content);
  return content;
}

function removePlan(planId, planNum) {
  var planIndex = planQueue.indexOf(0);
  planQueue.splice(planIndex, 1);
  // planQueue.push(0);
  if (planId != undefined) {
    $.ajax({
      url: "/account/projects/" + projectId + "/plans/" + planId + "/",
      method: "delete",
      dataType: "json",
      success: function(data){
        if (data.status == "y") {

        }
      }
    });
  }
  removePlanContainer(planNum);
}

function removePlanContainer(planNum) {
  $("#plan" + planNum + "container").remove();
  refreshPlanNum();
}

function refreshPlanNum() {
  $("#plansInfor").children().each(function(index) {
    $(this).find("h1").text("回报" + (index + 1) + "设置");
    $(this).find("h3").text("回报" + (index + 1));
  });
}

function generateForm(flowType, data) {
  if (flowType == "edit") {
    var content = "<form id='plan" + planIndex + "InforForm'><div class='form-group'><div class='form-group integer required plan_price'><label class='integer required control-label' for='plan_price'><abbr title='required'>*</abbr> 支持金额</label><input class='numeric integer required edit-input-short-width form-control' type='number' step='1' name='plan[price]' value='"+data.price+"' id='plan_price" + planIndex + "'></div><p><strong>回报内容</strong></p><textarea id='plan_descrition" + planIndex + "' class='form-control' rows='3' name='plan[description]'>" + data.description + "</textarea><div class='form-group integer required plan_plan_goal'><label class='integer required control-label' for='plan_plan_goal'><abbr title='required'>*</abbr> 人数上限</label><input class='numeric integer required edit-input-short-width form-control' value='" + data.plan_goal + "' type='number' step='1' name='plan[plan_goal]' id='plan_plan_goal" + planIndex + "'></div></form><input type='button' class='btn btn-success pull-right' planNum='" + planIndex + "' id='savePlan" + planIndex + "' value='保存'/><input type='button' class='btn btn-danger pull-right removePlan" + planIndex + "' data-confirm='确认删除该方案么?' planNum='" + planIndex + "' value='删除'/>";
    return content;
  } else {
    var content = "<form id='plan" + planIndex + "InforForm'><div class='form-group'><div class='form-group integer required plan_price'><label class='integer required control-label' for='plan_price'><abbr title='required'>*</abbr> 支持金额</label><input class='numeric integer required edit-input-short-width form-control' type='number' step='1' name='plan[price]' id='plan_price" + planIndex + "'></div><p><strong>回报内容</strong></p><textarea id='plan_descrition" + planIndex + "' class='form-control' rows='3' name='plan[description]'></textarea><div class='form-group integer required plan_plan_goal'><label class='integer required control-label' for='plan_plan_goal'><abbr title='required'>*</abbr> 人数上限</label><input class='numeric integer required edit-input-short-width form-control' type='number' step='1' name='plan[plan_goal]' id='plan_plan_goal" + planIndex + "'></div></form><input type='button' class='btn btn-success pull-right' planNum='" + planIndex + "' id='savePlan" + planIndex + "' value='保存'/><input type='button' class='btn btn-danger pull-right removePlan" + planIndex + "' data-confirm='确认删除该方案么?' planNum='" + planIndex + "' value='删除'/>";
    return content;
  }
}

function stepToggle() {
  if ($(".stepone").is(":visible")) {
    $(".stepone").hide();
    $(".steptwo").show();
  } else {
    $(".stepone").show();
    $(".steptwo").hide();
  }
}

function planABToggle(planNum) {
  if ($("#plan" + planNum + "A").is(":visible")) {
    $("#plan" + planNum + "A").hide();
    $("#plan" + planNum + "B").show();
  } else {
    $("#plan" + planNum + "A").show();
    $("#plan" + planNum + "B").hide();
  }
  refreshPlanB(planNum)
}

function refreshPlanB(planNum) {
  var planPrice = $("#plan_price" + planNum).val();
  var planGoal = $("#plan_plan_goal" + planNum).val();
  var planDescription = $("#plan_descrition" + planNum).val();
  $("#plan" + planNum + "B").find("p").first().text("¥ " + planPrice + " 限 " + planGoal + "人");
  $("#plan" + planNum + "B").find("p").last().text(planDescription)
}

function containerToggle() {
  if ($("#projectInfor").is(":visible")) {
    $("#projectInfor").hide();
    $("#plansInfor").show();
    $(".newPlan").show();
  } else {
    $("#projectInfor").show();
    $("#plansInfor").hide();
    $(".newPlan").hide();
  }
}

function generatePlanB(planPrice, planGoal, planDescription, planIndex, planNum) {
  var content = "<div class='row'>" +
              "<div class='col-md-4 col-md-offset-4 well project-well'>" +
                "<h3>回报" + planIndex + "</h3>" +
                "<p>¥ " + planPrice + " 限 " + planGoal + "人</p>" +
                "<p>" + planDescription + "</p>"+
                "<input type='button' class='btn btn-success pull-right' planNum='" + planNum + "' id='showPlan" + planNum + "A' value='修改'/><input type='button' class='btn btn-danger pull-right removePlan" + planNum + "' data-confirm='确认删除该方案么?' planNum='" + planNum + "' value='删除'/>"
              "</div>" +
            "</div>";
  return content;
}
;
/*!
 * jQuery Form Plugin
 * version: 3.51.0-2014.06.20
 * Requires jQuery v1.5 or later
 * Copyright (c) 2014 M. Alsup
 * Examples and documentation at: http://malsup.com/jquery/form/
 * Project repository: https://github.com/malsup/form
 * Dual licensed under the MIT and GPL licenses.
 * https://github.com/malsup/form#copyright-and-license
 */

!function(e){"use strict";"function"==typeof define&&define.amd?define(["jquery"],e):e("undefined"!=typeof jQuery?jQuery:window.Zepto)}(function(e){"use strict";function t(t){var r=t.data;t.isDefaultPrevented()||(t.preventDefault(),e(t.target).ajaxSubmit(r))}function r(t){var r=t.target,a=e(r);if(!a.is("[type=submit],[type=image]")){var n=a.closest("[type=submit]");if(0===n.length)return;r=n[0]}var i=this;if(i.clk=r,"image"==r.type)if(void 0!==t.offsetX)i.clk_x=t.offsetX,i.clk_y=t.offsetY;else if("function"==typeof e.fn.offset){var o=a.offset();i.clk_x=t.pageX-o.left,i.clk_y=t.pageY-o.top}else i.clk_x=t.pageX-r.offsetLeft,i.clk_y=t.pageY-r.offsetTop;setTimeout(function(){i.clk=i.clk_x=i.clk_y=null},100)}function a(){if(e.fn.ajaxSubmit.debug){var t="[jquery.form] "+Array.prototype.join.call(arguments,"");window.console&&window.console.log?window.console.log(t):window.opera&&window.opera.postError&&window.opera.postError(t)}}var n={};n.fileapi=void 0!==e("<input type='file'/>").get(0).files,n.formdata=void 0!==window.FormData;var i=!!e.fn.prop;e.fn.attr2=function(){if(!i)return this.attr.apply(this,arguments);var e=this.prop.apply(this,arguments);return e&&e.jquery||"string"==typeof e?e:this.attr.apply(this,arguments)},e.fn.ajaxSubmit=function(t){function r(r){var a,n,i=e.param(r,t.traditional).split("&"),o=i.length,s=[];for(a=0;o>a;a++)i[a]=i[a].replace(/\+/g," "),n=i[a].split("="),s.push([decodeURIComponent(n[0]),decodeURIComponent(n[1])]);return s}function o(a){for(var n=new FormData,i=0;i<a.length;i++)n.append(a[i].name,a[i].value);if(t.extraData){var o=r(t.extraData);for(i=0;i<o.length;i++)o[i]&&n.append(o[i][0],o[i][1])}t.data=null;var s=e.extend(!0,{},e.ajaxSettings,t,{contentType:!1,processData:!1,cache:!1,type:u||"POST"});t.uploadProgress&&(s.xhr=function(){var r=e.ajaxSettings.xhr();return r.upload&&r.upload.addEventListener("progress",function(e){var r=0,a=e.loaded||e.position,n=e.total;e.lengthComputable&&(r=Math.ceil(a/n*100)),t.uploadProgress(e,a,n,r)},!1),r}),s.data=null;var c=s.beforeSend;return s.beforeSend=function(e,r){r.data=t.formData?t.formData:n,c&&c.call(this,e,r)},e.ajax(s)}function s(r){function n(e){var t=null;try{e.contentWindow&&(t=e.contentWindow.document)}catch(r){a("cannot get iframe.contentWindow document: "+r)}if(t)return t;try{t=e.contentDocument?e.contentDocument:e.document}catch(r){a("cannot get iframe.contentDocument: "+r),t=e.document}return t}function o(){function t(){try{var e=n(g).readyState;a("state = "+e),e&&"uninitialized"==e.toLowerCase()&&setTimeout(t,50)}catch(r){a("Server abort: ",r," (",r.name,")"),s(k),j&&clearTimeout(j),j=void 0}}var r=f.attr2("target"),i=f.attr2("action"),o="multipart/form-data",c=f.attr("enctype")||f.attr("encoding")||o;w.setAttribute("target",p),(!u||/post/i.test(u))&&w.setAttribute("method","POST"),i!=m.url&&w.setAttribute("action",m.url),m.skipEncodingOverride||u&&!/post/i.test(u)||f.attr({encoding:"multipart/form-data",enctype:"multipart/form-data"}),m.timeout&&(j=setTimeout(function(){T=!0,s(D)},m.timeout));var l=[];try{if(m.extraData)for(var d in m.extraData)m.extraData.hasOwnProperty(d)&&l.push(e.isPlainObject(m.extraData[d])&&m.extraData[d].hasOwnProperty("name")&&m.extraData[d].hasOwnProperty("value")?e('<input type="hidden" name="'+m.extraData[d].name+'">').val(m.extraData[d].value).appendTo(w)[0]:e('<input type="hidden" name="'+d+'">').val(m.extraData[d]).appendTo(w)[0]);m.iframeTarget||v.appendTo("body"),g.attachEvent?g.attachEvent("onload",s):g.addEventListener("load",s,!1),setTimeout(t,15);try{w.submit()}catch(h){var x=document.createElement("form").submit;x.apply(w)}}finally{w.setAttribute("action",i),w.setAttribute("enctype",c),r?w.setAttribute("target",r):f.removeAttr("target"),e(l).remove()}}function s(t){if(!x.aborted&&!F){if(M=n(g),M||(a("cannot access response document"),t=k),t===D&&x)return x.abort("timeout"),void S.reject(x,"timeout");if(t==k&&x)return x.abort("server abort"),void S.reject(x,"error","server abort");if(M&&M.location.href!=m.iframeSrc||T){g.detachEvent?g.detachEvent("onload",s):g.removeEventListener("load",s,!1);var r,i="success";try{if(T)throw"timeout";var o="xml"==m.dataType||M.XMLDocument||e.isXMLDoc(M);if(a("isXml="+o),!o&&window.opera&&(null===M.body||!M.body.innerHTML)&&--O)return a("requeing onLoad callback, DOM not available"),void setTimeout(s,250);var u=M.body?M.body:M.documentElement;x.responseText=u?u.innerHTML:null,x.responseXML=M.XMLDocument?M.XMLDocument:M,o&&(m.dataType="xml"),x.getResponseHeader=function(e){var t={"content-type":m.dataType};return t[e.toLowerCase()]},u&&(x.status=Number(u.getAttribute("status"))||x.status,x.statusText=u.getAttribute("statusText")||x.statusText);var c=(m.dataType||"").toLowerCase(),l=/(json|script|text)/.test(c);if(l||m.textarea){var f=M.getElementsByTagName("textarea")[0];if(f)x.responseText=f.value,x.status=Number(f.getAttribute("status"))||x.status,x.statusText=f.getAttribute("statusText")||x.statusText;else if(l){var p=M.getElementsByTagName("pre")[0],h=M.getElementsByTagName("body")[0];p?x.responseText=p.textContent?p.textContent:p.innerText:h&&(x.responseText=h.textContent?h.textContent:h.innerText)}}else"xml"==c&&!x.responseXML&&x.responseText&&(x.responseXML=X(x.responseText));try{E=_(x,c,m)}catch(y){i="parsererror",x.error=r=y||i}}catch(y){a("error caught: ",y),i="error",x.error=r=y||i}x.aborted&&(a("upload aborted"),i=null),x.status&&(i=x.status>=200&&x.status<300||304===x.status?"success":"error"),"success"===i?(m.success&&m.success.call(m.context,E,"success",x),S.resolve(x.responseText,"success",x),d&&e.event.trigger("ajaxSuccess",[x,m])):i&&(void 0===r&&(r=x.statusText),m.error&&m.error.call(m.context,x,i,r),S.reject(x,"error",r),d&&e.event.trigger("ajaxError",[x,m,r])),d&&e.event.trigger("ajaxComplete",[x,m]),d&&!--e.active&&e.event.trigger("ajaxStop"),m.complete&&m.complete.call(m.context,x,i),F=!0,m.timeout&&clearTimeout(j),setTimeout(function(){m.iframeTarget?v.attr("src",m.iframeSrc):v.remove(),x.responseXML=null},100)}}}var c,l,m,d,p,v,g,x,y,b,T,j,w=f[0],S=e.Deferred();if(S.abort=function(e){x.abort(e)},r)for(l=0;l<h.length;l++)c=e(h[l]),i?c.prop("disabled",!1):c.removeAttr("disabled");if(m=e.extend(!0,{},e.ajaxSettings,t),m.context=m.context||m,p="jqFormIO"+(new Date).getTime(),m.iframeTarget?(v=e(m.iframeTarget),b=v.attr2("name"),b?p=b:v.attr2("name",p)):(v=e('<iframe name="'+p+'" src="'+m.iframeSrc+'" />'),v.css({position:"absolute",top:"-1000px",left:"-1000px"})),g=v[0],x={aborted:0,responseText:null,responseXML:null,status:0,statusText:"n/a",getAllResponseHeaders:function(){},getResponseHeader:function(){},setRequestHeader:function(){},abort:function(t){var r="timeout"===t?"timeout":"aborted";a("aborting upload... "+r),this.aborted=1;try{g.contentWindow.document.execCommand&&g.contentWindow.document.execCommand("Stop")}catch(n){}v.attr("src",m.iframeSrc),x.error=r,m.error&&m.error.call(m.context,x,r,t),d&&e.event.trigger("ajaxError",[x,m,r]),m.complete&&m.complete.call(m.context,x,r)}},d=m.global,d&&0===e.active++&&e.event.trigger("ajaxStart"),d&&e.event.trigger("ajaxSend",[x,m]),m.beforeSend&&m.beforeSend.call(m.context,x,m)===!1)return m.global&&e.active--,S.reject(),S;if(x.aborted)return S.reject(),S;y=w.clk,y&&(b=y.name,b&&!y.disabled&&(m.extraData=m.extraData||{},m.extraData[b]=y.value,"image"==y.type&&(m.extraData[b+".x"]=w.clk_x,m.extraData[b+".y"]=w.clk_y)));var D=1,k=2,A=e("meta[name=csrf-token]").attr("content"),L=e("meta[name=csrf-param]").attr("content");L&&A&&(m.extraData=m.extraData||{},m.extraData[L]=A),m.forceSync?o():setTimeout(o,10);var E,M,F,O=50,X=e.parseXML||function(e,t){return window.ActiveXObject?(t=new ActiveXObject("Microsoft.XMLDOM"),t.async="false",t.loadXML(e)):t=(new DOMParser).parseFromString(e,"text/xml"),t&&t.documentElement&&"parsererror"!=t.documentElement.nodeName?t:null},C=e.parseJSON||function(e){return window.eval("("+e+")")},_=function(t,r,a){var n=t.getResponseHeader("content-type")||"",i="xml"===r||!r&&n.indexOf("xml")>=0,o=i?t.responseXML:t.responseText;return i&&"parsererror"===o.documentElement.nodeName&&e.error&&e.error("parsererror"),a&&a.dataFilter&&(o=a.dataFilter(o,r)),"string"==typeof o&&("json"===r||!r&&n.indexOf("json")>=0?o=C(o):("script"===r||!r&&n.indexOf("javascript")>=0)&&e.globalEval(o)),o};return S}if(!this.length)return a("ajaxSubmit: skipping submit process - no element selected"),this;var u,c,l,f=this;"function"==typeof t?t={success:t}:void 0===t&&(t={}),u=t.type||this.attr2("method"),c=t.url||this.attr2("action"),l="string"==typeof c?e.trim(c):"",l=l||window.location.href||"",l&&(l=(l.match(/^([^#]+)/)||[])[1]),t=e.extend(!0,{url:l,success:e.ajaxSettings.success,type:u||e.ajaxSettings.type,iframeSrc:/^https/i.test(window.location.href||"")?"javascript:false":"about:blank"},t);var m={};if(this.trigger("form-pre-serialize",[this,t,m]),m.veto)return a("ajaxSubmit: submit vetoed via form-pre-serialize trigger"),this;if(t.beforeSerialize&&t.beforeSerialize(this,t)===!1)return a("ajaxSubmit: submit aborted via beforeSerialize callback"),this;var d=t.traditional;void 0===d&&(d=e.ajaxSettings.traditional);var p,h=[],v=this.formToArray(t.semantic,h);if(t.data&&(t.extraData=t.data,p=e.param(t.data,d)),t.beforeSubmit&&t.beforeSubmit(v,this,t)===!1)return a("ajaxSubmit: submit aborted via beforeSubmit callback"),this;if(this.trigger("form-submit-validate",[v,this,t,m]),m.veto)return a("ajaxSubmit: submit vetoed via form-submit-validate trigger"),this;var g=e.param(v,d);p&&(g=g?g+"&"+p:p),"GET"==t.type.toUpperCase()?(t.url+=(t.url.indexOf("?")>=0?"&":"?")+g,t.data=null):t.data=g;var x=[];if(t.resetForm&&x.push(function(){f.resetForm()}),t.clearForm&&x.push(function(){f.clearForm(t.includeHidden)}),!t.dataType&&t.target){var y=t.success||function(){};x.push(function(r){var a=t.replaceTarget?"replaceWith":"html";e(t.target)[a](r).each(y,arguments)})}else t.success&&x.push(t.success);if(t.success=function(e,r,a){for(var n=t.context||this,i=0,o=x.length;o>i;i++)x[i].apply(n,[e,r,a||f,f])},t.error){var b=t.error;t.error=function(e,r,a){var n=t.context||this;b.apply(n,[e,r,a,f])}}if(t.complete){var T=t.complete;t.complete=function(e,r){var a=t.context||this;T.apply(a,[e,r,f])}}var j=e("input[type=file]:enabled",this).filter(function(){return""!==e(this).val()}),w=j.length>0,S="multipart/form-data",D=f.attr("enctype")==S||f.attr("encoding")==S,k=n.fileapi&&n.formdata;a("fileAPI :"+k);var A,L=(w||D)&&!k;t.iframe!==!1&&(t.iframe||L)?t.closeKeepAlive?e.get(t.closeKeepAlive,function(){A=s(v)}):A=s(v):A=(w||D)&&k?o(v):e.ajax(t),f.removeData("jqxhr").data("jqxhr",A);for(var E=0;E<h.length;E++)h[E]=null;return this.trigger("form-submit-notify",[this,t]),this},e.fn.ajaxForm=function(n){if(n=n||{},n.delegation=n.delegation&&e.isFunction(e.fn.on),!n.delegation&&0===this.length){var i={s:this.selector,c:this.context};return!e.isReady&&i.s?(a("DOM not ready, queuing ajaxForm"),e(function(){e(i.s,i.c).ajaxForm(n)}),this):(a("terminating; zero elements found by selector"+(e.isReady?"":" (DOM not ready)")),this)}return n.delegation?(e(document).off("submit.form-plugin",this.selector,t).off("click.form-plugin",this.selector,r).on("submit.form-plugin",this.selector,n,t).on("click.form-plugin",this.selector,n,r),this):this.ajaxFormUnbind().bind("submit.form-plugin",n,t).bind("click.form-plugin",n,r)},e.fn.ajaxFormUnbind=function(){return this.unbind("submit.form-plugin click.form-plugin")},e.fn.formToArray=function(t,r){var a=[];if(0===this.length)return a;var i,o=this[0],s=this.attr("id"),u=t?o.getElementsByTagName("*"):o.elements;if(u&&!/MSIE [678]/.test(navigator.userAgent)&&(u=e(u).get()),s&&(i=e(':input[form="'+s+'"]').get(),i.length&&(u=(u||[]).concat(i))),!u||!u.length)return a;var c,l,f,m,d,p,h;for(c=0,p=u.length;p>c;c++)if(d=u[c],f=d.name,f&&!d.disabled)if(t&&o.clk&&"image"==d.type)o.clk==d&&(a.push({name:f,value:e(d).val(),type:d.type}),a.push({name:f+".x",value:o.clk_x},{name:f+".y",value:o.clk_y}));else if(m=e.fieldValue(d,!0),m&&m.constructor==Array)for(r&&r.push(d),l=0,h=m.length;h>l;l++)a.push({name:f,value:m[l]});else if(n.fileapi&&"file"==d.type){r&&r.push(d);var v=d.files;if(v.length)for(l=0;l<v.length;l++)a.push({name:f,value:v[l],type:d.type});else a.push({name:f,value:"",type:d.type})}else null!==m&&"undefined"!=typeof m&&(r&&r.push(d),a.push({name:f,value:m,type:d.type,required:d.required}));if(!t&&o.clk){var g=e(o.clk),x=g[0];f=x.name,f&&!x.disabled&&"image"==x.type&&(a.push({name:f,value:g.val()}),a.push({name:f+".x",value:o.clk_x},{name:f+".y",value:o.clk_y}))}return a},e.fn.formSerialize=function(t){return e.param(this.formToArray(t))},e.fn.fieldSerialize=function(t){var r=[];return this.each(function(){var a=this.name;if(a){var n=e.fieldValue(this,t);if(n&&n.constructor==Array)for(var i=0,o=n.length;o>i;i++)r.push({name:a,value:n[i]});else null!==n&&"undefined"!=typeof n&&r.push({name:this.name,value:n})}}),e.param(r)},e.fn.fieldValue=function(t){for(var r=[],a=0,n=this.length;n>a;a++){var i=this[a],o=e.fieldValue(i,t);null===o||"undefined"==typeof o||o.constructor==Array&&!o.length||(o.constructor==Array?e.merge(r,o):r.push(o))}return r},e.fieldValue=function(t,r){var a=t.name,n=t.type,i=t.tagName.toLowerCase();if(void 0===r&&(r=!0),r&&(!a||t.disabled||"reset"==n||"button"==n||("checkbox"==n||"radio"==n)&&!t.checked||("submit"==n||"image"==n)&&t.form&&t.form.clk!=t||"select"==i&&-1==t.selectedIndex))return null;if("select"==i){var o=t.selectedIndex;if(0>o)return null;for(var s=[],u=t.options,c="select-one"==n,l=c?o+1:u.length,f=c?o:0;l>f;f++){var m=u[f];if(m.selected){var d=m.value;if(d||(d=m.attributes&&m.attributes.value&&!m.attributes.value.specified?m.text:m.value),c)return d;s.push(d)}}return s}return e(t).val()},e.fn.clearForm=function(t){return this.each(function(){e("input,select,textarea",this).clearFields(t)})},e.fn.clearFields=e.fn.clearInputs=function(t){var r=/^(?:color|date|datetime|email|month|number|password|range|search|tel|text|time|url|week)$/i;return this.each(function(){var a=this.type,n=this.tagName.toLowerCase();r.test(a)||"textarea"==n?this.value="":"checkbox"==a||"radio"==a?this.checked=!1:"select"==n?this.selectedIndex=-1:"file"==a?/MSIE/.test(navigator.userAgent)?e(this).replaceWith(e(this).clone(!0)):e(this).val(""):t&&(t===!0&&/hidden/.test(a)||"string"==typeof t&&e(this).is(t))&&(this.value="")})},e.fn.resetForm=function(){return this.each(function(){("function"==typeof this.reset||"object"==typeof this.reset&&!this.reset.nodeType)&&this.reset()})},e.fn.enable=function(e){return void 0===e&&(e=!0),this.each(function(){this.disabled=!e})},e.fn.selected=function(t){return void 0===t&&(t=!0),this.each(function(){var r=this.type;if("checkbox"==r||"radio"==r)this.checked=t;else if("option"==this.tagName.toLowerCase()){var a=e(this).parent("select");t&&a[0]&&"select-one"==a[0].type&&a.find("option").selected(!1),this.selected=t}})},e.fn.ajaxSubmit.debug=!1});
(function() {


}).call(this);
(function (factory) {
	if (typeof define === 'function' && define.amd) {
		// AMD (Register as an anonymous module)
		define(['jquery'], factory);
	} else if (typeof exports === 'object') {
		// Node/CommonJS
		module.exports = factory(require('jquery'));
	} else {
		// Browser globals
		factory(jQuery);
	}
}(function ($) {

	var pluses = /\+/g;

	function encode(s) {
		return config.raw ? s : encodeURIComponent(s);
	}

	function decode(s) {
		return config.raw ? s : decodeURIComponent(s);
	}

	function stringifyCookieValue(value) {
		return encode(config.json ? JSON.stringify(value) : String(value));
	}

	function parseCookieValue(s) {
		if (s.indexOf('"') === 0) {
			// This is a quoted cookie as according to RFC2068, unescape...
			s = s.slice(1, -1).replace(/\\"/g, '"').replace(/\\\\/g, '\\');
		}

		try {
			// Replace server-side written pluses with spaces.
			// If we can't decode the cookie, ignore it, it's unusable.
			// If we can't parse the cookie, ignore it, it's unusable.
			s = decodeURIComponent(s.replace(pluses, ' '));
			return config.json ? JSON.parse(s) : s;
		} catch(e) {}
	}

	function read(s, converter) {
		var value = config.raw ? s : parseCookieValue(s);
		return $.isFunction(converter) ? converter(value) : value;
	}

	var config = $.cookie = function (key, value, options) {

		// Write

		if (arguments.length > 1 && !$.isFunction(value)) {
			options = $.extend({}, config.defaults, options);

			if (typeof options.expires === 'number') {
				var days = options.expires, t = options.expires = new Date();
				t.setMilliseconds(t.getMilliseconds() + days * 864e+5);
			}

			return (document.cookie = [
				encode(key), '=', stringifyCookieValue(value),
				options.expires ? '; expires=' + options.expires.toUTCString() : '', // use expires attribute, max-age is not supported by IE
				options.path    ? '; path=' + options.path : '',
				options.domain  ? '; domain=' + options.domain : '',
				options.secure  ? '; secure' : ''
			].join(''));
		}

		// Read

		var result = key ? undefined : {},
			// To prevent the for loop in the first place assign an empty array
			// in case there are no cookies at all. Also prevents odd result when
			// calling $.cookie().
			cookies = document.cookie ? document.cookie.split('; ') : [],
			i = 0,
			l = cookies.length;

		for (; i < l; i++) {
			var parts = cookies[i].split('='),
				name = decode(parts.shift()),
				cookie = parts.join('=');

			if (key === name) {
				// If second argument (value) is a function it's a converter...
				result = read(cookie, value);
				break;
			}

			// Prevent storing a cookie that we couldn't decode.
			if (!key && (cookie = read(cookie)) !== undefined) {
				result[name] = cookie;
			}
		}

		return result;
	};

	config.defaults = {};

	$.removeCookie = function (key, options) {
		// Must not alter options, thus extending a fresh object...
		$.cookie(key, '', $.extend({}, options, { expires: -1 }));
		return !$.cookie(key);
	};

}));
(function() {


}).call(this);
(function() {


}).call(this);
(function() {


}).call(this);
(function() {


}).call(this);
(function() {


}).call(this);
// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//



// require account/jquery-cookie

;
