function GetVesselTypeIDFromShip(/*VesselTypeID*/) {
    var x = $("#myUrlGetVesselTypeIDFromShip").val();
    
    $.ajax({
        url: x,
        type: "POST",
        //////data: JSON.stringify({ /*'VesselTypeID': VesselTypeID*/ }),
        data:
        {
            //////    ID: ID
        },
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        success: function (result) {

            //var drpVesselType = $('#VesselTypeID');
            //drpVesselType.find('option').remove();
           // console.log(result[0].VesselTypeID);
            $('#VesselTypeID').val(result[0].VesselTypeID);
            //$.each(result, function () {
            //    drpVesselType.append('<option value=' + this.VesselTypeID + '>' + this.Description + '</option>');
            //});
        },
        error: function (errormessage) {
            alert(errormessage.responseText);
        }
    });
}


function GetVesselTypeForDrp(/*VesselTypeID*/) {
    var x = $("#myUrlid0").val();

    $.ajax({
        url: x,
        type: "POST",
        //data: JSON.stringify({ /*'VesselTypeID': VesselTypeID*/ }),
        data:
        {
            //    ID: ID
        },
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        success: function (result) {

            var drpVesselType = $('#VesselTypeID');
            drpVesselType.find('option').remove();

            $.each(result, function () {
                drpVesselType.append('<option value=' + this.VesselTypeID + '>' + this.Description + '</option>');
            });

            GetVesselTypeIDFromShip();
        },
        error: function (errormessage) {
            alert(errormessage.responseText);
        }
    });
}

function GetVesselSubTypeByVesselTypeIDForDrp(VesselTypeID) {
    var x = $("#myUrlid1").val();


    $.ajax({
        url: x,
        type: "POST",
        data: JSON.stringify({ 'VesselTypeID': VesselTypeID }),
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        success: function (result) {
            //debugger;
            var drpVesselSubType = $('#VesselSubTypeID');
            drpVesselSubType.find('option').remove();

            $.each(result, function () {
                drpVesselSubType.append('<option value=' + this.VesselSubTypeID + '>' + this.SubTypeDescription + '</option>');
            });


        },
        error: function (errormessage) {
            alert(errormessage.responseText);
        }
    });
}

function GetVesselSubSubTypeByVesselSubTypeIDForDrp(VesselSubTypeID) {
    var x = $("#myUrlid2").val();


    $.ajax({
        url: x,
        type: "POST",
        data: JSON.stringify({ 'VesselSubTypeID': VesselSubTypeID }),
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        success: function (result) {
            //debugger;
            var drpVesselSubSubType = $('#VesselSubSubTypeID');
            drpVesselSubSubType.find('option').remove();

            $.each(result, function () {
                drpVesselSubSubType.append('<option value=' + this.VesselSubSubTypeID + '>' + this.VesselSubSubTypeDecsription + '</option>');
            });

        },
        error: function (errormessage) {
            alert(errormessage.responseText);
        }
    });
}





function validateVessel() {
    var isValid = true;

    if ($('#VesselTypeID').val().length === 0) {
        $('#VesselTypeID').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#VesselTypeID').css('border-color', 'lightgrey');
    }

    if ($('#VesselSubTypeID').val().length === 0) {
        $('#VesselSubTypeID').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#VesselSubTypeID').css('border-color', 'lightgrey');
    }

    if ($('#VesselSubSubTypeID').val().length === 0) {
        $('#VesselSubSubTypeID').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#VesselSubSubTypeID').css('border-color', 'lightgrey');
    }
   

    return isValid;

}

function validate() {
    var isValid = true;

    if ($('#ShipName').val().length === 0) {
        $('#ShipName').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#ShipName').css('border-color', 'lightgrey');
    }

    if ($('#IMONumber').val().length === 0) {
        $('#IMONumber').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#IMONumber').css('border-color', 'lightgrey');
    }

    if ($('#FlagOfShip').val().length === 0) {
        $('#FlagOfShip').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#FlagOfShip').css('border-color', 'lightgrey');
    }

    if ($('#SuperAdminUserName').val().length === 0) {
        $('#SuperAdminUserName').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#SuperAdminUserName').css('border-color', 'lightgrey');
    }

    if ($('#SuperAdminPassword').val().length === 0) {
        $('#SuperAdminPassword').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#SuperAdminPassword').css('border-color', 'lightgrey');
    }





    //if ($('#ShipEmail').val().length === 0) {
    //    $('#ShipEmail').css('border-color', 'Red');
    //    isValid = false;
    //}
    //else {
    //    $('#ShipEmail').css('border-color', 'lightgrey');
    //}

    return isValid;
}

function AddNewVessel() {
    //debugger;
    var addnew = $('#addnew').val();
    var res = validate();
    if (res == false) {
        return false;
    }
    var Ship = {
        ID: $('#ID').val(),
        ShipName: $('#ShipName').val(),
        FlagOfShip: $('#FlagOfShip').val(),
        IMONumber: $('#IMONumber').val()
    };
    //debugger;
    $.ajax({
        url: addnew,
        data: JSON.stringify(Ship),
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

function Add() {
    var posturl = $('#Unitadd').val();
    var res = validate();
    if (res == false) {
        return false;
    }
    var Ship = {
        ID: $('#ID').val(),
        ShipName: $('#ShipName').val(),
        FlagOfShip: $('#FlagOfShip').val(),
        IMONumber: $('#IMONumber').val()
    };

    $.ajax({
        url: posturl,
        data: JSON.stringify(Ship),
        type: "POST",
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        success: function (result) {
            loadData();
            $('#myModal').modal('hide');
        },
        error: function (errormessage) {
            console.log(errormessage.responseText);
        }
    });
}

function clearTextBox() {
    $('#ID').val("");
    $('#ShipName').val("");
    $('#FlagOfShip').val("");
    $('#IMONumber').val("");
    $('#btnUpdate').hide();
    $('#btnAdd').show();

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
    if ($.fn.dataTable.isDataTable('#VesselMastertable')) {
        table = $('#VesselMastertable').DataTable();
        table.destroy();
    }

    $("#VesselMastertable").DataTable({
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
                "data": "ShipName", "name": "ShipName", "autoWidth": true
            },
              {
                  "data": "FlagOfShip", "name": "FlagOfShip", "autoWidth": true
              },
                {
                    "data": "IMONumber", "name": "IMONumber", "autoWidth": true
            },

        


                {
                "data": "ID", "width": "50px", "render": function (data) {
                    return '<a href="#" onclick="GetShipByID(' + data + ')">Edit</a>';
                    }
                }
          
        ]
    });
}

function SetUpNonAdminGrid() {
    var loadposturl = $('#loaddata').val();

    //do not throw error
    $.fn.dataTable.ext.errMode = 'none';

    //check if datatable is already created then destroy iy and then create it
    if ($.fn.dataTable.isDataTable('#VesselMastertable2')) {
        table = $('#VesselMastertable2').DataTable();
        table.destroy();
    }

    $("#VesselMastertable2").DataTable({
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
                "data": "ShipName", "name": "ShipName", "autoWidth": true
            },
            {
                "data": "FlagOfShip", "name": "FlagOfShip", "autoWidth": true
            },
            {
                "data": "IMONumber", "name": "IMONumber", "autoWidth": true
            }
            

        ]
    });
}

function Update() {
    // alert();
    var i = $('#VesselUpdate').val();
    // debugger;
    var res = validateVessel();
    if (res === false) {
        return false;
    }
    var empObj = {

        ID: $('#ID').val(),
        ShipName: $('#Vessel').val(),
        FlagOfShip: $('#Flag').val(),
        IMONumber: $('#IMONumber').val(),

        VesselTypeID: $('#VesselTypeID').val(),
        VesselSubTypeID: $('#VesselSubTypeID').val(),
        VesselSubSubTypeID: $('#VesselSubSubTypeID').val(),

        ShipEmail: $('#Email1').val(),
        ShipEmail2: $('#Email2').val(),
        Voices1: $('#Voice1').val(),
        Voices2: $('#Voice2').val(),
        Fax1: $('#Fax1').val(),
        Fax2: $('#Fax2').val(),
        VOIP1: $('#VideoCall1').val(),
        VOIP2: $('#VideoCall2').val(),
        Mobile1: $('#Mobile1').val(),
        Mobile2: $('#Mobile2').val()
    };
    //debugger;
    $.ajax({

        url: i,
        data: JSON.stringify(empObj),
        type: "POST",
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        success: function (result) {
            
            //debugger;
            $('#myModal').modal('hide');

            $('#ID').val("");
            $('#Vessel').val("");
            $('#Flag').val("");
            $('#IMONumber').val("");

            $('#VesselTypeID').val("");
            $('#VesselSubTypeID').val("");
            $('#VesselSubSubTypeID').val("");

            $('#Email1').val("");
            $('#Email2').val("");
            $('#Voice1').val("");
            $('#Voice2').val("");
            $('#Fax1').val("");
            $('#Fax2').val("");
            $('#VideoCall1').val("");
            $('#VideoCall2').val("");
            $('#Mobile1').val("");
            $('#Mobile2').val("");

            GetShip();
        },
        error: function (errormessage) {
            console.log(errormessage.responseText);
        }

    });
}



function GetShipByID(ID) {
    $('#ShipName').css('border-color', 'lightgrey');
    var x = $("#myUrlship").val();
    $.ajax({
        url: x,
        data:
            {
                ID: ID
            },
        type: "GET",
        contentType: "application/json;charset=UTF-8",
        dataType: "json",
        success: function (result) {
            //debugger;
            $('#ID').val(result.ID);
            $('#ShipName').val(result.ShipName);
            $('#FlagOfShip').val(result.FlagOfShip);
            $('#IMONumber_edit').val(result.IMONumber);

            $('#ShipEmail_Edit').val(result.ShipEmail);

            $('#myModal').modal('show');
            $('#btnUpdate').show();
          //  $('#btnAdd').hide();
        },
        error: function (errormessage) {
            //debugger;
            console.log(errormessage.responseText);
        }
    });
    return false;
}




function NewAdd() {



    var posturl1 = $('#NewUnitadd').val();
    var res = validate();
    if (res == false) {
        return false;
    }

    if (res) {
    var Ship = {
       // ID: $('#ID').val(),
        ShipName: $('#ShipName').val(),
        FlagOfShip: $('#FlagOfShip').val(),
        IMONumber: $('#IMONumber').val(),
        SuperAdminUserName: $('#SuperAdminUserName').val(),
        SuperAdminPassword: $('#SuperAdminPassword').val()
    };

    $.ajax({
        url: posturl1,
        data: JSON.stringify(Ship),
        type: "POST",
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        success: function (result) {
            alert('Added Successfully');
            clearTextBox();
            window.location =  "index", "Login".url;
        },
        error: function (errormessage) {
            console.log(errormessage.responseText);
        }
    });
    }
}


function GetShip() {
  
    var x = $("#myUrlNew").val();
    $.ajax({
        url: x,
        data:
        {
        //    ID: ID
        },
        type: "GET",
        contentType: "application/json;charset=UTF-8",
        dataType: "json",
        success: function (result) {
            //debugger;
            $('#ID').val(result.ID);

            $('#Vessel').val(result.ShipName);
            $('#Flag').val(result.FlagOfShip);
            $('#IMONumber').val(result.IMONumber);

            $('#VesselTypeID').val(result.VesselTypeID);
            $('#VesselSubTypeID').val(result.VesselSubTypeID);
            $('#VesselSubSubTypeID').val(result.VesselSubSubTypeID);

            $('#Email1').val(result.ShipEmail);
            $('#Email2').val(result.ShipEmail2);
            $('#Voice1').val(result.Voices1);
            $('#Voice2').val(result.Voices2);
            $('#Fax1').val(result.Fax1);
            $('#Fax2').val(result.Fax2);
            $('#VideoCall1').val(result.VOIP1);
            $('#VideoCall2').val(result.VOIP2);
            $('#Mobile1').val(result.Mobile1);
            $('#Mobile2').val(result.Mobile2);

            //$('#myModal').modal('show');
            //$('#btnUpdate').show();
            //$('#btnAdd').hide();
        },
        error: function (errormessage) {
            //debugger;
            console.log(errormessage.responseText);
        }
    });
    return false;
}






function GetCompanyDetailsNew() {

    var x = $("#myUrlNew").val();
    $.ajax({
        url: x,
        data:
        {
            //    ID: ID
        },
        type: "GET",
        contentType: "application/json;charset=UTF-8",
        dataType: "json",
        success: function (result) {
            //debugger;
            $('#ID').val(result.ID);
            $('#Name').val(result.Name);
            $('#Address').val(result.Address);
            $('#Website').val(result.Website);
            $('#AdminContact').val(result.AdminContact);
            $('#AdminContactEmail').val(result.AdminContactEmail);
            $('#ContactNumber').val(result.ContactNumber);
            $('#Domain').val(result.Domain);
            //$('#myModal').modal('show');
            //$('#btnUpdate').show();
            //$('#btnAdd').hide();
        },
        error: function (errormessage) {
            //debugger;
            console.log(errormessage.responseText);
        }
    });
    return false;
}









function validateNext() {
    var isValid = true;

    if ($('#ShipName').val().length === 0) {
        $('#ShipName').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#ShipName').css('border-color', 'lightgrey');
    }

    if ($('#IMONumber').val().length === 0) {
        $('#IMONumber').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#IMONumber').css('border-color', 'lightgrey');
    }

    if ($('#FlagOfShip').val().length === 0) {
        $('#FlagOfShip').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#FlagOfShip').css('border-color', 'lightgrey');
    }

    if ($('#SuperAdminUserName').val().length === 0) {
        $('#SuperAdminUserName').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#SuperAdminUserName').css('border-color', 'lightgrey');
    }

    if ($('#SuperAdminPassword').val().length === 0) {
        $('#SuperAdminPassword').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#SuperAdminPassword').css('border-color', 'lightgrey');
    }

    if ($('#ConfirmPassword').val().length === 0) {
        $('#ConfirmPassword').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#ConfirmPassword').css('border-color', 'lightgrey');
    }

    if ($('#SuperAdminPassword').val() == $('#ConfirmPassword').val()) {
        $('#ConfirmPassword').css('border-color', 'lightgrey');
        $('#SuperAdminPassword').css('border-color', 'lightgrey');
    }
    else {
        $('#SuperAdminPassword').css('border-color', 'Red');
        $('#ConfirmPassword').css('border-color', 'Red');
        isValid = false;
    }

    return isValid;
}

function SaveInitialShipValues() {
    //debugger;
    var posturl = $('#saveInitialShipValues').val();
    var res = validateNext();
    if (res == false) {
        return false;
    }


    var Ship = {
        Vessel1: $('#ShipName').val(),              ///////////////////////////////////////////////////////////////////////
        Flag: $('#FlagOfShip').val(),
        IMO: $('#IMONumber').val(),
        AdminUser: $('#SuperAdminUserName').val(),
        AdminPassword: $('#SuperAdminPassword').val(),
    };


    //debugger;
    //window.location.href = redirectUrl



    var nexturl = $('#next').val();
    window.location.href = nexturl;



    $.ajax({
        url: posturl,
        data: JSON.stringify(Ship),
        type: "POST",
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        success: function (response) {
           
            if (response.result == 'Redirect') {
                alert('Data Saved Successfully');
               // window.location = response.url;
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














function validateMailServer() {
    var isValid = true;

    if ($('#SmptServer').val().length === 0) {
        $('#SmptServer').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#SmptServer').css('border-color', 'lightgrey');
    }

    if ($('#Port').val().length === 0) {
        $('#Port').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#Port').css('border-color', 'lightgrey');
    }

    //if ($('#MailFrom').val().length === 0) {
    //    $('#MailFrom').css('border-color', 'Red');
    //    isValid = false;
    //}
    //else {
    //    $('#MailFrom').css('border-color', 'lightgrey');
    //}

    //if ($('#MailId').val().length === 0) {
    //    $('#MailId').css('border-color', 'Red');
    //    isValid = false;
    //}
    //else {
    //    $('#MailId').css('border-color', 'lightgrey');
    //}

    //if ($('#Password').val().length === 0) {
    //    $('#Password').css('border-color', 'Red');
    //    isValid = false;
    //}
    //else {
    //    $('#Password').css('border-color', 'lightgrey');
    //}




    if ($('#ShipEmail').val().length === 0) {
        $('#ShipEmail').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#ShipEmail').css('border-color', 'lightgrey');
    }
    if ($('#ShipEmailPassword').val().length === 0) {
        $('#ShipEmailPassword').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#ShipEmailPassword').css('border-color', 'lightgrey');
    }
    if ($('#AdminCenterEmail').val().length === 0) {
        $('#AdminCenterEmail').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#AdminCenterEmail').css('border-color', 'lightgrey');
    }
    if ($('#POP3').val().length === 0) {
        $('#POP3').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#POP3').css('border-color', 'lightgrey');
    }
    if ($('#POP3Port').val().length === 0) {
        $('#POP3Port').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#POP3Port').css('border-color', 'lightgrey');
    }

    return isValid;
}

function SaveConfigData() {
    //debugger;
    var posturl = $('#saveConfigData').val();
    var res = validateMailServer();
    if (res == false) {
        return false;
    }
    var Ship = {
        SmtpServer: $('#SmptServer').val(),
        Port: $('#Port').val(),
        //MailFrom: $('#MailFrom').val(),
        //MailTo: $('#MailId').val(),
        //MailPassword: $('#Password').val(),         
        ShipEmail: $('#ShipEmail').val(),
        ShipEmailPassword: $('#ShipEmailPassword').val(),
        AdminCenterEmail: $('#AdminCenterEmail').val(),
        POP3: $('#POP3').val(),
        POP3Port: $('#POP3Port').val()
    };
    //debugger;


    var gotologin = $('#gotologin').val();
    window.location.href = gotologin;

    $.ajax({
        url: posturl,
        data: JSON.stringify(Ship),
        type: "POST",
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        success: function (response) {
        
            if (response.result == 'Redirect') {
                alert('Data Saved Successfully');
              //  window.location = response.url;    /////

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



function GetCompanyDetailsByID() {
  //  $('#Name').css('border-color', 'lightgrey');
    var x = $("#myUrl").val();
    //alert(x);
    //debugger;
    $.ajax({
        url: x,
        data:
        {
            hash: $('#SecureKey').val()
        },
        type: "GET",
        contentType: "application/json;charset=UTF-8",
        async: "false",
        dataType: "json",
        success: function (result) {
            //debugger;
            $('#ID').val(result.ID);
            //$('#UserID').val(result.AdminID);
            $('#Name').val(result.Name);
            $('#Address').val(result.Address);
            $('#Website').val(result.Website);
            $('#AdminContact').val(result.AdminContact);
            $('#AdminContactEmail').val(result.AdminContactEmail);
            $('#ContactNumber').val(result.ContactNumber);
            $('#Domain').val(result.Domain);
            $('#SecureKey').val(result.SecureKey);

           // $('#myModal').modal('show');
           // $('#btnUpdate').show();
           // $('#btnAdd').hide();
        },
        error: function (errormessage) {
            //debugger;
            console.log(errormessage.responseText);
        }
    });
    return false;
}