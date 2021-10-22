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


    if ($('#ddlRank').val().length === 0) {
        $('#ddlRank').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#ddlRank').css('border-color', 'lightgrey');
    }

    if ($('#Ethinicity').val().length === 0) {
        $('#Ethinicity').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#Ethinicity').css('border-color', 'lightgrey');
    }

    if ($('#Frequency').val().length === 0) {
        $('#Frequency').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#Frequency').css('border-color', 'lightgrey');
    }


    if ($('#Sex').val().length === 0) {
        $('#Sex').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#Sex').css('border-color', 'lightgrey');
    }

    if ($('#Age').val().length === 0) {
        $('#Age').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#Age').css('border-color', 'lightgrey');
    }

    if ($('#JoiningDate').val().length === 0) {
        $('#JoiningDate').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#JoiningDate').css('border-color', 'lightgrey');
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
            //CIRMId: $('#CIRMId').val(),

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
            LocationAndTypeOfInjuryOrBurn: $('#LocationAndTypeOfInjuryOrBurn').val(),
            FrequencyOfPain: $('#FrequencyOfPain').val(),
            FirstAidGiven: $('#FirstAidGiven').val(),
            PercentageOfBurn: $('#PercentageOfBurn').val()

            //SeverityOfPain: $("input[name='SeverityOfPain']:checked").val(),

            //PictureUploadPath: $('#PictureUploadPath').val(),

            //JoiningMedical: document.getElementById("JoiningMedical").checked,
            //MedicineAvailableOnBoard: document.getElementById("MedicineAvailableOnBoard").checked,
            //MedicalEquipmentOnBoard: document.getElementById("MedicalEquipmentOnBoard").checked,
            //MedicalHistoryUpload: document.getElementById("MedicalHistoryUpload").checked,
            //WorkAndRestHourLatestRecord: document.getElementById("WorkAndRestHourLatestRecord").checked,
            //PreExistingMedicationPrescription: document.getElementById("PreExistingMedicationPrescription").checked,



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


function UploadFiles() {
    var res = false;
    if ($('#ddlCrew').val().length === 0) {
        $('#ddlCrew').css('border-color', 'Red');
        res = false;
    }
    else {
        $('#ddlCrew').css('border-color', 'lightgrey');
        res = true;
    }
    
    if (res == false) {
        return false;
    }
    
    if (res) {
        //Checking whether FormData is available in browser  
        if (window.FormData !== undefined) {
            var crewId = $("#ddlCrew").val();
            var fileUpload = $("#uploadCrewHealthImage").get(0);
            var files = fileUpload.files;
            // Create FormData object  
            var fileData = new FormData();

            // Looping over all files and add it to FormData object  
            for (var i = 0; i < files.length; i++) {
                fileData.append(files[i].name, files[i]);
            }

            // Adding one more key to FormData object
            fileData.append('crewId', crewId);
            $.ajax({
                url: '/CrewHealth/UploadCrewHealthImage',
                type: "POST",
                //datatype: "json",
                //contentType: "application/json; charset=utf-8",
                contentType: false, // Not to set any content header  
                processData: false, // Not to process data  
                data: fileData,
                success: function (result) {
                    //alert(result);
                    $("#lblSuccMsg").text(result[1]);
                    $("#hdnCrewHealthImagePath").val(result[0]);
                    $("#lblSuccMsg").removeClass("hidden");

                    //ClearFields();
                    //toastr.options = {
                    //    "closeButton": false,
                    //    "debug": false,
                    //    "newestOnTop": false,
                    //    "progressBar": false,
                    //    "positionClass": "toast-bottom-full-width",
                    //    "preventDuplicates": false,
                    //    "onclick": null,
                    //    "showDuration": "300",
                    //    "hideDuration": "1000",
                    //    "timeOut": "5000",
                    //    "extendedTimeOut": "1000",
                    //    "showEasing": "swing",
                    //    "hideEasing": "linear",
                    //    "showMethod": "fadeIn",
                    //    "hideMethod": "fadeOut"
                    //};

                    //toastr.success("Added Successfully");
                },
                error: function (err) {
                    alert(err.statusText);
                }
            });
        } else {
            alert("FormData is not supported.");
        }

    }

}

function SendMail() {

    var crewHealthDetails = {
        ID                  : $('#ddlCrew').val(),
        Name                : $('#ddlCrew option:selected').text(),
        RankID              : $('#ddlRank').val(),
        RankName            : $('#ddlRank option:selected').text(),
        Nationality         : $('#Nationality option:selected').text(),
        DOB                 : $('#Age').val(),
        JoinDate            : $('#JoiningDate').val(),
        Sex                 : $('#Sex').val(),
        Adiction            : $('#Addiction').val(),
        Ethinicity          : $('#Ethinicity').val(),
        Frequency           : $('#Frequency').val(),
        Category            : $('#Category').val(),
        SubCategory         : $('#SubCategory').val(),
        Pulse               : $('#Pulse').val(),
        SPO2                : $('#OxygenSaturation').val(),
        Respiratory         : $('#RespiratoryRate').val(),
        Systolic            : $('#Systolic').val(),
        Diastolic           : $('#Diastolic').val(),
        ObservedDate        : $('#SymptomatologyDate').val(),
        ObservedTime        : $('#SymptomatologyTime').val(),
        IsVomiting          : $('#Vomiting').val(),
        VomitingFrequency   : $('#FrequencyOfVomiting').val(),
        IsFits              : $('#Fits').val(),
        FitsFrequency       : $('#FrequencyOfFits').val(),
        SympDetails         : $('#Details').val(),
        Medicines           : $('#MedicinesAdministered').val(),
        OtherInfo           : $('#AnyOtherRelevantInformation').val(),
        AccidentDesc        : $('#WhereAndHowAccidentOccured').val(),
        SeverityPain        : $("input[name='SeverityOfPain']:checked").parent('label').text(),
        InjuryLocation      : $('#LocationAndTypeOfInjuryBurn').val(),
        FrequencyOfPain     : $('#FrequencyOfPain').val(),
        FirstAid            : $('#FirstAidGiven').val(),
        PercentageOfInjury  : $('#PercentageOfBurn').val(),
        DoctorsMail         : $('#Email').val()

    };

    $.ajax({
        url: '/CrewHealth/SendMail',
        type: "POST",
        datatype: "json",
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify(crewHealthDetails),
        success: function (result) {
            //alert(result);
            $("#lblSuccMsg").text(result[1]);
            $("#hdnCrewHealthImagePath").val(result[0]);
            $("#lblSuccMsg").removeClass("hidden");

        },
        error: function (err) {
            alert(err.statusText);
        }
    });
}



