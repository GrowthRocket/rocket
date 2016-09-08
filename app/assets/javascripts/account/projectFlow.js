var planIndex = 0;
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
  bo = isBrowser();
  flowType = $("#flowType").val();
  projectId = $("#projectId").val();
  var multiple = 1;
  var element = document.querySelector("trix-editor");

  if (bo != undefined && bo == 'firefox') {
    $('trix-editor').on('trix-change', function() {
      if (projectId == undefined) {
        var inputv =  $("#project_description_trix_input_project");
        if (inputv.val().length == 50 * multiple) {
          multiple++;
          element.editor.insertLineBreak();
        }
      } else {
        var inputv =  $("#project_description_trix_input_project_" + projectId);
        if (inputv.val().length == 50 * multiple) {
          multiple++;
          element.editor.insertLineBreak();
        }
      }
    })

  }

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



function increaseNum() {
  planIndex++;
  var index = getCurrentPlanIndex(flowType, planIndex);
  planQueue[index] = 1;
  planQueue.push(0);
}

function generatePlans() {
  $.ajax({
    url: "/account/projects/" + projectId + "/plans/get_plans/",
    method: "get",
    async: false,
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
          showPlanInforB(planIndex, data.id);
        });
        planIndex++;
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

function showPlanInforB(planNum, planId) {
  $("#plan" + planNum + "A").hide();
  var planPrice = $("#plan_price" + planNum).val();
  var planGoal = $("#plan_plan_goal" + planNum).val();
  var planDescription = $("#plan_descrition" + planNum).val();
  var planIndex = $("#plan" + planNum + "A").find("h1").text().match(/\d/g).join("");
  var content = generatePlanB(planPrice, planGoal, planDescription, planIndex, planNum, planId);
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
        showPlanInforB(planNum, data.plan_id);
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
        } else if(errors.need_add != undefined) {
          showError("请选择是否为实物回报", "plansInfor");
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
  var planIndex = planQueue.indexOf(1);
  planQueue.splice(planIndex, 1);
  // planQueue.push(0);
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

function getNeedAdd(data) {
  var content = "";
  if (data.need_add == true) {
    content = "<input name='plan[need_add]' value='true' type='radio' checked='checked'>是 <input name='plan[need_add]' value='false' type='radio'>否"
  } else {
    content = "<input name='plan[need_add]' value='true' type='radio'>是 <input name='plan[need_add]' value='false' type='radio' checked='checked'>否"
  }
  return content;
}

function generateForm(flowType, data) {
  if (flowType == "edit" && data != undefined) {
    var content = "<form id='plan" + planIndex + "InforForm'><div class='form-group'><div class='form-group integer required plan_price'><input type='hidden' name='plan_id' value='" + data.id + "'><label class='integer required control-label' for='plan_price'><abbr title='required'>*</abbr> 支持金额</label><input class='numeric integer required edit-input-short-width form-control' type='number' step='1' name='plan[price]' min='1' max='1000000' value='"+data.price+"' id='plan_price" + planIndex + "'></div><p><b>是实物回报吗？</b></p>" + getNeedAdd(data) + " <p><b>回报内容</b></p><textarea id='plan_descrition" + planIndex + "' class='form-control'  name='plan[description]'>" + data.description + "</textarea><div class='form-group integer required plan_plan_goal'><label class='integer required control-label' for='plan_plan_goal'><abbr title='required'>*</abbr> 份数上限</label><input class='numeric integer required edit-input-short-width form-control' value='" + data.plan_goal + "' type='number' min='1' max='1000000' step='1' name='plan[plan_goal]' id='plan_plan_goal" + planIndex + "'></div></form><input type='button' class='btn btn-success pull-right' planNum='" + planIndex + "' id='savePlan" + planIndex + "' value='保存'/><input type='button' class='btn btn-danger pull-right removePlan" + planIndex + "' planId='"+ data.id +"' data-confirm='确认删除该方案么?' planNum='" + planIndex + "' value='删除'/>";
    return content;
  } else {
    var content = "<form id='plan" + planIndex + "InforForm'><div class='form-group'><div class='form-group integer required plan_price'><label class='integer required control-label' for='plan_price'><abbr title='required'>*</abbr> 支持金额</label><input class='numeric integer required edit-input-short-width form-control' type='number' step='1' name='plan[price]' min='1' max='1000000' id='plan_price" + planIndex + "'></div><p><b>是实物回报吗？</b></p><input name='plan[need_add]' value='true' type='radio'>是 <input name='plan[need_add]' value='false' type='radio'>否 <p><b>回报内容</b></p><textarea id='plan_descrition" + planIndex + "' class='form-control' rows='3' name='plan[description]'></textarea><div class='form-group integer required plan_plan_goal'><label class='integer required control-label' for='plan_plan_goal'><abbr title='required'>*</abbr> 人数上限</label><input class='numeric integer required edit-input-short-width form-control' min='1' max='1000000' type='number' step='1' name='plan[plan_goal]' id='plan_plan_goal" + planIndex + "'></div></form><input type='button' class='btn btn-success pull-right' planNum='" + planIndex + "' id='savePlan" + planIndex + "' value='保存'/><input type='button' class='btn btn-danger pull-right removePlan" + planIndex + "' data-confirm='确认删除该方案么?' planNum='" + planIndex + "' value='删除'/>";
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

function generatePlanB(planPrice, planGoal, planDescription, planIndex, planNum, planId) {
  var content = "<div class='row'>" +
              "<div class='col-md-4 col-md-offset-4 well project-well'>" +
                "<h3>回报" + planIndex + "</h3>" +
                "<p>¥ " + planPrice + " 限 " + planGoal + "人</p>" +
                "<p>" + planDescription + "</p>"+
                "<input type='button' class='btn btn-success pull-right' planNum='" + planNum + "' id='showPlan" + planNum + "A' value='修改'/><input type='button' class='btn btn-danger pull-right removePlan" + planNum + "' data-confirm='确认删除该方案么?' planNum='" + planNum + "' planId='" + planId + "' value='删除'/>"
              "</div>" +
            "</div>";
  return content;
}


function isBrowser(){

    var Sys={};

    var ua=navigator.userAgent.toLowerCase();

    var s;

    (s=ua.match(/msie ([\d.]+)/))?Sys.ie=s[1]:

    (s=ua.match(/firefox\/([\d.]+)/))?Sys.firefox=s[1]:

    (s=ua.match(/chrome\/([\d.]+)/))?Sys.chrome=s[1]:

    (s=ua.match(/opera.([\d.]+)/))?Sys.opera=s[1]:

    (s=ua.match(/version\/([\d.]+).*safari/))?Sys.safari=s[1]:0;

    // if(Sys.ie){//Js判断为IE浏览器
    //
    //     alert('http://www.phpernote.com'+Sys.ie);
    //
    //     if(Sys.ie=='9.0'){//Js判断为IE 9
    //
    //     }else if(Sys.ie=='8.0'){//Js判断为IE 8
    //
    //     }else{
    //
    //     }
    //
    // }

    if(Sys.firefox){//Js判断为火狐(firefox)浏览器

        return "firefox"

    }
    //
    // if(Sys.chrome){//Js判断为谷歌chrome浏览器
    //
    //     alert('http://www.phpernote.com'+Sys.chrome);
    //
    // }
    //
    // if(Sys.opera){//Js判断为opera浏览器
    //
    //     alert('http://www.phpernote.com'+Sys.opera);
    //
    // }
    //
    // if(Sys.safari){//Js判断为苹果safari浏览器
    //
    //     alert('http://www.phpernote.com'+Sys.safari);
    //
    // }

}
