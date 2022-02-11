var IsNewCIRM = false;
var IsReuseCIRMData = false;
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

function validateEmail() {
    var isValid = true;

    if ($('#Email').val().length === 0) {
        $('#Email').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#Email').css('border-color', 'lightgrey');
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

function ClearAllFields() {
    
    //$('#VesselName').val("");
    $('#DateOfReportingGMT').val();
    $('#TimeOfReportingGMT').val();
    $('#LocationOfShip').val();
    $('#Cousre').val();
    $('#Speed').val();
    $('#PortOfDeparture').val();
    $('#DateOfDeparture').val();
    $('#TimeOfDeparture').val();
    $('#PortOfArrival').val();
    $('#ETADateGMT').val();
    $('#ETATimeGMT').val();
    $('#EstimatedTimeOfArrival').val();
    $('#AgentDetails').val();
    $('#NearestPort').val();
    $('#NearestPortETADateGMT').val();
    $('#NearestPortETATimeGMT').val();
    $('#OtherPossiblePort').val();
    $('#OtherPortETADateGMT').val();
    $('#OtherPortETATimeGMT').val();

    $('#Direction').val();
        $('#BeaufortScale').val();
        $('#WindSpeed').val();
        $('#SeaState').val();
        $('#WaveHeight').val();
        $('#Swell').val();
        $('#WeatherCondition').val();
        $('#Visibility').val();
        $('#WeatherCondition').val();

    
    $('#Ethinicity').val("");
    $('#Addiction').val("");
    $('#Frequency').val("");
    $('#JoiningDate').val("");
    $('#DateResumeWork').val();
    $('#TimeResumeWork').val();

   
    $('#RelevantInformationForDesease').val("");
    $('#WhereAndHowAccidentOccured').val("");
    $('#LocationAndTypeOfInjuryOrBurn').val("");
    $('#FrequencyOfPain').val("");
    $('#PictureUploadPath').val("");
    $('#FirstAidGiven').val("");
    $('#PercentageOfBurn').val("");

    $('#VitalParamsId').val();
    $('#CIRMId').val();
    $('#VitalStatisticsDate').val();
    $('#VitalStatisticsTime').val();
    $('#Pulse').val();
    $('#RespiratoryRate').val();
    $('#OxygenSaturation').val();
    $('#Himoglobin').val();
    $('#Creatinine').val();
    $('#Bilirubin').val();
    $('#Temperature').val();
    $('#Systolic').val();
    $('#Diastolic').val();
    $('#Fasting').val();
    $('#Regular').val();

    $('#MedicalSymtomologyId').val();
    $('#CIRMId').val();
    $('#SymptomatologyDate').val();
    $('#SymptomatologyTime').val();
    $('#Vomiting').val();
    $('#FrequencyOfVomiting').val();
    $('#Fits').val();
    $('#FrequencyOfFits').val();
    $('#Giddiness').val();
    $('#FrequencyOfGiddiness').val();
    $('#Lethargy').val();
    $('#FrequencyOfLethargy').val();
    $('#AnyOtherRelevantInformation').val();
    $('#Ailment').val();
}

function ClearSymtomology() {
   $('#MedicalSymtomologyId').val("");
    $('#CIRMId').val("");
    $('#SymptomatologyDate').val("");
    $('#SymptomatologyTime').val("");
    $('#Vomiting').val("");
    $('#FrequencyOfVomiting').val("");
    $('#Fits').val("");
    $('#FrequencyOfFits').val("");
    $('#Giddiness').val("");
    $('#FrequencyOfGiddiness').val("");
    $('#Lethargy').val("");
    $('#FrequencyOfLethargy').val("");
    //SymptomologyDetails: $('#SymtomologyDetails').val("");
    //MedicinesAdministered: $('#MedicinesAdministered').val("");
    $('#AnyOtherRelevantInformation').val("");
}

function ClearAccidentDetails() {
   $('#WhereAndHowAccidentOccured').val("");
   $('#LocationAndTypeOfInjuryOrBurn').val("");
   $('#FirstAidGiven').val("");
   $('#FrequencyOfPain').val("");
   $('#TypeOfBurn').val("");
   $('#TypeOfBurn').val("");
   $('#DegreeOfBurn').val("");
   $('#PercentageOfBurn').val("");
   //$("input[name='SeverityOfPain']:checked").val(0);
}

function ClearTelemedicalConsuotationDetails() {
    $('#TeleMedicalContactDate').val("");
    $('#TeleMedicalContactTime').val("");
    $('#ModeOfCommunication').val("");
    $('#NameOfTelemedicalConsultant').val("");
    $('#DetailsOfTreatmentAdvised').val("");
}
function ClearMedicalTreatmentGivenOnboardDetails() {
    $('#PriorRadioMedicalAdvice').val("");
    $('#AfterRadioMedicalAdvice').val("");
    $('#HowIsPatientRespondingToTreatmentGiven').val("");
    $("input:checkbox.DoesPatientNeedRemoveFromVessel").prop("checked", false);
    $("#dvPatientNeedRemoveFromVessel").hide();
    $("#NeedRemovalDesc").val("");
    $("#NeedRemovalToPort").val("");
    $('#AdditionalNotes').val("");
}

function SaveCIRM(medicalAssistanceType) {

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
            MedicalAssitanceType:       medicalAssistanceType, //Added on 25th Jan 2022

            NameOfVessel:               $('#VesselName').val(),
            RadioCallSign:              $('#CallSign').val(),

            
            //#region Voyage Details
            DateOfReportingGMT:         $('#DateOfReportingGMT').val(),
            TimeOfReportingGMT:         $('#TimeOfReportingGMT').val(),
            LocationOfShip:             $('#LocationOfShip').val(),
            Cousre:                     $('#Cousre').val(),
            Speed:                      $('#Speed').val(),
            PortofDeparture:            $('#PortOfDeparture').val(),
            DateOfDeparture:            $('#DateOfDeparture').val(),
            TimeOfDeparture:            $('#TimeOfDeparture').val(),
            PortofDestination:          $('#PortOfArrival').val(),
            ETADateGMT:                 $('#ETADateGMT').val(),
            ETATimeGMT:                 $('#ETATimeGMT').val(),
            EstimatedTimeOfarrivalhrs:  $('#EstimatedTimeOfArrival').val(),
            AgentDetails:               $('#AgentDetails').val(),
            NearestPort:                $('#NearestPort').val(),
            NearestPortETADateGMT:      $('#NearestPortETADateGMT').val(),
            NearestPortETATimeGMT:      $('#NearestPortETATimeGMT').val(),
            OtherPossiblePort:          $('#OtherPossiblePort').val(),
            OtherPortETADateGMT:        $('#OtherPortETADateGMT').val(),
            OtherPortETATimeGMT:        $('#OtherPortETATimeGMT').val(),

            //#endregion

            //#region Weather Details
            WindDirection:              $('#Direction').val(),
            BeaufortScale:              $('#BeaufortScale').val(),
            WindSpeed:                  $('#WindSpeed').val(),
            SeaState:                   $('#SeaState').val(),
            WaveHeight:                 $('#WaveHeight').val(),
            Swell:                      $('#Swell').val(),
            WeatherCondition:           $('#WeatherCondition').val(),
            WeatherVisibility:          $('#Visibility').val(),
            Weather:                    $('#WeatherCondition').val(),
            //#endregion 

            //#region Crew Details
            CrewId:                     $('#ddlCrew').val(),
            Nationality:                $('#Nationality').val(),
            Addiction:                  $('#Addiction').val(),
            RankID:                     $('#ddlRank').val(),
            Ethinicity:                 $('#Ethinicity').val(),
            Frequency:                  $('#Frequency').val(),
            Sex:                        $('#Sex').val(),
            Age:                        $('#Age').val(),
            JoiningDate:                $('#JoiningDate').val(),
            //#endregion

            //#region Type of Ailment
            Category:                   $('#Category').val(),
            SubCategory:                $('#SubCategory').val(),
            //#endregion

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

            //#region Past Medical History
            PastMedicalHistory: $('#PastMedicalHostory').val(),
            PastTreatmentGiven: $('#TreatmentGiven').val(),
            PastTeleMedicalAdviceReceived: $('#TeleMedicalAdviceReceived').val(),
            PastRemarks: $('#Remarks').val(),
            PastMedicineAdministered: $('#PastMedicineAdministered').val(),
            PastMedicalHistoryPath: $('#hdnPathCIRMPastMedicalHistory').val(),
            //#endregion

            //#region Incase of Injury/Sevierty of Pain
            WhereAndHowAccidentOccured:         $('#WhereAndHowAccidentOccured').val(),
            LocationAndTypeOfInjuryOrBurn:      $('#LocationAndTypeOfInjuryOrBurn').val(),
            FrequencyOfPain:                    $('#FrequencyOfPain').val(),
            FirstAidGiven:                      $('#FirstAidGiven').val(),
            PercentageOfBurn:                   $('#PercentageOfBurn').val(),

            SeverityOfPain: $("input[name='SeverityOfPain']:checked").val(),
            //#endregion

            //#region Upload section
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
            //#endregion


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

function SaveCIRMNew(medicalAssistanceType) {
    //Created on 29th Jan 2022
    //alert($('textarea#Comments').val());
    //debugger;
    var posturl = $('#SaveCIRM').val();
    var medicationsTaken;
    var res = validate();
    if (res == false) {
        return false;
    }
    // alert(res);
    if (res) {
        if (CreateMedicationTakenDetailsJsonObject()) {
            /*MedicationTakenList = JSON.stringify({MedicationTakenList});*/
            MedicationTakenList = MedicationTakenList;
        }
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
            ID:                             $('#MedicalSymtomologyId').val(),
            CIRMId:                         $('#CIRMId').val(),
            ObservationDate:                $('#SymptomatologyDate').val(),
            ObservationTime:                $('#SymptomatologyTime').val(),
            Vomiting:                       $('#Vomiting').val(),
            FrequencyOfVomiting:            $('#FrequencyOfVomiting').val(),
            Fits:                           $('#Fits').val(),
            FrequencyOfFits:                $('#FrequencyOfFits').val(),
            Giddiness:                      $('#Giddiness').val(),
            FrequencyOfGiddiness:           $('#FrequencyOfGiddiness').val(),
            Lethargy:                       $('#Lethargy').val(),
            FrequencyOfLethargy:            $('#FrequencyOfLethargy').val(),
            //SymptomologyDetails: $('#SymtomologyDetails').val(),
            //MedicinesAdministered: $('#MedicinesAdministered').val(),
            AnyOtherRelevantInformation:    $('#AnyOtherRelevantInformation').val(),
            Ailment:                        $('#Ailment').val()
        };
        var cIRM = {
            CIRMId: $('#CIRMId').val(),
            MedicalAssitanceType: medicalAssistanceType,

            NameOfVessel: $('#VesselName').val(),
            RadioCallSign: $('#CallSign').val(),


            //#region Voyage Details
            DateOfReportingGMT:         $('#DateOfReportingGMT').val(),
            TimeOfReportingGMT:         $('#TimeOfReportingGMT').val(),
            LocationOfShip:             $('#LocationOfShip').val(),
            Cousre:                     $('#Cousre').val(),
            Speed:                      $('#Speed').val(),
            PortofDeparture:            $('#PortOfDeparture').val(),
            DateOfDeparture:            $('#DateOfDeparture').val(),
            TimeOfDeparture:            $('#TimeOfDeparture').val(),
            PortofDestination:          $('#PortOfArrival').val(),
            ETADateGMT:                 $('#ETADateGMT').val(),
            ETATimeGMT:                 $('#ETATimeGMT').val(),
            EstimatedTimeOfarrivalhrs:  $('#EstimatedTimeOfArrival').val(),
            AgentDetails:               $('#AgentDetails').val(),
            NearestPort:                $('#NearestPort').val(),
            NearestPortETADateGMT:      $('#NearestPortETADateGMT').val(),
            NearestPortETATimeGMT:      $('#NearestPortETATimeGMT').val(),
            OtherPossiblePort:          $('#OtherPossiblePort').val(),
            OtherPortETADateGMT:        $('#OtherPortETADateGMT').val(),
            OtherPortETATimeGMT:        $('#OtherPortETATimeGMT').val(),

            //#endregion

            //#region Weather Details
            WindDirection:      $('#Direction').val(),
            BeaufortScale:      $('#BeaufortScale').val(),
            WindSpeed:          $('#WindSpeed').val(),
            SeaState:           $('#SeaState').val(),
            WaveHeight:         $('#WaveHeight').val(),
            Swell:              $('#Swell').val(),
            WeatherCondition:   $('#WeatherCondition').val(),
            WeatherVisibility:  $('#Visibility').val(),
            Weather:            $('#WeatherCondition').val(),
            //#endregion 

            //#region Crew Details
            CrewId: $('#ddlCrew').val(),
            Nationality: $('#Nationality').val(),
            Addiction: $('#Addiction').val(),
            RankID: $('#ddlRank').val(),
            Ethinicity: $('#Ethinicity').val(),
            Frequency: $('#Frequency').val(),
            Sex: $('#Sex').val(),
            Age: $('#Age').val(),
            JoiningDate: $('#JoiningDate').val(),
            DateOfOffWork: $('#DateOffWork').val(),
            TimeOfOffWork: $('#TImeOffWork').val(),
            DateOfResumeWork: $('#DateResumeWork').val(),
            TimeOfResumeWork: $('#TimeResumeWork').val(),

            //#endregion

            //#region Incase of Injury/Sevierty of Pain

            DateOfInjuryOrIllness:          $('#DateOfInjuryOrIllness').val(),
            TimeOfInjuryOrIllness:          $('#TImeOfInjuryOrIllness').val(),
            DateOfFirstExamination:         $('#DateOfFirstExaminationOnboard').val(),
            TimeOfFirstExamination:         $('#TimeOfFirstExaminationOnboard').val(),
            IsInjuryorIllnessWorkRelated:   $("input[name='IsInjuryWorkRelated']:checked").val(),
            IsUnconsciousByInjuryOrIllness: $("input[name='IsUnconscious']:checked").val(),
            HowLongWasUnconscious:          $('#UnconsciousPeriod').val(),
            LevelOfConsciousness:           $("input[name='LevelOfConsciousness']:checked").val(),
            IsAccidentOrIlness:             $("input[name='AccidentOrIllness']:checked").val(),

            WhereAndHowAccidentOccured:     $('#WhereAndHowAccidentOccured').val(),
            LocationAndTypeOfInjuryOrBurn:  $('#LocationAndTypeOfInjuryOrBurn').val(),
            FirstAidGiven:                  $('#FirstAidGiven').val(),
            TypeOfBurn:                     $('#TypeOfBurn').val(),
            DegreeOfBurn:                   $('#DegreeOfBurn').val(),
            PercentageOfBurn:               $('#PercentageOfBurn').val(),

            MedicalSymtomology: Symtomology,

            SeverityOfPain:                 $("input[name='SeverityOfPain']:checked").val(),
            FrequencyOfPain:                $('#FrequencyOfPain').val(),

            //#endregion

            //#region  History and Medication Taken
            PastMedicalHistory: $('#RelaventMedicalHistory').val(),
            MedicationTakenList: MedicationTakenList,
            
            //#endregion

            VitalParams: VitalParams,

            //#region Findings of Affected Areas
            AffectedParts: $('#AffectedParts').val(),
            BloodType: $('#BloodType').val(),
            BloodQuantity: $('#BloodQuantity').val(),
            FluidType: $('#FluidType').val(),
            FluidQuantity: $('#FluidQuantity').val(),
            SkinDetails: $('#SkinDetails').val(),
            PupilsDetails: $('#PupilsDetails').val(),

            //#endregion

            //#region Telemedical Consultation
            TeleMedicalConsultation: $("input[name='TeleMedicalConsultation']:checked").val() ? true : false,
            TeleMedicalContactDate: $('#TeleMedicalContactDate').val(),
            TeleMedicalContactTime: $('#TeleMedicalContactTime').val(),
            ModeOfCommunication: $('#ModeOfCommunication').val(),
            NameOfTelemedicalConsultant: $('#NameOfTelemedicalConsultant').val(),
            DetailsOfTreatmentAdvised: $('#DetailsOfTreatmentAdvised').val(),

            //#endregion

            //#region Medical Treatment Given Onboard
            MedicalTreatmentGivenOnboard: $("input[name='MedicalTreatmentGivenOnboard']:checked").val() ? true : false,
            PriorRadioMedicalAdvice: $('#PriorRadioMedicalAdvice').val(),
            AfterRadioMedicalAdvice: $('#AfterRadioMedicalAdvice').val(),
            HowIsPatientRespondingToTreatmentGiven: $('#HowIsPatientRespondingToTreatmentGiven').val(),
            //DoesPatientNeedRemoveFromVessel: $('#DoesPatientNeedRemoveFromVessel').val(),
            DoesPatientNeedRemoveFromVessel: $("input[name='DoesPatientNeedRemoveFromVessel']:checked").val(),
            NeedRemovalDesc: $('#NeedRemovalDesc').val(),
            NeedRemovalToPort: $('#NeedRemovalToPort').val(),
            AdditionalNotes: $('#AdditionalNotes').val(),

            //#endregion
            
            //#region Upload Section
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


            PictureUploadPath: $('#hdnCrewHealthImagePath').val(),

            AccidentOrIllnessImagePathList: cirmAccidentOrIllnessImagePath
            //#endregion
            
        };

        $.ajax({
            url: posturl,
            data: JSON.stringify(cIRM),
            type: "POST",
            contentType: "application/json;charset=utf-8",
            dataType: "json",

            success: function (result) {
                //loadData();
                $('#myModal').modal('hide');
                // alert('Added Successfully');
                //HideCIRMUploadModal();
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
var cirmAccidentOrIllnessImagePath = [];
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
                    if (filetype == "AccidentOrIllness") {
                        var cnt = result[0];
                        for (var i = 1; i <= cnt; i++) {
                            cirmAccidentOrIllnessImagePath.push(result[i]);
                            $("#lblSuccMsgCIRM" + filetype).text(result[cnt]);
                        }
                    }
                    else {
                        $("#lblSuccMsgCIRM" + filetype).text(result[1]);
                        $("#hdnPathCIRM" + filetype).val(result[0]);
                        $("#lblSuccMsgCIRM" + filetype).removeClass("hidden");
                    }
                    

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

function SendMail3() {
    var res = validateEmail();
    if (res) {
        if ($('#ddlCrew').val().length === 0) {
            $('#ddlCrew').css('border-color', 'Red');
            alert("Please Select a Crew...!");

        }
        else {
            if ($('#CIRMId').val().length === 0) {
                alert("There is no CIRM for the selected Crew. Please create a CIRM for Vrew.");
            }
            else {

                $.ajax({
                    url: '/MedicalAssistance/SaveCIRMDoctorsEmails',
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
                        //$("#lblSuccMsg").text(result[1]);
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

                        toastr.success("Your mail has been posted and will be send ");

                    },
                    error: function (err) {
                        alert(err.statusText);
                    }
                });
            }

        }

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
            $('#CallSign').val(result.RadioCallSign);
            //#region Voyage Details
            $('#DateOfReportingGMT').val(result.DateOfReportingGMT);
            $('#TimeOfReportingGMT').val(result.TimeOfReportingGMT);
            $('#LocationOfShip').val(result.LocationOfShip);
            $('#Cousre').val(result.Cousre);
            $('#Speed').val(result.Speed);
            $('#PortOfDeparture').val(result.PortofDeparture);
            $('#DateOfDeparture').val(result.DateOfDeparture);
            $('#TimeOfDeparture').val(result.TimeOfDeparture);
            $('#PortOfArrival').val(result.PortofDestination);
            $('#ETADateGMT').val(result.ETADateGMT);
            $('#ETATimeGMT').val(result.ETATimeGMT);
            $('#EstimatedTimeOfArrival').val(result.EstimatedTimeOfarrivalhrs);
            $('#AgentDetails').val(result.AgentDetails);
            $('#NearestPort').val(result.NearestPort);
            $('#NearestPortETADateGMT').val(result.NearestPortETADateGMT);
            $('#NearestPortETATimeGMT').val(result.NearestPortETATimeGMT);
            $('#OtherPossiblePort').val(result.OtherPossiblePort);
            $('#OtherPortETADateGMT').val(result.OtherPortETADateGMT);
            $('#OtherPortETATimeGMT').val(result.OtherPortETATimeGMT);
            //#endregion 

            //#region Weather Details
            $('#Direction').val(result.WindDirection);
            $('#BeaufortScale').val(result.BeaufortScale);
            $('#WindSpeed').val(result.WindSpeed);
            $('#SeaState').val(result.SeaState);
            $('#WaveHeight').val(result.WaveHeight);
            $('#Swell').val(result.Swell);
            $('#WeatherCondition').val(result.WeatherCondition);
            $('#Visibility').val(result.WeatherVisibility);
            //#endregion

            //#region Crew Details
            $('#Addiction').val(result.Addiction);
            $('#Ethinicity').val(result.Ethinicity);
            $('#Frequency').val(result.Frequency);

            //#endregion

            //#region Type of Ailment
            $('#Category').val(result.Category);
            $('#SubCategory').val(result.SubCategory);

            //#endregion

            //#region Vital Statistica
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

            //#endregion

            //#region Symtomology
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

            //#endregion

            //#region Past Medical History
            $('#PastMedicalHostory').val(result.PastMedicalHistory);

            //#endregion

            //#region Incase of Injury/Sevierty of Pain

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

            //#endregion

            //#region Upload section

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

            //#endregion


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

function GetCIRMDetailsByCrewNew(id) {
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
            if (IsNewCIRM)
                $('#CIRMId').val('0');
            else
                $('#CIRMId').val(result.CIRMId);
                
            $('#CallSign').val(result.RadioCallSign);
            //#region Voyage Details
            $('#DateOfReportingGMT').val(result.DateOfReportingGMT);
            $('#TimeOfReportingGMT').val(result.TimeOfReportingGMT);
            $('#LocationOfShip').val(result.LocationOfShip);
            $('#Cousre').val(result.Cousre);
            $('#Speed').val(result.Speed);
            $('#PortOfDeparture').val(result.PortofDeparture);
            $('#DateOfDeparture').val(result.DateOfDeparture);
            $('#TimeOfDeparture').val(result.TimeOfDeparture);
            $('#PortOfArrival').val(result.PortofDestination);
            $('#ETADateGMT').val(result.ETADateGMT);
            $('#ETATimeGMT').val(result.ETATimeGMT);
            $('#EstimatedTimeOfArrival').val(result.EstimatedTimeOfarrivalhrs);
            $('#AgentDetails').val(result.AgentDetails);
            $('#NearestPort').val(result.NearestPort);
            $('#NearestPortETADateGMT').val(result.NearestPortETADateGMT);
            $('#NearestPortETATimeGMT').val(result.NearestPortETATimeGMT);
            $('#OtherPossiblePort').val(result.OtherPossiblePort);
            $('#OtherPortETADateGMT').val(result.OtherPortETADateGMT);
            $('#OtherPortETATimeGMT').val(result.OtherPortETATimeGMT);
            //#endregion 

            //#region Weather Details
            $('#Direction').val(result.WindDirection);
            $('#BeaufortScale').val(result.BeaufortScale);
            $('#WindSpeed').val(result.WindSpeed);
            $('#SeaState').val(result.SeaState);
            $('#WaveHeight').val(result.WaveHeight);
            $('#Swell').val(result.Swell);
            $('#WeatherCondition').val(result.WeatherCondition);
            $('#Visibility').val(result.WeatherVisibility);
            //#endregion

            //#region Crew Details
            $('#Addiction').val(result.Addiction);
            $('#Ethinicity').val(result.Ethinicity);
            $('#Frequency').val(result.Frequency);
            $('#DateOffWork').val(result.DateOfOffWork);
            $('#TImeOffWork').val(result.TimeOfOffWork);
            $('#DateResumeWork').val(result.DateOfResumeWork);
            $('#TimeResumeWork').val(result.TimeOfResumeWork);
            //#endregion

           

            //#region Incase of Injury or Illness 

            $('#DateOfInjuryOrIllness').val(result.DateOfInjuryOrIllness);
            $('#TImeOfInjuryOrIllness').val(result.TimeOfInjuryOrIllness);
            $('#DateOfFirstExaminationOnboard').val(result.DateOfFirstExamination);
            $('#TimeOfFirstExaminationOnboard').val(result.TimeOfFirstExamination);
            //$("input[name='IsInjuryWorkRelated']:checked").val(result.IsInjuryorIllnessWorkRelated);
            if (result.IsInjuryorIllnessWorkRelated != null) {
                var value = result.IsInjuryorIllnessWorkRelated;
                $("input[name=IsInjuryWorkRelated][value=" + value + "]").prop('checked', true);
            }
            //$("input[name='IsUnconscious']:checked").val(result.IsUnconsciousByInjuryOrIllness);
            if (result.IsUnconsciousByInjuryOrIllness != null) {
                var value = result.IsUnconsciousByInjuryOrIllness;
                $("input[name=IsUnconscious][value=" + value + "]").prop('checked', true);
            }
            $('#UnconsciousPeriod').val(result.HowLongWasUnconscious);
            //$("input[name='LevelOfConsciousness']:checked").val(result.LevelOfConsciousness);
            if (result.LevelOfConsciousness > 0 || result.LevelOfConsciousness != null) {
                var value = result.LevelOfConsciousness;
                $("input[name=LevelOfConsciousness][value=" + value + "]").prop('checked', true);
            }
            //$("input[name='AccidentOrIllness']:checked").val(result.IsAccidentOrIlness);
            if (result.IsAccidentOrIlness > 0 || result.IsAccidentOrIlness != null) {
                var value = result.IsAccidentOrIlness;
                $("input[name=AccidentOrIllness][value=" + value + "]").prop('checked', true);
            }

            //------Accident
            if (result.IsAccidentOrIlness == 1) {
                $('#WhereAndHowAccidentOccured').val(result.WhereAndHowAccidentOccured);
                $('#LocationAndTypeOfInjuryBurn').val(result.LocationAndTypeOfInjuryOrBurn);
                $('#FirstAidGiven').val(result.FirstAidGiven);
                $('#TypeOfBurn').val(result.TypeOfBurn);
                $('#DegreeOfBurn').val(result.FirstAidGiven);
                $('#PercentageOfBurn').val(result.PercentageOfBurn);

                $("#myModalAccident").show();
            }
            

            ////----------Illness------(Symtomology)--------------
            if (result.IsAccidentOrIlness == 2) {
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
                //$('#SymtomologyDetails').val(result.Symtomology.SymptomologyDetails);
                //$('#MedicinesAdministered').val(result.Symtomology.MedicinesAdministered);
                $('#AnyOtherRelevantInformation').val(result.Symtomology.AnyOtherRelevantInformation);
                $('#Ailment').val(result.Symtomology.Ailment);

                $("#myModalIllness").show();
            }
            ////--------End--Illness----------------------


            if (result.SeverityOfPain > 0 || result.SeverityOfPain != null) {
                var value = result.SeverityOfPain;
                $("input[name=SeverityOfPain][value=" + value + "]").prop('checked', true);
            }
            $('#FrequencyOfPain').val(result.FrequencyOfPain);
           
            //#endregion

            //#region History and Medication Taken
            $('#RelaventMedicalHistory').val(result.PastMedicalHistory);
            LoadCIRMMedicationTakenDataIntoTable(result.MedicationTakenList);
            //#endregion

            //#region Vital Statistica
            $('#VitalStatisticsDate').val(convertJsonDateToShortDate(result.VitalStatistics.ObservationDate));
            $('#VitalStatisticsTime').val(convertJsonDateToShortTime(result.VitalStatistics.ObservationTime));
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

            //#endregion

            //#region Findings of Affected Areas
            $('#AffectedParts').val(result.AffectedParts);
            $('#BloodType').val(result.BloodType);
            $('#BloodQuantity').val(result.BloodQuantity);
            $('#FluidType').val(result.FluidType);
            $('#FluidQuantity').val(result.FluidQuantity);
            $('#SkinDetails').val(result.SkinDetails);
            $('#PupilsDetails').val(result.PupilsDetails);

            //#endregion

            //#region Telemedical Consultation
            if (result.TeleMedicalConsultation) {
                $("#chkTeleMedicalConsultation").prop("checked", true);
                $('#TeleMedicalContactDate').val(result.TeleMedicalContactDate);
                $('#TeleMedicalContactTime').val(result.TeleMedicalContactTime);
                $('#ModeOfCommunication').val(result.ModeOfCommunication);
                $('#NameOfTelemedicalConsultant').val(result.NameOfTelemedicalConsultant);
                $('#DetailsOfTreatmentAdvised').val(result.DetailsOfTreatmentAdvised);
                $("#dvTeleMedicalConsultation").show();
            }
            
            //#endregion

            //#region Medical Treatment Given Onboard
            if (result.TeleMedicalConsultation) {
                $("#chkMedicalTreatmentGivenOnboard").prop("checked", true);
                $('#PriorRadioMedicalAdvice').val(result.PriorRadioMedicalAdvice);
                $('#AfterRadioMedicalAdvice').val(result.AfterRadioMedicalAdvice);
                $('#HowIsPatientRespondingToTreatmentGiven').val(result.HowIsPatientRespondingToTreatmentGiven);
                if (result.DoesPatientNeedRemoveFromVessel) {
                    //"#DoesPatientNeedRemoveFromVessel").prop("checked", true);
                    var value = result.DoesPatientNeedRemoveFromVessel;
                    $("input[name=DoesPatientNeedRemoveFromVessel][value=" + value + "]").prop('checked', true);
                    //$('#DoesPatientNeedRemoveFromVessel').val(result.DoesPatientNeedRemoveFromVessel);
                    $('#NeedRemovalDesc').val(result.NeedRemovalDesc);
                    $('#NeedRemovalToPort').val(result.NeedRemovalToPort);
                    $("#dvPatientNeedRemoveFromVessel").show();
                }
                
                $('#AdditionalNotes').val(result.AdditionalNotes);
                $("#dvMedicalTreatmentGivenOnboard").show();
            }
            //#endregion

            //#region Upload section

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

            //#endregion


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


function ConfirmDialog(message) {
    var retn = false;
    $('<div></div>').appendTo('body')
        .html('<div><h6>' + message + '?</h6></div>')
        .dialog({
            modal: true,
            title: 'Confirm message',
            zIndex: 10000,
            autoOpen: true,
            width: 'auto',
            resizable: false,
            buttons: {
                Yes: function () {
                    // $(obj).removeAttr('onclick');                                
                    // $(obj).parents('.Parent').remove();

                   // $('body').append('<h1>Confirm Dialog Result: <i>Yes</i></h1>');

                    $(this).dialog("close");
                    //retn = true;
                    IsNewCIRM = true;
                    $('#CIRMId').val('0');
                    //if (!confirm("Do you want to use existing CIRM - Patient Details for " + $('#hdnPageName').val()))
                    //    ClearAllFields();
                },
                No: function () {
                    //$('body').append('<h1>Confirm Dialog Result: <i>No</i></h1>');

                    $(this).dialog("close");
                    //retn = false;
                    //GetCIRMDetailsByCrewNew(ID, 0);
                    IsNewCIRM = false;
                }
            },
            close: function (event, ui) {
                $(this).remove();
            }
        });

    //return retn;
}




/////////////////////////////////////////////////////////////////////////////////////////////////////


var MedicationTakenDetailsJsonObject = { MedicationTakenDetails: [] };
var MedicationTakenList = [];
function CreateMedicationTakenDetailsJsonObject() {
    //alert(2);
    MedicationTakenDetailsJsonObject = { MedicationTakenDetails: [] };
    MedicationTakenList = [];
    var MedicationTakenDetailRow;
    var PrescriptionName;
    var MedicalConditionBeingTreated;
    var HowOftenMedicationTaken;
    var MedicationTakenDetailCount = 0;

    //alert(3);
    var tb = $('.table-MedicationTaken:eq(0) tbody');
    /*$('.MedicationDetailRow').each(function () {*/
    tb.find("tr").each(function () {
        MedicationTakenDetailRow = $(this);// alert(4);
        PrescriptionName = $(MedicationTakenDetailRow).find("input[name='PrescriptionName']").val();
        MedicalConditionBeingTreated = $(MedicationTakenDetailRow).find("input[name='MedicalConditionBeingTreated']").val();
        HowOftenMedicationTaken = $(MedicationTakenDetailRow).find("input[name='HowOftenMedicationTaken']").val();


        MedicationTakenDetailsJsonObject.MedicationTakenDetails.push({
            "PrescriptionName": PrescriptionName,
            "MedicalConditionBeingTreated": MedicalConditionBeingTreated,
            "HowOftenMedicationTaken": HowOftenMedicationTaken
        });

        MedicationTakenList.push({
            PrescriptionName: PrescriptionName,
            MedicalConditionBeingTreated: MedicalConditionBeingTreated,
            HowOftenMedicationTaken: HowOftenMedicationTaken
        });
        MedicationTakenDetailCount++;
    });

    //alert(10);
    if (MedicationTakenDetailCount == 0) {
        alert('Give at least one Detail');
        return false;
    }
    //alert(11);

    return true;
}

function LoadCIRMMedicationTakenDataIntoTable(medications) {
    var MedicationTakenList = [];
    var MedicationTakenDetailRow;
    MedicationTakenList = medications;
    var len = MedicationTakenList.length;
    var tb = $('.table-MedicationTaken:eq(0) tbody');
    var trCnt = 0;
    if (len == 1) {
        tb.find("tr").each(function () {
            MedicationTakenDetailRow = $(this);
            $(MedicationTakenDetailRow).find("input[name='PrescriptionName']").val(MedicationTakenList[0]["PrescriptionName"]);
            $(MedicationTakenDetailRow).find("input[name='MedicalConditionBeingTreated']").val(MedicationTakenList[0]["MedicalConditionBeingTreated"]);
            $(MedicationTakenDetailRow).find("input[name='HowOftenMedicationTaken']").val(MedicationTakenList[0]["HowOftenMedicationTaken"]);

        });
    }
    else if (MedicationTakenList.length > 1) {
        for (var i = 1; i < len; i++) {
            AddRow(i);
        }

        tb.find("tr").each(function () {
            MedicationTakenDetailRow = $(this);
            $(MedicationTakenDetailRow).find("input[name='PrescriptionName']").val(MedicationTakenList[trCnt]["PrescriptionName"]);
            $(MedicationTakenDetailRow).find("input[name='MedicalConditionBeingTreated']").val(MedicationTakenList[trCnt]["MedicalConditionBeingTreated"]);
            $(MedicationTakenDetailRow).find("input[name='HowOftenMedicationTaken']").val(MedicationTakenList[trCnt]["HowOftenMedicationTaken"]);
            //alert(trCnt + ',' + MedicationTakenList[0]["PrescriptionName"]);
            trCnt++;
        });
    }
}
function AddRow(trCount) {
    trCount += 1;
    $("#tblMedicationTaken").each(function () {

        var tds = '<tr>';
        var tdCount = 0;
        jQuery.each($('tr:last td', this), function () {
            tdCount += 1;
            if (tdCount == 1)
                tds += '<td>' + trCount + '</td>';
            else
                tds += '<td>' + $(this).html() + '</td>';
        });
        tds += '</tr>';
        if ($('tbody', this).length > 0) {
            $('tbody', this).append(tds);
        } else {
            $(this).append(tds);
        }

    });
}

//$("#addrows").click(function () {
//    $("#mytable").each(function () {
//        var tds = '<tr>';
//        jQuery.each($('tr:last td', this), function () {
//            tds += '<td>' + $(this).html() + '</td>';
//        });
//        tds += '</tr>';
//        if ($('tbody', this).length > 0) {
//            $('tbody', this).append(tds);
//        } else {
//            $(this).append(tds);
//        }
//    });
//});
