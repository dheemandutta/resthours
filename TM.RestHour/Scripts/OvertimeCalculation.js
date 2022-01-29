function validate() {
    var isValid = true;

    if ($('#HourlyRate').val().length === 0) {
        $('#HourlyRate').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#HourlyRate').css('border-color', 'lightgrey');
    }


    //if ($('#DepartmentMasterCode').val().length === 0) {
    //    $('#DepartmentMasterCode').css('border-color', 'Red');
    //    isValid = false;
    //}
    //else {
    //    $('#DepartmentMasterCode').css('border-color', 'lightgrey');
    //}
    return isValid;
}

function clearTextBox() {

    //$('#ddlAdmCru option:selected').each(function () {
    //    $(this).prop('selected', false);
    //});

    //$('#ddlAdmCru').multiselect('refresh');

    $('#Category').val("");
    $('#HourlyRate').val("");
    $('#ID').val("");
    //$('#btnUpdate').hide();
    //$('#btnAdd').show();

}




function GetOvertimeCalculation(Id) {
    $('#HourlyRate').css('border-color', 'lightgrey');
    var x = $("#myUrl").val();

    var Overtime = {

    };


    //alert(x);
    //debugger;
    $.ajax({
        url: x,
        data:
        {
            Id: Id
        },
        type: "GET",
        contentType: "application/json;charset=UTF-8",
        async: "false",
        dataType: "json",
        success: function (result) {
            //debugger;
            $('#DailyWorkHours').val(result.DailyWorkHours);
            $('#HourlyRate').val(result.HourlyRate);
            $('#HoursPerWeekOrMonth').val(result.HoursPerWeekOrMonth);
            $('#FixedOvertime').val(result.FixedOvertime);

            //$('#ID').val(result.ID);

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




function SaveOvertimeCalculation() {
    //alert($('#Mon-value').text());
    var posturl = $('#SaveOvertimeCalculation').val();
    var res = validate();
    if (res == false) {
        return false;
    }
    // alert(res);
    if (res) {
        var WH = {
            MonDay: $('#Mon-value').text(),
            TueDay: $('#Tue-value').text(),
            WedDay: $('#Wed-value').text(),
            ThuDay: $('#Thu-value').text(),
            FriDay: $('#Fri-value').text(),
            SatDay: $('#Sat-value').text(),
            SunDay: $('#Sun-value').text(),

            WorkHours: $('#DailyWorkHours').val()
        };


        var OvertimeCalculation = {
            DailyWorkHours: $('#DailyWorkHours').val(),
            HourlyRate: $('#HourlyRate').val(),
            HoursPerWeekOrMonth: $('#HoursPerWeekOrMonth').val(),
            FixedOvertime: $('#FixedOvertime').val(),

            WorkingHours: WH
        };

        var x = JSON.stringify(OvertimeCalculation);

        $.ajax({
            url: posturl,
            data: JSON.stringify(OvertimeCalculation),
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

                //window.location = response.url;
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