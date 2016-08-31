var adminmsg = {
  error: function(msg) {
    $('#alertMsg').empty().append('<div class="row"><div class="center-block alert alert-danger"><button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button><div>'+ msg +'</div></div></div>');
    alertMsgAutoClose();
  },
  info: function(msg) {
    $('#alertMsg').empty().append('<div class="row"><div class="center-block alert alert-success"><button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button><div>'+ msg +'</div></div></div>');
    alertMsgAutoClose();
  }
};

jQuery.delegate = function(rules) {
  return function(e) {
    var target = $(e.target);
    for (var selector in rules)
      if (target.is(selector)) return rules[selector].apply(this, $.makeArray(arguments));
  };
};

$(document).ajaxSend(function(e, xhr, options) {
  var token = $("meta[name='csrf-token']").attr("content");
  xhr.setRequestHeader("X-CSRF-Token", token);
});

function asyncDeleteForm(obj, options) {
  $.ajax($.extend({
    type: "DELETE",
    url: obj.attr('action'),
    beforeSend: function(xhr) {
      xhr.setRequestHeader("Accept", "application/json");
    },
    dataType: 'json',
    success: function(msg){
      display = msg.undo_message;
      if (msg.undo_path) {
        display += '<span class="undo-link"> (<a class="undo-link" href="' + msg.undo_path + '">撤销</a>)</span>';
        undo_stack.push(msg.undo_path);
      }
      adminmsg.info(display);
    },
    error: function (XMLHttpRequest, textStatus, errorThrown) {
      adminmsg.error('Could not delete item, or maybe it has already been deleted');
    }
  }, options || {}));
}

function processUndo(path, options) {
  $.ajax($.extend({
    type: "POST",
    url: path,
    beforeSend: function(xhr) {
      xhr.setRequestHeader("Accept", "application/json");
    },
    dataType: 'json',
    success: function(msg){
      adminmsg.info(msg.message);
    },
    error: function (XMLHttpRequest, textStatus, errorThrown) {
      adminmsg.error('还原失败');
    }
  }, options || {}));

  // Assume success and remove undo link
  // $('a.undo-link[href=' + path + ']').parent('span').hide();//由于有代理直接使用会有问题
  $('span.undo-link').hide();
  undo_stack = jQuery.grep(undo_stack, function(e) { return e != path; });
}

function asyncUndoBehaviour(options) {
  $('#alertMsg').click($.delegate({
    'a.undo-link': function(e) {
      processUndo(jQuery(e.target).attr('href'), options);
      return false;
    }
  }));
  jQuery.each(["Ctrl+Z", "Meta+Z"], function () {
    shortcut.add(this, function() {
      item = undo_stack.pop();
      if (item)
        processUndo(item, options);
      else
        adminmsg.info("没有待还原的内容");
    });
  });
}

var undo_stack = [];

function onDeleteFormClick() {
  asyncDeleteForm($(this));

  // Assume success and remove item
  $(this).parent('td').parent('tr').remove();
  return false;
}

function destroyAndUndoBehaviour(type) {
  return function (){
    asyncUndoBehaviour({
      success: function(msg){
        adminmsg.info(msg.message);
        $.get('/admin/' + type + '/' + msg.obj.id, function(data) {
          $('table tbody').append(data);

          $('form.delete-item').unbind('submit', onDeleteFormClick);
          $('form.delete-item').submit(onDeleteFormClick);
        });
      },
    });

    $('form.delete-item').submit(onDeleteFormClick);
  };
}
//alert提示框自动消失功能
function alertMsgAutoClose(){
  $("#alertMsg").fadeTo(4000, 500).slideUp(500, function(){
    $("#alertMsg").alert('close');
  });
}

//启动时加载，完成删除功能、登录方式切换
$(document).ready(function() {
  $(['posts', 'comments', 'pages']).each(function() {
    if ($('#' + this).length > 0) {
      destroyAndUndoBehaviour(this)();
    }
  });

  alertMsgAutoClose();

  $('#open-id-login-link').click(function (e) {
    $('#email-login').addClass("hidden");
    $('#openid-login').removeClass("hidden");
    return false;
  });
  $('#email-login-link').on("click", function (e) {
    $('#openid-login').addClass("hidden");
    $('#email-login').removeClass("hidden");
    return false;
  });
});


