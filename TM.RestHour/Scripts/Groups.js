function validate() {
    var isValid = true;

    if ($('#GroupName').val().length === 0) {
        $('#GroupName').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#GroupName').css('border-color', 'lightgrey');
    }

    return isValid;
}

function AddNewGroups() {
    //debugger;
    var addnew = $('#addnew').val();
    var res = validate();
    if (res == false) {
        return false;
    }
    var Groups = {
        ID: $('#ID').val(),
        GroupName: $('#GroupName').val()
    };
    //debugger;
    $.ajax({
        url: addnew,
        data: JSON.stringify(Groups),
        type: "POST",
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        success: function (response) {
            //debugger;
            if (response.result == 'Redirect') {
                //show successfull message
                alert('Data Saved Successfully');
                window.location = response.url;
            }
            else if (response.result == 'Error') {
                alert('Data not saved,Please try again');
            }
        },
        error: function (errormessage) {
            console.log(errormessage.responseText);
        }
    });
}

function clearTextBox() {
    $('#ID').val("");
    $('#GroupName').val("");
  
    //$('#btnUpdate').hide();
    //$('#btnAdd').show();

}