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

function SaveCIRM() {
    //debugger;
    var saveCIRM = $('#saveCIRM').val();
    //var res = validate();
    //if (res == false) {
    //    return false;
    //}
    var CIRM = {
        CIRMId: $('#CIRMId').val(),
        NameOfVessel: $('#NameOfVessel').val(),
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
    };
    //debugger;
    $.ajax({
        url: saveCIRM,
        data: JSON.stringify(CIRM),
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