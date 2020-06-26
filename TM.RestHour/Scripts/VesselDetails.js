function validate() {
    var isValid = true;

    if ($('#VesselName').val().length === 0) {
        $('#VesselName').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#VesselName').css('border-color', 'lightgrey');
    }

    return isValid;
}

function clearTextBox() {
    $('#ID').val("");
    $('#VesselName').val("");
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
            Swell: $('#Swell').val()

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