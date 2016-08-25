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
