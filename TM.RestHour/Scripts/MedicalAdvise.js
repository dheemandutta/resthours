
var pageName = '';
function ClearFields() {
    $('#hdnPlanMedicalAdviseImagePath').val("");
    $('#VisitDate').val("");
    
}

function UploadMedicalAdviseFile() {
    var res = true;
    

    if (res) {
        //Checking whether FormData is available in browser  
        if (window.FormData !== undefined) {
            var fileUpload = $("#uploadMedicalAdviseImage").get(0);
            var files = fileUpload.files;
            // Create FormData object  
            var fileData = new FormData();

            // Looping over all files and add it to FormData object  
            for (var i = 0; i < files.length; i++) {
                fileData.append(files[i].name, files[i]);
            }

            // Adding one more key to FormData object
            fileData.append('category', "MedicalAdvise");
            fileData.append('visitDate', $("#VisitDate").val());
            $.ajax({
                url: '/MedicalAssistance/UploadMedicalAdviseFile',
                type: "POST",
                //datatype: "json",
                //contentType: "application/json; charset=utf-8",
                contentType: false, // Not to set any content header  
                processData: false, // Not to process data  
                data: fileData,
                success: function (result) {
                    //alert(result);

                    $("#lblSuccMsg").text(result[1]);
                    $("#hdnMedicalAdviseImagePath").val(result[0]);
                    $("#lblSuccMsg").removeClass("hidden");

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

                    toastr.success(result[1]);
                    AddMedicalAdvise();
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

function SaveMedicalAdvise() {
    var res = true;
    if ($('#TestDate').val().length === 0) {
        $('#TestDate').css('border-color', 'Red');
        res = false;
    }
    else {
        $('#VisitDate').css('border-color', 'lightgrey');
        res = true;
    }
    if (res) {

        if (CreateExaminationDetailsJsonObject()) {
            ExaminationList = ExaminationList;
        }

        var medicalAdvise = {
            Diagnosis:                      $('#Diagnosis').val(),
            TreatmentPrescribed:            $('#TreatmentPrescribed').val(),
            IsIllnessDueToAnAccident:       $('#IsIllnessDueToAnAccident').val(),
            MedicinePrescribed:             $('#MedicinePrescribed').val(),
            RequireHospitalisation:         $('#RequireHospitalisation').val(),
            RequireSurgery:                 $('#RequireSurgery').val(),
            IsFitForDuty:                   $("input[name='IsFitForDuty']:checked").val() ? true : false,
            FitForDutyComments:             $('#FitForDutyComments').val(),
            IsMayJoinOnBoardButLightDuty:   $("input[name='IsMayJoinOnBoardButLightDuty']:checked").val() ? true : false,
            MayJoinOnBoardDays:             $('#MayJoinOnBoardDays').val(),
            MayJoinOnBoardComments:         $('#MayJoinOnBoardComments').val(),
            IsUnfitForDuty:                 $("input[name='IsUnfitForDuty']:checked").val() ? true : false,
            UnfitForDutyComments:           $('#UnfitForDutyComments').val(),
            FutureFitnessAndRestrictions:   $('#FutureFitnessAndRestrictions').val(),
            DischargeSummary:               $('#DischargeSummary').val(),
            FollowUpAction:                 $('#FollowUpAction').val(),
            DoctorName:                     $('#DoctorName').val(),
            DoctorContactNo:                $('#DoctorContactNo').val(),
            DoctorEmail:                    $('#DoctorEmail').val(),
            DoctorSpeciality:               $('#DoctorSpeciality').val(),
            DoctorMedicalRegNo:             $('#DoctorMedicalRegNo').val(),
            DoctorCountry:                  $('#DoctorCountry').val(),
            NameOfHospital:                 $('#NameOfHospital').val(),
            ExaminationForMedicalAdviseList: ExaminationList,

            TestDate: $('#TestDate').val()
            //TestDate: $('#VisitDate').val(),
        };



        $.ajax({
            url: '/MedicalAssistance/AddMedicalAdvise',
            data: JSON.stringify(medicalAdvise),
            type: "POST",
            contentType: "application/json;charset=utf-8",
            dataType: "json",

            success: function (result) {
                //loadData();
                $('#uploadAdviseDetailsModal').modal('hide');
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

                toastr.success("Send Successfully");

                //ClearFields();
                //reloadPage();
            },
            error: function (errormessage) {
                console.log(errormessage.responseText);
            }
        });
    }

}


function AddMedicalAdvise() {
    var res = false;
    if ($('#VisitDate').val().length === 0) {
        $('#VisitDate').css('border-color', 'Red');
        res = false;
    }
    else {
        $('#VisitDate').css('border-color', 'lightgrey');
        res = true;
    }
    if ($('#hdnMedicalAdviseImagePath').val().length === 0) {

        res = false;
        alert("Choose a Medical Advise file..!")
    }
    else {

        res = true;
    }
    

    if (res) {
        var medicalAdvise = {
            TestDate: $('#VisitDate').val(),
            Path: $('#hdnMedicalAdviseImagePath').val()
        };



        $.ajax({
            url: '/MedicalAssistance/AddMedicalAdvise',
            data: JSON.stringify(medicalAdvise),
            type: "POST",
            contentType: "application/json;charset=utf-8",
            dataType: "json",

            success: function (result) {
                //loadData();
                $('#uploadAdviseDetailsModal').modal('hide');
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

               ClearFields();
                reloadPage();
            },
            error: function (errormessage) {
                console.log(errormessage.responseText);
            }
        });
    }

}

function reloadPage() {

    location.reload();
}

function ShowDetalisModal(id,date) {
    //$("#viewAdviseDetailsModal").show();
    //$('#viewAdviseDetailsModal').modal('show');
    var medicalAdvise = {
        TestDate: date,
        Id: id
    };

    $.ajax({
        url: '/MedicalAssistance/GetMedicalAdviseDetails',
        data: JSON.stringify({ adviseId: id}),
        type: "POST",
        contentType: "application/json;charset=utf-8",
        dataType: "json",

        success: function (result) {
            //loadData();
            $('#CrewName').val(result.CrewName);
            $('#Nationality').val(result.Nationality);
            $('#VesselName').val(result.VesselName);
            $('#IMONumber').val(result.IMONumber);
            $('#Rank').val(result.RankName);
            $('#Age').val(ConvertJsonDateString( result.DOB));
            $('#VesselType').val(result.VesselSubType);
            $('#Owner').val(result.CompanyOwner);
            $('#Gender').val(result.Gender);
            $('#PassportOrSeaman').val(result.PassportOrSeaman);
            $('#FlagOfShip').val(result.FlagOfShip);


            $('#Diagnosis').val(result.Diagnosis);
            $('#TreatmentPrescribed').val(result.TreatmentPrescribed);
            $('#IsIllnessDueToAnAccident').val(result.IsIllnessDueToAnAccident);
            $('#MedicinePrescribed').val(result.MedicinePrescribed);

            LoadExaminationDataIntoTable(result.ExaminationForMedicalAdviseList);

            $('#RequireHospitalisation').val(result.RequireHospitalisation);
            $('#RequireSurgery').val(result.RequireSurgery);
            if (result.IsFitForDuty) {
                $("#IsFitForDuty").prop("checked", true);
            }
            
            $('#FitForDutyComments').val(result.FitForDutyComments);
            if (result.IsMayJoinOnBoardButLightDuty) {
                $("#IsMayJoinOnBoardButLightDuty").prop("checked", true);
            }
            $('#MayJoinOnBoardDays').val(result.MayJoinOnBoardDays);
            $('#MayJoinOnBoardComments').val(result.MayJoinOnBoardComments);
            if (result.IsUnfitForDuty) {
                $("#IsUnfitForDuty").prop("checked", true);
            }
            $('#UnfitForDutyComments').val(result.UnfitForDutyComments);
            $('#FutureFitnessAndRestrictions').val(result.FutureFitnessAndRestrictions);
            $('#DischargeSummary').val(result.DischargeSummary);
            $('#FollowUpAction').val(result.FollowUpAction);
            $('#DoctorName').val(result.DoctorName);
            $('#DoctorContactNo').val(result.DoctorContactNo);
            $('#DoctorEmail').val(result.DoctorEmail);
            $('#DoctorSpeciality').val(result.DoctorSpeciality);
            $('#DoctorMedicalRegNo').val(result.DoctorMedicalRegNo);
            $('#DoctorCountry').val(result.DoctorCountry);
            $('#NameOfHospital').val(result.NameOfHospital);

            $('#TestDate').val(ConvertJsonDateString(result.TestDate));

            


            $('#viewAdviseDetailsModal').modal('show');
            //ClearFields();
            //reloadPage();
        },
        error: function (errormessage) {
            console.log(errormessage.responseText);
        }
    });
}
function DownloadDetails(path) {

    $.ajax({
        url: '/MedicalAssistance/Download',
        data: { filePath: path },
        type: "GET",
        contentType: "application/json;charset=utf-8",
        dataType: "json",

        success: function (result) {
            //loadData();
            
        },
        error: function (errormessage) {
            console.log(errormessage.responseText);
        }
    });
}


var ExaminationList = [];
function CreateExaminationDetailsJsonObject() {
    //alert(2);
   
    ExaminationList = [];
    var ExaminationRow;
    var ExaminationName;
    var ExaminationPath;
    var ExaminationCount = 0;

    //alert(3);
    var tb = $('.table-Examination:eq(0) tbody');
    /*$('.MedicationDetailRow').each(function () {*/
    tb.find("tr").each(function () {
        ExaminationRow = $(this);// alert(4);
        ExaminationName = $(ExaminationRow).find("input[name='ExaminationName']").val();
        ExaminationPath = $(ExaminationRow).find("input[name='hdnExaminationFilePath']").val();

        ExaminationList.push({
            Examination: ExaminationName,
            ExaminationPath: ExaminationPath
        });
        ExaminationCount++;
    });

    //alert(10);
    if (ExaminationCount == 0) {
        alert('Give at least one Detail');
        return false;
    }
    //alert(11);

    return true;
}

function LoadExaminationDataIntoTable(examinations) {
    var ExaminationList = [];
    var ExaminationRow;
    ExaminationList = examinations;
    var len = ExaminationList.length;
    $('.table-Examination').find("tr:gt(0)").remove();// remove all rows except first row
    var tb = $('.table-Examination:eq(0) tbody');
    var trCnt = 0;
    if (len == 1) {
        tb.find("tr").each(function () {
            ExaminationRow = $(this);
            $(ExaminationRow).find("input[name='ExaminationName']").val(ExaminationList[trCnt]["Examination"]);
            $(ExaminationRow).find("input[name='hdnExaminationFilePath']").val(ExaminationList[trCnt]["ExaminationPath"]);

        });
    }
    else if (ExaminationList.length > 1) {
        for (var i = 1; i < len; i++) {
            AddRow(i);
        }

        tb.find("tr").each(function () {
            ExaminationRow = $(this);
            $(ExaminationRow).find("input[name='ExaminationName']").val(ExaminationList[trCnt]["Examination"]);
            $(ExaminationRow).find("input[name='hdnExaminationFilePath']").val(ExaminationList[trCnt]["ExaminationPath"]);
            trCnt++;
        });
    }
}
function AddRow(trCount) {
    trCount += 1;
    $("#tblExamination").each(function () {

        var tds = '<tr>';
        var tdCount = 0;
        jQuery.each($('tr:last td', this), function () {
            tdCount += 1;
            //if (tdCount == 1)
            //    tds += '<td>' + trCount + '</td>';
            //else
            //    tds += '<td>' + $(this).html() + '</td>';

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


//var trCount = 1;
//$("#addrows").click(function () {
//    trCount += 1;
//    $("#tblMedicationTaken").each(function () {

//        var tds = '<tr>';
//        var tdCount = 0;
//        jQuery.each($('tr:last td', this), function () {
//            tdCount += 1;
//            //if (tdCount == 1)
//            //    tds += '<td>' + trCount + '</td>';
//            //else
//            //    tds += '<td>' + $(this).html() + '</td>';

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

//#region  Json format Date convert

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
function ConvertJsonDateString(jsonDate) {
    var shortDate = null;
    var months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    if (jsonDate) {
        var regex = /-?\d+/;
        var matches = regex.exec(jsonDate);
        var dt = new Date(parseInt(matches[0]));
        var month = dt.getMonth() + 1;

        
        var monthString = month > 9 ? month : '0' + month;
        //monthString = months[monthString]
        //var m1 = months[month];
        var m1 = months[dt.getMonth()];
        var day = dt.getDate();
        var dayString = day > 9 ? day : '0' + day;
        var year = dt.getFullYear();
        shortDate = dayString + '-' + m1 + '-' + year;
    }
    return shortDate;
};


//#endregion



