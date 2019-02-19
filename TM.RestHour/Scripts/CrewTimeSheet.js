//debugger;
/*Global count to set the attribute id*/


/*Clone row using the table name*/


function GetLastMinusAdjustmentDate(crewid, bdate) {
    var m = $('#GetMinusOneBookStatus').val();

    return $.ajax({
        url: m,
        data:
        {
            crewId: crewid,
            bookDate: bdate
        },
        type: "GET",
        contentType: "application/json;charset=UTF-8",
        dataType: "json",
        async: 'false',
        complete: function (result) {

        },
        error: function (errormessage) {
            //debugger;
            console.log(errormessage.responseText);
        }
    });
}


function GetAdjustmentFactor() {
    var adjustmentFactor = $('#GetAdjustmentFactor').val();
    var selectedDt = '';

    selectedDt = $('.multiple').val();

    if (selectedDt == '') {

        var d = new Date();

        var month = d.getMonth() + 1;
        var day = d.getDate();

        var output = (('' + month).length < 2 ? '0' : '') + month + '/' +
            (('' + day).length < 2 ? '0' : '') + day + '/' +
            d.getFullYear();



        selectedDt = output;
        console.log(selectedDt);
    }

    //debugger;  //ok
    return $.ajax({
        url: adjustmentFactor,
        data:
        {
            selectedDate: selectedDt
        },
        type: "GET",
        contentType: "application/json;charset=UTF-8",
        dataType: "json",
        async: 'false',
        success: function (result) {
            adjustmentvalue = result;
            console.log(adjustmentvalue);
        },
        error: function (errormessage) {
            //debugger;
            console.log(errormessage.responseText);
        }
    });
}



function addTP($els) {

    //var dfrd = $.Deferred();

    //console.log($els.attr('id'));
    //console.log('in addTP');
    //console.log($('.multiple').val());


    var selectValues = {
        "00:00": "00:00", "00:30": "00:30", "01:00": "01:00", "01:30": "01:30", "02:00": "02:00", "02:30": "02:30", "03:00": "03:00", "03:30": "03:30", "04:00": "04:00", "04:30": "04:30", "05:00": "05:00", "05:30": "05:30", "06:00": "06:00", "06:30": "06:30", "07:00": "07:00", "07:30": "07:30", "08:00": "08:00", "08:30": "08:30"
        , "09:00": "09:00", "09:30": "09:30", "10:00": "10:00", "10:30": "10:30", "11:00": "11:00", "11:30": "11:30", "12:00": "12:00", "12:30": "12:30", "13:00": "13:00", "13:30": "13:30", "14:00": "14:00", "14:30": "14:30", "15:00": "15:00", "15:30": "15:30", "16:00": "16:00", "16:30": "16:30", "17:00": "17:00", "17:30": "17:30"
        , "18:00": "18:00", "18:30": "18:30", "19:00": "19:00", "19:30": "19:30", "20:00": "20:00", "20:30": "20:30", "21:00": "21:00", "21:30": "21:30", "22:00": "22:00", "22:30": "22:30", "23:00": "23:00", "23:30": "23:30", "23:59": "23:59"
    };

    $.each(selectValues, function (key, value) {
        $els.append($("<option></option>")
            .attr("value", key)
            .text(value));
    });




}

$("#btnCloseModal").on("click", function (event) {

    //CompleteRegistration(event);
    $('#myModal').modal('hide');

    return false;
});

function addTPDynamic($els) {

    var dfrd = $.Deferred();

    //console.log($els.attr('id'));
    //console.log('in addTP');
    //console.log($('.multiple').val());




    GetAdjustmentFactor().done(function (data) {
        console.log('in done');
        console.log(data);
        console.log(adjustmentvalue);
        $els.attr('disabled', false);
        $('#btnAdd').attr('disabled', false);
        $('#hdnAdjustmentFactor').val(adjustmentvalue);

        if (adjustmentvalue == "+1") {

            $('#btnAdd').attr('disabled', false);

            if ($(".timepicker option[value='00:00']").length > 0) {
                $(".timepicker option[value='00:00']").remove();
            }

            if ($(".timepicker option[value='00:30']").length > 0) {
                $(".timepicker option[value='00:30']").remove();
            }

            $('#daytoggle').bootstrapToggle('disable');
        }

        else if (adjustmentvalue == "+30") {

            $('#daytoggle').bootstrapToggle('disable');
            $('#btnAdd').attr('disabled', false);

            if ($(".timepicker option[value='00:00']").length > 0) {

                console.log('in +30');
                $(".timepicker option[value='00:00']").remove();
            }

        }
        else if (adjustmentvalue == "+1D") {

            $('#daytoggle').bootstrapToggle('disable');
            $('#btnAdd').attr('disabled', true);
            var msg = "TIme Booking is locked for today.";
            $('#myModal').modal('show');
            $('#succMsg').html(msg);

        }

        else if (adjustmentvalue == "-1D") {
            $('#daytoggle').bootstrapToggle('enable');
            //make it visible
            //$(".show_hide").show();
            $('#divdaytoggle').show();
        }
        else {


            console.log('In 0 adjustment');

            $('#daytoggle').bootstrapToggle('disable');

            if ($(".timepicker option[value='00:00']").length <= 0) {
                console.log('adding 00 back');

                $('.timepicker').prepend("<option value='00:00'>00:00</option>");
                //   $(".timepicker option").eq(1).before($("<option></option>").val("00:00").text("00:00")); selected='selected'
            }

            if ($(".timepicker option[value='00:30']").length <= 0) {
                $(".timepicker option").eq(2).before($("<option></option>").val("00:30").text("00:30"));
            }
        }

        prevAdjustmentValue = adjustmentvalue;
    });


    dfrd.resolve();

    return $.when(dfrd).done(function () {
        console.log(' tasks in ADDTP are done');
        // Both asyncs tasks are done
    }).promise();


}

function removeTP($els) {
    $els.html('');
}





var initflag = true;

function CheckCompliance() {

    var dfrd2 = $.Deferred();
    var isPostable = false;

    console.log('In CheckComplaince');

    //clear previous comments
    $('#Comments').html('');

    //check for compliance
    var compliancecheckurl = $('#checkcompliance').val();
    var tsheetdata = [];
    //run through each row
    $('.table-responsive tr').not(":first").each(function (i, row) {

        // reference all the stuff you need first
        var $row = $(row),
            $stdt = $row.find('select[name*="startdate"]'),
            $enddt = $row.find('select[name*="enddate"]');

        if ($stdt.val() != '00:00' || $enddt.val() != '00:00') {
            isPostable = true;
        }


        console.log('In loop');
        console.log($stdt.val());

        tsheetdata[i] = new Array($stdt.val(), $enddt.val());



    });

    console.log('In ComplianceCheck');
    console.log(tsheetdata);
    console.log(isPostable);
    //check if there is valid time

    if (isPostable) {



        CalculateWorkingTime(tsheetdata);



        //////////////////////////////////////////////



        var TSheetJsonObject = { WF: [] };
        TSheetJsonObject.WF.push({ d: tsheetdata });
        //post
        $.ajax({
            url: compliancecheckurl,
            data: JSON.stringify({ 'timesheetjsondata': JSON.stringify(TSheetJsonObject), crewId: $('#ddlCrew').val(), selectedDate: $('.multiple').val() }),
            type: "POST",
            contentType: "application/json;charset=utf-8",
            dataType: "json",
            async: "false",
            success: function (result) {

                //debugger;
                $('#Comments').html(result);

                // debugger;

                //set calendar color
                if ($.trim(result).length > 0) {

                    Paint('1');

                    //Commented by Dheeman
                    $('.ui-datepicker-calendar tr').each(function () {

                        //chnage colour of calendar for altered date -- change to red
                        $(this).find('td.ui-datepicker-current-day').each(function () {
                            //console.log('found');
                            initflag = false;
                            //var td = $(this);
                            //$(td).find('a.ui-state-booked').addClass('ui-state-bookednc');
                            //$(td).find('a.ui-state-booked').removeClass('ui-state-booked');
                        });
                    });



                }
                else {
                    Paint('0');

                    //Commented by Dheeman
                    $('.ui-datepicker-calendar tr').each(function () {

                        //chnage colour of calendar for altered date
                        $(this).find('td.ui-datepicker-current-day').each(function () {
                            //console.log('found');
                            initflag = false;
                            //var td = $(this);
                            //$(td).find('a.ui-state-active').addClass('ui-state-booked');
                            //$(td).find('a.ui-state-active').removeClass('ui-state-active');

                            //$(td).find('a.ui-state-bookednc').addClass('ui-state-booked');
                            //$(td).find('a.ui-state-bookednc').removeClass('ui-state-bookednc');

                        });
                    });


                }


            },
            error: function (errormessage) {
                console.log(errormessage.responseText);
            }
        });



        dfrd2.resolve();

        //Colourise Calendar
        SetCalendarColor();

        return $.when(dfrd2).done(function () {
            console.log('tasks in CheckCompliance are done');
            // Both asyncs tasks are done
        }).promise();
    }
    else {
        ClearWorkingTime();
        SetCalendarColor();
    }

}

var thisStartTime = '';
var thisEndTime = '';
var thisRow;
var thisEndTimeSelectedIndex;

function CalculateWorkingTime(tdata) {
    var workedhrs = 0;
    var resthours = 0;
    var hour = 0;
    var workhr_hrcomponent = 0;
    var workhr_mincomponent = 0;
    //calculate total hours worked
    for (var i = 0; i < tdata.length; i++) {
        var s = tdata[i][0].split(':');
        var e = tdata[i][1].split(':');

        if (e[1] == 59) {
            e[0] = 24;
            e[1] = 00;
        }

        var min = e[1] - s[1];
        var hour_carry = 0;

        if (min < 0) {
            min += 60;
            hour_carry += 1;

        }

        hour = (e[0] - s[0] - hour_carry);

        console.log('Printing Min');
        console.log(min);

        workhr_hrcomponent += hour;
        workhr_mincomponent += min;

        if (workhr_mincomponent >= 60) {
            workhr_hrcomponent += 1;
            workhr_mincomponent = workhr_mincomponent - 60;
        }

        s = 0;
        e = 0;
        min = 0;
        hour = 0;
    }

    workedhrs = workhr_hrcomponent + ':' + workhr_mincomponent;
    $('#TotalWorkHours').val(workedhrs);

    //calculating total rest hours
    var rest_hours = '24:00';
    var e_rest = rest_hours.split(':');
    var s_rest = workedhrs.split(':');

    var min_rest = e_rest[1] - s_rest[1];
    console.log('min res prining');
    console.log(min_rest);
    var hr_carry_rest = 0;

    if (min_rest < 0) {
        min_rest += 60;
        hr_carry_rest += 1;
    }

    var hour_rest = e_rest[0] - s_rest[0] - hr_carry_rest;

    //if (min_rest == 60)
    //{
    //	hour_rest += 1;
    //	min_rest = 0;
    //}

    resthours = hour_rest + ':' + min_rest;

    $('#TotalRestHours').val(resthours);
}

function ClearWorkingTime() {
    $('#TotalWorkHours').val('');
    $('#TotalRestHours').val('');
}

function changeColor(drpdn) {

    //var this = drpdn;
    console.log('in change');
    console.log($(drpdn).attr('id'));

    //Commented by Dheeman
    $('.ui-datepicker-calendar tr').each(function () {

        //chnage colour of calendar for altered date
        $(this).find('td.ui-datepicker-current-day').each(function () {
            //console.log('found');
            initflag = false;
            //var td = $(this);
            //$(td).find('a.ui-state-active').addClass('ui-state-booked');
            //$(td).find('a.ui-state-active').removeClass('ui-state-active');
        });
    });

    //alert(newrowCreated);
    if (initflag == false && $('#ddlCrew').val().length > 0) {

        //Validation - START
        thisRow = $(drpdn).parent('td').parent('tr');
        ValidateTime($(drpdn), thisRow);
        if (isValidationTripped) {
            alert('Start time and end time is not correct');
            $(drpdn).val(timeBackup);
            isValidationTripped = false;
            // timeBackup = '';
            return false;
        }
        ValidateSlots(thisRow);
        if (isValidationTripped) {
            alert('This time is overlapping with row number ' + validationTrippedForRowIndex);
            $(drpdn).val(timeBackup);
            isValidationTripped = false;
            // timeBackup = '';
            return false;
        }
        //Validation - END

        //	Paint();
        //CheckCompliance();

        //if id is greater than or equal to 0, then show message
        //debugger;

        var ctrl = $(drpdn);
        //debugger;

        //commented by Dheeman as now third control notification is not needed anymore
        //if (ctrl[0].id != '' && typeof ctrl[0].id != 'undefined') {
        //	//alert(ctrl[0].id);
        //	//display message
        //	if (ctrl[0].id != 'stdt1' && ctrl[0].id != 'enddat0' && ctrl[0].id != 'stdt0' && ctrl[0].id != 'enddat1') {
        //		//var warningmsg = 'You will be non-compliant. ';
        //		$(ctrl[0]).css('border-color', 'Red');
        //		$('.pos').notify("You're Non-Compliant", "warn", { position: "right" });

        //		console.log('Control Id in Change Color');
        //		console.log(ctrl[0].id);
        //	}
        //}

        // if (newrowCreated == true) newrowCreated = false;


        //var timecounter = 0;
        //check for compliance only for  enddt controils . The if below is to stop for start date
        //debugger;
        //if (ctrl[0].id != 'stdt0' && ctrl[0].id != 'stdt1' && ctrl[0].id.substr(0, ctrl[0].id.length - 1) != 'startdt')
        //{


        var compliancecheckurl = $('#checkcompliance').val();
        var tsdata = [];
        //run through each row
        $('.table-responsive tr').not(":first").each(function (i, row) {

            // reference all the stuff you need first
            var $row = $(row),
                $stdt = $row.find('select[name*="startdate"]'),
                $enddt = $row.find('select[name*="enddate"]');

            // if ($enddt.val() == '23:59') $enddt = '00:00' ;

            if ($stdt.val() != $enddt.val()) {
                tsdata[i] = new Array($stdt.val(), $enddt.val());
            }

            console.log('Prining tsdata');
            console.log(tsdata);

        })

        var allowpost = false;
        var startsection = '';
        var endsection = '';
        for (var q = 0; q < tsdata.length; q++) {
            //console.log(tsdata[q]);

            //check if both values are not 0
            if (tsdata[q] != '00:00,00:00') {
                // debugger;
                allowpost = true;
            }
            //var arr = tsdata[q].split(',');
            //console.log('printing 2nd component');
            //console.log(tsdata[q][1]);
            if (tsdata[q][1] != '00:00') {
                allowpost = true;
            }
            else {
                allowpost = false;
            }

        }

        if (allowpost) {

            CalculateWorkingTime(tsdata);

            //////////////////////////////////////////////

            var TSJsonObject = { WF: [] };
            TSJsonObject.WF.push({ d: tsdata });
            //post
            $.ajax({
                url: compliancecheckurl,
                data: JSON.stringify({ 'timesheetjsondata': JSON.stringify(TSJsonObject), crewId: $('#ddlCrew').val(), selectedDate: $('.multiple').val() }),
                type: "POST",
                contentType: "application/json;charset=utf-8",
                dataType: "json",
                async: "false",
                success: function (result) {

                    //debugger;
                    $('#Comments').html(result);

                    //set calendar color
                    if ($.trim(result).length > 0) {

                        Paint('1');

                        //Commented by Dheeman
                        $('.ui-datepicker-calendar tr').each(function () {

                            //chnage colour of calendar for altered date -- change to red
                            $(this).find('td.ui-datepicker-current-day').each(function () {
                                //console.log('found');
                                initflag = false;
                                //var td = $(this);
                                //$(td).find('a.ui-state-booked').addClass('ui-state-bookednc');
                                //$(td).find('a.ui-state-booked').removeClass('ui-state-booked');
                            });
                        });

                        //chnage color of timepickers to red
                        $('.table-responsive tr').not(":first").each(function (i, row) {

                            // reference all the stuff you need first
                            var $row = $(row),
                                $stdt = $row.find('input[name*="startdate"]'),
                                $enddt = $row.find('input[name*="enddate"]');


                            $($stdt).css('border-color', 'Red');
                            $($enddt).css('border-color', 'Red');


                        });
                    }
                    else {

                        Paint('0');

                        //Commented by Dheeman
                        $('.ui-datepicker-calendar tr').each(function () {

                            //chnage colour of calendar for altered date
                            $(this).find('td.ui-datepicker-current-day').each(function () {
                                //console.log('found');
                                initflag = false;
                                //var td = $(this);
                                //$(td).find('a.ui-state-active').addClass('ui-state-booked');
                                //$(td).find('a.ui-state-active').removeClass('ui-state-active');

                                //$(td).find('a.ui-state-bookednc').addClass('ui-state-booked');
                                //$(td).find('a.ui-state-bookednc').removeClass('ui-state-bookednc');

                            });
                        });

                        //reset color of timepickers
                        $('.table-responsive tr').not(":first").each(function (i, row) {

                            // reference all the stuff you need first
                            var $row = $(row),
                                $stdt = $row.find('input[name*="startdate"]'),
                                $enddt = $row.find('input[name*="enddate"]');


                            $($stdt).css('border-color', 'black');
                            $($enddt).css('border-color', 'black');


                        });
                    }


                },
                error: function (errormessage) {
                    console.log(errormessage.responseText);
                }
            });


        }
        else {
            ClearWorkingTime();
        }

        // }

    } //crew  end




}



function SetCalendarColor() {

    var nc = $('#GetNCForMonth').val();

    if ($('#ddlCrew').val() > 0) {

        $.ajax({
            url: nc,
            data: ({ bookDate: $('.multiple').val(), CrewId: $('#ddlCrew').val() }),
            type: "GET",
            contentType: "application/json;charset=UTF-8",
            dataType: "json",
            async: 'false',
            success: function (result) {

                //remove all colours first 
                $('.ui-datepicker-calendar tr td').each(function () {

                    var blankcell = $(this);
                    //$(blankcell).removeClass('ui-state-bookednc');
                });

                //for (i = 0; i < result.length; i++) {


                $('.ui-datepicker-calendar tr td').each(function () {

                    //$(this).find('td').each(function () {

                    var cell = $(this);


                    //console.log('Calendar Data');
                    //	console.log(cell);
                    //console.log($(cell).attr('data-month'));
                    //console.log($(cell).attr('data-year'));



                    $(cell).children().each(function () {
                        //console.log(this);
                        var anchor = this;
                        //console.log($(anchor).text());
                        //console.log('In GetNCDays');
                        //console.log(result);
                        //console.log($.inArray('21', result));

                        for (var y = 0; y < result.length; y++) {
                            if (result[y] == $(anchor).text()) {
                                console.log('Coloring Red');
                                $(cell).find('a.ui-state-default').addClass('ui-state-bookednc');
                                $(cell).addClass('ui-state-bookednc');
                            }
                        }


                    });


                });




                //}

            },
            error: function (errormessage) {
                //debugger;
                console.log(errormessage.responseText);
            }
        });
    }

}



var thisStartTime = '';
var thisEndTime = '';
var hour, minute, startTimeInMinute, endTimeInMinute;

function GetModifiedTime() {


    console.log('In Modified Time');

    return $.ajax({
        url: $('#RetrieveTimeChange').val(),
        type: "POST",
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        async: "false",
        success: function (result) {
            timeModified = result;
            console.log('get time modified');
            console.log(timeModified);
        },
        error: function (errormessage) {
            console.log(errormessage.responseText);
        }
    });
}

function GetModifiedDate() {

    return $.ajax({
        url: $('#RetrieveTimeChangeDate').val(),
        type: "POST",
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        async: "false",
        success: function (result) {
            dateModified = result;
            console.log('get date modified');
            console.log(dateModified);
        },
        error: function (errormessage) {
            console.log(errormessage.responseText);
        }
    });
}

function PaintInTimeCalendar(startTimeInMinute, endTimeInMinute, cssClass) {
    if (endTimeInMinute > startTimeInMinute) {
        do {
            $('[name=timebox][time-in-minute=' + startTimeInMinute.toString() + ']').addClass(cssClass);
            startTimeInMinute = startTimeInMinute + 30;
        } while (startTimeInMinute < endTimeInMinute);
    }
}
var timeCount;
function Paint(indicator) {

    var dfrd3 = $.Deferred();

    $('[name=timebox]').removeClass('pre-occupied');
    $('[name=timebox]').removeClass('occupied');
    $('[name=timebox]').removeClass('occupied_red');
    timeCount = 1;
    $('#cloneTable>tbody>tr').each(function () {
        if ($(this).find('select[name*="startdate"]').length > 0)
        //for (var i = 0; i < (savedTime.length / 2); i++)
        {

            //hour = savedTime[i].split(':')[0];
            //minute = savedTime[i].split(':')[1];

            thisStartTime = $(this).find('select[name*="startdate"]').val(); //savedTime[i];
            hour = thisStartTime.split(':')[0];
            minute = thisStartTime.split(':')[1];
            startTimeInMinute = (parseInt(hour) * 60) + parseInt(minute);

            thisEndTime = $(this).find('select[name*="enddate"]').val();//savedTime[i + 1];
            console.log(thisEndTime);
            //if (thisEndTime == '23:59') thisEndTime = '00:00';
            hour = thisEndTime.split(':')[0];
            minute = thisEndTime.split(':')[1];
            endTimeInMinute = (parseInt(hour) * 60) + parseInt(minute);

            //alert($.trim($('#hdnAdjustmentFactor').val()));
            if ($.trim($('#hdnAdjustmentFactor').val()) == '-1') {
                if (startTimeInMinute > 0) {
                    startTimeInMinute = startTimeInMinute - 60;
                }
                else if (startTimeInMinute == 0 && endTimeInMinute > 0) {
                    startTimeInMinute = startTimeInMinute - 60;

                    if ($('[name=timebox][time-in-minute=-60]').length == 0) {
                        var scheduleHeaderHTML = '';
                        scheduleHeaderHTML += '<th id="newro_th" class="tg-amwm" width="18px">00</th>';
                        $('#schedule_header').children('tbody').children('tr').prepend(scheduleHeaderHTML);

                        var schedule = '';
                        schedule += '<td id="newro_td1" class="tg-yw4l" height="20px" width="9px" name="timebox" time-in-minute="-60"></td>';
                        schedule += '<td id="newro_td2" class="tg-yw4l" height="20px" width="9px" name="timebox" time-in-minute="-30"></td>';
                        $('#schedule').children('tbody').children('tr').prepend(schedule);
                    }
                }
            }

            //alert(startTimeInMinute)
            //PaintInTimeCalendar(startTimeInMinute, endTimeInMinute, 'occupied');

            //alert(startTimeInMinute)
            //alert(endTimeInMinute)
            console.log('Printing text of comments');
            console.log($('#Comments').html().trim().length);
            if (indicator == '0') {
                PaintInTimeCalendar(startTimeInMinute, endTimeInMinute, 'occupied');
            }
            else {
                PaintInTimeCalendar(startTimeInMinute, endTimeInMinute, 'occupied_red');
            }

            timeCount++;
        }

    });

    dfrd3.resolve();

    return $.when(dfrd3).done(function () {
        console.log(' tasks in Paint are done');
        // Both asyncs tasks are done
    }).promise();
}

var thisRow;
var thisRowIndex;
var validatingRow;
var validatingRowIndex;
var validatingStartTime, validatingStartTimeInMinute;
var validatingEndTime, validatingEndTimeInMinute;
var isValidationTripped = false;
var validationTrippedForRowIndex;

var thisTextBoxName;
var thisTextBoxStartEnd;

function ValidateTime(thisTextBox, thisRow) {
    thisRowIndex = $(thisRow).index();
    thisTextBoxName = $(thisTextBox).attr('name');

    //start time
    if (thisTextBoxName.indexOf('startdate') >= 0) {
        thisTextBoxStartEnd = 'S';
    }
    //endtime
    else {
        thisTextBoxStartEnd = 'E';
    }

    if (thisRowIndex > 0) {
        //Start time of this row
        thisStartTime = $(thisRow).find('select[name*="startdate"]').val();
        hour = thisStartTime.split(':')[0];
        minute = thisStartTime.split(':')[1];
        startTimeInMinute = (parseInt(hour) * 60) + parseInt(minute);

        //End time of this row
        thisEndTime = $(thisRow).find('select[name*="enddate"]').val();
        hour = thisEndTime.split(':')[0];
        minute = thisEndTime.split(':')[1];
        endTimeInMinute = (parseInt(hour) * 60) + parseInt(minute);

        thisEndTimeSelectedIndex = $(thisRow).find('select[name*="enddate"] option:selected').index();

        if (thisTextBoxStartEnd == 'S') {
            //if (endTimeInMinute > 0) {
            if (thisEndTimeSelectedIndex > 0) {
                if (endTimeInMinute < startTimeInMinute) {
                    isValidationTripped = true;
                    return false;
                }
            }
        }
        else {
            if (endTimeInMinute < startTimeInMinute) {
                isValidationTripped = true;
                return false;
            }
        }
    }
}

function ValidateSlots(thisRow) {
    thisRowIndex = $(thisRow).index();

    if (thisRowIndex > 0) {
        //Start time of this row
        thisStartTime = $(thisRow).find('select[name*="startdate"]').val();
        hour = thisStartTime.split(':')[0];
        minute = thisStartTime.split(':')[1];
        startTimeInMinute = (parseInt(hour) * 60) + parseInt(minute);

        //End time of this row
        thisEndTime = $(thisRow).find('select[name*="enddate"]').val();
        if (thisEndTime != 'undefined') {

            hour = thisEndTime.split(':')[0];
            minute = thisEndTime.split(':')[1];
            endTimeInMinute = (parseInt(hour) * 60) + parseInt(minute);


            if (endTimeInMinute > startTimeInMinute) {
                //Loop for validation
                $('#cloneTable>tbody>tr').each(function () {
                    validatingRow = $(this);
                    validatingRowIndex = $(this).index();
                    //alert('thisRowIndex: ' + thisRowIndex + ' | validatingRowIndex: ' + validatingRowIndex)
                    if (validatingRowIndex > 0 && validatingRowIndex != thisRowIndex) {
                        if ($(this).find('select[name*="startdate"]').length > 0) {
                            validatingStartTime = $(this).find('select[name*="startdate"]').val();
                            hour = validatingStartTime.split(':')[0];
                            minute = validatingStartTime.split(':')[1];
                            validatingStartTimeInMinute = (parseInt(hour) * 60) + parseInt(minute);

                            validatingEndTime = $(this).find('select[name*="enddate"]').val();
                            hour = validatingEndTime.split(':')[0];
                            minute = validatingEndTime.split(':')[1];
                            validatingEndTimeInMinute = (parseInt(hour) * 60) + parseInt(minute);

                            if (validatingStartTimeInMinute != 0 || validatingEndTimeInMinute != 0) {
                                for (var tempTimeInMinute = startTimeInMinute; tempTimeInMinute <= endTimeInMinute && !isValidationTripped; tempTimeInMinute = tempTimeInMinute + 30) {
                                    //alert('tempTimeInMinute: ' + tempTimeInMinute + ' | validatingStartTimeInMinute: ' + validatingStartTimeInMinute + ' | validatingEndTimeInMinute: ' + validatingEndTimeInMinute)
                                    //if (tempTimeInMinute == validatingStartTimeInMinute) {
                                    //    //alert(1);
                                    //    isValidationTripped = true;
                                    //    validationTrippedForRowIndex = validatingRowIndex;
                                    //}
                                    //if (tempTimeInMinute == validatingEndTimeInMinute) {
                                    //    //alert(2);
                                    //    isValidationTripped = true;
                                    //    validationTrippedForRowIndex = validatingRowIndex;
                                    //}
                                    if (tempTimeInMinute > validatingStartTimeInMinute && tempTimeInMinute < validatingEndTimeInMinute) {
                                        //alert(3);
                                        isValidationTripped = true;
                                        validationTrippedForRowIndex = validatingRowIndex;
                                    }
                                }
                            }
                        }
                    }

                    if (isValidationTripped) { return false; }
                })
            }

        } //end

        console.log('Validation');
        console.log(isValidationTripped);

        if (isValidationTripped) { return false; }

    }
}


var timeBackup;
$(document).on('click', 'select[name*="startdate"],select[name*="enddate"]', function () {
    timeBackup = $(this).val();
})

