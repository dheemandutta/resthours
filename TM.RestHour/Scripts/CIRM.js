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

        var VitalParams = {
            ID:                 $('#VitalParamsId').val(),
            CIRMId:             $('#CIRMId').val(),
            ObservationDate:    $('#VitalStatisticsDate').val(),
            ObservationTime:    $('#VitalStatisticsTime').val(),
            Pulse:              $('#Pulse').val(),
            RespiratoryRate:    $('#RespiratoryRate').val(),
            OxygenSaturation:   $('#OxygenSaturation').val(),
            Himoglobin:         $('#Himoglobin').val(),
            Creatinine:         $('#Creatinine').val(),
            Bilirubin:          $('#Bilirubin').val(),
            Temperature:        $('#Temperature').val(),
            Systolic:           $('#Systolic').val(),
            Diastolic:          $('#Diastolic').val(),
            Fasting:            $('#Fasting').val(),
            Regular:            $('#Regular').val()
        };
        var Symtomology = {
            ID:                         $('#MedicalSymtomologyId').val(),
            CIRMId:                     $('#CIRMId').val(),
            ObservationDate:            $('#SymptomatologyDate').val(),
            ObservationTime:            $('#SymptomatologyTime').val(),
            Vomiting:                   $('#Vomiting').val(), 
            FrequencyOfVomiting:        $('#FrequencyOfVomiting').val(),
            Fits:                       $('#Fits').val(),
            FrequencyOfFits:            $('#FrequencyOfFits').val(),
            Giddiness:                  $('#Giddiness').val(),
            FrequencyOfGiddiness:       $('#FrequencyOfGiddiness').val(),
            Lethargy:                   $('#Lethargy').val(),
            FrequencyOfLethargy:        $('#FrequencyOfLethargy').val(),
            SymptomologyDetails:        $('#SymtomologyDetails').val(),
            MedicinesAdministered:      $('#MedicinesAdministered').val(),
            AnyOtherRelevantInformation:$('#AnyOtherRelevantInformation').val()
        };                              
        var Crew = {
            CIRMId: $('#CIRMId').val(),

            NameOfVessel:               $('#VesselName').val(),
            RadioCallSign:              $('#CallSign').val(),
            PortofDeparture:            $('#PortOfDeparture').val(),
            PortofDestination:          $('#PortOfArrival').val(),
            LocationOfShip:             $('#LocationOfShip').val(),
            EstimatedTimeOfarrivalhrs:  $('#EstimatedTimeOfArrival').val(),
            Speed:                      $('#Speed').val(),
            Weather:                    $('#Weather').val(),
            AgentDetails:               $('#AgentDetails').val(),


            CrewId:                     $('#ddlCrew').val(),
            Nationality:                $('#Nationality').val(),
            Addiction:                  $('#Addiction').val(),
            RankID:                     $('#ddlRank').val(),
            Ethinicity:                 $('#Ethinicity').val(),
            Frequency:                  $('#Frequency').val(),
            Sex:                        $('#Sex').val(),
            Age:                        $('#Age').val(),
            JoiningDate:                $('#JoiningDate').val(),
            Category:                   $('#Category').val(),
            SubCategory:                $('#SubCategory').val(),

            //Pulse: $('#Pulse').val(),
            //OxygenSaturation: $('#OxygenSaturation').val(),
            //RespiratoryRate: $('#RespiratoryRate').val(),
            //Systolic: $('#Systolic').val(),
            //Diastolic: $('#Diastolic').val(),

            //SymptomatologyDate: $('#SymptomatologyDate').val(),
            //SymptomatologyTime: $('#SymptomatologyTime').val(),
            //Vomiting: $('#Vomiting').val(),
            //FrequencyOfVomiting: $('#FrequencyOfVomiting').val(),
            //Fits: $('#Fits').val(),
            //FrequencyOfFits: $('#FrequencyOfFits').val(),

            //SymptomatologyDetails: $('#SymptomatologyDetails').val(),
            //MedicinesAdministered: $('#MedicinesAdministered').val(),
            //RelevantInformationForDesease: $('#RelevantInformationForDesease').val(),

            PastMedicalHistory: $('#PastMedicalHostory').val(),
            PastTreatmentGiven: $('#TreatmentGiven').val(),
            PastTeleMedicalAdviceReceived: $('#TeleMedicalAdviceReceived').val(),
            PastRemarks: $('#Remarks').val(),
            PastMedicineAdministered: $('#PastMedicineAdministered').val(),
            PastMedicalHistoryPath: $('#hdnPathCIRMPastMedicalHistory').val(),

            WhereAndHowAccidentOccured:         $('#WhereAndHowAccidentOccured').val(),
            LocationAndTypeOfInjuryOrBurn:      $('#LocationAndTypeOfInjuryOrBurn').val(),
            FrequencyOfPain:                    $('#FrequencyOfPain').val(),
            FirstAidGiven:                      $('#FirstAidGiven').val(),
            PercentageOfBurn:                   $('#PercentageOfBurn').val(),

            SeverityOfPain: $("input[name='SeverityOfPain']:checked").val(),

            //PictureUploadPath: $('#PictureUploadPath').val(),

            //JoiningMedical: document.getElementById("JoiningMedical").checked,
            JoiningMedical: $("input[name='uploaddocJoiningMedical']:checked").val() ? true : false,
            JoiningMedicalPath: $('#lblSuccMsgCIRMJoiningMedical').val(),

            //MedicineAvailableOnBoard: document.getElementById("MedicineAvailableOnBoard").checked,
            MedicineAvailableOnBoard: $("input[name='uploaddocMedicineAvailableOnBoard']:checked").val() ? true : false,
            MedicineAvailableOnBoardPath: $('#hdnPathCIRMMedicineAvailableOnBoard').val(),

            //MedicalEquipmentOnBoard: document.getElementById("MedicalEquipmentOnBoard").checked,
            MedicalEquipmentOnBoard: $("input[name='uploaddocMedicalEquipmentOnBoard']:checked").val() ? true : false,
            MedicalEquipmentOnBoardPath: $('#hdnPathCIRMMedicalEquipmentOnBoard').val(),

            //MedicalHistoryUpload: document.getElementById("MedicalHistoryUpload").checked,
            MedicalHistoryUpload: $("input[name='uploaddocMedicalHistoryUpload']:checked").val() ? true : false,
            MedicalHistoryPath: $('#hdnPathCIRMMedicalHistory').val(),

            //WorkAndRestHourLatestRecord: document.getElementById("WorkAndRestHourLatestRecord").checked,
            WorkAndRestHourLatestRecord: $("input[name='uploaddocWorkAndRestHourLatestRecord']:checked").val() ? true : false,
            WorkAndRestHourLatestRecordPath: $('#hdnPathCIRMWorkAndRestHourLatestRecord').val(),
            //PreExistingMedicationPrescription: document.getElementById("PreExistingMedicationPrescription").checked,



        //CrewId: $('#ddlCrew').val(),
        //IsMedicalHistoryUploaded: document.getElementById("uploaddoc4").checked

            VitalParams: VitalParams,
            MedicalSymtomology: Symtomology
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
                HideCIRMUploadModal();
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

function SaveCIRMVitalParams() {

    var posturl = $('#SaveCIRMVitalParams').val();
    var res = validate();
    if (res == false) {
        return false;
    }
    // alert(res);
    if (res) {

        var VitalParams = {
            //ID: $('#VitalParamsId').val(),
            CIRMId: $('#CIRMId').val(),
            ObservationDate: $('#VitalStatisticsDate').val(),
            ObservationTime: $('#VitalStatisticsTime').val(),
            Pulse: $('#Pulse').val(),
            RespiratoryRate: $('#RespiratoryRate').val(),
            OxygenSaturation: $('#OxygenSaturation').val(),
            Himoglobin: $('#Himoglobin').val(),
            Creatinine:  $('#Creatinine').val(),
            Bilirubin: $('#Bilirubin').val(),
            Temperature: $('#Temperature').val(),
            Systolic: $('#Systolic').val(),
            Diastolic: $('#Diastolic').val(),
            Fasting: $('#Fasting').val(),
            Regular: $('#Regular').val()
        };
       
        $.ajax({
            url: posturl,
            data: JSON.stringify(VitalParams),
            type: "POST",
            contentType: "application/json;charset=utf-8",
            dataType: "json",
            success: function (result) {
                $('#myModal').modal('hide');
                // alert('Added Successfully');
                HideCIRMUploadModal();
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

                toastr.success("Vital Param Added Successfully");

                //clearTextBox();
            },
            error: function (errormessage) {
                console.log(errormessage.responseText);
            }
        });
    }
}

function SaveCIRMSymtomology() {

    var posturl = $('#SaveCIRMSymtomology').val();
    var res = validate();
    if (res == false) {
        return false;
    }
    
    if (res) {

        var Symtomology = {
            //ID: $('#MedicalSymtomologyId').val(),
            CIRMId: $('#CIRMId').val(),
            ObservationDate: $('#SymptomatologyDate').val(),
            ObservationTime: $('#SymptomatologyTime').val(),
            Vomiting: $('#Vomiting').val(),
            FrequencyOfVomiting: $('#FrequencyOfVomiting').val(),
            Fits: $('#Fits').val(),
            FrequencyOfFits: $('#FrequencyOfFits').val(),
            Giddiness: $('#Giddiness').val(),
            FrequencyOfGiddiness: $('#FrequencyOfGiddiness').val(),
            Lethargy: $('#Lethargy').val(),
            FrequencyOfLethargy: $('#FrequencyOfLethargy').val(),
            SymptomologyDetails: $('#SymtomologyDetails').val(),
            MedicinesAdministered: $('#MedicinesAdministered').val(),
            AnyOtherRelevantInformation: $('#AnyOtherRelevantInformation').val()
        };

        $.ajax({
            url: posturl,
            data: JSON.stringify(Symtomology),
            type: "POST",
            contentType: "application/json;charset=utf-8",
            dataType: "json",
            success: function (result) {
                $('#myModal').modal('hide');
                HideCIRMUploadModal();
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

                toastr.success("Symtomology Added Successfully");

                //clearTextBox();
            },
            error: function (errormessage) {
                console.log(errormessage.responseText);
            }
        });
    }
}


function HideCIRMUploadModal() {
    $('#myModalMedicalEquipmentOnBoard').modal('hide');
    $('#myModalMedicineAvailableOnBoard').modal('hide');
    $('#myModalJoiningMedical').modal('hide');
    $('#myModalMedicalHistoryUpload').modal('hide');
    $('#myModalWorkAndRestHourLatestRecord').modal('hide');
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

function UploadCIRMFile(control,filetype) {
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
            var fileUpload = $("#"+control).get(0);
            var files = fileUpload.files;
            // Create FormData object  
            var fileData = new FormData();

            // Looping over all files and add it to FormData object  
            for (var i = 0; i < files.length; i++) {
                fileData.append(files[i].name, files[i]);
            }

            // Adding one more key to FormData object
            fileData.append('crewId', crewId);
            fileData.append('fileType', filetype);
            $.ajax({
                url: '/CrewHealth/UploadCIRMPatientMediclImages',
                type: "POST",
                //datatype: "json",
                //contentType: "application/json; charset=utf-8",
                contentType: false, // Not to set any content header  
                processData: false, // Not to process data  
                data: fileData,
                success: function (result) {
                    //alert(result);
                    $("#lblSuccMsgCIRM" + filetype).text(result[1]);
                    $("#hdnPathCIRM" + filetype).val(result[0]);
                    $("#lblSuccMsgCIRM" + filetype).removeClass("hidden");

                    //ClearFields();
                    if (filetype == "PastMedicalHistory") {
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

                        toastr.success(result[1] + "Added Successfully");
                    }
                    
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

function SendMail2() {

    if ($('#CIRMId').val().length === 0) {
        alert("There is no CIRM for the selected Crew. Please create a CIRM for Vrew.");
    }
    else {

        $.ajax({
            url: '/CrewHealth/SendCIRMMail',
            type: "POST",
            datatype: "json",
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify({

                crewId: $('#ddlCrew').val(),
                cirmId: $('#CIRMId').val(),
                doctorsMail: $('#Email').val()

            }),
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

   
}

function GetCIRMDetailsByCrew(id) {
    var x = $("#getCIRMDetailsByCrew").val();
    $.ajax({
        url: x,
        data:
        {
            ID: id
        },
        type: "GET",
        contentType: "application/json;charset=UTF-8",
        dataType: "json",
        success: function (result) {
            //debugger;
            $('#CIRMId').val(result.CIRMId);
            $('#PortOfDeparture').val(result.PortofDeparture);
            $('#PortOfArrival').val(result.PortofDestination);
            $('#Speed').val(result.Speed);
            $('#CallSign').val(result.RadioCallSign);
            $('#Weather').val(result.Weather);
            $('#LocationOfShip').val(result.LocationOfShip);
            $('#EstimatedTimeOfArrival').val(result.EstimatedTimeOfarrivalhrs);
            $('#AgentDetails').val(result.AgentDetails);

            $('#Addiction').val(result.Addiction);
            $('#Ethinicity').val(result.Ethinicity);
            $('#Frequency').val(result.Frequency);

            $('#Category').val(result.Category);
            $('#SubCategory').val(result.SubCategory);

            //$('#VitalStatisticsDate').val(convertJsonDateToShortDate(result.VitalStatistics.ObservationDate));
            //$('#VitalStatisticsTime').val(convertJsonDateToShortTime(result.VitalStatistics.ObservationTime));
            $('#VitalStatisticsDate').val(result.VitalStatistics.ObservationDate);
            $('#VitalStatisticsTime').val(result.VitalStatistics.ObservationTime);
            $('#RespiratoryRate').val(result.VitalStatistics.RespiratoryRate);
            $('#Temperature').val(result.VitalStatistics.Temperature);
            $('#Pulse').val(result.VitalStatistics.Pulse);
            $('#OxygenSaturation').val(result.VitalStatistics.OxygenSaturation);
            $('#Creatinine').val(result.VitalStatistics.Creatinine);
            $('#Himoglobin').val(result.VitalStatistics.Himoglobin);
            $('#Bilirubin').val(result.VitalStatistics.Bilirubin);
            $('#Systolic').val(result.VitalStatistics.Systolic);
            $('#Diastolic').val(result.VitalStatistics.Diastolic);
            $('#Fasting').val(result.VitalStatistics.Fasting);
            $('#Regular').val(result.VitalStatistics.Regular);

            
            $('#SymptomatologyDate').val(result.Symtomology.ObservationDate);
            $('#SymptomatologyTime').val((result.Symtomology.ObservationTime));
            $('#Vomiting').val(result.Symtomology.Vomiting);
            $('#FrequencyOfVomiting').val(result.Symtomology.FrequencyOfVomiting);
            $('#Fits').val(result.Symtomology.Fits);
            $('#FrequencyOfFits').val(result.Symtomology.FrequencyOfFits);
            $('#Giddiness').val(result.Symtomology.Giddiness);
            $('#FrequencyOfGiddiness').val(result.Symtomology.FrequencyOfGiddiness);
            $('#Lethargy').val(result.Symtomology.Lethargy);
            $('#FrequencyOfLethargy').val(result.Symtomology.FrequencyOfLethargy);
            $('#SymtomologyDetails').val(result.Symtomology.SymptomologyDetails);
            $('#MedicinesAdministered').val(result.Symtomology.MedicinesAdministered);
            $('#AnyOtherRelevantInformation').val(result.Symtomology.AnyOtherRelevantInformation);

            $('#PastMedicalHostory').val(result.PastMedicalHistory);
            $('#Remarks').val(result.PastRemarks);
            $('#TreatmentGiven').val(result.PastTreatmentGiven);
            $('#PastMedicineAdministered').val(result.PastMedicineAdministered);
            $('#TeleMedicalAdviceReceived').val(result.PastTeleMedicalAdviceReceived);
            $('#hdnPathCIRMPastMedicalHistory').val(result.PastMedicalHistoryPath);

            $('#WhereAndHowAccidentOccured').val(result.WhereAndHowAccidentOccured);
            $('#LocationAndTypeOfInjuryBurn').val(result.LocationAndTypeOfInjuryOrBurn);
            $('#FirstAidGiven').val(result.FirstAidGiven);
            $('#FrequencyOfPain').val(result.FrequencyOfPain);
            $('#PercentageOfBurn').val(result.PercentageOfBurn);

            if (result.SeverityOfPain > 0 || result.SeverityOfPain != null) {
                var value = result.SeverityOfPain;
                $("input[name=SeverityOfPain][value=" + value + "]").prop('checked', true);
            }
            //else if (result.SeverityOfPain == 2) {

            //}
            //else if (result.SeverityOfPain == 3) {

            //}
            //else if (result.SeverityOfPain == 4) {

            //}
            //else if (result.SeverityOfPain == 5) {

            //}
            //else if (result.SeverityOfPain == 6) {

            //}


            if (result.MedicalEquipmentOnBoard) {
                $("#uploaddocMedicalEquipmentOnBoard").prop("checked", true);
                $("#hdnPathCIRMMedicalEquipmentOnBoard").val(result.MedicalEquipmentOnBoardPath);
                HideCIRMUploadModal();
            }
            if (result.MedicineAvailableOnBoard) {
                $("#uploaddocMedicineAvailableOnBoard").prop("checked", true);
                $("#hdnPathCIRMMedicineAvailableOnBoard").val(result.MedicineAvailableOnBoardPath);
                HideCIRMUploadModal();
            }
            if (result.JoiningMedical) {
                $("#uploaddocJoiningMedical").prop("checked", true);
                $("#hdnPthCIRMJoiningMedical").val(result.JoiningMedicalPath);
                HideCIRMUploadModal();
            }
            if (result.MedicalHistoryUpload) {
                $("#uploaddocMedicalHistoryUpload").prop("checked", true);
                $("#hdnPathCIRMMedicalHistory").val(result.MedicalHistoryPath);
                HideCIRMUploadModal();
            }
            if (result.WorkAndRestHourLatestRecord) {
                $("#uploaddocWorkAndRestHourLatestRecord").prop("checked", true);
                $("#hdnPathCIRMWorkAndRestHourLatestRecord").val(result.WorkAndRestHourLatestRecordPath);
                HideCIRMUploadModal();
            }



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

function convertJsonDateToShortDate(data) {
    // This function converts a json date to a short date
    // e.g. /Date(1538377200000)/ to 10/1/2018

    const dateValue = new Date(parseInt(data.substr(6)));
    //const timeValue = new Ti
    //return dateValue.toLocaleDateString("en-US") + ' - ' + dateValue.toLocaleTimeString();
    //return dateValue.toISOString(0,10) + ' - ' + dateValue.toLocaleTimeString();
    //return dateValue.toISOString().split('T')[0] + ' || ' + dateValue.toLocaleTimeString();
    return dateValue.toISOString().split('T')[0];
    //return dateValue;
}
function convertJsonDateToShortTime(data) {
    // This function converts a json date to a short date
    // e.g. /Date(1538377200000)/ to 10/1/2018

    const dateValue = new Date(parseInt(data.substr(6)));
    //const timeValue = new Ti
    //return dateValue.toLocaleDateString("en-US") + ' - ' + dateValue.toLocaleTimeString();
    //return dateValue.toISOString(0,10) + ' - ' + dateValue.toLocaleTimeString();
    //return dateValue.toISOString().split('T')[0] + ' || ' + dateValue.toLocaleTimeString();
    return dateValue.toLocaleTimeString();
    //return dateValue;
}


function loadCIRMVitalParamsData() {
    var loadposturl = $('#loaddata').val();
    var cirmId = "0";
    if ($('#CIRMId').val().length === 0) {
        alert("There is no CIRM for the selected Crew. Please create a CIRM for Vrew.");
    }
    else {
       
        cirmId = $('#CIRMId').val();
        SetUpCIRMVitalParamsGrid(cirmId);
        $('#myModalCIRMVitalParams').modal('show');
    }
    
}

function loadCIRMSymtomologyData() {
    var loadposturl = $('#loaddata').val();
    var cirmId = "0";
    if ($('#CIRMId').val().length === 0) {
        alert("There is no CIRM for the selected Crew. Please create a CIRM for Vrew.");
    }
    else {
        
        cirmId = $('#CIRMId').val();
        SetUpCIRMSymtomologyGrid(cirmId);
        $('#myModalCIRMSymtomology').modal('show');
    }

    
}

function SetUpCIRMVitalParamsGrid(cirmId) {
    var lposturl = $('#showCIRMVitalParams').val();
    
    //do not throw error
    $.fn.dataTable.ext.errMode = 'none';

    if ($.fn.dataTable.isDataTable('#CIRMVitalParamstable')) {
        table = $('#CIRMVitalParamstable').DataTable();
        table.destroy();
    }

    $("#CIRMVitalParamstable").DataTable({
        "processing": true, // for show progress bar
        "serverSide": true, // for process server side
        "filter": false, // this is for disable filter (search box)
        "orderMulti": false, // for disable multiple column at once
        "bLengthChange": false, //disable entries dropdown
        "ordering": false,
        "bInfo": false,
        "deferRender": true,
        "ajax": {
            "url": lposturl,
            "type": "POST",
            "data": {
                cirmId: cirmId

            },
            "datatype": "json"
        },

        "columns": [
            {
                //"data": "ObservationDate", "name": "ObservationDate", "autoWidth": true
                "autoWidth": true,
                "targets": 2,
                "data": 'data',
                "render": function (data, type, full, meta) {
                    //alert(full.observationdate);
                    //var invNo = full.observationdate;
                    console.log(full);
                    return full.ObservationDate + ' - ' + full.ObservationTime;
                }
               

            },
            //{
            //    "data": "ObservationTime", "name": "ObservationTime", "autoWidth": true
            //},
            {
                "data": "Pulse", "name": "Pulse", "autoWidth": true
            },
            {
                "data": "RespiratoryRate", "name": "RespiratoryRate", "autoWidth": true
            },
            {
                "data": "OxygenSaturation", "name": "OxygenSaturation", "autoWidth": true
            },
            {
                "data": "Himoglobin", "name": "Himoglobin", "autoWidth": true
            },
            {
                "data": "Creatinine", "name": "Creatinine", "autoWidth": true
            },
            {
                "data": "Bilirubin", "name": "Bilirubin", "autoWidth": true
            },
            {
                "data": "Temperature", "name": "Temperature", "autoWidth": true
            },
            {
                "data": "Systolic", "name": "Systolic", "autoWidth": true
            },
            {
                "data": "Diastolic", "name": "Diastolic", "autoWidth": true
            },
            {
                "data": "Fasting", "name": "Fasting", "autoWidth": true
            },
            {
                "data": "Regular", "name": "Regular", "autoWidth": true
            }

        ],

        "rowId": "ID",
        //"dom": "Bfrtip"
        
    });
}

function SetUpCIRMSymtomologyGrid(cirmId) {
    var lposturl = $('#showCIRMSymtomology').val();
    
    //do not throw error
    $.fn.dataTable.ext.errMode = 'none';

    if ($.fn.dataTable.isDataTable('#CIRMSymtomologytable')) {
        table = $('#CIRMSymtomologytable').DataTable();
        table.destroy();
    }

    $("#CIRMSymtomologytable").DataTable({
        "processing": true, // for show progress bar
        "serverSide": true, // for process server side
        "filter": false, // this is for disable filter (search box)
        "orderMulti": false, // for disable multiple column at once
        "ordering": false,
        "bLengthChange": false, //disable entries dropdown
        "bInfo": false,
        "deferRender": true,
        "ajax": {
            "url": lposturl,
            "type": "POST",
            "data": {
                cirmId: cirmId

            },
            "datatype": "json"
        },

        "columns": [
            {
                //"data": "ObservationDate", "name": "ObservationDate", "autoWidth": true
                "targets": 2,
                "data": 'data',
                "render": function (data, type, full, meta) {
                    //alert(full.observationdate);
                    //var invNo = full.observationdate;
                    console.log(full);
                    return full.ObservationDate + ' - ' + full.ObservationTime;
                }
            },
            //{
            //    "data": "ObservationTime", "name": "ObservationTime", "autoWidth": true
            //},
            {
                //"data": "Vomiting", "name": "Vomiting", "autoWidth": true

                "targets": 2,
                "data": 'data',
                "render": function (data, type, full, meta) {
                    //alert(full.observationdate);
                    //var invNo = full.observationdate;
                    console.log(full);
                    return full.Vomiting + ' ( ' + full.FrequencyOfVomiting +' )';
                }
            },
            //{
            //    "data": "FrequencyOfVomiting", "name": "FrequencyOfVomiting", "autoWidth": true
            //},
            {
                //"data": "Fits", "name": "Fits", "autoWidth": true
                "autoWidth": true,
                "targets": 2,
                "data": 'data',
                "render": function (data, type, full, meta) {
                    //alert(full.observationdate);
                    //var invNo = full.observationdate;
                    console.log(full);
                    return full.Fits + ' ( ' + full.FrequencyOfFits+' )';
                }
            },
            //{
            //    "data": "FrequencyOfFits", "name": "FrequencyOfFits", "autoWidth": true
            //},
            {
                //"data": "Giddiness", "name": "Giddiness", "autoWidth": true
                "targets": 2,
                "data": 'data',
                "render": function (data, type, full, meta) {
                    //alert(full.observationdate);
                    //var invNo = full.observationdate;
                    console.log(full);
                    return full.Giddiness + ' ( ' + full.FrequencyOfGiddiness+' )';
                }
            },
            //{
            //    "data": "FrequencyOfGiddiness", "name": "FrequencyOfGiddiness", "autoWidth": true
            //},
            {
                //"data": "Lethargy", "name": "Lethargy", "autoWidth": true
                "targets": 2,
                "data": 'data',
                "render": function (data, type, full, meta) {
                    //alert(full.observationdate);
                    //var invNo = full.observationdate;
                    console.log(full);
                    return full.Lethargy + ' ( ' + full.FrequencyOfLethargy +' )';
                }
            },
            //{
            //    "data": "FrequencyOfLethargy", "name": "FrequencyOfLethargy", "autoWidth": true
            //},
            {
                "data": "SymptomologyDetails", "name": "SymptomologyDetails", "autoWidth": true
            },
            {
                "data": "MedicinesAdministered", "name": "MedicinesAdministered", "autoWidth": true
            },
            {
                "data": "AnyOtherRelevantInformation", "name": "AnyOtherRelevantInformation", "autoWidth": true
            }

        ],

        "rowId": "ID",
        //"dom": "Bfrtip"
    });
}


