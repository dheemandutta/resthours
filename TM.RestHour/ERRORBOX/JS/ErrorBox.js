$(function () {

    var errorBoxHtml = '';

    //Error box
    errorBoxHtml += '<div id="dvMessageBox" title="Download complete">';
    errorBoxHtml += '<p id="pMessageText">';
    errorBoxHtml += '</p>';
    errorBoxHtml += '</div>';

    $('body').append(errorBoxHtml);

});


function ShowMessage(messageHeader, messageText, messageType) {
    // Only Numeric message are not allowed in message
    if (!isNaN(messageText))
        return;

    if (typeof messageText === "undefined") {
        return;
    }
    if (messageText != "") {

        //messageHeader = $('#GLOBAL_PRODUCT_HEADING').val();
        $('#dvMessageBox').attr('title', messageHeader);
        $('.ui-dialog-title').html(messageHeader);
        $('#pMessageText').html(messageText);

        if (messageType == "ERROR") {
            $('#dvMessageBox').css("color", "#7C0012");
            $('#dvMessageBox').effect("highlight", { color: 'red' });
        }
        else if (messageType == "INFO") {
            $('#dvMessageBox').css("color", "#000");
            $('#dvMessageBox').effect("highlight", { color: 'green' });
        }

        $('#dvMessageBox').dialog({
            modal: true,
            /*height: 300,*/
            /*width: "auto",*/
            width: 400,
            resizable: false,
            closeOnEscape: false,
            draggable: true,
            /*show: "highlight",*/
            hide: "puff",
            open: function (event, ui) {
                // SHOW/HIDE close button
                $(".ui-dialog-titlebar-close").hide();
                //$("a.ui-dialog-titlebar-close").show();
            },
            buttons: {
                Ok: function () {
                    $(this).dialog("close");
                }
            }
        });
    }
}

function ShowMessageAndContinue(messageHeader, messageText, messageType, passThruFunc) {

    $('<div id="dvShowMessageAndContinue_message"></div>').appendTo('body')
      .html('<div>' + messageText + '</div>')
      .dialog({
          modal: true,
          title: messageHeader,
          //zIndex: 10000,
          autoOpen: true,
          width: 'auto',
          resizable: false,
          draggable: false,
          hide: "puff",
          width: 400,
          closeOnEscape: false,
          open: function (event, ui) {
              // SHOW/HIDE close button
              $(".ui-dialog-titlebar-close").hide();

              // Message style
              if (messageType == "ERROR") {
                  $('#dvShowMessageAndContinue_message').css("color", "#7C0012");
                  $('#dvShowMessageAndContinue_message').effect("highlight", { color: 'red' });
              }
              else if (messageType == "INFO") {
                  $('#dvShowMessageAndContinue_message').css("color", "#000");
                  $('#dvShowMessageAndContinue_message').effect("highlight", { color: 'green' });
              }
          },
          buttons: {
              Ok: function () {
                  passThruFunc();
                  $(this).dialog("close");
              }
          },
          close: function (event, ui) {
              $(this).remove();
          }
    });
}

function ConfirmAndContinue(messageHeader, messageText, messageType, passThruFunc) {

    $('<div id="dvConfirmAndContinue_message"></div>').appendTo('body')
      .html('<div>' + messageText + '</div>')
      .dialog({
          modal: true,
          title: messageHeader,
          zIndex: 10000,
          autoOpen: true,
          width: 'auto',
          resizable: false,
          draggable: false,
          hide: "puff",
          width: 400,
          closeOnEscape: false,
          open: function (event, ui) {
              // SHOW/HIDE close button
              $(".ui-dialog-titlebar-close").hide();

              // Message style
              if (messageType == "ERROR") {
                  $('#dvConfirmAndContinue_message').css("color", "#7C0012");
                  $('#dvConfirmAndContinue_message').effect("highlight", { color: 'red' });
              }
              else if (messageType == "INFO") {
                  $('#dvConfirmAndContinue_message').css("color", "#000");
                  $('#dvConfirmAndContinue_message').effect("highlight", { color: 'green' });
              }
          },
          buttons: {
              Yes: function () {
                  passThruFunc();
                  $(this).dialog("close");
              },
              No: function () {
                  $(this).dialog("close");
              }
          },
          close: function (event, ui) {
              $(this).remove();
          }
      });
}