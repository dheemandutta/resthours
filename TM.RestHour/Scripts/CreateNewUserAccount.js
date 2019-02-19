function validate() {
    var isValid = true;
    var checkusername = $('#validateusername').val();

    if ($('#Username').val().length === 0) {
        $('#Username').css('border-color', 'Red');
        isValid = false;
    }
    else {

        $('#Username').css('border-color', 'lightgrey');
    }

    
    if ($('#Password1').val().length === 0) {
        $('#Password1').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#Password1').css('border-color', 'lightgrey');
    }

    if ($('#Password2').val().length === 0) {
        $('#Password2').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#Password2').css('border-color', 'lightgrey');
    }

    if ($('#Password1').val() == $('#Password2').val()) {
        $('#Password2').css('border-color', 'lightgrey');
        $('#Password1').css('border-color', 'lightgrey');
    }
    else {
        $('#Password1').css('border-color', 'Red');
        $('#Password2').css('border-color', 'Red');
        isValid = false;
    }

    

    return isValid;
}

function ClearValues() {
    $('#Username').val("");
    $('#Password').val("");
    alert('Data Saved Successfully');

}

function LoadInitialData(id) {
    var loadinitialdata = $('#loadinitialdata').val();
    var getcrewIdurl = $('#getCrewName').val();
    var cId = getParameterByName('crewId');

    
    // load Crew Name
    $.ajax({
        url: getcrewIdurl,
        type: "GET",
        contentType: "application/json;charset=utf-8",
        data:
        {
            crewid: cId
        },
        dataType: "json",
        success: function (result) {
            //debugger;
            if (result !== 'undefined')
            $('#CrewName').val(result);
        },
        error: function (errormessage) {
            console.log(errormessage.responseText);
        }
    });
    
    $.ajax({
        url: loadinitialdata,
        type: "GET",
        contentType: "application/json;charset=utf-8",
        data:
        {
            crewId: cId
        },
        dataType: "json",
        success: function (result) {
            console.log('In Load Initial Data');
            console.log(result.Username);
            
            if (result.Username != null) {
                $('#Username').val(result.Username);
                $('#Username').prop("disabled", true);

                $('#Password1').val(result.Password);
                $('#Password2').val(result.Password);
                $('#hdnID').val(result.ID);

                //var crewId = getParameterByName('crewId');
                //if (crewId !== null) {
                //    $('#ddlCrew').val(crewId);
                //    $('#ddlCrew').prop('disabled', true);
                //}

                var selectedgroupId = getParameterByName('grp');
                if (selectedgroupId !== null) {
                    $('#ddlgrp').val(selectedgroupId);
                }

                return '1';
            }
            else {

                //debugger;
                var userName = getParameterByName('username');
                $('#Username').val(userName);
                console.log(userName);
                var selectedgroupId = getParameterByName('grp');
                $('#ddlgrp').val(selectedgroupId);

               // var cId = getParameterByName('crewId');
                //$('#ddlCrew').val(cId);
                //$('#ddlCrew').prop('disabled', true);
                $('#hdnID').val('0');

                return '0';
            }

            

        },
        error: function (errormessage) {
            console.log(errormessage.responseText);
        }
    });
}

function loadData() {
    var loadposturl = $('#loaddata').val();
    $.ajax({
        url: loadposturl,
        type: "GET",
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        success: function (result) {
            SetUpGrid();

        },
        error: function (errormessage) {
            console.log(errormessage.responseText);
        }
    });
}

function SetUpGrid() {
    var loadposturl = $('#loaddata').val();

    //do not throw error
    $.fn.dataTable.ext.errMode = 'none';

    //check if datatable is already created then destroy iy and then create it
    if ($.fn.dataTable.isDataTable('#Mastertable')) {
        table = $('#Mastertable').DataTable();
        table.destroy();
    }

    $("#Mastertable").DataTable({
        "processing": true, // for show progress bar
        "serverSide": true, // for process server side
        "filter": false, // this is for disable filter (search box)
        "orderMulti": false, // for disable multiple column at once
        "bLengthChange": false, //disable entries dropdown
        "ajax": {
            "url": loadposturl,
            "type": "POST",
            "datatype": "json"
        },
        "columns": [
            {
                "data": "Username", "name": "Username", "autoWidth": true
            },
                {
                    "data": "Active", "name": "IMONumber", "Active": true
                }
            //{
            //    "data": "ID", "width": "50px", "render": function (data) {
            //        return '<a href="#" onclick="GetShipByID(' + data + ')">Edit</a>';
            //    }
            //}

        ]
    });
}




//function Add(Username, Password, SelectedGroupID) {
//    var posturl = $('#Add').val();
//    var res = validate();
//    if (res == false) {
//        return false;
//    }
//    var User = {
//        ID: $('#ID').val(),
//        Username: $('#Username').val(),
//        Password: $('#Password').val(),
//        SelectedGroupID: $('#GroupID').val()
//    };

//    $.ajax({
//        url: posturl,
//        data: JSON.stringify(User),
//        type: "POST",
//        contentType: "application/json;charset=utf-8",
//        dataType: "json",
//        //success: function (result) {

//        //},
//        success: function (result) {

//            alert('Added Successfully');

//            clearTextBox();
//        }
//        ,
//        error: function (errormessage) {
//            console.log(errormessage.responseText);
//        }
//    });
//}

