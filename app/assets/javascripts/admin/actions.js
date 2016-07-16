$(document).ready(function () {
  $('form.undo-item').submit(function () {
    asyncDeleteForm($(this), {
      type: "POST",
      success: function (msg) {
        adminmsg.info( msg.message );
      },
      error: function (XMLHttpRequest, textStatus, errorThrown) {
        adminmsg.error( '还原失败' );
      }
    });

    // Assume success and remove item
    $(this).parent('td').parent('tr').remove();
    restripe();
    return false;
  });
});
