function validate() {
    var isValid = true;

    if ($('#ShipName').val().length === 0) {
        $('#ShipName').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#ShipName').css('border-color', 'lightgrey');
    }


    return isValid;
}

//function clearTextBox() {
//    //$("#ddlAdmCru option:selected").prop("selected", false);

//    $('#ddlAdmCru option:selected').each(function () {
//        $(this).prop('selected', false);
//    });

//    $('#ddlAdmCru').multiselect('refresh');

//    //  $('#DepartmentMasterID').val("");
//    $('#DepartmentMasterName').val("");
//    $('#DepartmentMasterCode').val("");
//    $('#ID').val("");
//    $('#btnUpdate').hide();
//    $('#btnAdd').show();

//}

function SaveCIRM() {
    //debugger;
    var saveCIRM = $('#saveCIRM').val();
    //var res = validate();
    //if (res == false) {
    //    return false;
    //}
    var CIRM = {
        CIRMId: $('#CIRMId').val(),
        //NameOfVessel: $('#NameOfVessel').val(),
        RadioCallSign: $('#RadioCallSign').val(),
        PortofDestination: $('#PortofDestination').val(),
        Route: $('#Route').val(),
        LocationOfShip: $('#LocationOfShip').val(),
        PortofDeparture: $('#PortofDeparture').val(),
        EstimatedTimeOfarrivalhrs: $('#EstimatedTimeOfarrival').val(),
        Speed: $('#Speed').val(),
        Nationality: $('#Nationality').val(),
        Qualification: $('#Qualification').val(),
        RespiratoryRate: $('#RespiratoryRate').val(),
        Pulse: $('#Pulse').val(),
        Temperature: $('#Temperature').val(),
        Systolic: $('#Systolic').val(),
        Diastolic: $('#Diastolic').val(),
        Symptomatology: $('#Symptomatology').val(),
        LocationAndTypeOfPain: $('#Locationandtypeofpain').val(),
        RelevantInformationForDesease: $('#RelevantInformationforDesease').val(),
        WhereAndHowAccidentIsCausedCHK: document.getElementById("WhereandHowAccidentiscausedCHK").checked,
        UploadMedicalHistory: $('#UploadMedicalHistory').val(),
        UploadMedicinesAvailable: $('#UploadMedicinesAvailable').val(),
        MedicalProductsAdministered: $('#MedicalProductsAdministered').val(),
        WhereAndHowAccidentIsausedARA: $('#WhereandHowAccidentiscausedARA').val(),

        CrewId: $('#ddlCrew').val()
    };
    //debugger;
   // console.log(CIRM);
    $.ajax({
        url: saveCIRM,
        data: JSON.stringify(CIRM),
        type: "POST",
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        success: function (result) {
            //loadData();
            //$('#myModal').modal('hide');
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

            //clearTextBox();
        },
        error: function (errormessage) {
            console.log(errormessage.responseText);
        }
    });
}


