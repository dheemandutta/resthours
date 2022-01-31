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




function GetOvertimeCalculation() {
    $('#HourlyRate').css('border-color', 'lightgrey');
    var x = $("#GetOvertimeCalculation").val();

    var Overtime = {

    };


    //alert(x);
    //debugger;
    $.ajax({
        url: x,
        type: "GET",
        contentType: "application/json;charset=UTF-8",
        async: "false",
        dataType: "json",
        success: function (result) {

            $('#isWeekly').val(result.IsWeekly);

            if ($('#isWeekly').val() === 'true') {
                console.log("hi");
                $('input:radio[id=Week]').prop('checked', true);
                EnableMonth();
               
            }
            else {
                $('input:radio[id=Month]').prop('checked', true);
                EnableWeek();
            }

            //debugger;
            console.log(result);
            $('#DailyWorkHours').val(result.DailyWorkHours);
            $('#HourlyRate').val(result.HourlyRate);
            $('#HoursPerWeekOrMonth').val(result.HoursPerWeekOrMonth);
            $('#FixedOvertime').val(result.FixedOvertime);



            var DayVal1 = '';
            var DayVal2 = '';
            var DayVal3 = '';
            var DayVal4 = '';
            var DayVal5 = '';
            var DayVal6 = '';
            var DayVal7 = '';

            var Mon = $('#Mon').tristate();
            if (result.WorkingHoursPOCO.MonDay === 1)
                DayVal1 = true;
            else if (result.WorkingHoursPOCO.MonDay === 0)
                DayVal1 = false;
            else if (result.WorkingHoursPOCO.MonDay === 2)
                DayVal1 = null;
            Mon.tristate('state', DayVal1);

            if (result.WorkingHoursPOCO.TueDay === 1)
                DayVal2 = true;
            else if (result.WorkingHoursPOCO.TueDay === 0)
                DayVal2 = false;
            else if (result.WorkingHoursPOCO.TueDay === 2)
                DayVal2 = null;
            var Tue = $('#Tue').tristate();
            Tue.tristate('state', DayVal2);

            if (result.WorkingHoursPOCO.WedDay === 1)
                DayVal3 = true;
            else if (result.WorkingHoursPOCO.WedDay === 0)
                DayVal3 = false;
            else if (result.WorkingHoursPOCO.WedDay === 2)
                DayVal3 = null;
            var Wed = $('#Wed').tristate();
            Wed.tristate('state', DayVal3);

            if (result.WorkingHoursPOCO.ThuDay === 1)
                DayVal4 = true;
            else if (result.WorkingHoursPOCO.ThuDay === 0)
                DayVal4 = false;
            else if (result.WorkingHoursPOCO.ThuDay === 2)
                DayVal4 = null;
            var Thu = $('#Thu').tristate();
            Thu.tristate('state', DayVal4);


            if (result.WorkingHoursPOCO.FriDay === 1)
                DayVal5 = true;
            else if (result.WorkingHoursPOCO.FriDay === 0)
                DayVal5 = false;
            else if (result.WorkingHoursPOCO.FriDay === 2)
                DayVal5 = null;
            var Fri = $('#Fri').tristate();
            Fri.tristate('state', DayVal5);

            if (result.WorkingHoursPOCO.SatDay === 1)
                DayVal6 = true;
            else if (result.WorkingHoursPOCO.SatDay === 0)
                DayVal6 = false;
            else if (result.WorkingHoursPOCO.SatDay === 2)
                DayVal6 = null;
            var Sat = $('#Sat').tristate();
            Sat.tristate('state', DayVal6);

            if (result.WorkingHoursPOCO.SunDay === 1)
                DayVal7 = true;
            else if (result.WorkingHoursPOCO.SunDay === 0)
                DayVal7 = false;
            else if (result.WorkingHoursPOCO.SunDay === 2)
                DayVal7 = null;
            var Sun = $('#Sun').tristate();
            Sun.tristate('state', DayVal7);


            calc();

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


function calc()         //FixedWorkHour  DailyWorkHours
{
    if ($('#DailyWorkHours').val() === '8') {
        $('#FixedWorkHour').val('44');
    }
    if ($('#DailyWorkHours').val() === '9') {
        $('#FixedWorkHour').val('49');
    }
    if ($('#DailyWorkHours').val() === '7') {
        $('#FixedWorkHour').val('39');
    }
}

function EnableMonth() {
    $('#DailyWorkHours').prop("disabled", false).val('');
    $('#HourlyRate').val('');
    $('#FixedWorkHour').val('');

    var Mon = $('#Mon').tristate();
    Mon.tristate('state', false);

    var Tue = $('#Tue').tristate();
    Tue.tristate('state', false);

    var Wed = $('#Wed').tristate();
    Wed.tristate('state', false);

    var Thu = $('#Thu').tristate();
    Thu.tristate('state', false);

    var Fri = $('#Fri').tristate();
    Fri.tristate('state', false);

    var Sat = $('#Sat').tristate();
    Sat.tristate('state', false);

    var Sun = $('#Sun').tristate();
    Sun.tristate('state', false);

    $('#week').show();
    $('#FixedOvertime').prop("disabled", true).val('');
}


function EnableWeek() {
    $('#DailyWorkHours').prop("disabled", true).val('');
    $('#HourlyRate').val('');
    $('#FixedWorkHour').prop("disabled", true).val('');

    var Mon = $('#Mon').tristate();
    Mon.tristate('state', false);

    var Tue = $('#Tue').tristate();
    Tue.tristate('state', false);

    var Wed = $('#Wed').tristate();
    Wed.tristate('state', false);

    var Thu = $('#Thu').tristate();
    Thu.tristate('state', false);

    var Fri = $('#Fri').tristate();
    Fri.tristate('state', false);

    var Sat = $('#Sat').tristate();
    Sat.tristate('state', false);

    var Sun = $('#Sun').tristate();
    Sun.tristate('state', false);

    $('#week').hide();
    $('#FixedOvertime').prop("disabled", false).val('');
}


function SaveOvertimeCalculation() {
    //alert($('#Mon-value').text());
    var posturl = $('#SaveOvertimeCalculation').val();
    var res = validate();
    if (res == false) {
        return false;
    }
    var dwh = $('#DailyWorkHours').val();
    var fwh = $('#FixedWorkHour').val();
    var ed = parseInt(fwh / dwh);
    if ($('#Mon-value').text() === '0')
    {
        $('#Mon-value').text(ed);
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

                //clearTextBox();

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