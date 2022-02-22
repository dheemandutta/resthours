
function GetNonComplianceDetails() {

    var posturl = $('#GetNonComplianceDetails').val();
    //debugger;
    var htmlstr2 = '';
    var statustext2 = false;
    var monthYear = $('.monthYearPicker').val();
    $("#schedule").find("tr:gt(1)").remove();

    $.ajax({
        url: posturl,
        data: JSON.stringify({ 'monthyear': $('.monthYearPicker').val() }),
        type: "POST",
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        async: 'false',

        success: function (result) {

            //$('#yr').text(result.Year);
            //$('#mn').text(result.MonthName);
            htmlstr2 = result;
            statustext2 = true;
            //console.log(result);
            var crewid = 0;
            var previouscrewid = 0;
            var day = 0;
            var isnewCrew = false;

            var getUrl = window.location;
            var baseurl = getUrl.protocol + "//" + getUrl.host; //+ "/" + getUrl.pathname.split('/')[1]  ;

            //var baseurl = $('base').attr('href');
            var imgpathR = baseurl + "/images/R.png";
            var imgpathG = baseurl + "/images/G.png";


            if (result != null) {
                //loop in result array
                var positionCounter = 0;

                $.each(result, function (index, item) {
                    if (item != null) {

                        var table = $('#schedule');
                        var trLast = $(table).find("tr:last");
                        var trnew;
                        var adjustmentfactor = item.AdjustmentFactor;
                        //console.log('here');
                        //console.log(item.DateNumber);
                        var ignoreRow = '';
                        //ok

                        day = item.DateNumber;
                        if (crewid == 0) {
                            crewid = item.CrewID;
                            previouscrewid = crewid;
                        }

                        if (crewid != item.CrewID) {
                            crewid = item.CrewID;

                        }

                        //crewid = item.CrewID;


                        var tdnum = 0;
                        var colcnt = 0;
                        //add row

                        if (crewid == previouscrewid && index == 0) { //first iteration 
                            $('#trclone').attr('id', crewid);
                            var trid = '#' + crewid;
                            console.log(trid);
                            $(trid).children('td').each(function (idx, itm) {  //map data in row 1

                                if (idx == 0) //name
                                {
                                    //debugger;
                                    //clear
                                    $(this).html('');
                                    $(this).html(result[index].Name);
                                    console.log(result[index].Name);

                                    //tdnum++;
                                }
                                else if (idx == 1) //regimename
                                {
                                    //debugger;
                                    //clear
                                    $(this).html('');
                                    $(this).html(result[index].RegimeName);
                                    console.log(result[index].RegimeName);
                                    console.log(idx);
                                    //tdnum++;
                                }
                             
                                else if (idx - 1 == parseInt(day)) {

                                    // debugger;
                                    if (result[index].isNonCompliant == '1') {
                                        //clear
                                        $(this).html('');
                                        $(this).html('&nbsp;<a href="#" id="myid3" onclick="javascript:GetNCDetails(&quot;' + result[index].NCDetailsID + '&quot;);"> <img src="/images/R.png" width="16" height="16"> </a>');  //NC
                                    }
                                    else {
                                        //clear
                                        $(this).html('');
                                        $(this).html('&nbsp;<a href="#" id= "' + result[index].NCDetailsID + '"> <img src="/images/G.png" width="16" height="16"> </a>');   //NA
                                        console.log('Checking Status');
                                        console.log(idx);
                                    }
                                }

                                tdnum++;

                            });



                        }
                        else if (crewid == previouscrewid) { // mathcing rows
                            var trid = $('#schedule tbody>tr:last');
                            $(trid).children('td').each(function (idx, itm) {  //map data in row 1

                                if (idx === 0) //name
                                {

                                    if ($(this).html() == result[index].Name) {
                                        ignoreRow = false;
                                    }
                                    else {
                                        ignoreRow = true;
                                    }

                                    //console.log('Repeat Name');
                                    //console.log(result[index].Name);
                                    //console.log(ignoreRow);
                                }
         

                                if (!ignoreRow) {
                                    if (idx - 1 == parseInt(day)) {
                                        //console.log('Checking Status');
                                        //console.log(result[index].isNonCompliant);
                                        if (result[index].isNonCompliant == '1') {
                                            //clear
                                            $(this).html('');
                                            $(this).html('&nbsp;<a href="#" id="myid3" onclick="javascript:GetNCDetails(&quot;' + result[index].NCDetailsID + '&quot;);"> <img src=' + imgpathR + ' width="16" height="16"> </a>');  //NC
                                        }
                                        else {
                                            //clear
                                            $(this).html('');
                                            $(this).html('&nbsp;<a href="#"  id= "' + result[index].NCDetailsID + '"> <img src=' + imgpathG + ' width="16" height="16"> </a>');  //NA
                                            console.log('Checking Status2');
                                            console.log(idx);
                                        }
                                    }
                                }

                                tdnum++;

                            });

                        }
                        else if (crewid !== previouscrewid) {
                            trnew = $(trLast).clone();
                            console.log('here in not equal');
                            previouscrewid = crewid;
                            $(trnew).attr('id', crewid);
                            //clear row
                            ///////////////////////////////////////////////////
                            var rowcounter = 0;
                            var columncounter = 0;

                            // = 0;
                            $(trnew).children('td').each(function () {

                                $(this).html('');
                            });
                            //tdnum = 0;

                            $(trnew).children('td').each(function (idx, itm) {  //map data in row n, where n > 1
                                if (idx == 0) //name
                                {
                                    //debugger;
                                    // $(this).html(result.BookedHours[index].LastName + ' ' + result.BookedHours[index].FirstName);             
                                    //clear
                                    $(this).html('');
                                    $(this).html(result[index].Name);
                                    console.log('here');
                                    console.log(result[index].Name);
                                    //tdnum++;
                                }
                                else if (idx == 1) //name
                                {
                                    //debugger;
                                    // $(this).html(result.BookedHours[index].LastName + ' ' + result.BookedHours[index].FirstName);             
                                    //clear
                                    $(this).html('');
                                    $(this).html(result[index].RegimeName);
                                    //console.log('here');
                                    //console.log(result[index].Name);
                                    //tdnum++;
                                }
                        
                                else if (idx - 1 == parseInt(day)) {
                                    //console.log('Checking Status');
                                    //console.log(result[index].isNonCompliant);
                                    if (result[index].isNonCompliant == '1') {
                                        //clear
                                        $(this).html('');
                                        $(this).html('&nbsp;<a href="#" id="myid3" onclick="javascript:GetNCDetails(&quot;' + result[index].NCDetailsID + '&quot;);"> <img src=' + imgpathR + ' width="16" height="16"> </a>');  //NC
                                    }
                                    else {
                                        //clear
                                        $(this).html('');

                                        $(this).html('&nbsp;<a href="#" id= "' + result[index].NCDetailsID + '"> <img src=' + imgpathG + ' width="16" height="16"> </a>');   //NA
                                    }
                                }





                                //
                            });

                            tdnum++;
                            $('#schedule >tbody:last-child').append(trnew);
                            //$(trLast).after(trnew);

                        }


                        $('#trclone').attr('id', crewid);
                        var trid = '#' + crewid;
                        console.log(trid);
                        $(trid).children('td').each(function (idx, itm) {  //map data in row 1
                            console.log(idx);
                            if (idx === 33)
                            {
                                $(this).html('');
                                //$(this).html('<i class="fa fa-eye" aria-hidden="true" data-toggle="modal" data-target="#myTestModal"></i>');  // eye btn
                                
                                $(this).html('<i class="fa fa-eye" aria-hidden="true" data-toggle="modal" onclick = "javascript:OpenSubReport(&quot;' + crewid + '&quot;,&quot; ' + monthYear + '&quot;);"></i>');
                            }
                        });
                    }


                });
            }

        }
        ,
        error: function (errormessage) {
            console.log(errormessage.responseText);
        }
    });

    if (statustext2) {
        $('#dvprintForMV').val(htmlstr2);
        var divtoprint = $('#dvprintForMV');

        Popup1ForMV(htmlstr2);
    }
}



function OpenSubReport(crewId, monthYear) 
{
    console.log(crewId);
    console.log(monthYear);
    var url = $('#MonthlyWorkHours').val();
    //$('#myModal').load(url, { crewId: crewId, monthYear: monthYear});
    //$("#myModal").modal('show');
    var redirecturl = url + "?mode=update&crew=" + crewId + "&monthYear=" + monthYear;
    console.log(redirecturl);
    window.location.href = redirecturl;
}



function ClearTable() {

    var rowcounter = 0;
    var columncounter = 0;
    $('#schedule > tbody > tr').each(function () {

        var row = $(this);

        if (rowcounter >= 1) {
            columncounter = 0;
            $(row).children('td').each(function () {

                if (columncounter >= 1) {
                    $(this).html('');
                }

                columncounter++;

            });
        }

        rowcounter++;
    });

    //$('#btnUpdate').hide();
    //$('#btnAdd').show();
}



function GetHours(crewId, monthYear) {

    //alert($('textarea#Comments').val());

    var posturl = $('#Showreport').val();
    var rowurl = $('#GetMinusOneDayAdjustmentValue').val();
    var GetWorkingHours = $('#GetWorkingHours').val();
    var totalNormal = 0;
    var totalOvertime = 0;
    var total = 0;
    var totalRest = 0;
    var clonero = '';

    ClearTable();

    //create extra row for -1D
    $.ajax({
        url: rowurl,
        data: JSON.stringify({ monthyear: monthYear, crewID: crewId }),
        type: "POST",
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        async: 'false',
        success: function (result) {
            if (result != null) {

                console.log('In Minus One');
                console.log(result.BookedHours);
                console.log(result.BookedHours.length);
                clonero = $('#1').clone();
                for (var i = 0; i < result.BookedHours.length; i++) {
                    var r = result.BookedHours[i].MinusAdjustmentDate;
                    var nofilltr = clonero;
                    $(nofilltr).attr('id', r + '_dup');
                    var tdcount = 0;
                    $(nofilltr).children('td').each(function () {


                        if (tdcount == 0) {
                            $(this).html('0' + r);
                        }
                        tdcount++;

                        if (tdcount > 0) return false;

                    });

                    $('#schedule > tbody > tr:nth-child(' + r + ')').after(nofilltr);

                    console.log(nofilltr);

                }
            }
        }

    });


    var Reports = {
        CrewID: crewId,
        SelectedMonthYear: monthYear,

    };

    $.ajax({
        url: posturl,
        data: JSON.stringify(Reports),
        type: "POST",
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        async: 'false',
        //success: function (result) {

        //},
        success: function (result) {

            //debugger;
            //alert(result[0].Hours);

            $('#nm').text(result.BookedHours[0].LastName + ' ,' + result.BookedHours[0].FirstName);
            $('#rn').text(result.BookedHours[0].RankName);
            $('#rn1').text(result.BookedHours[0].RankName);
            // $('#fl').text(@{ shipPoco.FlagOfShip.ToString() });


            $('#yr').text(result.BookedHours[0].Year);
            $('#mn').text(result.BookedHours[0].MonthName);


            $('#sptotalnormalhrs').html(result.BookedHours[0].TotalNormalHours);
            $('#sptotalovertimehrs').html(result.BookedHours[0].TotalOvertimeHours); //
            $('#sptotal').html(result.BookedHours[0].TotalHours);
            $('#sptotalRest').html(result.BookedHours[0].TotalRestHours);

            $('#seamanfooter').text(result.BookedHours[0].LastName + ' ' + result.BookedHours[0].FirstName);



            $.each(result.BookedHours, function (index, item) {
                if (item !== null) {
                    //debugger;
                    //loop in table to find the row corresponding to the date
                    //get tr corresponding to that date 
                    var tr = '#' + item.BookDate;

                    //clone a row for later use


                    var adjustmentfactor = item.AdjustmentFactor;
                    var tdnum = 0;
                    var colcnt = 1;
                    // alert($('#schedule tr #15').val());
                    console.log('In Print Loop');
                    $(tr).children('td').each(function () {
                        // debugger;

                        if (adjustmentfactor == 0 || adjustmentfactor == "+1" || adjustmentfactor == "+30" || adjustmentfactor == "-1D" || adjustmentfactor === "BOOKING_NOT_ALLOWED") {

                            $(tr).attr("filled", "yes");

                            if (tdnum == 0) {
                                var $item = $(this).find('.super');
                                $($item).html(item.RegimeSymbol);
                            }

                            if (tdnum <= 1) tdnum++; //skipping first two tds

                            else if (tdnum > 1 && tdnum < 26) {
                                //debugger;

                                var hr = item.Hours.substring(colcnt - 1, colcnt);
                                //console.log(item.Hours.length);

                                colcnt++;
                                tdnum++;
                                if (hr == "1") {
                                    $(this).html('<h4>&#9673;</h4>');
                                }
                                else if (hr == "3") //01
                                {
                                    $(this).html('<h4>&#9681;</h4>');
                                }
                                else if (hr == "4") //10
                                {
                                    $(this).html('<h4>&#9680;</h4>');
                                }

                            }
                            else if (tdnum == 26) //normal col
                            {
                                //debugger;

                                $(this).html(item.NormalWorkingHours);

                                tdnum++;
                            }
                            else if (tdnum == 27) { //overtime


                                $(this).html(item.OvertimeHours);

                                tdnum++;
                            }
                            else if (tdnum == 28) { //total 
                                $(this).html(item.TotalWorkedHours);

                                tdnum++;
                            }
                            else if (tdnum == 29) { //rest 
                                $(this).html(item.MinTwentyFourHourrest);

                                tdnum++;
                            }
                            else if (tdnum == 30) { //comments 
                                $(this).html(item.Comment);
                                tdnum++;
                            }
                            else if (tdnum == 31) { //min rest in 24  
                                $(this).html(item.MaxRestPeriodInTwentyFourHours);
                                tdnum++;
                            }
                            else if (tdnum == 32) { //min rest in 7  
                                $(this).html(item.MinSevenDayRest);
                                tdnum++;
                            }
                            //else if (tdnum == 33) { // text area
                            //    $(this).html('<textarea id="Comments_' + item.BookDate.toString() + '" rows="4" cols="50">' + item.Comments + '</textarea>');
                            //    tdnum++;
                            //}
                            //else if (tdnum == 34) //checkbox
                            //{
                            //    if (item.IsApproved) {
                            //        $(this).html('<input checked=checked type="checkbox" id="Approved_' + item.BookDate.toString() + '"/>');
                            //        tdnum++;
                            //    }
                            //    else {
                            //        $(this).html('<input type="checkbox" id="Approved_' + item.BookDate.toString() + '"/>');
                            //        tdnum++;

                            //    }


                            //}
                        }
                        else if (adjustmentfactor == "-1") {
                            $(tr).attr("filled", "yes");

                            if (item.HasOneFirst == false) {
                                if (tdnum <= 1) tdnum++

                                else if (tdnum > 1 && tdnum < 26) {
                                    //debugger;

                                    var hr = item.Hours.substring(colcnt - 1, colcnt);
                                    //console.log(hr);

                                    colcnt++;
                                    tdnum++;
                                    if (hr == "1") {
                                        $(this).html('<h4>&#9673;</h4>');
                                    }
                                    else if (hr == "3") //01
                                    {
                                        $(this).html('<h4>&#9681;</h4>');
                                    }
                                    else if (hr == "4") //10
                                    {
                                        $(this).html('<h4>&#9680;</h4>');
                                    }

                                }
                                else if (tdnum == 26) //normal col
                                {
                                    //debugger;
                                    $(this).html(item.NormalWorkingHours);

                                    tdnum++;
                                }
                                else if (tdnum == 27) { //overtime
                                    $(this).html(item.OvertimeHours);

                                    tdnum++;
                                }
                                else if (tdnum == 28) { //total 
                                    $(this).html(item.TotalWorkedHours);

                                    tdnum++;
                                }
                                else if (tdnum == 29) { //rest 
                                    $(this).html(item.MinTwentyFourHourrest);

                                    tdnum++;
                                }
                                else if (tdnum == 30) { //comments 
                                    $(this).html(item.Comment);
                                    tdnum++;
                                }
                                else if (tdnum == 31) { //min rest in 24  
                                    $(this).html(item.MaxRestPeriodInTwentyFourHours);
                                    tdnum++;
                                }
                                else if (tdnum == 32) { //min rest in 7  
                                    $(this).html(item.MinSevenDayRest);
                                    tdnum++;
                                }
                                //else if (tdnum == 33) { // text area
                                //    $(this).html('<textarea id="Comments_' + item.BookDate.toString() + '" rows="4" cols="50">' + item.Comments + '</textarea>');
                                //    tdnum++;
                                //}
                                //else if (tdnum == 34) //checkbox
                                //{
                                //    if (item.IsApproved) {
                                //        $(this).html('<input checked=checked type="checkbox" id="Approved_' + item.BookDate.toString() + '"/>');
                                //        tdnum++;
                                //    }
                                //    else {
                                //        $(this).html('<input type="checkbox" id="Approved_' + item.BookDate.toString() + '"/>');
                                //        tdnum++;

                                //    }


                                //}
                            }
                            else {
                                //set to false so that only the first time is decreased by 1 hr
                                //item.HasOneFirst = false;
                                if (tdnum == 1) {
                                    console.log('in here');
                                    $(this).html('<h4>&#9673;</h4>');
                                }


                                if (tdnum <= 1) tdnum++;

                                else if (tdnum > 1 && tdnum < 26) {
                                    //debugger;

                                    var hr = item.Hours.substring(colcnt - 1, colcnt);
                                    //console.log(hr);

                                    colcnt++;
                                    tdnum++;
                                    if (hr == "1") {
                                        $(this).html('<h4>&#9673;</h4>');
                                    }
                                    else if (hr == "3") //01
                                    {
                                        $(this).html('<h4>&#9681;</h4>');
                                    }
                                    else if (hr == "4") //10
                                    {
                                        $(this).html('<h4>&#9680;</h4>');
                                    }

                                }
                                else if (tdnum == 26) //normal col
                                {
                                    //debugger;
                                    $(this).html(item.NormalWorkingHours);

                                    tdnum++;
                                }
                                else if (tdnum == 27) { //overtime
                                    $(this).html(item.OvertimeHours);

                                    tdnum++;
                                }
                                else if (tdnum == 28) { //total 
                                    $(this).html(item.TotalWorkedHours);

                                    tdnum++;
                                }
                                else if (tdnum == 29) { //rest 
                                    $(this).html(item.MinTwentyFourHourrest);

                                    tdnum++;
                                }
                                else if (tdnum == 30) { //comments 
                                    $(this).html(item.Comment);
                                    tdnum++;
                                }
                                else if (tdnum == 31) { //min rest in 24  
                                    $(this).html(item.MaxRestPeriodInTwentyFourHours);
                                    tdnum++;
                                }
                                else if (tdnum == 32) { //min rest in 7  
                                    $(this).html(item.MinSevenDayRest);
                                    tdnum++;
                                }
                                //else if (tdnum == 33) { // text area
                                //    $(this).html('<textarea id="Comments_' + item.BookDate.toString() + '" rows="4" cols="50">' + item.Comments + '</textarea>');
                                //    tdnum++;
                                //}
                                //else if (tdnum == 34) //checkbox
                                //{
                                //    if (item.IsApproved) {
                                //        $(this).html('<input checked=checked type="checkbox" id="Approved_' + item.BookDate.toString() + '"/>');
                                //        tdnum++;
                                //    }
                                //    else {
                                //        $(this).html('<input type="checkbox" id="Approved_' + item.BookDate.toString() + '"/>');
                                //        tdnum++;

                                //    }


                                //}
                            }


                        }
                        else if (adjustmentfactor == "-30") {
                            $(tr).attr("filled", "yes");
                            if (item.HasThirtyFirst == false) {
                                if (tdnum <= 1) tdnum++

                                else if (tdnum >= 1 && tdnum < 26) {
                                    //debugger;

                                    var hr = item.Hours.substring(colcnt - 1, colcnt);
                                    //console.log(hr);

                                    colcnt++;
                                    tdnum++;
                                    if (hr == "1") {
                                        $(this).html('<h4>&#9673;</h4>');
                                    }
                                    else if (hr == "3") //01
                                    {
                                        $(this).html('<h4>&#9681;</h4>');
                                    }
                                    else if (hr == "4") //10
                                    {
                                        $(this).html('<h4>&#9680;</h4>');
                                    }

                                }
                                else if (tdnum == 26) //normal col
                                {
                                    //debugger;
                                    $(this).html(item.NormalWorkingHours);

                                    tdnum++;
                                }
                                else if (tdnum == 27) { //overtime
                                    $(this).html(item.OvertimeHours);

                                    tdnum++;
                                }
                                else if (tdnum == 28) { //total 
                                    $(this).html(item.TotalWorkedHours);

                                    tdnum++;
                                }
                                else if (tdnum == 29) { //rest 
                                    $(this).html(item.MinTwentyFourHourrest);

                                    tdnum++;
                                }
                                else if (tdnum == 30) { //comments 
                                    $(this).html(item.Comment);
                                    tdnum++;
                                }
                                else if (tdnum == 31) { //min rest in 24  
                                    $(this).html(item.MaxRestPeriodInTwentyFourHours);
                                    tdnum++;
                                }
                                else if (tdnum == 32) { //min rest in 7  
                                    $(this).html(item.MinSevenDayRest);
                                    tdnum++;
                                }
                                //else if (tdnum == 33) { // text area
                                //    $(this).html('<textarea id="Comments_' + item.BookDate.toString() + '" rows="4" cols="50">' + item.Comments + '</textarea>');
                                //    tdnum++;
                                //}
                                //else if (tdnum == 34) //checkbox
                                //{
                                //    if (item.IsApproved) {
                                //        $(this).html('<input checked=checked type="checkbox" id="Approved_' + item.BookDate.toString() + '"/>');
                                //        tdnum++;
                                //    }
                                //    else {
                                //        $(this).html('<input type="checkbox" id="Approved_' + item.BookDate.toString() + '"/>');
                                //        tdnum++;

                                //    }


                                //}
                            }
                            else {

                                $(tr).attr("filled", "yes");

                                console.log('in -30 else');
                                console.log(tdnum);
                                if (tdnum == 1) {
                                    console.log('in here');
                                    $(this).html('<h4>&#9681;</h4>');
                                }

                                if (tdnum <= 1) tdnum++;

                                else if (tdnum > 1 && tdnum < 26) {
                                    //debugger;

                                    var hr = item.Hours.substring(colcnt - 1, colcnt);
                                    //console.log(hr);

                                    colcnt++;
                                    tdnum++;
                                    if (hr == "1") {
                                        $(this).html('<h4>&#9673;</h4>');
                                    }
                                    else if (hr == "3") //01
                                    {
                                        $(this).html('<h4>&#9681;</h4>');
                                    }
                                    else if (hr == "4") //10
                                    {
                                        $(this).html('<h4>&#9680;</h4>');
                                    }

                                }
                                else if (tdnum == 26) //normal col
                                {
                                    //debugger;
                                    $(this).html(item.NormalWorkingHours);

                                    tdnum++;
                                }
                                else if (tdnum == 27) { //overtime
                                    $(this).html(item.OvertimeHours);

                                    tdnum++;
                                }
                                else if (tdnum == 28) { //total 
                                    $(this).html(item.TotalWorkedHours);

                                    tdnum++;
                                }
                                else if (tdnum == 29) { //rest 
                                    $(this).html(item.MinTwentyFourHourrest);

                                    tdnum++;
                                }
                                else if (tdnum == 30) { //comments 
                                    $(this).html(item.Comment);
                                    tdnum++;
                                }
                                else if (tdnum == 31) { //min rest in 24  
                                    $(this).html(item.MaxRestPeriodInTwentyFourHours);
                                    tdnum++;
                                }
                                else if (tdnum == 32) { //min rest in 7  
                                    $(this).html(item.MinSevenDayRest);
                                    tdnum++;
                                }
                                //else if (tdnum == 33) { // text area
                                //    $(this).html('<textarea id="Comments_' + item.BookDate.toString() + '" rows="4" cols="50">' + item.Comments + '</textarea>');
                                //    tdnum++;
                                //}
                                //else if (tdnum == 34) //checkbox
                                //{
                                //    if (item.IsApproved) {
                                //        $(this).html('<input checked=checked type="checkbox" id="Approved_' + item.BookDate.toString() + '"/>');
                                //        tdnum++;
                                //    }
                                //    else {
                                //        $(this).html('<input type="checkbox" id="Approved_' + item.BookDate.toString() + '"/>');
                                //        tdnum++;

                                //    }


                                //}
                            }
                        }
                        else if (adjustmentfactor == "-11D") {

                            //check if filled value is true 
                            console.log('Check Value');
                            var f = $(tr).attr("filled");
                            console.log(f);
                            console.log(tdnum);


                            if (f == "no") {



                                if (tdnum <= 1) tdnum++; //skipping first two tds

                                else if (tdnum > 1 && tdnum < 26) {
                                    //debugger;

                                    var hr = item.Hours.substring(colcnt - 1, colcnt);
                                    //console.log(item.Hours.length);

                                    colcnt++;
                                    tdnum++;
                                    if (hr == "1") {
                                        $(this).html('&#9673;');
                                    }
                                    else if (hr == "3") //01
                                    {
                                        $(this).html('&#9681;');
                                    }
                                    else if (hr == "4") //10
                                    {
                                        $(this).html('&#9680;');
                                    }

                                }
                                else if (tdnum == 26) //normal col
                                {
                                    //debugger;
                                    $(this).html(item.NormalWorkingHours);

                                    tdnum++;
                                }
                                else if (tdnum == 27) { //overtime
                                    $(this).html(item.OvertimeHours);

                                    tdnum++;
                                }
                                else if (tdnum == 28) { //total 
                                    $(this).html(item.TotalWorkedHours);

                                    tdnum++;
                                }
                                else if (tdnum == 29) { //rest 
                                    $(this).html(item.MinTwentyFourHourrest);

                                    tdnum++;
                                }
                                else if (tdnum == 30) { //comments 
                                    $(this).html(item.Comment);
                                    tdnum++;
                                }
                                else if (tdnum == 31) { //min rest in 24  
                                    $(this).html(item.MaxRestPeriodInTwentyFourHours);
                                    tdnum++;
                                }
                                else if (tdnum == 32) { //min rest in 7  
                                    $(this).html(item.MinSevenDayRest);
                                    console.log('Setting first to yes');
                                    $(tr).attr("filled", "yes");
                                    tdnum++;
                                }
                                //else if (tdnum == 33) { // text area
                                //    $(this).html('<textarea id="Comments_' + item.BookDate.toString() + '" rows="4" cols="50">' + item.Comments + '</textarea>');
                                //    tdnum++;
                                //}
                                //else if (tdnum == 34) //checkbox
                                //{
                                //    if (item.IsApproved) {
                                //        $(this).html('<input checked=checked type="checkbox" id="Approved_' + item.BookDate.toString() + '"/>');
                                //        tdnum++;
                                //    }
                                //    else {
                                //        $(this).html('<input type="checkbox" id="Approved_' + item.BookDate.toString() + '"/>');
                                //        tdnum++;

                                //    }


                                //}

                            }
                            else if (f == "yes") {

                                //get closest tr with filled=no tag
                                //console.log('No Row');
                                //var nofilltr = clonero;
                                //$(nofilltr).attr('id', item.BookDate);
                                //var tdcount = 0;
                                //$(nofilltr).children('td').each(function () {


                                //        if (tdcount == 0) {
                                //            $(this).html('0' + item.BookDate);
                                //    }
                                //        tdcount++;

                                //        if (tdcount > 0) return false;

                                //});

                                //$('#schedule > tbody > tr:nth-child(' + item.BookDate + ')').after(nofilltr);



                                //console.log(nofilltr);
                                //create a new row


                            }
                        } //end -1d


                    });


                }

            });
            //}


            //clearTextBox();
        }
        ,
        error: function (errormessage) {
            console.log(errormessage.responseText);
        }
    });

    //debugger;
    //setRowValue('schedule', 'totals', 28, totalNormal);
    //alert(totalNormal);
    //setTimeout("console.log(totalNormal);", 5000);

}




//=============================================================================================================
var pageName = '';

function GetWellBeingHealtaTableData() {
    var loadposturl = $('#loadWellBeingHealthdata').val();
    $.ajax({
        url: loadposturl,
        type: "GET",
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        success: function (result) {


            console.log(result);
            $('#spinnerLoad').hide();
            
            SetUpWellBeingHealthGrid(result.data.WellBeingHealthList);
        },
        error: function (errormessage) {
            console.log(errormessage.responseText);
        }
    });
}

function SetUpWellBeingHealthGrid(jsondata) {

    //do not throw error
    $.fn.dataTable.ext.errMode = 'none';

    //check if datatable is already created then destroy iy and then create it
    if ($.fn.dataTable.isDataTable('#tblWellBeingHealth')) {
        table = $('#tblWellBeingHealth').DataTable();
        table.destroy();
    }

    $("#tblWellBeingHealth").DataTable({
        "processing": true, // for show progress bar
        //"serverSide": true, // for process server side
        "filter": false, // this is for disable filter (search box)
        "orderMulti": false, // for disable multiple column at once
        "bLengthChange": false, //disable entries dropdown
        "stateSave": true,
        data: jsondata,
        //"ajax": {
        //    "url": loadposturl,
        //    "type": "POST",
        //    "datatype": "json"
        //},
        "columns": [
            {
                "data": "CrewName", "name": "CrewName", "autoWidth": true
            },
            {
                //"data": "IsLocusTested", "name": "IsLocusTested", "autoWidth": true
                "data": "IsJoiningMedical", "width": "50px", "render": function (data, type, row) {
                    if (data == true) {
                        return '<div class="align-center"><i class="fa fa-eye" style="color:#4ff339" aria-hidden="true"  onclick="ShowJoiningMedicalFile(' + row.CrewId +')"></i></div>';
                    }
                    else if (data == false) {
                        //return '<a style="border-radius: 5px;"><img src="/images/R.png" width="16" height="16"></a>';
                        return '<div class="align-center"><i class="fa fa-eye disabled" aria-hidden="true"></i></div>';
                    }
                }
            },
            {
                //"data": "IsMassTested", "name": "IsMassTested", "autoWidth": true
                "data": "IsMonthlyMedicalData", "width": "50px", "render": function (data, type, row) {
                    if (data == true) {
                        return '<div class="align-center"><i class="fa fa-eye" aria-hidden="true"></i></div>';
                    }
                    else if (data == false) {
                        //return '<a style="border-radius: 5px;"><img src="/images/R.png" width="16" height="16"></a>';
                        return '<div class="align-center"><i class="fa fa-eye disabled" aria-hidden="true"></i></div>';
                    }
                }
            },
            {
                //"data": "IsPSQ30Tested", "name": "IsPSQ30Tested", "autoWidth": true
                "data": "IsPrescriptionMedicine", "width": "50px", "render": function (data, type, row) {
                    if (data == true) {
                        return '<div class="align-center"><i class="fa fa-eye" aria-hidden="true"></i></div>';
                    }
                    else if (data == false) {
                        //return '<a style="border-radius: 5px;"><img src="/images/R.png" width="16" height="16"></a>';
                        return '<div class="align-center"><i class="fa fa-eye disabled" aria-hidden="true"></i></div>';
                    }
                }
            },
            {
                //"data": "IsBeckTested", "name": "IsBeckTested", "autoWidth": true
                "data": "IsMedicalAdvise", "width": "50px", "render": function (data, type, row) {
                    if (data == true) {
                        //return '<a style="border-radius: 5px;"><img src="/images/G.png" width="16" height="16"></a>';
                        console.log(row.CrewId);
                        return '<div class="align-center"><a><i class="fa fa-eye " style="color:#4ff339" aria-hidden="true" onclick="ShowMedicalAdviseDetailsModal(' + row.CrewId +')"></i></a></div>';
                    }
                    else if (data == false) {
                        //return '<a style="border-radius: 5px;"><img src="/images/R.png" width="16" height="16"></a>';
                        return '<div class="align-center"><i class="fa fa-eye disabled" aria-hidden="true"></i></div>';
                    }
                }
            },
            {
                //"data": "IsZ1Tested", "name": "IsZ1Tested", "autoWidth": true
                "data": "IsMedicinePrescribed", "width": "50px", "render": function (data, type, row) {
                    if (data == true) {
                        return '<div class="align-center"><i class="fa fa-eye" aria-hidden="true"></i></div>';
                    }
                    else if (data == false) {
                        //return '<a style="border-radius: 5px;"><img src="/images/R.png" width="16" height="16"></a>';
                        return '<div class="align-center"><i class="fa fa-eye disabled" aria-hidden="true"></i></div>';
                    }
                }
            },
            {
                //"data": "IsZ2Tested", "name": "IsZ2Tested", "autoWidth": true
                "data": "IsOthers", "width": "50px", "render": function (data, type, row) {
                    if (data == true) {
                        //return '<a style="border-radius: 5px;"><img src="/images/G.png" width="16" height="16"></a>';
                        return '<div class="align-center"><i class="fa fa-eye" aria-hidden="true"></i></div>';
                    }
                    else if (data == false) {
                        //return '<a style="border-radius: 5px;"><img src="/images/R.png" width="16" height="16"></a>';
                        return '<div class="align-center"><i class="fa fa-eye disabled" aria-hidden="true"></i></div>';
                    }
                }
            }
        ],
        "rowId": "CrewId",
        "dom": "Bfrtip"

    });
}

function ShowMedicalAdviseDetailsModal(crewId) {
    //$("#viewAdviseDetailsModal").show();
    //$('#viewAdviseDetailsModal').modal('show');
    var medicalAdvise = {
        //TestDate: date,
        Id: crewId
    };

    $.ajax({
        url: '/WellBeing/GetMedicalAdvise',
        data: JSON.stringify({ crewId: crewId }),
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
            $('#Age').val(ConvertJsonDateString(result.DOB));
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


function ShowJoiningMedicalFile(crewId) {

    $('#pdfContent').html("");
    $('#pdfContent').html('<embed id="embedPDF" src="" width="100%" height="600px;" />');

    $('#hHeader').html("");
    $('#embedPDF').removeAttr("src");
    //var x = decodeURI(path);

    //#region Show Modal
    //$('#hHeader').html(planName);
    //$('#embedPDF').attr('src', path);

    //$('#viewJoiningMedialModal').modal('show');
    //#endregion

    //#region


    $.ajax({
        url: "/WellBeing/GetJoiningMedicalData",
        //data: JSON.stringify({ crewId: crewId }),
        data: { crewId: crewId },
        type: "GET",
        contentType: "application/json;charset=UTF-8",
        dataType: "json",
        success: function (result) {

            $('#hHeader').html(result.JoiningMedicalFileName);
            $('#embedPDF').attr('src', result.JoiningMedicalFile);

            $('#viewJoiningMedialModal').modal('show');

        },
        error: function (errormessage) {
            //debugger;
            console.log(errormessage.responseText);
        }
    });

    //#endregion

}

