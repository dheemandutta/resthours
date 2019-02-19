function validate() {
    var isValid = true;

    //if ($('#UserName').val().length === 0) {
    //    $('#UserName').css('border-color', 'Red');
    //    isValid = false;
    //}
    //else {
    //    $('#UserName').css('border-color', 'lightgrey');
    //}
    if ($('#OldPassword').val().length === 0) {
        $('#OldPassword').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#OldPassword').css('border-color', 'lightgrey');
    }
    if ($('#NewPassword').val().length === 0) {
        $('#NewPassword').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#NewPassword').css('border-color', 'lightgrey');
    }
    if ($('#ConfirmNewPassword').val().length === 0) {
        $('#ConfirmNewPassword').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#ConfirmNewPassword').css('border-color', 'lightgrey');
    }
    return isValid;
}

function clearTextBox() {
   // $('#UserName').val("");
    $('#OldPassword').val("");
    $('#NewPassword').val("");
    $('#ConfirmNewPassword').val("");
}

function Reset() {

    //alert($('textarea#Comments').val());
    //debugger;
    var posturl = $('#ResetPassword').val();
    var res = validate();
    if (res == false) {
        return false;
    }
    var ResetPassword = {
        ID: $('#ID').val(),
        UserName: $('#UserName').val(),
        OldPassword: $('#OldPassword').val(),
        NewPassword: $('#NewPassword').val(),
        //ConfirmNewPassword: $('#ConfirmNewPassword').val()
    };

    $.ajax({
        url: posturl,
        data: JSON.stringify(ResetPassword),
        type: "POST",
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        //success: function (result) {

        //},
        success: function (result) {

            alert('Reset Password Successfully');

            clearTextBox();
        }
        ,
        error: function (errormessage) {
            console.log(errormessage.responseText);
        }
    });
}