function validate() {
    var isValid = true;

    if ($('#FirstName').val().length === 0) {
        $('#FirstName').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#FirstName').css('border-color', 'lightgrey');
    }
    if ($('#LastName').val().length === 0) {
        $('#LastName').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#LastName').css('border-color', 'lightgrey');
    }
    if ($('#Gender').val().length === 0) {
        $('#Gender').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#Gender').css('border-color', 'lightgrey');
    }
    
    if ($('#RankID').val().length === 0) {
        $('#RankID').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#RankID').css('border-color', 'lightgrey');
    }
    if ($('#CountryID').val().length === 0) {
        $('#CountryID').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#CountryID').css('border-color', 'lightgrey');
    }
    //if ($('#DepartmentMasterID').val().length === 0) {
    //    $('#DepartmentMasterID').css('border-color', 'Red');
    //    isValid = false;
    //}
    //else {
    //    $('#DepartmentMasterID').css('border-color', 'lightgrey');
    //}

    if ($('#DOB').val().length === 0) {
        $('#DOB').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#DOB').css('border-color', 'lightgrey');
    }

    if ($('#POB').val().length === 0) {
        $('#POB').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#POB').css('border-color', 'lightgrey');
    }



    if ($('#CreatedOn').val().length === 0) {
        $('#CreatedOn').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#CreatedOn').css('border-color', 'lightgrey');
    }

    if ($('#LatestUpdate').val().length === 0) {
        $('#LatestUpdate').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#LatestUpdate').css('border-color', 'lightgrey'); 
    }



    if ($('#PassportSeamanPassportBook').val().length === 0) {
        $('#PassportSeamanPassportBook').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#PassportSeamanPassportBook').css('border-color', 'lightgrey');
    }

    if ($('#DepartmentMasterID').val().length === 0) {
        $('#DepartmentMasterID').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#DepartmentMasterID').css('border-color', 'lightgrey');
    }



    if ($('#CreatedOn').val().length === 0) {
       // $('#CreatedOn').css('border-color', 'Red');
        $('.valid').notify("Service terms is Mandatory", "error", { position: "top left" });
        isValid = false;
    }
    else {
        $('#CreatedOn').css('border-color', 'lightgrey');
    }

    if ($('#LatestUpdate').val().length === 0) {
       // $('#LatestUpdate').css('border-color', 'Red');
        $('.valid1').notify("Service terms is Mandatory", "error", { position: "bottom right" });
        isValid = false;
    }
    else {
        $('#LatestUpdate').css('border-color', 'lightgrey');
    }

    var fromdt = $('#CreatedOn').val();
    var todt = $('#LatestUpdate').val();

    if (Date.parse(fromdt) >= Date.parse(todt)) {

        isValid = false;
        $('.valid').notify("Form Date cannot be greater than To Date", "error", { position: "top left" });
    }
    




    if ($('#IssuingStateOfIdentityDocument').val().length === 0) {
        $('#IssuingStateOfIdentityDocument').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#IssuingStateOfIdentityDocument').css('border-color', 'lightgrey');
    }

    if ($('#ExpiryDateOfIdentityDocument').val().length === 0) {
        $('#ExpiryDateOfIdentityDocument').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#ExpiryDateOfIdentityDocument').css('border-color', 'lightgrey');
    }
    

    return isValid;
}

function clearTextBox() {
    $('#FirstName').val("");
    $('#MiddleName').val("");
    $('#LastName').val("");
    $('#Gender').val("");
    $('#RankID').val("");
    $('#CountryID').val("");
    $('#DOB').val("");
    $('#POB').val("");
    //$('#CrewIdentity').val("");
    $('#PassportSeamanPassportBook').val("");

    $('#CreatedOn').val("");
    $('#LatestUpdate').val("");
    $('#DepartmentMasterID').val("");
    $('#EmployeeNumber').val("");
    $('#Comments').val("");
    $('#Watchkeeper').val("");
    $('#OvertimeEnabled').val("");

   
    $('#IssuingStateOfIdentityDocument').val("");
    $('#ExpiryDateOfIdentityDocument').val("");
   
}

function AddCrew() {                           

    //alert($('textarea#Comments').val());
    //debugger;
    var posturl = $('#Unitadd').val();
    var res = validate();
    if (res == false) {
        return false;
    }
   // alert(res);
    if (res) {
        var Crew = {
            ID: $('#ID').val(),
            FirstName: $('#FirstName').val(),
            MiddleName: $('#MiddleName').val(),
            LastName: $('#LastName').val(),
            Gender: $('#Gender').val(),
            RankID: $('#RankID').val(),

            DepartmentMasterID: $('#DepartmentMasterID').val(),
            CountryID: $('#CountryID').val(),
           // Nationality: $('#Nationality').val(),
            DOB1: $('#DOB').val(),
            POB: $('#POB').val(),
            //  CrewIdentity: $('#CrewIdentity').val(),
            PassportSeamanPassportBook: $('#PassportSeamanPassportBook').val(),
            //Seaman: $('#Seaman').val(),
            //$('input:radio[name=PassportSeaman]')[1].checked = true;
            //PassportSeaman: document.getElementById("PassportSeaman").checked,
            PassportSeaman: $("input[name='PassportSeaman']:checked").val(),
            CreatedOn1: $('#CreatedOn').val(),
            LatestUpdate1: $('#LatestUpdate').val(),
            //PayNum: $('#PayNum').val(),
            // EmployeeNumber: $('#EmployeeNumber').val(),
            Notes: $('textarea#Comments').val(),
            // Watchkeeper: $('#Watchkeeper').val(),
            //OvertimeEnabled: $('#OvertimeEnabled').val(),
            Watchkeeper: document.getElementById("Watchkeeper").checked,
            OvertimeEnabled: document.getElementById("OvertimeEnabled").checked,

            AllowPsychologyForms: document.getElementById("AllowPsychologyForms").checked,

            IssuingStateOfIdentityDocument: $('#IssuingStateOfIdentityDocument').val(),
            ExpiryDateOfIdentityDocument1: $('#ExpiryDateOfIdentityDocument').val()
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

                   // clearTextBox();  deep

                    //window.location = response.url;
                    $('#btnAdd1').show();
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



function AddCrewEdit() {

    var posturl = $('#UnitaddEdit').val();
    //var passedCrewId = GetParameterValues('crew');

   // alert(passedCrewId);

   // if (res) {
        var Crew = {
            ID: $('#ID').val(),
            FirstName: $('#FirstName').val(),
            MiddleName: $('#MiddleName').val(),
            LastName: $('#LastName').val(),
            Gender: $('#Gender').val(),
            RankID: $('#RankID').val(),
            DepartmentMasterID: $('#DepartmentMasterID').val(),
            CountryID: $('#CountryID').val(),
            DOB1: $('#DOB').val(),
            POB: $('#POB').val(),
            PassportSeamanPassportBook: $('#PassportSeamanPassportBook').val(),
            PassportSeaman: $("input[name='PassportSeaman']:checked").val(),
            CreatedOn1: $('#CreatedOn').val(),
            LatestUpdate1: $('#LatestUpdate').val(),
            Notes: $('textarea#Comments').val(),
            Watchkeeper: document.getElementById("Watchkeeper").checked,
            OvertimeEnabled: document.getElementById("OvertimeEnabled").checked,

            AllowPsychologyForms: document.getElementById("AllowPsychologyForms").checked,

            IssuingStateOfIdentityDocument: $('#IssuingStateOfIdentityDocument').val(),
            ExpiryDateOfIdentityDocument1: $('#ExpiryDateOfIdentityDocument').val()
        };

        $.ajax({
            url: posturl,
            data: JSON.stringify(Crew),
            type: "POST",
            contentType: "application/json;charset=utf-8",
            dataType: "json",

            success: function (response) {
                if (response.result == 'Redirect') {

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

                   // toastr.success("Added Successfully");
                    clearTextBox();
                    window.location = response.url;
                }
                else if (response.result == 'Error') {
                    alert('Error occured. Please relogin and try again');
                }
            },
            
            error: function (errormessage) {
                console.log(errormessage.responseText);
            }
        });
  //  }
}

function LoadDataById(id) {
    //debugger;
    var ld = $('#GetById').val();
    //alert(id);
    //alert(ld);
    $.ajax({

        url: ld,
        data:
        {
            id: id
        },
        type: "GET",
        contentType: "application/json;charset=UTF-8",
        dataType: "json",
        success: function (result) {
            //debugger;
            //   $('#id').val(result.id);
           // alert(result.WatchKeeper);
            $('#ID').val(result.ID);
            $('#FirstName').val(result.FirstName);
            $('#LastName').val(result.LastName);
            $('#Gender').val(result.Gender);
            $('#MiddleName').val(result.MiddleName);
            $('#RankID').val(result.RankID);
            $('#RankName').val(result.RankName);
            $('#CountryID').val(result.CountryID);
           // $('#Nationality').val(result.Nationality);
            $('#DOB').val(result.DOB1);
            $('#POB').val(result.POB);
            // $('#CrewIdentity').val(result.CrewIdentity);
            //debugger;
            console.log('Seaman');
            console.log(result.Seaman);

            if (result.PassportSeamanIndicator === "P") {
                $('input:radio[name=PassportSeaman]')[1].checked = true;
                $('#PassportSeamanPassportBook').val(result.PassportSeamanPassportBook);
            }
            else {
                $('input:radio[name=PassportSeaman]')[0].checked = true;
                $('#PassportSeamanPassportBook').val(result.Seaman);
            }

           
          //  $('#PassportSeamanPassportBook').val(result.Seaman);

            $('#DepartmentMasterID').val(result.DepartmentMasterID);
            $('#DepartmentMasterName').val(result.DepartmentMasterName);


            $('#CreatedOn').val(result.CreatedOn1);
            $('#LatestUpdate').val(result.LatestUpdate1);

            //debugger;
            console.log('StartDate Test');
            console.log(result.CreatedOn1);
            //diable More Setting button when there is no service date
            if (result.CreatedOn1.length === 0 || result.LatestUpdate1.length === 0) {
                $('#btnAdd1').hide();
            }
            else
            {
                $('#btnAdd1').show();
            }

            //$('#PayNum').val(result.PayNum);
           // $('#EmployeeNumber').val(result.EmployeeNumber);
            $('#Comments').val(result.Notes);

            if ((result.Watchkeeper) === true) {
                $('#Watchkeeper').prop('checked', true);
            } else {
                $('#Watchkeeper').prop('checked', false);
            }

            if ((result.OvertimeEnabled) === true) {
                $('#OvertimeEnabled').prop('checked', true);
            }
            else {
                $('#OvertimeEnabled').prop('checked', false);
            }




            if ((result.AllowPsychologyForms) === true) {
                $('#AllowPsychologyForms').prop('checked', true);
            }
            else {
                $('#AllowPsychologyForms').prop('checked', false);
            }




            $('#IssuingStateOfIdentityDocument').val(result.IssuingStateOfIdentityDocument);
            $('#ExpiryDateOfIdentityDocument').val(result.ExpiryDateOfIdentityDocument1);


        },
        error: function (errormessage) {
            //debugger;
            console.log(errormessage.responseText);
        }
    });
    return false;
}


function LoadDataById2() {

    var ld = $('#GetById2').val();
    //alert(id);
    //alert(ld);
    $.ajax({

        url: ld,
        data:
        {
            id: $('#ddlCrew').val()
        },
        type: "GET",
        contentType: "application/json;charset=UTF-8",
        dataType: "json",
        success: function (result) {
            //debugger;
            //   $('#id').val(result.id);
            // alert(result.WatchKeeper);
            $('#ID').val(result.ID);
            $('#FirstName').val(result.FirstName);
            $('#LastName').val(result.LastName);
            $('#Gender').val(result.Gender);
            $('#RankID').val(result.RankID);
            $('#RankName').val(result.RankName);
            $('#CountryID').val(result.CountryID);
            // $('#Nationality').val(result.Nationality);
            $('#DOB').val(result.DOB1);
            $('#POB').val(result.POB);
            // $('#CrewIdentity').val(result.CrewIdentity);
            //alert(result.Seaman);
            $('#PassportSeamanPassportBook').val(result.PassportSeamanPassportBook);
            //  $('#PassportSeamanPassportBook').val(result.Seaman);

            $('#DepartmentMasterID').val(result.DepartmentMasterID);
            $('#DepartmentMasterName').val(result.DepartmentMasterName);


            $('#CreatedOn').val(result.CreatedOn1);
            $('#LatestUpdate').val(result.LatestUpdate1);
            //$('#PayNum').val(result.PayNum);
            // $('#EmployeeNumber').val(result.EmployeeNumber);
            $('#Comments').val(result.Notes);

            if ((result.Watchkeeper) === true) {
                $('#Watchkeeper').prop('checked', true);
            } else {
                $('#Watchkeeper').prop('checked', false);
            }

            if ((result.OvertimeEnabled) === true) {
                $('#OvertimeEnabled').prop('checked', true);
            }
            else {
                $('#OvertimeEnabled').prop('checked', false);
            }


        },
        error: function (errormessage) {
            //debugger;
            console.log(errormessage.responseText);
        }
    });
    return false;
}


