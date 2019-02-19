function validate() {
    var isValid = true;

    if ($('#DoctorName').val().length === 0) {
        $('#DoctorName').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#DoctorName').css('border-color', 'lightgrey');
    }

    if ($('#DoctorEmail').val().length === 0) {
        $('#DoctorEmail').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#DoctorEmail').css('border-color', 'lightgrey');
    }
    
    if ($('#Comment').val().length === 0) {
        $('#Comment').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#Comment').css('border-color', 'lightgrey');
    }

    if (!validateEmail($('#DoctorEmail').val())) {
        $('#DoctorEmail').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#DoctorEmail').css('border-color', 'lightgrey');
    }
    
    return isValid;
}

function validate2() {
    var isValid = true;

    if ($('#drpDoctorID').val().length === 0) {
        $('#drpDoctorID').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#drpDoctorID').css('border-color', 'lightgrey');
    }

   
    if ($('#Problem').val().length === 0) {
        $('#Problem').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#Problem').css('border-color', 'lightgrey');
    }

    return isValid;
}

function validate3() {
    var isValid = true;

    if ($('#Weight').val().length === 0) {
        $('#Weight').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#Weight').css('border-color', 'lightgrey');
    }


    if ($('#BMI').val().length === 0) {
        $('#BMI').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#BMI').css('border-color', 'lightgrey');
    }

    return isValid;
}


function validateEmail($email) {
    var emailReg = /^([\w-\.]+@@([\w-]+\.)+[\w-]{2,4})?$/;
    return emailReg.test($email);
}


function clearTextBox() {
    $('#DoctorName').val("");
    $('#DoctorEmail').val("");
    $('#Comment').val("");
}


function clearTextBox2() {
    $('#drpDoctorID').val("");
    $('#Problem').val("");
}

function clearTextBox3() {
    $('#Weight').val("");
    $('#BMI').val("");
}

function AddConsultant() {

    var posturl = $('#Consultantadd').val();
    var res = validate();
    if (res == false) {
        return false;
    }
    // alert(res);
    if (res) {
        var Consultant = {

            DoctorName: $('#DoctorName').val(),
            DoctorEmail: $('#DoctorEmail').val(),
            SpecialityID: $('#SpecialityID').val(),
            Comment: $('#Comment').val(),

            //Weight: $('#Weight').val(),
            //BMI: $('#BMI').val(),
            //BP: $('#BP').val(),
            //BloodSugarLevel: $('#BloodSugarLevel').val(),
            //UrineTest: document.getElementById("UrineTest").checked
                      
        };

        $.ajax({
            url: posturl,
            data: JSON.stringify(Consultant),
            type: "POST",
            contentType: "application/json;charset=utf-8",
            dataType: "json",

            success: function (response) {
                //debugger;
               // if (response.result == 'Redirect') {
                    //show successfull message
                    alert('Added Successfully');

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

                    window.location = response.url;
               // }
                //else if (response.result == 'Error') {
                //    alert('Data not saved,Please try again');
                //}
            },



            error: function (errormessage) {
                console.log(errormessage.responseText);
            }
        });
    }
}


function GetDoctorBySpecialityID(SpecialityID) {
    var x = $("#myUrlid").val();


    $.ajax({
        url: x,
        type: "POST",
        data: JSON.stringify({ 'SpecialityID': SpecialityID }),
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        success: function (result) {
            //debugger;
            var drpDoctorName = $('#drpDoctorID');
            drpDoctorName.find('option').remove();

            $.each(result, function () {
                drpDoctorName.append('<option value=' + this.DoctorID + '>' + this.DoctorName + '</option>');
            });

        },
        error: function (errormessage) {
            console.log(errormessage.responseText);
        }
    });
}


function SaveConsultation() {

    //alert($('textarea#Comments').val());
    //debugger;
    var posturl = $('#SaveConsultation').val();
    var res = validate2();
    if (res == false) {
        return false;
    }
    // alert(res);
    if (res) {
        var Consultation = {
            //ID: $('#ID').val(),
            
            DoctorID: $('#drpDoctorID').val(),
            Problem: $('#Problem').val(),

            //Notes: $('textarea#Comments').val(),
        };

        $.ajax({
            url: posturl,
            data: JSON.stringify(Consultation),
            type: "POST",
            contentType: "application/json;charset=utf-8",
            dataType: "json",

            //success: function (result) {

            //    alert('Added Successfully');

            //    clearTextBox();
            //    }         
            //,




            success: function (response) {
                //debugger;
                if (response.result == 'Redirect') {
                    //show successfull message
                    //alert('Added Successfully');

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

                    clearTextBox2();

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
}








function SaveMedicalAdvisory() {

    var posturl = $('#SaveMedicalAdvisory').val();
    //alert($('#Height').val());
    var res = validate3();
    if (res == false) {
        return false;
    }
    // alert(res);  ////
    if (res) {
        var MedicalAdvisory = {

            Weight: $('#Weight').val(),
            BMI: $('#BMI').val(),
           // BP: $('#BP').val(),
            BloodSugarLevel: $('#BloodSugarLevel').val(),
            UrineTest: document.getElementById("UrineTest").checked,

            Height: $('#Height').val(),
            Age: $('#Age').val(),
            BloodSugarUnit: $('#BloodSugarUnit').val(),
            BloodSugarTestType: $('#BloodSugarTestType').val(),
            Systolic: $('#Systolic').val(),
            Diastolic: $('#Diastolic').val(),

            UnannouncedAlcohol: document.getElementById("UnannouncedAlcohol").checked,
            AnnualDH: document.getElementById("AnnualDH").checked,
            Month: $('#Month').val(),
            CrewID: $('#ID').val(),            /////////////////////////////
            PulseRatebpm: $('#PulseRatebpm').val(),
            AnyDietaryRestrictions: $('#AnyDietaryRestrictions').val(),
            MedicalProductsAdministered: $('#MedicalProductsAdministered').val(),
            UploadExistingPrescriptions: $('#UploadExistingPrescriptions').val(),    ///////////////////////////////////////
            UploadUrineReport: $('#UploadUrineReport').val(),     ///////////////////////////////////
        };

        $.ajax({
            url: posturl,
            data: JSON.stringify(MedicalAdvisory),
            type: "POST",
            contentType: "application/json;charset=utf-8",
            dataType: "json",

            success: function (response) {
                //debugger;
                // if (response.result == 'Redirect') {
                //show successfull message
                alert('Added Successfully');

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

                clearTextBox3();

                window.location = response.url;
                // }
                //else if (response.result == 'Error') {
                //    alert('Data not saved,Please try again');
                //}
            },



            error: function (errormessage) {
                console.log(errormessage.responseText);
            }
        });
    }
}