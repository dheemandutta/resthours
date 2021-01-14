function validate() {
    var isValid = true;

    if ($('#ddlCrew').val().length === 0) {
        $('#ddlCrew').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#ddlCrew').css('border-color', 'lightgrey');
    }

    if ($('#Nationality').val().length === 0) {
        $('#Nationality').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#Nationality').css('border-color', 'lightgrey');
    }

    if ($('#Addiction').val().length === 0) {
        $('#Addiction').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#Addiction').css('border-color', 'lightgrey');
    }


    return isValid;
}



function clearTextBox() {
    $('#CIRMId').val("");
    //$('#VesselName').val("");
    $('#ddlCrew').val("");
    $('#Ethinicity').val("");
    $('#Addiction').val("");
    $('#Frequency').val("");
    $('#JoiningDate').val("");
    $('#Category').val("");
    $('#SubCategory').val("");
    $('#Pulse').val("");
    $('#RespiratoryRate').val("");
    $('#OxygenSaturation').val("");
    $('#Systolic').val("");
    $('#Diastolic').val("");
    $('#SymptomatologyDate').val("");
    $('#SymptomatologyTime').val("");
    $('#Vomiting').val("");
    $('#FrequencyOfVomiting').val("");
    $('#Fits').val("");
    $('#FrequencyOfFits').val("");
    $('#SymptomatologyDetails').val("");
    $('#MedicinesAdministered').val("");
    $('#RelevantInformationForDesease').val("");
    $('#WhereAndHowAccidentOccured').val("");
    $('#LocationAndTypeOfInjuryOrBurn').val("");
    $('#FrequencyOfPain').val("");
    $('#PictureUploadPath').val("");
    $('#FirstAidGiven').val("");
    $('#PercentageOfBurn').val("");
}

function SaveCIRM() {

    //alert($('textarea#Comments').val());
    //debugger;
    var posturl = $('#SaveCIRM').val();
    var res = validate();
    if (res == false) {
        return false;
    }
    // alert(res);
    if (res) {
        var Crew = {
            CIRMId: $('#CIRMId').val(),

            CrewId: $('#ddlCrew').val(),
            Nationality: $('#Nationality').val(),
            Addiction: $('#Addiction').val(),
            RankID: $('#ddlRank').val(),
            Ethinicity: $('#Ethinicity').val(),
            Frequency: $('#Frequency').val(),
            Sex: $('#Sex').val(),
            Age: $('#Age').val(),
            JoiningDate: $('#JoiningDate').val(),
            Category: $('#Category').val(),
            SubCategory: $('#SubCategory').val(),
            Pulse: $('#Pulse').val(),
            OxygenSaturation: $('#OxygenSaturation').val(),
            RespiratoryRate: $('#RespiratoryRate').val(),
            Systolic: $('#Systolic').val(),
            Diastolic: $('#Diastolic').val(),
            SymptomatologyDate: $('#SymptomatologyDate').val(),
            SymptomatologyTime: $('#SymptomatologyTime').val(),
            Vomiting: $('#Vomiting').val(),
            FrequencyOfVomiting: $('#FrequencyOfVomiting').val(),
            Fits: $('#Fits').val(),
            FrequencyOfFits: $('#FrequencyOfFits').val(),
            SymptomatologyDetails: $('#SymptomatologyDetails').val(),
            MedicinesAdministered: $('#MedicinesAdministered').val(),
            RelevantInformationForDesease: $('#RelevantInformationForDesease').val(),
            WhereAndHowAccidentOccured: $('#WhereAndHowAccidentOccured').val(),


            //SeverityOfPain: $("input[name='SeverityOfPain']:checked").val(),

            //NoHurt: document.getElementById("NoHurt").checked,
            //HurtLittleBit: document.getElementById("HurtLittleBit").checked,
            //HurtsLittleMore: document.getElementById("HurtsLittleMore").checked,
            //HurtsEvenMore: document.getElementById("HurtsEvenMore").checked,
            //HurtsWholeLot: document.getElementById("HurtsWholeLot").checked,
            //HurtsWoest: document.getElementById("HurtsWoest").checked,


            JoiningMedical: document.getElementById("JoiningMedical").checked,
            MedicineAvailableOnBoard: document.getElementById("MedicineAvailableOnBoard").checked,
            MedicalEquipmentOnBoard: document.getElementById("MedicalEquipmentOnBoard").checked,
            MedicalHistoryUpload: document.getElementById("MedicalHistoryUpload").checked,
            WorkAndRestHourLatestRecord: document.getElementById("WorkAndRestHourLatestRecord").checked,
            PreExistingMedicationPrescription: document.getElementById("PreExistingMedicationPrescription").checked,

            LocationAndTypeOfInjuryOrBurn: $('#LocationAndTypeOfInjuryOrBurn').val(),
            FrequencyOfPain: $('#FrequencyOfPain').val(),
            PictureUploadPath: $('#PictureUploadPath').val(),
            FirstAidGiven: $('#FirstAidGiven').val(),
            PercentageOfBurn: $('#PercentageOfBurn').val()

        //CrewId: $('#ddlCrew').val(),
        //IsMedicalHistoryUploaded: document.getElementById("uploaddoc4").checked
        };

        $.ajax({
            url: posturl,
            data: JSON.stringify(Crew),
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




function GetCrewForCIRMPatientDetails() {

    var x = $("#getCrewForCIRMPatientDetails").val();
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

            $('#CrewName').val(result.CrewName);
            $('#ddlRank').val(result.RankID);
            $('#Sex').val(result.Gender);
            $('#Nationality').val(result.CountryID);
            $('#Age').val(result.DOB);
            //13-01-2021 SSG
            $('#JoiningDate').val(result.CreatedOn);
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



function GetCrewForCIRMPatientDetailsByCrew(ID) {

    var x = $("#getCrewForCIRMPatientDetailsByCrew").val();
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

           // $('#CrewName').val(result.CrewName);
            $('#ddlRank').val(result.RankID);
            $('#Sex').val(result.Gender);
            $('#Nationality').val(result.CountryID);
            $('#Age').val(result.DOB);
            //13-01-2021 SSG
            $('#JoiningDate').val(result.CreatedOn);
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



