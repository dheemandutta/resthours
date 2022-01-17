function validate() {
    var isValid = true;

    if ($('#VesselName').val().length === 0) {
        $('#VesselName').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#VesselName').css('border-color', 'lightgrey');
    }

    if ($('#CallSign').val().length === 0) {
        $('#CallSign').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#CallSign').css('border-color', 'lightgrey');
    }

    return isValid;
}

function clearTextBox() {
    $('#ID').val("");
    //$('#VesselName').val("");
    $('#CallSign').val("");
    $('#DateOfReportingGMT').val("");
    $('#TimeOfReportingGMT').val("");
    $('#PresentLocation').val("");
    $('#Course').val("");
    $('#Speed').val("");
    $('#PortOfDeparture').val("");
    $('#PortOfArrival').val("");
    $('#ETADateGMT').val("");
    $('#ETATimeGMT').val("");
    $('#AgentDetails').val("");
    $('#NearestPortETADateGMT').val("");
    $('#NearestPortETATimeGMT').val("");
    $('#WindSpeed').val("");
    $('#Sea').val("");
    $('#Visibility').val("");
    $('#Swell').val("");


    $('#PortOfRegistry').val("");
    $('#HelicopterDeck').val("");
    $('#HelicopterWinchingArea').val("");
    $('#Length').val("");
    $('#Breadth').val("");
    $('#PAndIClub').val("");
    $('#PAndIClubOther').val("");
    $('#ContactDetails').val("");

}

function SaveVesselDetails() {

    //alert($('textarea#Comments').val());
    //debugger;
    var posturl = $('#SaveVesselDetails').val();
    var res = validate();
    if (res == false) {
        return false;
    }
    //alert(res);
    if (res) {
        var VesselDetails = {
            ID: $('#ID').val(),

            VesselName: $('#VesselName').val(),
            CallSign: $('#CallSign').val(),
            DateOfReportingGMT: $('#DateOfReportingGMT').val(),
            TimeOfReportingGMT: $('#TimeOfReportingGMT').val(),
            PresentLocation: $('#PresentLocation').val(),
            Course: $('#Course').val(),

            Speed: $('#Speed').val(),
            PortOfDeparture: $('#PortOfDeparture').val(),
            PortOfArrival: $('#PortOfArrival').val(),
            ETADateGMT: $('#ETADateGMT').val(),
            ETATimeGMT: $('#ETATimeGMT').val(),
            AgentDetails: $('#AgentDetails').val(),

            NearestPortETADateGMT: $('#NearestPortETADateGMT').val(),
            NearestPortETATimeGMT: $('#NearestPortETATimeGMT').val(),
            WindSpeed: $('#WindSpeed').val(),
            Sea: $('#Sea').val(),
            Visibility: $('#Visibility').val(),
            Swell: $('#Swell').val(),



            PortOfRegistry: $('#PortOfRegistry').val(),
            HelicopterDeck: $('#HelicopterDeck').val(),
            HelicopterWinchingArea: $('#HelicopterWinchingArea').val(),
            Length: $('#Length').val(),
            Breadth: $('#Breadth').val(),
            PAndIClub: $('#PAndIClub').val(),
            PAndIClubOther: $('#PAndIClubOther').val(),
            ContactDetails: $('#ContactDetails').val()

        };

        $.ajax({
            url: posturl,
            data: JSON.stringify(VesselDetails),
            type: "POST",
            contentType: "application/json;charset=utf-8",
            dataType: "json",

            //success: function (result) {

            //    alert('Added Successfully');

            //    clearTextBox();
            //    }         
            //,



            success: function (result) {
                //loadData();
                $('#myModal').modal('hide');
                // alert('Added Successfully');

                toastr.options = {
                    "closeButton": false,
                    "debug": false,
                    "newestOnTop": false,
                    "progressBar": false,
                    "positionClass": "toast-bottom-full-width",
                    "preventDuplicates": false,
                    "onclick": null,
                    "showDuration": "300",
                    "hideDuration": "1000",
                    "timeOut": "5000",
                    "extendedTimeOut": "1000",
                    "showEasing": "swing",
                    "hideEasing": "linear",
                    "showMethod": "fadeIn",
                    "hideMethod": "fadeOut"
                };

                toastr.success("Added Successfully");

                clearTextBox();
            },
            error: function (errormessage) {
                console.log(errormessage.responseText);
            }
        });
    }
}







function GetVesselSubSubTypeIDFromShip() {
    var x = $("#myUrlGetVesselSubSubTypeIDFromShip").val();

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





            $('#VesselSubSubTypeID').val(result[0].VesselSubSubTypeID);
            /////////////////////// GetVesselSubSubTypeByVesselTypeIDForDrp(result[0].VesselSubTypeID);



        },
        error: function (errormessage) {
            alert(errormessage.responseText);
        }
    });
}

function GetVesselSubTypeIDFromShip() {
    var x = $("#myUrlGetVesselSubTypeIDFromShip").val();

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
            $('#VesselSubTypeID').val(result[0].VesselSubTypeID);
            GetVesselSubSubTypeByVesselSubTypeIDForDrp(result[0].VesselSubTypeID);
            //$.each(result, function () {
            //    drpVesselType.append('<option value=' + this.VesselTypeID + '>' + this.Description + '</option>');
            //});
        },
        error: function (errormessage) {
            alert(errormessage.responseText);
        }
    });
}

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
            GetVesselSubTypeByVesselTypeIDForDrp(result[0].VesselTypeID);
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

            drpVesselType.append('<option value=' + '0' + '>' + 'Select' + '</option>');

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

            drpVesselSubType.append('<option value=' + '0' + '>' + 'Select' + '</option>');

            $.each(result, function () {
                drpVesselSubType.append('<option value=' + this.VesselSubTypeID + '>' + this.SubTypeDescription + '</option>');
            });
            GetVesselSubTypeIDFromShip();

        },
        error: function (errormessage) {
            alert(errormessage.responseText);
        }
    });
}

function GetVesselSubSubTypeByVesselSubTypeIDForDrp(VesselSubTypeID) {
    var x = $("#myUrlid2").val();
    console.log(VesselSubTypeID);
    console.log('hiii');
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

            drpVesselSubSubType.append('<option value=' + '0' + '>' + 'Select' + '</option>');

            $.each(result, function () {
                drpVesselSubSubType.append('<option value=' + this.VesselSubSubTypeID + '>' + this.VesselSubSubTypeDecsription + '</option>');
            });
            GetVesselSubSubTypeIDFromShip();
        },
        error: function (errormessage) {
            alert(errormessage.responseText);
        }
    });
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

            $('#VesselName').val(result.ShipName);
            $('#FlagOfShip').val(result.FlagOfShip);
            $('#IMONumber').val(result.IMONumber);

            $('#ShipEmail').val(result.ShipEmail);
            $('#ShipEmail2').val(result.ShipEmail2);
            $('#Voices1').val(result.Voices1);
            $('#Voices2').val(result.Voices2);
            $('#Fax1').val(result.Fax1);
            $('#Fax2').val(result.Fax2);
            $('#VOIP1').val(result.VOIP1);
            $('#VOIP2').val(result.VOIP2);
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