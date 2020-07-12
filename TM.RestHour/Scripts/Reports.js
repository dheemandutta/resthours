function ProcessData()
{
    DisableRow();
    GetHours();
}

function GetHours() {

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
        data: JSON.stringify({ monthyear: $('.monthYearPicker').val(), crewID: $('#ddlCrew').val()}),
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
        CrewID: $('#ddlCrew').val(),
        SelectedMonthYear: $('.monthYearPicker').val(),

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
                                else if (tdnum == 33) { // text area
                                    $(this).html('<textarea id="Comments_' + item.BookDate.toString() + '" rows="4" cols="50">' + item.Comments + '</textarea>');
                                    tdnum++;
                                }
                                else if (tdnum == 34) //checkbox
                                {
                                    if (item.IsApproved) {
                                        $(this).html('<input checked=checked type="checkbox" id="Approved_' + item.BookDate.toString() + '"/>');
                                        tdnum++;
                                    }
                                    else {
                                        $(this).html('<input type="checkbox" id="Approved_' + item.BookDate.toString() + '"/>');
                                        tdnum++;

                                    }


                                }
                            }
                            else if (adjustmentfactor == "-1")
                            {
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
                                    else if (tdnum == 33) { // text area
                                        $(this).html('<textarea id="Comments_' + item.BookDate.toString() + '" rows="4" cols="50">' + item.Comments + '</textarea>');
                                        tdnum++;
                                    }
                                    else if (tdnum == 34) //checkbox
                                    {
                                        if (item.IsApproved) {
                                            $(this).html('<input checked=checked type="checkbox" id="Approved_' + item.BookDate.toString() + '"/>');
                                            tdnum++;
                                        }
                                        else {
                                            $(this).html('<input type="checkbox" id="Approved_' + item.BookDate.toString() + '"/>');
                                            tdnum++;

                                        }


                                    }
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
                                    else if (tdnum == 33) { // text area
                                        $(this).html('<textarea id="Comments_' + item.BookDate.toString() + '" rows="4" cols="50">' + item.Comments + '</textarea>');
                                        tdnum++;
                                    }
                                    else if (tdnum == 34) //checkbox
                                    {
                                        if (item.IsApproved) {
                                            $(this).html('<input checked=checked type="checkbox" id="Approved_' + item.BookDate.toString() + '"/>');
                                            tdnum++;
                                        }
                                        else {
                                            $(this).html('<input type="checkbox" id="Approved_' + item.BookDate.toString() + '"/>');
                                            tdnum++;

                                        }


                                    }
                                }


                            }
                            else if (adjustmentfactor == "-30")
                            {
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
                                    else if (tdnum == 33) { // text area
                                        $(this).html('<textarea id="Comments_' + item.BookDate.toString() + '" rows="4" cols="50">' + item.Comments + '</textarea>');
                                        tdnum++;
                                    }
                                    else if (tdnum == 34) //checkbox
                                    {
                                        if (item.IsApproved) {
                                            $(this).html('<input checked=checked type="checkbox" id="Approved_' + item.BookDate.toString() + '"/>');
                                            tdnum++;
                                        }
                                        else {
                                            $(this).html('<input type="checkbox" id="Approved_' + item.BookDate.toString() + '"/>');
                                            tdnum++;

                                        }


                                    }
                                }
                                else
                                {

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
                                    else if (tdnum == 33) { // text area
                                        $(this).html('<textarea id="Comments_' + item.BookDate.toString() + '" rows="4" cols="50">' + item.Comments + '</textarea>');
                                        tdnum++;
                                    }
                                    else if (tdnum == 34) //checkbox
                                    {
                                        if (item.IsApproved) {
                                            $(this).html('<input checked=checked type="checkbox" id="Approved_' + item.BookDate.toString() + '"/>');
                                            tdnum++;
                                        }
                                        else {
                                            $(this).html('<input type="checkbox" id="Approved_' + item.BookDate.toString() + '"/>');
                                            tdnum++;

                                        }


                                    }
                                }
                            }
                            else if (adjustmentfactor == "-11D") {

                                //check if filled value is true 
                                console.log('Check Value');
                                var f = $(tr).attr("filled");
                                console.log(f);
                                console.log(tdnum);
                                

                                if (f == "no")
                                {

                                    
                                
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
                                else if (tdnum == 33) { // text area
                                    $(this).html('<textarea id="Comments_' + item.BookDate.toString() + '" rows="4" cols="50">' + item.Comments + '</textarea>');
                                    tdnum++;
                                }
                                else if (tdnum == 34) //checkbox
                                {
                                    if (item.IsApproved) {
                                        $(this).html('<input checked=checked type="checkbox" id="Approved_' + item.BookDate.toString() + '"/>');
                                        tdnum++;
                                    }
                                    else {
                                        $(this).html('<input type="checkbox" id="Approved_' + item.BookDate.toString() + '"/>');
                                        tdnum++;

                                    }


                                }

                                }
                                else if (f == "yes")
                                {

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

function GetHoursForPdf() {

    //alert($('textarea#Comments').val());

    var posturl = $('#Showreport').val();
    var GetWorkingHours = $('#GetWorkingHours').val();
    var totalNormal = 0;
    var totalOvertime = 0;
    var total = 0;
    var totalRest = 0;

    var Reports2 = {
        CrewID: $('#ddlCrew').val(),
        SelectedMonthYear: $('.monthYearPicker').val(),

    };

    $.ajax({
        url: posturl,
        data: JSON.stringify(Reports2),
        type: "POST",
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        async: 'false',
        //success: function (result) {

        //},
        success: function (result) {

            //debugger;
            //alert(result[0].Hours);

            $('#nm2').text(result.BookedHours[0].LastName + ' ,' + result.BookedHours[0].FirstName);
            $('#rn2').text(result.BookedHours[0].RankName);
            $('#yr2').text(result.BookedHours[0].Year);
            $('#mn2').text(result.BookedHours[0].MonthName);

            $('#sptotalnormalhrs2').text(result.BookedHours[0].TotalNormalHours);
            $('#sptotalovertimehrs2').text(result.BookedHours[0].TotalOvertimeHours);
            $('#sptotal2').text(result.BookedHours[0].TotalHours);
            $('#sptotalRest2').text(result.BookedHours[0].TotalRestHours);

            $('#seamanfooter2').text(result.BookedHours[0].LastName + ' ' + result.BookedHours[0].FirstName);


            $.each(result.BookedHours, function (index, item) {
                if (item != null) {
                    //debugger;
                    //loop in table to find the row corresponding to the date
                    //get tr corresponding to that date 
                    var tr = '#' + item.BookDate + '_' ;
                    //var tr = $('#15');
                    var tdnum = 0;
                    // alert($('#schedule tr #15').val());
                    $(tr).children('td').each(function () {
                        // debugger;
                        if (tdnum == 0) tdnum++
                        else if (tdnum > 0 && tdnum < 25) {
                            //debugger;
                            var hr = item.Hours.substring(tdnum - 1, tdnum);
                            tdnum++;
                            if (hr == "1") {
                                //$(this).html('&#9724;');
                               // $(this).html(unescapeHtml('&lt;div style=&quot;border: 2px solid #000;width:20px; height:14px;background: #000;margin: 4px; &quot;&gt;&lt;div style=&quot;border: 2px solid #000;width:9px; height:10px;background:#fff;&quot;&gt;&lt;/div&gt;&lt;/div&gt;'));//&#9724;
                                $(this).html(unescapeHtml('&lt;div style=&quot;width:18px;height:8px;border:1px solid #000; margin-top:8px; background:#000;margin-left:2px;&quot;&gt;&lt;/div&gt;'));//&#9724;

                            }
                            else if (hr == "3") //01
                            {
                               // $(this).html(unescapeHtml('&lt;div style=&quot;border: 4px solid #000;width:16px; height:10px;background: #fff;margin: 4px; &quot;&gt;&lt;div style=&quot;border: 2px solid #000;width:3px; height:7px;background:#000;&quot;&gt;&lt;/div&gt;&lt;/div&gt;'));//&#9703;
                                $(this).html(unescapeHtml('&lt;div style=&quot;width:9px;height:8px;border:1px solid #000; background:#000; float:left; margin-top:8px; margin-left:2px;&quot;&gt;&lt;/div&gt; &lt;div style=&quot;width:9px;height:8px; float:right; margin-top:8px;border:1px solid #000; background:#fff; margin-right:4px;&quot;&gt;&lt;/div&gt;'));//&#9724;
                            }
                            else if (hr == "4") //10
                            {
                                //$(this).html(unescapeHtml('&lt;div style=&quot;border: 2px solid #000;width:20px; height:14px;background: #000;margin: 4px; &quot;&gt;&lt;div style=&quot;border: 2px solid #000;width:9px; height:10px;background:#fff;&quot;&gt;&lt;/div&gt;&lt;/div&gt;'));//&#9704;
                                //$(this).html(unescapeHtml('&lt;div style=&quot;border: 4px solid #000;width:16px; height:10px;background: #fff;margin: 4px; &quot;&gt;&lt;div style=&quot;border: 2px solid #000;width:3px; height:7px;background:#000;&quot;&gt;&lt;/div&gt;&lt;/div&gt;'));//&#9703;
                               // $(this).html(unescapeHtml('&lt;div style=&quot;width:9px;height:8px;border:1px solid #000; background:#fff; float:left; margin-top:8px; margin-left:2px;&quot;&gt;&lt;/div&gt; &lt;div style=&quot;width:9px;height:8px; float:right; margin-top:8px;border:1px solid #000; background:#000; margin-right:4px;&quot;&gt;&lt;/div&gt;'));//&#9704;
                            }

                        }
                        else if (tdnum == 25) //normal col
                        {
                            //debugger;
                            $(this).html(item.NormalWorkingHours);

                            tdnum++;
                        }
                        else if (tdnum == 26) { //overtime
                            $(this).html(item.OvertimeHours);

                            tdnum++;
                        }
                        else if (tdnum == 27) { //total 
                            $(this).html(item.TotalWorkedHours);

                            tdnum++;
                        }
                        else if (tdnum == 28) { //rest 
                            $(this).html(item.MinTwentyFourHourrest);

                            tdnum++;
                        }
                        else if (tdnum == 29) { //comments 
                            $(this).html(item.Comment);
                            tdnum++;
                        }
                        else if (tdnum == 30) { //min rest in 24  
                            $(this).html(item.MaxRestPeriodInTwentyFourHours);
                            tdnum++;
                        }
                        else if (tdnum == 31) { //min rest in 7  
                            $(this).html(item.MinSevenDayRest);
                            tdnum++;
                        }

                    });


                }
                //alert(item);
            });

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

function PrintPdf() {

    //get data 
    var posturl = $('#Reportsadd').val();
    var seafarerFullName = '';
    var seafarerRank = '';
    var selectedYear = '';
    var selectedMonth = '';
    var totnormalHours = '0';
    var totOvertimeHours = '0';
    var totHours = '0';
    var totRestHours = '0';
    var monthlyBookedHours = [];
    var data = [];
    var res = [];
    var tsdata = '';
    var day = 0;
    var loopcounter = 0;

    var Reports = {
        CrewID: $('#ddlCrew').val(),
        SelectedMonthYear: $('.monthYearPicker').val(),

    };

    $.ajax({
        url: posturl,
        data: JSON.stringify(Reports),
        type: "POST",
        contentType: "application/json;charset=utf-8",
        dataType: "json",

        success: function (result) {

            seafarerFullName = result.BookedHours[0].LastName + ' ,' + result.BookedHours[0].FirstName;
            seafarerRank = result.BookedHours[0].RankName;
            selectedYear = result.BookedHours[0].Year;
            selectedMonth = result.BookedHours[0].MonthName;

            totnormalHours = result.BookedHours[0].TotalNormalHours;
            totOvertimeHours = result.BookedHours[0].TotalOvertimeHours;
            totHours = result.BookedHours[0].TotalHours;
            totRestHours = result.BookedHours[0].TotalRestHours;
            //generate pdf now /////////////////////////////////////////
            // set column names
            // data.push(['', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''])
            // initialize each row
            for (var i = 1; i <= 31; i++) {


                data.push([
                    {
                        text: '' + i,
                        fillColor: '#f0f0f0'
                    },
                    {
                        text: ''


                    },
                    {
                        text: '',
                        // border: 1
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {

                        text: '',

                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    }
                ]);
            } //end for

            //clear all half-hour borders
            for (var m = 0; m <= 31; m++) {
                for (var n = 0; n < 48; n++) {

                    console.log('m:' + m);

                    if (m > 0) {
                        if ((n + 1) % 2 === 0) {
                            data[m - 1][n + 1] = { text: '', style: 'fillstylewhite', border: [false, true, true, true], };
                        }
                        else {
                            data[m - 1][n + 1] = { text: '', style: 'fillstylewhite', border: [true, true, false, true], };
                        }
                    }

                }
            }

            //loop in data to set hours for each data
            $.each(result.BookedHours, function (index, item) {
                if (item != null) {

                    tsdata = item.Hours;
                    day = item.BookDate;
                    loopcounter = 0;
                    // copy in an array
                    for (var i = 0; i < tsdata.length; i++) {
                        res[i] = tsdata.charAt(i);
                        //loopcounter++;
                    }



                    for (var m = 0; m <= 31; m++) {
                        for (var n = 0; n < 48; n++) {

                            if (m == day) {

                                if (res[n] == '1') //1
                                {


                                    if ((n + 1) % 2 === 0) {
                                        data[m - 1][n + 1] = { text: '', style: 'fillstyle', border: [false, true, true, true], }; //,
                                    }
                                    else {
                                        data[m - 1][n + 1] = { text: '', style: 'fillstyle', border: [true, true, false, true], };
                                    }
                                    data[m - 1][49] = { text: item.NormalWorkingHours };
                                    data[m - 1][50] = { text: item.OvertimeHours }; //overtime
                                    data[m - 1][51] = { text: item.TotalWorkedHours }; //total
                                    data[m - 1][52] = { text: item.MinTwentyFourHourrest }; //rest
                                    data[m - 1][53] = { text: item.Comment }; //Comments
                                    data[m - 1][54] = { text: item.MaxRestPeriodInTwentyFourHours }; //min rest in 24 
                                    data[m - 1][55] = { text: item.MinSevenDayRest }; //min rest in 7 

                                }
                                //else {

                                //    // for 0s 
                                //    if ((n + 1) % 2 === 0) {
                                //        data[m - 1][n + 1] = { text: '', style: 'fillstylewhite', border: [false, true, true, true], };
                                //    }
                                //    else {
                                //        data[m - 1][n + 1] = { text: '', style: 'fillstylewhite', border: [true, true, false, true], };
                                //    }

                                //} // end else



                            }


                        }
                    } // end nested for
                } //end item null if
            }); // end result loop

            var docDefinition = {
                pageSize: 'A3',
                pageOrientation: 'landscape',
                pageMargins: [20, 20, 20, 20],
                content: [
                    {
                        text: [
                            {
                                text: "HOURS OF WORK AND REST ",
                                style: "header"
                            },
                            {
                                text: "                                                                                                                                                                                                                                                                                                                                                             Revision Number : 05 ",
                                style: "anotherStyle"
                            },
                        ]
                    },
                    {
                        text: [
                            {
                                text: "Form Number: ILO Rest",
                                style: "anotherStyle"
                            },
                            {
                                text: "                                                                                                                                                                                                                                                                                                                                                                                         Page Number : 1 of 1 ",
                                style: "anotherStyle"
                            },
                        ]
                    },
                    {
                        text: [
                            {
                                text: "___________________________________________________________________________________________________________________________________________________________________________________________________________",
                                // style: "anotherStyle"
                            }
                        ]
                    },
                    {
                        text: [
                            {
                                text: "Seafarer's Full Name: " + seafarerFullName,
                                style: "anotherStyle"
                            },
                            {
                                text: "                                                                                                                                                 Vessel Name: OSX 2",
                                style: "anotherStyle"
                            },
                            {
                                text: "                                                                                                                                                                           Master: Singh, Amitabh",
                                style: "anotherStyle"
                            },

                        ]
                    },


                    {
                        text: [
                            {
                                text: "Year : " + selectedYear,
                                style: "anotherStyle"
                            },
                            {
                                text: "                      Month: " + selectedMonth,
                                style: "anotherStyle"
                            },
                            {
                                text: "                                                                                                                                           Flag : Liberia",
                                style: "anotherStyle"
                            },

                        ]
                    },

                    {
                        style: "Margin0",
                        table: {
                            widths: [17, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 25, 30, 22, 22, 190, 25, 25,],
                            body: [

                                ['Date', '00', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', 'Normal', 'Overtime', 'Total', 'Rest', 'Comments', 'Minimum Rest in 24 Hours', 'Minimum Rest in 7 days'],
                            ]
                        }
                    },


                    {
                        style: "tblStyle",
                        table: {
                            widths: [17, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 25, 30, 22, 22, 190, 25, 25,],
                            // headerRows: 1,
                            body: data

                        }

                    },



                    {
                        style: "Margin",
                        table: {
                            widths: [407, 25, 30, 22, 22],
                            body: [
                                ['Totals', totnormalHours, totOvertimeHours, totHours, totRestHours],
                                ['Guaranteed Overtime', '', '', '', ''],
                                ['Extra Overtime Payable', '', '', '', ''],
                            ]
                        }
                    },
                    //              {
                    //	style: 'tableExample',
                    //	table: {
                    //		heights: 40,
                    //		body: [
                    //			[  {
                    //	//style: 'tableExample',
                    //		style: 'anotherStyle',
                    //	table: {
                    //		headerRows: 1,
                    //		body: [


                    //			['','', ''],
                    //			['','', 'First 30 mins'],
                    //			['Key :','', 'Last 30 mins'],
                    //			['','', 'Full Hour'],
                    //		]
                    //	},
                    //	layout: 'noBorders'
                    //},]
                    //		]
                    //	}
                    //},
                    {
                        //style: 'tableExample',
                        style: 'anotherStyle',
                        table: {
                            headerRows: 1,
                            body: [

                                ['', '', '', ''],
                                ['', '', '', ''],
                                ['Signature of Seaman:', '________________________________________________________', 'Signature of Master/Person Authorised by the Master:', '________________________________________________________'],
                                ['', seafarerFullName, '', 'Singh, Amitabh'],
                                ['', '', '', ''],
                            ]
                        },
                        layout: 'noBorders'
                    },

                ],
                styles: {
                    header: {
                        fontSize: 12,
                        bold: true
                    },
                    anotherStyle: {
                        fontSize: 9,

                    },
                    tblStyle: {
                        fontSize: 6,

                    },
                    Margin: {

                        fontSize: 4.8,
                        alignment: 'right',
                        margin: [282, 0, 0, 0]
                    },
                    noBorders: {
                        fontSize: 4.8,
                        alignment: 'left',
                        margin: [100, 0, 0, 282]
                    },
                    fillstyle: {
                        fillColor: '#656565'

                    },
                    fillstyle3: {
                        fillColor: '#f0f0f0'
                    },
                    Margin0: {
                        fontSize: 7

                    },
                    tblStyle1: {
                        fontSize: 7

                    },
                    fillstylewhite: {
                        fillColor: '#FFFFFF'
                    }


                }
            }



            pdfMake.createPdf(docDefinition).download('PDF_2.pdf');


            /////////// end pdf generation /////////////////////
        }
        ,
        error: function (errormessage) {
            console.log(errormessage.responseText);
        }
    });










    //alert(data);





    //console.log(data[19][2]);
    //console.log(data[19][5]);
    //console.log(data[19][7]);



}

function MapDataInTable(adjustmentfactor,tdnum,item,tr,thisro,colcnt) {

    if (adjustmentfactor == 0 || adjustmentfactor == "+1" || adjustmentfactor == "+30" || adjustmentfactor == "-1D" || adjustmentfactor == "BOOKING_NOT_ALLOWED") {

        $(tr).attr("filled", "yes");
        //console.log(tdnum);
        if (tdnum == 3) tdnum++; //skipping first two tds

        else if (tdnum > 3 && tdnum < 29)
        {
            //debugger;
//$(thisro).html('E');


            var hr = item.Hours.substring(colcnt - 1, colcnt);
            console.log(colcnt);
            console.log(hr);

            colcnt++;
            tdnum++;
            if (hr == "0") {
                //clear
                $(thisro).html('');
                
            }
            if (hr == "1") {
                //clear
                $(thisro).html('');
                $(thisro).html('<h4>&#9673;</h4>');
            }
            else if (hr == "3") //01
            {
                //clear
                $(thisro).html('');
                $(thisro).html('<h4>&#9681;</h4>');
            }
            else if (hr == "4") //10
            {
                //clear
                $(thisro).html('');
                $(thisro).html('<h4>&#9680;</h4>');
            }

        }
        else if (tdnum == 29) //normal col
        {
            //debugger;
            //clear
            $(thisro).html('');
            $(thisro).html(item.NormalWorkingHours);

            //tdnum++;
        }
        else if (tdnum == 30) { //overtime

            //clear
            $(thisro).html('');
            $(thisro).html(item.OvertimeHours);

            //tdnum++;
        }
        else if (tdnum == 31) { //total 

            //clear
            $(thisro).html('');
            $(thisro).html(item.TotalWorkedHours);

            tdnum++;
        }
        else if (tdnum == 32) { //rest 

            //clear
            $(thisro).html('');
            $(thisro).html(item.MinTwentyFourHourrest);

            //tdnum++;
        }
        else if (tdnum == 33) { //comments 

            //clear
            $(thisro).html('');
            $(thisro).html(item.Comment);
            //tdnum++;
        }
        //else if (tdnum == 31) { //min rest in 24  
        //    $(this).html(item.MaxRestPeriodInTwentyFourHours);
        //    tdnum++;
        //}
        //else if (tdnum == 32) { //min rest in 7  
        //    $(this).html(item.MinSevenDayRest);
        //    tdnum++;
        //}
    }
    else if (adjustmentfactor == "-1") {
        $(tr).attr("filled", "yes");

        if (item.HasOneFirst == false) {
            if (tdnum <= 2) tdnum++;

            else if (tdnum >= 2 && tdnum < 28){
                //debugger;

                var hr = item.Hours.substring(colcnt - 1, colcnt);
                //console.log(hr);

                colcnt++;
                tdnum++;
                if (hr == "1") {

                    //clear
                    $(thisro).html('');
                    $(thisro).html('<h4>&#9673;</h4>');
                }
                else if (hr == "3") //01
                {
                    //clear
                    $(thisro).html('');
                    $(thisro).html('<h4>&#9681;</h4>');
                }
                else if (hr == "4") //10
                {
                    //clear
                    $(thisro).html('');
                    $(thisro).html('<h4>&#9680;</h4>');
                }

            }
            else if (tdnum == 28) //normal col
            {
                //debugger;
                //clear
                $(thisro).html('');
                $(thisro).html(item.NormalWorkingHours);

                //tdnum++;
            }
            else if (tdnum == 29) { //overtime

                //clear
                $(thisro).html('');
                $(thisro).html(item.OvertimeHours);

                //tdnum++;
            }
            else if (tdnum == 30) { //total 

                //clear
                $(thisro).html('');
                $(thisro).html(item.TotalWorkedHours);

                tdnum++;
            }
            else if (tdnum == 31) { //rest 

                //clear
                $(thisro).html('');
                $(thisro).html(item.MinTwentyFourHourrest);

                //tdnum++;
            }
            else if (tdnum == 32) { //comments 

                //clear
                $(thisro).html('');
                $(thisro).html(item.Comment);
                //tdnum++;
            }
        }
        else {
            //set to false so that only the first time is decreased by 1 hr
            //item.HasOneFirst = false;
            if (tdnum == 3) {
                console.log('in here');
                //clear
                $(thisro).html('');
                $(thisro).html('<h4>&#9673;</h4>');
            }


            if (tdnum <= 2) tdnum++;

            else if (tdnum >= 4 && tdnum < 28) {
                //debugger;

                var hr = item.Hours.substring(colcnt - 1, colcnt);
                //console.log(hr);

                colcnt++;
                tdnum++;
                if (hr == "1") {
                    //clear
                    $(thisro).html('');
                    $(thisro).html('<h4>&#9673;</h4>');
                }
                else if (hr == "3") //01
                {
                    //clear
                    $(thisro).html('');
                    $(thisro).html('<h4>&#9681;</h4>');
                }
                else if (hr == "4") //10
                {
                    //clear
                    $(thisro).html('');
                    $(thisro).html('<h4>&#9680;</h4>');
                }

            }
            else if (tdnum == 28) //normal col
            {
                //debugger;
                //clear
                $(thisro).html('');
                $(thisro).html(item.NormalWorkingHours);

                //tdnum++;
            }
            else if (tdnum == 29) { //overtime

                //clear
                $(thisro).html('');
                $(thisro).html(item.OvertimeHours);

                //tdnum++;
            }
            else if (tdnum == 30) { //total 

                //clear
                $(thisro).html('');
                $(thisro).html(item.TotalWorkedHours);

                tdnum++;
            }
            else if (tdnum == 31) { //rest 

                //clear
                $(thisro).html('');
                $(thisro).html(item.MinTwentyFourHourrest);

                //tdnum++;
            }
            else if (tdnum == 32) { //comments 

                //clear
                $(thisro).html('');
                $(thisro).html(item.Comment);
                //tdnum++;
            }
        }


    }
    else if (adjustmentfactor == "-30") {
        $(tr).attr("filled", "yes");
        if (item.HasThirtyFirst == false) {
            if (tdnum <= 2) tdnum++

            else if (tdnum >= 2 && tdnum < 28) {
                //debugger;

                var hr = item.Hours.substring(colcnt - 1, colcnt);
                //console.log(hr);

                colcnt++;
                tdnum++;
                if (hr == "1") {

                    //clear
                    $(thisro).html('');
                    $(thisro).html('<h4>&#9673;</h4>');
                }
                else if (hr == "3") //01
                {
                    //clear
                    $(thisro).html('');
                    $(thisro).html('<h4>&#9681;</h4>');
                }
                else if (hr == "4") //10
                {
                    //clear
                    $(thisro).html('');
                    $(thisro).html('<h4>&#9680;</h4>');
                }

            }
            else if (tdnum == 28) //normal col
            {
                //debugger;
                //clear
                $(thisro).html('');
                $(thisro).html(item.NormalWorkingHours);

                //tdnum++;
            }
            else if (tdnum == 29) { //overtime

                //clear
                $(thisro).html('');
                $(thisro).html(item.OvertimeHours);

                //tdnum++;
            }
            else if (tdnum == 30) { //total 

                //clear
                $(thisro).html('');
                $(thisro).html(item.TotalWorkedHours);

                tdnum++;
            }
            else if (tdnum == 31) { //rest 
                //clear
                $(thisro).html('');
                $(thisro).html(item.MinTwentyFourHourrest);

                //tdnum++;
            }
            else if (tdnum == 32) { //comments 
                //clear
                $(thisro).html('');
                $(thisro).html(item.Comment);
                //tdnum++;
            }
        }
        else {

            $(tr).attr("filled", "yes");

            console.log('in -30 else');
            console.log(tdnum);
            if (tdnum == 3) {
                console.log('in here');
                //clear
                $(thisro).html('');
                $(thisro).html('<h4>&#9681;</h4>');
            }

            if (tdnum <= 2) tdnum++;

            else if (tdnum >= 4 && tdnum < 28) {
                //debugger;

                var hr = item.Hours.substring(colcnt - 1, colcnt);
                //console.log(hr);

                colcnt++;
                tdnum++;
                if (hr == "1") {
                    //clear
                    $(thisro).html('');
                    $(thisro).html('<h4>&#9673;</h4>');
                }
                else if (hr == "3") //01
                {
                    //clear
                    $(thisro).html('');
                    $(thisro).html('<h4>&#9681;</h4>');
                }
                else if (hr == "4") //10
                {
                    //clear
                    $(thisro).html('');
                    $(thisro).html('<h4>&#9680;</h4>');
                }

            }
            else if (tdnum == 28) //normal col
            {
                //debugger;
                //clear
                $(thisro).html('');
                $(thisro).html(item.NormalWorkingHours);

                //tdnum++;
            }
            else if (tdnum == 29) { //overtime

                //clear
                $(thisro).html('');
                $(thisro).html(item.OvertimeHours);

                //tdnum++;
            }
            else if (tdnum == 30) { //total 

                //clear
                $(thisro).html('');
                $(thisro).html(item.TotalWorkedHours);

                tdnum++;
            }
            else if (tdnum == 31) { //rest 

                //clear
                $(thisro).html('');
                $(thisro).html(item.MinTwentyFourHourrest);

                //tdnum++;
            }
            else if (tdnum == 32) { //comments 

                //clear
                $(thisro).html('');
                $(thisro).html(item.Comment);
                //tdnum++;
            }
        }
    }
}

function GetDayWiseCrewData() {

    

    $("#schedule").find("tr:gt(1)").remove();
    $("#schedule_d").find("tr:gt(1)").remove();

    GetDayWiseCrewDataPrint();

    var posturl = $('#Showreport1').val();
    var GetWorkingHours = $('#GetWorkingHours').val();
    var totalNormal = 0;
    var totalOvertime = 0;
    var total = 0;
    var totalRest = 0;

    var Reports = {
        //CrewID: $('#ddlCrew').val(),
        //SelectedMonthYear: $('.monthYearPicker').val(),
        BookDate: $('#ReportsDate').val(),
    };

    $.ajax({
        url: posturl,
        data: JSON.stringify({ bookDate: $('#ReportsDate').val() }),
        type: "POST",
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        async: 'false',
        //success: function (result) {

        //},
        success: function (result) {

            //debugger;
            //alert(result[0].Hours);

           // $('#nm').text(result.BookedHours[0].LastName + ' ,' + result.BookedHours[0].FirstName);
          //  $('#rn').text(result.BookedHours[0].RankName);

            if (result !== null) {
                //clear
                $('#yr').text('');
                $('#mn').text('');
                $('#dy').text('');

                $('#yr').text(result.BookedHours[0].Year);
                $('#mn').text(result.BookedHours[0].MonthName);
                $('#dy').text($('#ReportsDate').val());

                var positionCounter = 0;;
                $.each(result.BookedHours, function (index, item) {
                    if (item !== null) {

                        var table = $('#schedule');
                        var trLast = $(table).find("tr:last");
                        var adjustmentfactor = item.AdjustmentFactor;

                        var tdnum = 0;
                        var colcnt = 0;
                        //add row

                        if (index == 0) {
                            $('#trclone').children('td').each(function () {  //map data in row 1

                                if (tdnum == 0) //name
                                {
                                    //debugger;
                                    //clear
                                    $(this).html('');
                                    $(this).html(result.BookedHours[index].LastName + ' ' + result.BookedHours[index].FirstName);

                                    //tdnum++;
                                }
                                if (tdnum == 1) //Nationality
                                {
                                    //debugger;
                                    //clear
                                    $(this).html('');
                                    $(this).html(result.BookedHours[index].Nationality);


                                }
                                if (tdnum == 2) //RankName
                                {
                                    //debugger;
                                    //clear
                                    $(this).html('');
                                    $(this).html(result.BookedHours[index].RankName);


                                }
                                if (tdnum == 3) //RegimeName
                                {
                                    //debugger;
                                    //clear
                                    $(this).html('');
                                    $(this).html(result.BookedHours[index].RegimeName);


                                }

                                else if (tdnum > 3 && tdnum < 34) {
                                    MapDataInTable(adjustmentfactor, tdnum, item, $('#trclone'), this, colcnt);
                                    colcnt++;
                                }
                                tdnum++;
                                
                            });

                        }
                        else {
                            var trnew = $(trLast).clone();
                            //clear row
                            ///////////////////////////////////////////////////
                            var rowcounter = 0;
                            var columncounter = 0;
                            
                                    // = 0;
                                    $(trnew).children('td').each(function () {
                                        
                                            $(this).html('');
                                    });
                                //tdnum = 0;

                            $(trnew).children('td').each(function () {  //map data in row n, where n > 1
                                if (tdnum == 0) //name
                                {
                                    //debugger;
                                    //clear
                                    $(this).html('');
                                    $(this).html(result.BookedHours[index].LastName + ' ' + result.BookedHours[index].FirstName);

                                    //tdnum++;
                                }
                                if (tdnum == 1) //Nationality
                                {
                                    //debugger;
                                    //clear
                                    $(this).html('');
                                    $(this).html(result.BookedHours[index].Nationality);


                                }
                                if (tdnum == 2) //RankName
                                {
                                    //debugger;
                                    //clear
                                    $(this).html('');
                                    $(this).html(result.BookedHours[index].RankName);


                                }
                                if (tdnum == 3) //RegimeName
                                {
                                    //debugger;
                                    //clear
                                    $(this).html('');
                                    $(this).html(result.BookedHours[index].RegimeName);


                                }

                                else if (tdnum > 3 && tdnum < 34) {
                                    MapDataInTable(adjustmentfactor, tdnum, item, trnew, this, colcnt);
                                    colcnt++;
                                }
                                tdnum++;
                                




                                //
                            });

                            tdnum++;
                            $(trLast).after(trnew);

                        }
                    }


                });


            }


           

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

function GetDayWiseCrewDataPrint() {

    var posturl = $('#Showreport1').val();
    var GetWorkingHours = $('#GetWorkingHours').val();
    var totalNormal = 0;
    var totalOvertime = 0;
    var total = 0;
    var totalRest = 0;

    var Reports = {
        //CrewID: $('#ddlCrew').val(),
        //SelectedMonthYear: $('.monthYearPicker').val(),
        BookDate: $('#ReportsDate').val(),
    };

    $.ajax({
        url: posturl,
        data: JSON.stringify({ bookDate: $('#ReportsDate').val() }),
        type: "POST",
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        async: 'false',
        //success: function (result) {

        //},
        success: function (result) {

            //debugger;
            //alert(result[0].Hours);

            // $('#nm').text(result.BookedHours[0].LastName + ' ,' + result.BookedHours[0].FirstName);
            //  $('#rn').text(result.BookedHours[0].RankName);

            if (result != null) {

                //clear
                $('#yr_d').text('');
                $('#mn_d').text('');
                $('#dy_d').text('');

                $('#yr_d').text(result.BookedHours[0].Year);
                $('#mn_d').text(result.BookedHours[0].MonthName);
                $('#dy_d').text($('#ReportsDate').val());

                var positionCounter = 0;;
                $.each(result.BookedHours, function (index, item) {
                    if (item != null) {

                        var table = $('#schedule_d');
                        var trLast = $(table).find("tr:last");
                        var adjustmentfactor = item.AdjustmentFactor;

                        var tdnum = 0;
                        var colcnt = 0;
                        //add row

                        if (index == 0) {
                            $('#trclone_d').children('td').each(function () {  //map data in row 1

                                if (tdnum == 0) //name
                                {
                                    //debugger;
                                    //clear
                                    $(this).html('');

                                    $(this).html(result.BookedHours[index].LastName + ' ' + result.BookedHours[index].FirstName);

                                    //tdnum++;
                                }
                                if (tdnum == 1) //Nationality
                                {
                                    //debugger;
                                    //clear
                                    $(this).html('');
                                    $(this).html(result.BookedHours[index].Nationality);


                                }
                                if (tdnum == 2) //RankName
                                {
                                    //debugger;
                                    //clear
                                    $(this).html('');
                                    $(this).html(result.BookedHours[index].RankName);


                                }
                                if (tdnum == 3) //RegimeName
                                {
                                    //debugger;
                                    //clear
                                    $(this).html('');
                                    $(this).html(result.BookedHours[index].RegimeName);


                                }
                                else if (tdnum > 3 && tdnum < 34) {
                                    MapDataInTable(adjustmentfactor, tdnum, item, $('#trclone'), this, colcnt);
                                    colcnt++;
                                }
                                tdnum++;

                            });

                        }
                        else {
                            var trnew = $(trLast).clone();
                            //clear row
                            ///////////////////////////////////////////////////
                            var rowcounter = 0;
                            var columncounter = 0;

                            // = 0;
                            $(trnew).children('td').each(function () {

                                $(this).html('');
                            });
                            //tdnum = 0;

                            $(trnew).children('td').each(function () {  //map data in row n, where n > 1
                                if (tdnum == 0) //name
                                {
                                    //debugger;
                                    //clear
                                    $(this).html('');
                                    $(this).html(result.BookedHours[index].LastName + ' ' + result.BookedHours[index].FirstName);

                                    //tdnum++;
                                }
                                if (tdnum == 1) //Nationality
                                {
                                    //debugger;
                                    //clear
                                    $(this).html('');
                                    $(this).html(result.BookedHours[index].Nationality);


                                }
                                if (tdnum == 2) //RankName
                                {
                                    //debugger;
                                    //clear
                                    $(this).html('');
                                    $(this).html(result.BookedHours[index].RankName);


                                }
                                if (tdnum == 3) //RegimeName
                                {
                                    //debugger;
                                    //clear
                                    $(this).html('');
                                    $(this).html(result.BookedHours[index].RegimeName);


                                }

                                else if (tdnum > 3 && tdnum < 34) {
                                    MapDataInTable(adjustmentfactor, tdnum, item, trnew, this, colcnt);
                                    colcnt++;
                                }
                                tdnum++;





                                //
                            });

                            tdnum++;
                            $(trLast).after(trnew);

                        }
                    }


                });


            }




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

function PrintDayWiseCrewData() {
    var data = [];
    var res = [];
    //var tsdata = '001100001111111111000000000000000000000000000000';
    //var day = 19;
    var day = 1;
    var posturl = $('#Showreport1').val();
    var loopcounter = 0;


    var rep = {
        
        BookDate: $('#ReportsDate').val(),
    };

    $.ajax({
        url: posturl,
        data: JSON.stringify(rep),
        type: "POST",
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        async: 'false',
        //success: function (result) {

        //},
        success: function (result) {

            $.each(result.BookedHours, function (index, item) {
                if (item != null)
                {
                    data.push([
                        {
                            text: result.BookedHours[index].LastName + ' ' + result.BookedHours[index].FirstName
                        },
                        {
                            text: result.BookedHours[index].Nationality
                        },
                        {
                            text: result.BookedHours[index].RankName
                        },
                        {
                            text: '',
                            style: item.Hours.substring(0, 1) == '1' ? 'fillstyle' : 'fillstylewhite',
                            border: [true, true, false, true]

                        },
                        {
                            text: '',
                            style: item.Hours.substring(1, 2) == '1' ? 'fillstyle' : 'fillstylewhite',
                            border: [false, true, true, true]
                        },
                        {
                            text: '',
                            style: item.Hours.substring(2, 3) == '1' ? 'fillstyle' : 'fillstylewhite',
                            border: [true, true, false, true]
                        },
                        {
                            text: '',
                            style: item.Hours.substring(3, 4) == '1' ? 'fillstyle' : 'fillstylewhite',
                            border: [false, true, true, true]
                        },
                        {
                            text: '',
                            style: item.Hours.substring(4, 5) == '1' ? 'fillstyle' : 'fillstylewhite',
                            border: [true, true, false, true]
                        },
                        {
                            text: '',
                            style: item.Hours.substring(5, 6) == '1' ? 'fillstyle' : 'fillstylewhite',
                            border: [false, true, true, true]
                        },
                        {
                            text: '',
                            style: item.Hours.substring(6, 7) == '1' ? 'fillstyle' : 'fillstylewhite',
                            border: [true, true, false, true]
                        },
                        {
                            text: '',
                            style: item.Hours.substring(7, 8) == '1' ? 'fillstyle' : 'fillstylewhite',
                            border: [false, true, true, true]
                        },
                        {
                            text: '',
                            style: item.Hours.substring(8, 9) == '1' ? 'fillstyle' : 'fillstylewhite',
                            border: [true, true, false, true]
                        },
                        {
                            text: '',
                            style: item.Hours.substring(9, 10) == '1' ? 'fillstyle' : 'fillstylewhite',
                            border: [false, true, true, true]
                        },
                        {
                            text: '',
                            style: item.Hours.substring(10, 11) == '1' ? 'fillstyle' : 'fillstylewhite',
                            border: [true, true, false, true]
                        },
                        {
                            text: '',
                            style: item.Hours.substring(11, 12) == '1' ? 'fillstyle' : 'fillstylewhite',
                            border: [false, true, true, true]
                        },
                        {
                            text: '',
                            style: item.Hours.substring(12, 13) == '1' ? 'fillstyle' : 'fillstylewhite',
                            border: [true, true, false, true]
                        },
                        {
                            text: '',
                            style: item.Hours.substring(13, 14) == '1' ? 'fillstyle' : 'fillstylewhite',
                            border: [false, true, true, true]
                        },
                        {
                            text: '',
                            style: item.Hours.substring(14, 15) == '1' ? 'fillstyle' : 'fillstylewhite',
                            border: [true, true, false, true]
                        },
                        {
                            text: '',
                            style: item.Hours.substring(15, 16) == '1' ? 'fillstyle' : 'fillstylewhite',
                            border: [false, true, true, true]
                        },
                        {
                            text: '',
                            style: item.Hours.substring(16, 17) == '1' ? 'fillstyle' : 'fillstylewhite',
                            border: [true, true, false, true]
                        },
                        {
                            text: '',
                            style: item.Hours.substring(17, 18) == '1' ? 'fillstyle' : 'fillstylewhite',
                            border: [false, true, true, true]
                        },
                        {
                            text: '',
                            style: item.Hours.substring(18, 19) == '1' ? 'fillstyle' : 'fillstylewhite',
                            border: [true, true, false, true]
                        },
                        {
                            text: '',
                            style: item.Hours.substring(19, 20) == '1' ? 'fillstyle' : 'fillstylewhite',
                            border: [false, true, true, true]
                        },
                        {
                            text: '',
                            style: item.Hours.substring(20, 21) == '1' ? 'fillstyle' : 'fillstylewhite',
                            border: [true, true, false, true]
                        },
                        {
                            text: '',
                            style: item.Hours.substring(21, 22) == '1' ? 'fillstyle' : 'fillstylewhite',
                            border: [false, true, true, true]
                        },
                        {
                            text: '',
                            style: item.Hours.substring(22, 23) == '1' ? 'fillstyle' : 'fillstylewhite',
                            border: [true, true, false, true]
                        },
                        {

                            text: '',
                            style: item.Hours.substring(23, 24) == '1' ? 'fillstyle' : 'fillstylewhite',
                            border: [false, true, true, true]

                        },
                        {
                            text: '',
                            style: item.Hours.substring(24, 25) == '1' ? 'fillstyle' : 'fillstylewhite',
                            border: [true, true, false, true]
                        },
                        {
                            text: '',
                            style: item.Hours.substring(25, 26) == '1' ? 'fillstyle' : 'fillstylewhite',
                            border: [false, true, true, true]
                        },
                        {
                            text: '',
                            style: item.Hours.substring(26, 27) == '1' ? 'fillstyle' : 'fillstylewhite',
                            border: [true, true, false, true]
                        },
                        {
                            text: '',
                            style: item.Hours.substring(27, 28) == '1' ? 'fillstyle' : 'fillstylewhite',
                            border: [false, true, true, true]
                        },
                        {
                            text: '',
                            style: item.Hours.substring(28, 29) == '1' ? 'fillstyle' : 'fillstylewhite',
                            border: [true, true, false, true]
                        },
                        {
                            text: '',
                            style: item.Hours.substring(29, 30) == '1' ? 'fillstyle' : 'fillstylewhite',
                            border: [false, true, true, true]
                        },
                        {
                            text: '',
                            style: item.Hours.substring(30, 31) == '1' ? 'fillstyle' : 'fillstylewhite',
                            border: [true, true, false, true]
                        },
                        {
                            text: '',
                            style: item.Hours.substring(31, 32) == '1' ? 'fillstyle' : 'fillstylewhite',
                            border: [false, true, true, true]
                        },
                        {
                            text: '',
                            style: item.Hours.substring(32, 33) == '1' ? 'fillstyle' : 'fillstylewhite',
                            border: [true, true, false, true]
                        },
                        {
                            text: '',
                            style: item.Hours.substring(33, 34) == '1' ? 'fillstyle' : 'fillstylewhite',
                            border: [false, true, true, true]
                        },
                        {
                            text: '',
                            style: item.Hours.substring(34, 35) == '1' ? 'fillstyle' : 'fillstylewhite',
                            border: [true, true, false, true]
                        },
                        {
                            text: '',
                            style: item.Hours.substring(35, 36) == '1' ? 'fillstyle' : 'fillstylewhite',
                            border: [false, true, true, true]
                        },
                        {
                            text: '',
                            style: item.Hours.substring(36, 37) == '1' ? 'fillstyle' : 'fillstylewhite',
                            border: [true, true, false, true]
                        },
                        {
                            text: '',
                            style: item.Hours.substring(37, 38) == '1' ? 'fillstyle' : 'fillstylewhite',
                            border: [false, true, true, true]
                        },
                        {
                            text: '',
                            style: item.Hours.substring(38, 39) == '1' ? 'fillstyle' : 'fillstylewhite',
                            border: [true, true, false, true]
                        },
                        {
                            text: '',
                            style: item.Hours.substring(39, 40) == '1' ? 'fillstyle' : 'fillstylewhite',
                            border: [false, true, true, true]
                        },
                        {
                            text: '',
                            style: item.Hours.substring(40, 41) == '1' ? 'fillstyle' : 'fillstylewhite',
                            border: [true, true, false, true]
                        },
                        {
                            text: '',
                            style: item.Hours.substring(41, 42) == '1' ? 'fillstyle' : 'fillstylewhite',
                            border: [false, true, true, true]
                        },
                        {
                            text: '',
                            style: item.Hours.substring(42, 43) == '1' ? 'fillstyle' : 'fillstylewhite',
                            border: [true, true, false, true]
                        },
                        {
                            text: '',
                            style: item.Hours.substring(43, 44) == '1' ? 'fillstyle' : 'fillstylewhite',
                            border: [false, true, true, true]
                        },
                        {
                            text: '',
                            style: item.Hours.substring(44, 45) == '1' ? 'fillstyle' : 'fillstylewhite',
                            border: [true, true, false, true]
                        },
                        {
                            text: '',
                            style: item.Hours.substring(45, 46) == '1' ? 'fillstyle' : 'fillstylewhite',
                            border: [false, true, true, true]
                        },
                        {
                            text: '',
                            style: item.Hours.substring(46, 47) == '1' ? 'fillstyle' : 'fillstylewhite',
                            border: [true, true, false, true]
                        },
                        {
                            text: '',
                            style: item.Hours.substring(47, 48) == '1' ? 'fillstyle' : 'fillstylewhite',
                            border: [false, true, true, true]
                        },
                        {
                            text: result.BookedHours[index].NormalWorkingHours,
                        },
                        {
                            text: result.BookedHours[index].OvertimeHours,
                        },
                        {
                            text: result.BookedHours[index].TotalWorkedHours ,
                        },
                        {
                            text: result.BookedHours[index].MinTwentyFourHourrest,
                        },
                        {
                            text: result.BookedHours[index].Comment,
                        }

                    ]);
                   
                }
            });


            //for (var i = 1; i <= 6; i++) {

            var docDefinition = {
                pageSize: 'A3',
                pageOrientation: 'landscape',

                content: [
                    {
                        text: [
                            {
                                text: "HOURS OF WORK AND REST ",
                                style: "header"
                            },
                            {
                                text: "                                                                                                                                                                                                                                                                                                                                                                               Revision Number : 05 ",
                                style: "anotherStyle"
                            },
                        ]
                    },
                    {
                        text: [
                            {
                                text: "Form Number: ILO Rest",
                                style: "anotherStyle"
                            },
                            {
                                text: "                                                                                                                                                                                                                                                                                                                                                                                                           Page Number : 1 of 1 ",
                                style: "anotherStyle"
                            },
                        ]
                    },
                    // {
                    //  canvas: [
                    //       {
                    //            type: 'line',
                    //  //          x1: 0,
                    //          y1: 5,
                    //           x2: 535,
                    //           y2: 5,
                    //           lineWidth: 0.5
                    //       }
                    //   ]
                    // },
                    {
                        text: [
                            {
                                text: "___________________________________________________________________________________________________________________________________________________________________________________________________________",
                                // style: "anotherStyle"
                            }
                        ]
                    },
                    {
                        text: [
                            {
                                text: "Year : 2017",
                                style: "anotherStyle"
                            },
                            {
                                text: "                                                                                                                                                                                                Vessel Name: OSX 2",
                                style: "anotherStyle"
                            },
                            {
                                text: "                                                                                                                                                                                             Master: Singh, Amitabh",
                                style: "anotherStyle"
                            },

                        ]
                    },


                    {
                        text: [
                            {
                                text: "Month : NOVEMBER",
                                style: "anotherStyle"
                            },
                            {
                                text: "                                                                                                                                                                                 IMO Number: 8618217",
                                style: "anotherStyle"
                            }

                        ]
                    },



                    {
                        text: [
                            {
                                text: "Day : 3",
                                style: "anotherStyle"
                            },
                            {
                                text: "",
                                style: "anotherStyle"
                            },
                            {
                                text: "                                                                                                                                                                                                           Flag : Liberia",
                                style: "anotherStyle"
                            },

                        ]
                    },

                    {
                        style: "tblStyle1",
                        table: {
                            widths: [100, 50, 50, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 25, 30, 15, 15, 80,],
                            headerRows: 1,
                            body: [
                                ['Seafarer Name', 'Nationality', 'Rank', '00', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', 'Normal', 'Overtime', 'Total', 'Rest', 'Comments'],
                            ]
                        }
                    },


                    {
                        style: "tblStyle",
                        table: {
                            widths: [100, 50, 50, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 25, 30, 15, 15, 80,],
                            headerRows: 1,
                            body: data
                        }
                    },












                    {
                        text: [
                            {
                                text: "   ",
                                style: "anotherStyle"
                            },
                            {
                                text: "   ",
                                style: "anotherStyle"
                            },
                            {
                                text: "   ",
                                style: "anotherStyle"
                            }

                        ]
                    },

















                    {
                        text: [
                            {
                                text: "                         ",
                                style: "anotherStyle"
                            },
                            {
                                text: "                                                                                                                                                                                                                                                                                                                                                                        Signature Of Master: _____________________________________________ ",
                                style: "anotherStyle"
                            },
                        ]
                    },

                    {
                        text: [
                            {
                                text: "                         ",
                                style: "anotherStyle"
                            },
                            {
                                text: "                                                                                                                                                                                                                                                                                                                                                                                                                               Singh, Amitabh  ",
                                style: "anotherStyle"
                            },
                        ]
                    },


                ],
                styles: {
                    header: {
                        fontSize: 12,
                        bold: true
                    },
                    anotherStyle: {
                        fontSize: 9,
                        // italics: true,
                        // alignment: 'right'
                    },
                    tblStyle1: {
                        fontSize: 7,
                        // italics: true,
                        // alignment: 'right'
                    },
                    tblStyle: {
                        fontSize: 7,
                        // italics: true,
                        // alignment: 'right'
                    },
                    Margin: {
                        fontSize: 4.8,

                        //	bold: true,
                        alignment: 'right',
                        margin: [282, 0, 0, 282]
                    },
                    fillstyle: {
                        fillColor: '#656565'

                    },
                    fillstylewhite: {
                        fillColor: '#FFFFFF'
                    }
                }
            }

            pdfMake.createPdf(docDefinition).download('daywisecrew.pdf');
                
            //}
        },
        error: function (errormessage) {
            console.log(errormessage.responseText);
        }
    });


    //for (var i = 0; i < tsdata.length; i = i + 2) {
    //    res[loopcounter] = tsdata.charAt(i) + tsdata.charAt(i + 1);
    //    loopcounter++;
    //}




    

    //alert(data);
    //console.log(data[2][1]);






   
}

function unescapeHtml(safe) {
    return safe.replace(/&amp;/g, '&')
        .replace(/&lt;/g, '<')
        .replace(/&gt;/g, '>')
        .replace(/&quot;/g, '"')
        .replace(/&#039;/g, "'");
}

function PrintWorkAndRestHours() {
    var data = [];
    var res = [];
    var day = 1;
    var posturl = $('#pdfreport').val();
    var loopcounter = 0;

    var totalNormal = 0;
    var totalOvertime = 0;
    var total = 0;
    var totalRest = 0;

    var Reports = {
        CrewID: $('#ddlCrew').val(),
        SelectedMonthYear: $('.monthYearPicker').val()
        
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

           // selectedVessel = result.BookedHours[0].Vessel;
            //selectedCrew = result.BookedHours[0].Crew;
           // console.log(result);

            $.each(result, function (index, item) {
                if (item != null) {
                    //console.log(item);
                    data.push([
                        {
                            text: item.BookDate
                        },
                        {
                            text: item.WorkDate
                        },
                        {
                            text: item.NormalWorkingHours
                        },
                        {
                            text:item.OvertimeHours

                        },
                        {
                            text: item.TotalWorkedHours
                         
                        },
                        {
                            text: item.FomattedComplianceInfo
                        }


                    ]);

                }
            });


            //for (var i = 1; i <= 6; i++) {


            var docDefinition = {
                pageSize: 'A3',
                pageOrientation: 'landscape',

                content: [
                    {
                        text: [
                            {
                                text: "Work and Rest Hours - Variance ",
                                style: "header"
                            },
                            {
                                text: "",
                                style: "anotherStyle"
                            },
                        ]
                    },
                    {
                        text: [
                            {
                                text: "Vessel:",
                                style: "anotherStyle"
                            },
                            {
                                text: "                                                                                                                                  Crew: ",
                                style: "anotherStyle"
                            },
                        ]
                    },
                    // {
                    //  canvas: [
                    //       {
                    //            type: 'line',
                    //  //          x1: 0,
                    //          y1: 5,
                    //           x2: 535,
                    //           y2: 5,
                    //           lineWidth: 0.5
                    //       }
                    //   ]
                    // },

                    {
                        text: [
                            {
                                text: "",
                                style: "header"
                            },
                            {
                                text: "",
                                style: "anotherStyle"
                            },
                        ]
                    },
                    {
                        text: [
                            {
                                text: "Reporting Period:",
                                style: "anotherStyle"
                            },
                            {
                                text: "                                                                                                                Department: ",
                                style: "anotherStyle"
                            },
                        ]
                    },
















                    {
                        style: "tblStyle1",
                        table: {
                            widths: [170, 170, 170, 170, 170, 170],
                            headerRows: 1,
                            body: [
                                ['Day', 'Date', 'Normal Hours', 'Overtime', 'Total Hours', 'Compliance Errors'],
                            ]
                        }
                    },


                    {
                        style: "tblStyle",
                        table: {
                            widths: [170, 170, 170, 170, 170, 170],
                            headerRows: 1,
                            body: data
                        }
                    },














                    {
                        text: [
                            {
                                text: "   ",
                                style: "anotherStyle"
                            },
                            {
                                text: "   ",
                                style: "anotherStyle"
                            },
                            {
                                text: "   ",
                                style: "anotherStyle"
                            }

                        ]
                    },

                ],
                styles: {
                    header: {
                        fontSize: 30,
                        bold: true
                    },
                    anotherStyle: {
                        fontSize: 20,
                        // italics: true,
                        // alignment: 'right'
                    },
                    tblStyle1: {
                        fontSize: 20,
                        // italics: true,
                        // alignment: 'right'
                    },
                    tblStyle: {
                        fontSize: 18,
                        // italics: true,
                        // alignment: 'right'
                    },
                    Margin: {
                        fontSize: 4.8,

                        //	bold: true,
                        alignment: 'right',
                        margin: [282, 0, 0, 282]
                    },
                }
            }

            pdfMake.createPdf(docDefinition).download('daywisecrew.pdf');

            //}
        },
        error: function (errormessage) {
            console.log(errormessage.responseText);
        }
    });


    //for (var i = 0; i < tsdata.length; i = i + 2) {
    //    res[loopcounter] = tsdata.charAt(i) + tsdata.charAt(i + 1);
    //    loopcounter++;
    //}






    //alert(data);
    //console.log(data[2][1]);







}


function GetHours2() {

    //alert($('textarea#Comments').val());

    var posturl = $('#Showreport3').val();
   // var GetWorkingHours = $('#GetWorkingHours').val();
    var totalNormal = 0;
    var totalOvertime = 0;
    var total = 0;
    var totalRest = 0;

    var Reports = {
      //  CrewID: $('#ddlCrew').val(),
        SelectedMonthYear: $('.monthYearPicker').val(),

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

            //$('#nm').text(result.BookedHours[0].LastName + ' ,' + result.BookedHours[0].FirstName);
            //$('#rn').text(result.BookedHours[0].RankName);
            //$('#yr').text(result.BookedHours[0].Year);
            //$('#mn').text(result.BookedHours[0].MonthName);

            //$('#sptotalnormalhrs').text(result.BookedHours[0].TotalNormalHours);
            //$('#sptotalovertimehrs').html(result.BookedHours[0].TotalOvertimeHours);
            //$('#sptotal').html(result.BookedHours[0].TotalHours);
            //$('#sptotalRest').html(result.BookedHours[0].TotalRestHours);

            //$('#seamanfooter').text(result.BookedHours[0].LastName + ' ' + result.BookedHours[0].FirstName);



            $.each(result.BookedHours, function (index, item) {
                if (item != null) {
                    //debugger;
                    //loop in table to find the row corresponding to the date
                    //get tr corresponding to that date 
                    var tr = '#' + item.BookDate;
                    //var tr = $('#15');
                    var tdnum = 0;
                    // alert($('#schedule tr #15').val());
                    $(tr).children('td').each(function () {
                        // debugger;
                        if (tdnum == 0) tdnum++
                        else if (tdnum > 0 && tdnum < 25) {
                            //debugger;
                            var hr = item.Hours.substring(tdnum - 1, tdnum);
                            tdnum++;
                            if (hr == "1") {
                                $(this).html('&#9673;');
                            }
                            else if (hr == "3") //01
                            {
                                $(this).html('&#9680;');
                            }
                            else if (hr == "4") //10
                            {
                                $(this).html('&#9681;');
                            }

                        }
                        else if (tdnum == 25) //normal col
                        {
                            //debugger;
                            $(this).html(item.NormalWorkingHours);

                            tdnum++;
                        }
                        else if (tdnum == 26) { //overtime
                            $(this).html(item.OvertimeHours);

                            tdnum++;
                        }
                        else if (tdnum == 27) { //total 
                            $(this).html(item.TotalWorkedHours);

                            tdnum++;
                        }
                        else if (tdnum == 28) { //rest 
                            $(this).html(item.MinTwentyFourHourrest);

                            tdnum++;
                        }
                        else if (tdnum == 29) { //comments 
                            $(this).html(item.Comment);
                            tdnum++;
                        }
                        else if (tdnum == 30) { //min rest in 24  
                            $(this).html(item.MaxRestPeriodInTwentyFourHours);
                            tdnum++;
                        }
                        else if (tdnum == 31) { //min rest in 7  
                            $(this).html(item.MinSevenDayRest);
                            tdnum++;
                        }

                    });


                }
                //alert(item);
            });

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

function loadData() {
    var loadposturl = $('#loaddata').val();
    $.ajax({
        url: loadposturl,
        type: "GET",
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        success: function (result) {
            SetUpGrid();

        },
        error: function (errormessage) {
            console.log(errormessage.responseText);
        }
    });
}

function SetUpGrid() {

    SetUpPrintGrid();


    var loadposturl = $('#loaddata').val();

    //do not throw error
    $.fn.dataTable.ext.errMode = 'none';

    //check if datatable is already created then destroy iy and then create it
    if ($.fn.dataTable.isDataTable('#certtable')) {
        table = $('#certtable').DataTable();
        table.destroy();
    }

    var Reports = {
        
        SelectedMonthYear: $('.monthYearPicker').val(),
        CrewID: $('#ddlCrew').val()
    };

    console.log(Reports);

    $("#certtable").DataTable({
        "processing": true, // for show progress bar
        "serverSide": true, // for process server side
        "filter": false, // this is for disable filter (search box)
        "orderMulti": false, // for disable multiple column at once
        "bLengthChange": false, //disable entries dropdown 
        "paging": false,
        "ajax": {
            "url": loadposturl,
            "data": Reports,

            "type": "POST",
            "datatype": "json"
        },
        "columnDefs": [

            { "className": "dt-center", "targets": "_all" }

        ],
        "columns": [
            {
                "data": "BookDate", "name": "BookDate", "autoWidth": true
            },
            {
                "data": "WorkDate", "name": "BookDate", "autoWidth": true
            },
            {
                "data": "MaxRestPeriodInTwentyFourHours", "name": "MaxRestPeriodInTwentyFourHours", "autoWidth": true
            },
            {
                "data": "MinTwentyFourHourrest", "name": "MinTwentyFourHourrest", "autoWidth": true
            },
            {
                "data": "MinTotalRestIn7Days", "name": "MinTotalRestIn7Days", "autoWidth": true
            },
            {
                "data": "MinSevenDayRest", "name": "MinSevenDayRest", "autoWidth": true
            },
            {
                "data": "FomattedComplianceInfo", "name": "ComplianceErrors", "autoWidth": true
            },


            {
                "data": "Comment", "name": "Comment", "autoWidth": true
            }
            //{
            //    "data": "ID", "width": "50px", "render": function (data) {
            //        return '<a href="#" onclick="xxxxxx(' + data + ')">Open</a>';
            //    }
            //}

        ]
    });
}

function SetUpPrintGrid() {
    var loadposturl = $('#loaddata').val();

     //do not throw error
    $.fn.dataTable.ext.errMode = 'none';

    //check if datatable is already created then destroy iy and then create it
    if ($.fn.dataTable.isDataTable('#certtable_print')) {
        table = $('#certtable_print').DataTable();
        table.destroy();
    }

    var Reports = {

        SelectedMonthYear: $('.monthYearPicker').val(),
        CrewID: $('#ddlCrew').val()
    };

    //console.log(Reports);

    $("#certtable_print").DataTable({
        "processing": true, // for show progress bar
        "serverSide": true, // for process server side
        "filter": false, // this is for disable filter (search box)
        "orderMulti": false, // for disable multiple column at once
        "bLengthChange": false, //disable entries dropdown
        "paging": false,
        "bInfo": false,
        "ajax": {
            "url": loadposturl,
            "data": Reports,
            "type": "POST",
            "datatype": "json"
        },
        "columnDefs": [

            { "className": "dt-center", "targets": "_all" }

        ],
        "columns": [
            {
                "data": "BookDate", "name": "BookDate", "autoWidth": true

            },
            {
                "data": "WorkDate", "name": "BookDate", "autoWidth": true

            },
            {
                "data": "MaxRestPeriodInTwentyFourHours", "name": "MaxRestPeriodInTwentyFourHours", "autoWidth": true

            },
            {
                "data": "MinTwentyFourHourrest", "name": "MinTwentyFourHourrest", "autoWidth": true
            },
            {
                "data": "MinTotalRestIn7Days", "name": "MinTotalRestIn7Days", "autoWidth": true
            },
            {
                "data": "MinSevenDayRest", "name": "MinSevenDayRest", "autoWidth": true
            },
            {
                "data": "FomattedComplianceInfo", "name": "ComplianceErrors", "autoWidth": true
            },
            {
                "data": "Comment", "name": "Comment", "autoWidth": true
            }
           

        ]
    });

   
}


function loadData2() {
    var loadposturl = $('#loaddatareport').val();
    $.ajax({
        url: loadposturl,
        type: "GET",
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        success: function (result) {
            SetUpGrid();

        },
        error: function (errormessage) {
            console.log(errormessage.responseText);
        }
    });
}



function SetUpGridReport() {

    SetUpPrintGridReport();/////////////////////////////////////////////////////

    var loadposturl = $('#loaddatareport').val();
    //do not throw error
    $.fn.dataTable.ext.errMode = 'none';
    //check if datatable is already created then destroy iy and then create it
    if ($.fn.dataTable.isDataTable('#certtableReport')) {
        table = $('#certtableReport').DataTable();
        table.destroy();
    }

    $("#certtableReport").DataTable({
        "processing": true, // for show progress bar
        "serverSide": true, // for process server side
        "filter": false, // this is for disable filter (search box)
        "orderMulti": false, // for disable multiple column at once
        "bLengthChange": false, //disable entries dropdown
        "ajax": {
            "url": loadposturl,
            "type": "POST",
            "datatype": "json"
        },
        "columns": [
            {
                "data": "RowNumber", "name": "RowNumber", "autoWidth": true
            },
            {
                "data": "Name", "name": "Name", "autoWidth": true
            },
            {
                "data": "EmployeeNumber", "name": "EmployeeNumber", "autoWidth": true
            },
           
            {
                "data": "RankName", "name": "RankName", "autoWidth": true
            },
            {
                "data": "Nationality", "name": "Nationality", "autoWidth": true
            },
            {
                "data": "DOB1", "name": "DOB1", "autoWidth": true
            },
            {
                "data": "PassportSeamanPassportBook", "name": "PassportSeamanPassportBook", "autoWidth": true
            },
            {
                 "data": "Seaman", "name": "Seaman", "autoWidth": true
            }

        ]
    });
}

function SetUpPrintGridReport() {
    var loadposturl = $('#loadprintreport').val();

    //do not throw error
    $.fn.dataTable.ext.errMode = 'none';

    //check if datatable is already created then destroy iy and then create it
    if ($.fn.dataTable.isDataTable('#certtable_print')) {
        table = $('#certtable_print').DataTable();
        table.destroy();
    }

    $("#certtable_print").DataTable({
        "processing": true, // for show progress bar
        "serverSide": true, // for process server side
        "filter": false, // this is for disable filter (search box)
        "orderMulti": false, // for disable multiple column at once
        "bLengthChange": false, //disable entries dropdown
        "paging": false,
        "bInfo": false,
        "ajax": {
            "url": loadposturl,
            "type": "POST",
            "datatype": "json"
        },
        "columns": [
            {
                "data": "RowNumber", "name": "RowNumber", "autoWidth": true
            },
            {
                "data": "Name", "name": "Name", "autoWidth": true
            },
            {
                "data": "EmployeeNumber", "name": "EmployeeNumber", "autoWidth": true
            },
           
            {
                "data": "RankName", "name": "RankName", "autoWidth": true
            },
            {
                "data": "Nationality", "name": "Nationality", "autoWidth": true
            },
            {
                "data": "DOB1", "name": "DOB1", "autoWidth": true
            },
            {
                "data": "PassportSeamanPassportBook", "name": "PassportSeamanPassportBook", "autoWidth": true
            },
            {
                "data": "Seaman", "name": "Seaman", "autoWidth": true
            }

        ]
    });
}

//Disable row for +1D booking
function DisableRow()
{
    var purl = $('#GetPlusOneDayAdjustmentValue').val();

    $.ajax({
        url: purl,
        data: JSON.stringify({ monthyear: $('.monthYearPicker').val() }),
        type: "POST",
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        async: 'false',
        success: function (result) {
            if (result != null) {

                console.log('In Plus One');
                console.log(result.BookedHours);
                console.log(result.BookedHours.length);
                for (var i = 0; i < result.BookedHours.length; i++) {
                    var r = result.BookedHours[i].AdjustmentDate;
                    var disabledrow = $('#' + r + '');
                    $(disabledrow).children('td,th').css('background-color', 'grey');
                }
            }
        }
    });

    //var disablecol = $('#h16').index();
    //$('td, th').filter(':nth-child(' + (disablecol + 1) + ')').css('background-color', 'grey');

    //var disabledrow = $('#16');
    //$(disabledrow).children('td,th').css('background-color', 'grey');
}

function PrintReport1() {
    //alert('hi');
   // alert($('#nm').text());
    var htmlstr = '';
    var statustext = false;
    var printurl = $('#printReport1').val();

    $.ajax({
        url: printurl,
        data: JSON.stringify({ monthyear: $('.monthYearPicker').val(), crewID: $('#ddlCrew').val(), fullname: $('#nm').text(),rank: $('#rn').text() }),
        type: "POST",
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        async: false,
        success: function (result) {
            //debugger;

            htmlstr = result;
            statustext = true;
        },
        error: function (errormessage) {
            console.log(errormessage.responseText);
        }
    });

    if (statustext) {
        $('#dvprint').val(htmlstr);
        var divtoprint = $('#dvprint');

        Popup1(htmlstr);
    }

}

function Popup1(data) {
    var mywindow = window.open('', '', 'left=0,top=0,width=1600,height=1400');

    var is_chrome = Boolean(mywindow.chrome);
    //console.log(is_chrome);
    //alert(is_chrome);
    mywindow.document.write('<html><head><title></title>');
    mywindow.document.write('</head><body >');
    mywindow.document.write(data);
    mywindow.document.write('</body></html>');
    mywindow.document.close(); // necessary for IE >= 10 and necessary before onload for chrome
    //alert(is_chrome);

    is_chrome = false;   /////////////////

    if (is_chrome) {
        mywindow.onload = function () { // wait until all resources loaded 
            mywindow.focus(); // necessary for IE >= 10
            mywindow.print();  // change window to mywindow
            mywindow.close();// change window to mywindow
        };
    }
    else {
        mywindow.document.close(); // necessary for IE >= 10
        mywindow.focus(); // necessary for IE >= 10
        mywindow.print();
        mywindow.close();
    }

    return true;
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


function PrintReport2() {
    //alert('hi');
    var htmlstr = '';
    var statustext = false;
    var printurl = $('#printReport2').val();

    Popup2('');

    //$.ajax({
    //    url: printurl,
    //    data: JSON.stringify({ 'letterText': $('#txtbodytext').text() }),
    //    type: "POST",
    //    contentType: "application/json;charset=utf-8",
    //    dataType: "json",
    //    async: false,
    //    success: function (result) {
    //        //debugger;

    //        htmlstr = result;
    //        statustext = true;
    //    },
    //    error: function (errormessage) {
    //        console.log(errormessage.responseText);
    //    }
    //});

    //if (statustext) {


    //GetDayWiseCrewDataPrint();
    
}


function PrintTest(data) {
    var mywindow = window.open('', '', 'left=0,top=0,width=1600,height=1400');

    var is_chrome = Boolean(mywindow.chrome);

    mywindow.document.write('<html><head><title></title>');
    mywindow.document.write('</head><body >');
    mywindow.document.write($('#dvprint2').html());
    mywindow.document.write('</body></html>');
    mywindow.document.close(); // necessary for IE >= 10 and necessary before onload for chrome
    is_chrome = false;
    //alert(is_chrome);
    if (is_chrome) {
        mywindow.onload = function () { // wait until all resources loaded 
            mywindow.focus(); // necessary for IE >= 10
           // mywindow.print();  // change window to mywindow
            //mywindow.close();// change window to mywindow
        };
    }
    else {
        mywindow.document.close(); // necessary for IE >= 10
        mywindow.focus(); // necessary for IE >= 10
        //mywindow.print();
       // mywindow.close();
    }

    return true;
}



function Popup2(data) {
    var mywindow = window.open('', '', 'left=0,top=0,width=1600,height=1400');

    var is_chrome = Boolean(mywindow.chrome);
    
    mywindow.document.write('<html><head><title></title>');
    mywindow.document.write('</head><body >');
    mywindow.document.write($('#dvprint2').html());
    mywindow.document.write('</body></html>');
    mywindow.document.close(); // necessary for IE >= 10 and necessary before onload for chrome
    is_chrome = false; 
    //alert(is_chrome);
    if (is_chrome) {
        mywindow.onload = function () { // wait until all resources loaded 
            mywindow.focus(); // necessary for IE >= 10
            mywindow.print();  // change window to mywindow
            mywindow.close();// change window to mywindow
        };
    }
    else {
        mywindow.document.close(); // necessary for IE >= 10
        mywindow.focus(); // necessary for IE >= 10
        mywindow.print();
        mywindow.close();
    }

    return true;
}

function GetNCDetails(ncdetailId) {
    var posturl = $('#getNonComplianceInfo').val();
    
    console.log('NCDetailID');
    console.log(ncdetailId);
    $.ajax({
        url: posturl,
        data: JSON.stringify({ ncDetailID: ncdetailId}),
        type: "POST",
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        success: function (result) {
            //loadData();
            //$('#myModal').modal('hide');

            console.log('In NCDetails');
            console.log(result);

            var msg = result;
            $('#myModal').modal('show');
            $('#succMsg').html(msg);
        },
        error: function (errormessage) {
            console.log(errormessage.responseText);
        }
    });
}

function GetNonComplianceDetails() {

    var posturl = $('#GetNonComplianceDetails').val();
    //debugger;

    $("#schedule").find("tr:gt(1)").remove();

    $.ajax({
        url: posturl,
        data: JSON.stringify({ 'monthyear' : $('.monthYearPicker').val() }),
        type: "POST",
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        async: 'false',

        success: function (result) {
            
            //$('#yr').text(result.Year);
            //$('#mn').text(result.MonthName);

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
                        var ignoreRow='';
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
                            $(trid).children('td').each(function (idx,itm) {  //map data in row 1

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
                                else if (idx-1 == parseInt(day)) {
                                    
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
                                    if (idx -1 == parseInt(day)) {
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
                        else if (crewid !== previouscrewid)
                        {
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

                            $(trnew).children('td').each(function (idx,itm) {  //map data in row n, where n > 1
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
                                else if (idx -1 == parseInt(day)) {
                                    //console.log('Checking Status');
                                    //console.log(result[index].isNonCompliant);
                                    if (result[index].isNonCompliant == '1') {
                                        //clear
                                        $(this).html('');
                                        $(this).html('&nbsp;<a href="#" id="myid3" onclick="javascript:GetNCDetails(&quot;' + result[index].NCDetailsID + '&quot;);"> <img src=' + imgpathR +' width="16" height="16"> </a>');  //NC
                                    }
                                    else {
                                        //clear
                                        $(this).html('');
                                        
                                        $(this).html('&nbsp;<a href="#" id= "' + result[index].NCDetailsID + '"> <img src=' + imgpathG +' width="16" height="16"> </a>');   //NA
                                    }
                                }





                                //
                            });

                            tdnum++;
                            $('#schedule >tbody:last-child').append(trnew);
                            //$(trLast).after(trnew);

                        }
                    }


                });
            }
            
        }
        ,
        error: function (errormessage) {
            console.log(errormessage.responseText);
        }
    });

}

function GetNonComplianceDetailsByCurrentMonth(monthyr) {

    var posturl = $('#GetNonComplianceDetails').val();

    var getUrl = window.location;
    var baseurl = getUrl.protocol + "//" + getUrl.host; //+ "/" + getUrl.pathname.split('/')[1]  ;

    console.log('BaseUrl');
    console.log(baseurl);

    //var baseurl = $('base').attr('val');
    var imgpathR = baseurl + "/images/R.png";
    var imgpathG = baseurl + "/images/G.png";


    $.ajax({
        url: posturl,
        data: JSON.stringify({ 'monthyear': monthyr }),
        type: "POST",
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        async: 'false',

        success: function (result) {

            //$('#yr').text(result.Year);
            //$('#mn').text(result.MonthName);

            //console.log(result);
            var crewid = 0;
            
            var previouscrewid = 0;
            var day = 0;
            var isnewCrew = false;

            if (result !== null) {
                //loop in result array
                var positionCounter = 0;;
                $.each(result, function (index, item) {
                    if (item !== null) {

                        var table = $('#schedule');
                        var trnew;
                        var trLast = $(table).find("tr:last");
                        var adjustmentfactor = item.AdjustmentFactor;
                        //console.log('here in main loop');
                        //console.log(item);
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
                        //if(crewid == 10)
                        //debugger;

                        var tdnum = 0;
                        var colcnt = 0;
                        //add row

                        if (crewid === previouscrewid && index === 0) {
                            $('#trclone').attr('id', crewid);
                            var trid = '#' + crewid;
                            console.log(trid);
                            $(trid).children('td').each(function (idx, itm) {  //map data in row 1

                                if (idx == 0) //name
                                {
                                    //debugger;
                                    $(this).html(result[index].Name);
                                    //console.log('In idx 0');
                                    //console.log(result[index].Name);
                                    //console.log(parseInt(day));
                                    //tdnum++;
                                }
                                else if (idx == parseInt(day)) {
                                    //console.log('Checking Status');
                                    //console.log(result[index].isNonCompliant);
                                    if (result[index].isNonCompliant == '1')
                                        $(this).html('&nbsp;<a href="#" id="myid3" onclick="javascript:GetNCDetails(&quot;' + result[index].NCDetailsID + '&quot;);"> <img src=' + imgpathR+' width="16" height="16"> </a>');  //NC
                                    else
                                        $(this).html('&nbsp;<a href="#" id= "' + result[index].NCDetailsID + '"> <img src=' + imgpathG +' width="16" height="16"> </a>');   //NA
                                }

                                //tdnum++;

                            });



                        }
                        else if (crewid === previouscrewid) {
                            var trid = $('#schedule tbody>tr:last');//'#' + crewid;
                            //if (crewid === 10) debugger;
                            
                            //var trid = trnew;
                            //console.log('In prev.');
                            console.log($(trid).children('td').length);

                            $(trid).children('td').each(function (idx, itm) {  //map data in row 1
                                //console.log(idx);
                                //debugger;
                                if (idx === 0) //name
                                {
                                    
                                    
                                    if ($(this).html() === result[index].Name) {
                                        ignoreRow = false;
                                    }
                                    else {
                                        ignoreRow = true;
                                    }

                                    console.log(parseInt(day));
                                    //console.log(result[index].Name);
                                    console.log(ignoreRow);
                                }

                                if (!ignoreRow) {
                                    if (idx == parseInt(day)) {
                                        //console.log('Checking Status');
                                        //console.log(result[index].isNonCompliant);
                                        if (result[index].isNonCompliant === '1')
                                            $(this).html('&nbsp;<a href="#" id="myid3" onclick="javascript:GetNCDetails(&quot;' + result[index].NCDetailsID + '&quot;);"> <img src=' + imgpathR +' width="16" height="16"> </a>');  //NC
                                        else
                                            $(this).html('&nbsp;<a href="#"  id= "' + result[index].NCDetailsID + '"> <img src=' + imgpathG +' width="16" height="16"> </a>');  //NA
                                    }
                                }

                                tdnum++;

                            });

                        }
                        else if (crewid !== previouscrewid) {
                             trnew = $(trLast).clone();//trLast
                            //debugger;
                            console.log('here in not equal');
                            console.log(crewid);
                            previouscrewid = crewid;
                            $(trnew).attr('id', crewid);
                            console.log($(trnew).innerHTML);
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
                                //if(crewid === 10)
                                //debugger;
                                if (idx == 0) //name
                                {
                                    //debugger;
                                    // $(this).html(result.BookedHours[index].LastName + ' ' + result.BookedHours[index].FirstName);             ok
                                    $(this).html(result[index].Name);
                                    console.log('here');
                                    console.log(result[index].Name);
                                    //tdnum++;
                                }
                                else if (idx == parseInt(day)) {
                                    //console.log('Checking Status');
                                    //console.log(result[index].isNonCompliant);
                                    if (result[index].isNonCompliant === '1') {
                                        $(this).html(
                                            '&nbsp;<a href="#" id="myid3" onclick="javascript:GetNCDetails(&quot;' +
                                            result[index].NCDetailsID +
                                            '&quot;);"> <img src=' +
                                            imgpathR +
                                            ' width="16" height="16"> </a>'); //NC
                                    } else {
                                        //debugger;
                                        $(this).html('&nbsp;<a href="#" id= "' +
                                            result[index].NCDetailsID +
                                            '"> <img src=' +
                                            imgpathG +
                                            ' width="16" height="16"> </a>'); //NA
                                    }
                                }


                                //else if (tdnum > 2 && tdnum < 33) {
                                //   // MapDataInTable(adjustmentfactor, tdnum, item, trnew, this, colcnt);
                                //    colcnt++;
                                //}
                                //tdnum++;





                                //
                            });

                            tdnum++;
                            //$(trLast).after(trnew);
                            $('#schedule >tbody:last-child').append(trnew);

                        }

                        
                    }
                    

                });
            }

        }
        ,
        error: function (errormessage) {
            console.log(errormessage.responseText);
        }
    });

}




///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function ProcessDataForUser() {
    DisableRowForUser();
    GetHoursForUser();
}

function PrintReport1ForUser() {
    //alert('hi');
    var htmlstr = '';
    var statustext = false;
    var printurl = $('#printReport1ForUser').val();

    $.ajax({
        url: printurl,
        data: JSON.stringify({ monthyear: $('.monthYearPicker').val(), crewID: $('#ddlCrew').val() }),
        type: "POST",
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        async: false,
        success: function (result) {
            //debugger;

            htmlstr = result;
            statustext = true;
        },
        error: function (errormessage) {
            console.log(errormessage.responseText);
        }
    });

    if (statustext) {
        $('#dvprint').val(htmlstr);
        var divtoprint = $('#dvprint');

        Popup1ForUser(htmlstr);
    }

}


function Popup1ForUser(data) {
    var mywindow = window.open('', '', 'left=0,top=0,width=1600,height=1400');

    var is_chrome = Boolean(mywindow.chrome);
    //console.log(is_chrome);
    //alert(is_chrome);
    mywindow.document.write('<html><head><title></title>');
    mywindow.document.write('</head><body >');
    mywindow.document.write(data);
    mywindow.document.write('</body></html>');
    mywindow.document.close(); // necessary for IE >= 10 and necessary before onload for chrome
    //alert(is_chrome);

    is_chrome = false;   /////////////////

    if (is_chrome) {
        mywindow.onload = function () { // wait until all resources loaded 
            mywindow.focus(); // necessary for IE >= 10
            mywindow.print();  // change window to mywindow
            mywindow.close();// change window to mywindow
        };
    }
    else {
        mywindow.document.close(); // necessary for IE >= 10
        mywindow.focus(); // necessary for IE >= 10
        mywindow.print();
        mywindow.close();
    }

    return true;
}


function PrintPdfForUser() {

    //get data 
    var posturl = $('#ReportsaddForUser').val();
    var seafarerFullName = '';
    var seafarerRank = '';
    var selectedYear = '';
    var selectedMonth = '';
    var totnormalHours = '0';
    var totOvertimeHours = '0';
    var totHours = '0';
    var totRestHours = '0';
    var monthlyBookedHours = [];
    var data = [];
    var res = [];
    var tsdata = '';
    var day = 0;
    var loopcounter = 0;

    var Reports = {
        CrewID: $('#ddlCrew').val(),
        SelectedMonthYear: $('.monthYearPicker').val(),

    };

    $.ajax({
        url: posturl,
        data: JSON.stringify(Reports),
        type: "POST",
        contentType: "application/json;charset=utf-8",
        dataType: "json",

        success: function (result) {

            seafarerFullName = result.BookedHours[0].LastName + ' ,' + result.BookedHours[0].FirstName;
            seafarerRank = result.BookedHours[0].RankName;
            selectedYear = result.BookedHours[0].Year;
            selectedMonth = result.BookedHours[0].MonthName;

            totnormalHours = result.BookedHours[0].TotalNormalHours;
            totOvertimeHours = result.BookedHours[0].TotalOvertimeHours;
            totHours = result.BookedHours[0].TotalHours;
            totRestHours = result.BookedHours[0].TotalRestHours;
            //generate pdf now /////////////////////////////////////////
            // set column names
            // data.push(['', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''])
            // initialize each row
            for (var i = 1; i <= 31; i++) {


                data.push([
                    {
                        text: '' + i,
                        fillColor: '#f0f0f0'
                    },
                    {
                        text: ''


                    },
                    {
                        text: '',
                        // border: 1
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {

                        text: '',

                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    },
                    {
                        text: ''
                    }
                ]);
            } //end for

            //clear all half-hour borders
            for (var m = 0; m <= 31; m++) {
                for (var n = 0; n < 48; n++) {

                    console.log('m:' + m);

                    if (m > 0) {
                        if ((n + 1) % 2 === 0) {
                            data[m - 1][n + 1] = { text: '', style: 'fillstylewhite', border: [false, true, true, true], };
                        }
                        else {
                            data[m - 1][n + 1] = { text: '', style: 'fillstylewhite', border: [true, true, false, true], };
                        }
                    }

                }
            }

            //loop in data to set hours for each data
            $.each(result.BookedHours, function (index, item) {
                if (item != null) {

                    tsdata = item.Hours;
                    day = item.BookDate;
                    loopcounter = 0;
                    // copy in an array
                    for (var i = 0; i < tsdata.length; i++) {
                        res[i] = tsdata.charAt(i);
                        //loopcounter++;
                    }



                    for (var m = 0; m <= 31; m++) {
                        for (var n = 0; n < 48; n++) {

                            if (m == day) {

                                if (res[n] == '1') //1
                                {


                                    if ((n + 1) % 2 === 0) {
                                        data[m - 1][n + 1] = { text: '', style: 'fillstyle', border: [false, true, true, true], }; //,
                                    }
                                    else {
                                        data[m - 1][n + 1] = { text: '', style: 'fillstyle', border: [true, true, false, true], };
                                    }
                                    data[m - 1][49] = { text: item.NormalWorkingHours };
                                    data[m - 1][50] = { text: item.OvertimeHours }; //overtime
                                    data[m - 1][51] = { text: item.TotalWorkedHours }; //total
                                    data[m - 1][52] = { text: item.MinTwentyFourHourrest }; //rest
                                    data[m - 1][53] = { text: item.Comment }; //Comments
                                    data[m - 1][54] = { text: item.MaxRestPeriodInTwentyFourHours }; //min rest in 24 
                                    data[m - 1][55] = { text: item.MinSevenDayRest }; //min rest in 7 

                                }
                                //else {

                                //    // for 0s 
                                //    if ((n + 1) % 2 === 0) {
                                //        data[m - 1][n + 1] = { text: '', style: 'fillstylewhite', border: [false, true, true, true], };
                                //    }
                                //    else {
                                //        data[m - 1][n + 1] = { text: '', style: 'fillstylewhite', border: [true, true, false, true], };
                                //    }

                                //} // end else



                            }


                        }
                    } // end nested for
                } //end item null if
            }); // end result loop

            var docDefinition = {
                pageSize: 'A3',
                pageOrientation: 'landscape',
                pageMargins: [20, 20, 20, 20],
                content: [
                    {
                        text: [
                            {
                                text: "HOURS OF WORK AND REST ",
                                style: "header"
                            },
                            {
                                text: "                                                                                                                                                                                                                                                                                                                                                             Revision Number : 05 ",
                                style: "anotherStyle"
                            },
                        ]
                    },
                    {
                        text: [
                            {
                                text: "Form Number: ILO Rest",
                                style: "anotherStyle"
                            },
                            {
                                text: "                                                                                                                                                                                                                                                                                                                                                                                         Page Number : 1 of 1 ",
                                style: "anotherStyle"
                            },
                        ]
                    },
                    {
                        text: [
                            {
                                text: "___________________________________________________________________________________________________________________________________________________________________________________________________________",
                                // style: "anotherStyle"
                            }
                        ]
                    },
                    {
                        text: [
                            {
                                text: "Seafarer's Full Name: " + seafarerFullName,
                                style: "anotherStyle"
                            },
                            {
                                text: "                                                                                                                                                 Vessel Name: OSX 2",
                                style: "anotherStyle"
                            },
                            {
                                text: "                                                                                                                                                                           Master: Singh, Amitabh",
                                style: "anotherStyle"
                            },

                        ]
                    },


                    {
                        text: [
                            {
                                text: "Year : " + selectedYear,
                                style: "anotherStyle"
                            },
                            {
                                text: "                      Month: " + selectedMonth,
                                style: "anotherStyle"
                            },
                            {
                                text: "                                                                                                                                           Flag : Liberia",
                                style: "anotherStyle"
                            },

                        ]
                    },

                    {
                        style: "Margin0",
                        table: {
                            widths: [17, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 25, 30, 22, 22, 190, 25, 25,],
                            body: [

                                ['Date', '00', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', 'Normal', 'Overtime', 'Total', 'Rest', 'Comments', 'Minimum Rest in 24 Hours', 'Minimum Rest in 7 days'],
                            ]
                        }
                    },


                    {
                        style: "tblStyle",
                        table: {
                            widths: [17, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 25, 30, 22, 22, 190, 25, 25,],
                            // headerRows: 1,
                            body: data

                        }

                    },



                    {
                        style: "Margin",
                        table: {
                            widths: [407, 25, 30, 22, 22],
                            body: [
                                ['Totals', totnormalHours, totOvertimeHours, totHours, totRestHours],
                                ['Guaranteed Overtime', '', '', '', ''],
                                ['Extra Overtime Payable', '', '', '', ''],
                            ]
                        }
                    },
                    //              {
                    //	style: 'tableExample',
                    //	table: {
                    //		heights: 40,
                    //		body: [
                    //			[  {
                    //	//style: 'tableExample',
                    //		style: 'anotherStyle',
                    //	table: {
                    //		headerRows: 1,
                    //		body: [


                    //			['','', ''],
                    //			['','', 'First 30 mins'],
                    //			['Key :','', 'Last 30 mins'],
                    //			['','', 'Full Hour'],
                    //		]
                    //	},
                    //	layout: 'noBorders'
                    //},]
                    //		]
                    //	}
                    //},
                    {
                        //style: 'tableExample',
                        style: 'anotherStyle',
                        table: {
                            headerRows: 1,
                            body: [

                                ['', '', '', ''],
                                ['', '', '', ''],
                                ['Signature of Seaman:', '________________________________________________________', 'Signature of Master/Person Authorised by the Master :', '________________________________________________________'],
                                ['', seafarerFullName, '', 'Singh, Amitabh'],
                                ['', '', '', ''],
                            ]
                        },
                        layout: 'noBorders'
                    },

                ],
                styles: {
                    header: {
                        fontSize: 12,
                        bold: true
                    },
                    anotherStyle: {
                        fontSize: 9,

                    },
                    tblStyle: {
                        fontSize: 6,

                    },
                    Margin: {

                        fontSize: 4.8,
                        alignment: 'right',
                        margin: [282, 0, 0, 0]
                    },
                    noBorders: {
                        fontSize: 4.8,
                        alignment: 'left',
                        margin: [100, 0, 0, 282]
                    },
                    fillstyle: {
                        fillColor: '#656565'

                    },
                    fillstyle3: {
                        fillColor: '#f0f0f0'
                    },
                    Margin0: {
                        fontSize: 7

                    },
                    tblStyle1: {
                        fontSize: 7

                    },
                    fillstylewhite: {
                        fillColor: '#FFFFFF'
                    }


                }
            }



            pdfMake.createPdf(docDefinition).download('PDF_2.pdf');


            /////////// end pdf generation /////////////////////
        }
        ,
        error: function (errormessage) {
            console.log(errormessage.responseText);
        }
    });










    //alert(data);





    //console.log(data[19][2]);
    //console.log(data[19][5]);
    //console.log(data[19][7]);



}


function GetHoursForUser() {

    //alert($('textarea#Comments').val());

    var posturl = $('#ShowreportForUser').val();
    var rowurl = $('#GetMinusOneDayAdjustmentValueForUser').val();
    var GetWorkingHours = $('#GetWorkingHoursForUser').val();
    var totalNormal = 0;
    var totalOvertime = 0;
    var total = 0;
    var totalRest = 0;
    var clonero = '';

    ClearTable();

    //create extra row for -1D
    $.ajax({
        url: rowurl,
        data: JSON.stringify({ monthyear: $('.monthYearPicker').val(), crewID: $('#ddlCrew').val() }),
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
        CrewID: $('#ddlCrew').val(),
        SelectedMonthYear: $('.monthYearPicker').val(),

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

            $('#sptotalnormalhrs').text(result.BookedHours[0].TotalNormalHours);
            $('#sptotalovertimehrs').text(result.BookedHours[0].TotalOvertimeHours);
            $('#sptotal').text(result.BookedHours[0].TotalHours);
            $('#sptotalRest').text(result.BookedHours[0].TotalRestHours);

            $('#seamanfooter').text(result.BookedHours[0].LastName + ' ' + result.BookedHours[0].FirstName);



            $.each(result.BookedHours, function (index, item) {
                if (item != null) {
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

                        if (adjustmentfactor == 0 || adjustmentfactor == "+1" || adjustmentfactor == "+30" || adjustmentfactor == "-1D") {

                            $(tr).attr("filled", "yes");

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
                            }
                            else {
                                //set to false so that only the first time is decreased by 1 hr
                                //item.HasOneFirst = false;
                                if (tdnum == 1) {
                                    console.log('in here');
                                    $(this).html('<h4>&#9673;</h4>');
                                }


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
                            }
                            else {

                                $(tr).attr("filled", "yes");

                                console.log('in -30 else');
                                console.log(tdnum);
                                if (tdnum == 1) {
                                    console.log('in here');
                                    $(this).html('<h4>&#9681;</h4>');
                                }

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
                //alert(item);
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

function GetHoursForPdfForUser() {

    //alert($('textarea#Comments').val());

    var posturl = $('#ShowreportForUser').val();
    var GetWorkingHours = $('#GetWorkingHoursForUser').val();
    var totalNormal = 0;
    var totalOvertime = 0;
    var total = 0;
    var totalRest = 0;

    var Reports2 = {
        CrewID: $('#ddlCrew').val(),
        SelectedMonthYear: $('.monthYearPicker').val(),

    };

    $.ajax({
        url: posturl,
        data: JSON.stringify(Reports2),
        type: "POST",
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        async: 'false',
        //success: function (result) {

        //},
        success: function (result) {

            //debugger;
            //alert(result[0].Hours);

            $('#nm2').text(result.BookedHours[0].LastName + ' ,' + result.BookedHours[0].FirstName);
            $('#rn2').text(result.BookedHours[0].RankName);
            $('#yr2').text(result.BookedHours[0].Year);
            $('#mn2').text(result.BookedHours[0].MonthName);

            $('#sptotalnormalhrs2').text(result.BookedHours[0].TotalNormalHours);
            $('#sptotalovertimehrs2').text(result.BookedHours[0].TotalOvertimeHours);
            $('#sptotal2').text(result.BookedHours[0].TotalHours);
            $('#sptotalRest2').text(result.BookedHours[0].TotalRestHours);

            $('#seamanfooter2').text(result.BookedHours[0].LastName + ' ' + result.BookedHours[0].FirstName);


            $.each(result.BookedHours, function (index, item) {
                if (item != null) {
                    //debugger;
                    //loop in table to find the row corresponding to the date
                    //get tr corresponding to that date 
                    var tr = '#' + item.BookDate + '_';
                    //var tr = $('#15');
                    var tdnum = 0;
                    // alert($('#schedule tr #15').val());
                    $(tr).children('td').each(function () {
                        // debugger;
                        if (tdnum == 0) tdnum++
                        else if (tdnum > 0 && tdnum < 25) {
                            //debugger;
                            var hr = item.Hours.substring(tdnum - 1, tdnum);
                            tdnum++;
                            if (hr == "1") {
                                //$(this).html('&#9724;');
                                // $(this).html(unescapeHtml('&lt;div style=&quot;border: 2px solid #000;width:20px; height:14px;background: #000;margin: 4px; &quot;&gt;&lt;div style=&quot;border: 2px solid #000;width:9px; height:10px;background:#fff;&quot;&gt;&lt;/div&gt;&lt;/div&gt;'));//&#9724;
                                $(this).html(unescapeHtml('&lt;div style=&quot;width:18px;height:8px;border:1px solid #000; margin-top:8px; background:#000;margin-left:2px;&quot;&gt;&lt;/div&gt;'));//&#9724;

                            }
                            else if (hr == "3") //01
                            {
                                // $(this).html(unescapeHtml('&lt;div style=&quot;border: 4px solid #000;width:16px; height:10px;background: #fff;margin: 4px; &quot;&gt;&lt;div style=&quot;border: 2px solid #000;width:3px; height:7px;background:#000;&quot;&gt;&lt;/div&gt;&lt;/div&gt;'));//&#9703;
                                $(this).html(unescapeHtml('&lt;div style=&quot;width:9px;height:8px;border:1px solid #000; background:#000; float:left; margin-top:8px; margin-left:2px;&quot;&gt;&lt;/div&gt; &lt;div style=&quot;width:9px;height:8px; float:right; margin-top:8px;border:1px solid #000; background:#fff; margin-right:4px;&quot;&gt;&lt;/div&gt;'));//&#9724;
                            }
                            else if (hr == "4") //10
                            {
                                //$(this).html(unescapeHtml('&lt;div style=&quot;border: 2px solid #000;width:20px; height:14px;background: #000;margin: 4px; &quot;&gt;&lt;div style=&quot;border: 2px solid #000;width:9px; height:10px;background:#fff;&quot;&gt;&lt;/div&gt;&lt;/div&gt;'));//&#9704;
                                //$(this).html(unescapeHtml('&lt;div style=&quot;border: 4px solid #000;width:16px; height:10px;background: #fff;margin: 4px; &quot;&gt;&lt;div style=&quot;border: 2px solid #000;width:3px; height:7px;background:#000;&quot;&gt;&lt;/div&gt;&lt;/div&gt;'));//&#9703;
                                // $(this).html(unescapeHtml('&lt;div style=&quot;width:9px;height:8px;border:1px solid #000; background:#fff; float:left; margin-top:8px; margin-left:2px;&quot;&gt;&lt;/div&gt; &lt;div style=&quot;width:9px;height:8px; float:right; margin-top:8px;border:1px solid #000; background:#000; margin-right:4px;&quot;&gt;&lt;/div&gt;'));//&#9704;
                            }

                        }
                        else if (tdnum == 25) //normal col
                        {
                            //debugger;
                            $(this).html(item.NormalWorkingHours);

                            tdnum++;
                        }
                        else if (tdnum == 26) { //overtime
                            $(this).html(item.OvertimeHours);

                            tdnum++;
                        }
                        else if (tdnum == 27) { //total 
                            $(this).html(item.TotalWorkedHours);

                            tdnum++;
                        }
                        else if (tdnum == 28) { //rest 
                            $(this).html(item.MinTwentyFourHourrest);

                            tdnum++;
                        }
                        else if (tdnum == 29) { //comments 
                            $(this).html(item.Comment);
                            tdnum++;
                        }
                        else if (tdnum == 30) { //min rest in 24  
                            $(this).html(item.MaxRestPeriodInTwentyFourHours);
                            tdnum++;
                        }
                        else if (tdnum == 31) { //min rest in 7  
                            $(this).html(item.MinSevenDayRest);
                            tdnum++;
                        }

                    });


                }
                //alert(item);
            });

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

function DisableRowForUser() {
    var purl = $('#GetPlusOneDayAdjustmentValueForUser').val();

    $.ajax({
        url: purl,
        data: JSON.stringify({ monthyear: $('.monthYearPicker').val() }),
        type: "POST",
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        async: 'false',
        success: function (result) {
            if (result != null) {

                console.log('In Plus One');
                console.log(result.BookedHours);
                console.log(result.BookedHours.length);
                for (var i = 0; i < result.BookedHours.length; i++) {
                    var r = result.BookedHours[i].AdjustmentDate;
                    var disabledrow = $('#' + r + '');
                    $(disabledrow).children('td,th').css('background-color', 'grey');
                }
            }
        }
    });

    //var disablecol = $('#h16').index();
    //$('td, th').filter(':nth-child(' + (disablecol + 1) + ')').css('background-color', 'grey');

    //var disabledrow = $('#16');
    //$(disabledrow).children('td,th').css('background-color', 'grey');
}

//function PrintReport1ForUser() {
//    //alert('hi');
//    var htmlstr = '';
//    var statustext = false;
//    var printurl = $('#printReport1ForUser').val();

//    $.ajax({
//        url: printurl,
//        data: JSON.stringify({ monthyear: $('.monthYearPicker').val(), crewID: $('#ddlCrew').val() }),
//        type: "POST",
//        contentType: "application/json;charset=utf-8",
//        dataType: "json",
//        async: false,
//        success: function (result) {
//            //debugger;

//            htmlstr = result;
//            statustext = true;
//        },
//        error: function (errormessage) {
//            console.log(errormessage.responseText);
//        }
//    });

//    if (statustext) {
//        $('#dvprint').val(htmlstr);
//        var divtoprint = $('#dvprint');

//        Popup1ForUser(htmlstr);
//    }

//}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



function PrintReport2ForUser() {
    //alert('hi');
    var htmlstr = '';
    var statustext = false;
    var printurl = $('#printReport2ForUser').val();

    Popup2ForUser('');

    //$.ajax({
    //    url: printurl,
    //    data: JSON.stringify({ 'letterText': $('#txtbodytext').text() }),
    //    type: "POST",
    //    contentType: "application/json;charset=utf-8",
    //    dataType: "json",
    //    async: false,
    //    success: function (result) {
    //        //debugger;

    //        htmlstr = result;
    //        statustext = true;
    //    },
    //    error: function (errormessage) {
    //        console.log(errormessage.responseText);
    //    }
    //});

    //if (statustext) {


    //GetDayWiseCrewDataPrint();

}



function Popup2ForUser(data) {
    var mywindow = window.open('', '', 'left=0,top=0,width=1600,height=1400');

    var is_chrome = Boolean(mywindow.chrome);

    mywindow.document.write('<html><head><title></title>');
    mywindow.document.write('</head><body >');
    mywindow.document.write($('#dvprint2').html());
    mywindow.document.write('</body></html>');
    mywindow.document.close(); // necessary for IE >= 10 and necessary before onload for chrome
    is_chrome = false;
    //alert(is_chrome);
    if (is_chrome) {
        mywindow.onload = function () { // wait until all resources loaded 
            mywindow.focus(); // necessary for IE >= 10
            mywindow.print();  // change window to mywindow
            mywindow.close();// change window to mywindow
        };
    }
    else {
        mywindow.document.close(); // necessary for IE >= 10
        mywindow.focus(); // necessary for IE >= 10
        mywindow.print();
        mywindow.close();
    }

    return true;
}



function loadDataForUser() {
    var loadposturl = $('#loaddataForUser').val();
    $.ajax({
        url: loadposturl,
        type: "GET",
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        success: function (result) {
            SetUpGridForUser();

        },
        error: function (errormessage) {
            console.log(errormessage.responseText);
        }
    });
}

function SetUpGridForUser() {

    SetUpPrintGridForUser();


    var loadposturl = $('#loaddataForUser').val();

    //do not throw error
    $.fn.dataTable.ext.errMode = 'none';

    //check if datatable is already created then destroy iy and then create it
    if ($.fn.dataTable.isDataTable('#certtable')) {
        table = $('#certtable').DataTable();
        table.destroy();
    }

    var Reports = {

        SelectedMonthYear: $('.monthYearPicker').val(),
        CrewID: $('#ddlCrew').val()
    };

    console.log(Reports);

    $("#certtable").DataTable({
        "processing": true, // for show progress bar
        "serverSide": true, // for process server side
        "filter": false, // this is for disable filter (search box)
        "orderMulti": false, // for disable multiple column at once
        "bLengthChange": false, //disable entries dropdown 
        "paging": false,
        "ajax": {
            "url": loadposturl,
            "data": Reports,

            "type": "POST",
            "datatype": "json"
        },
        "columns": [
            {
                "data": "BookDate", "name": "BookDate", "autoWidth": true
            },
            {
                "data": "WorkDate", "name": "BookDate", "autoWidth": true
            },
            {
                "data": "NormalWorkingHours", "name": "NormalHours", "autoWidth": true
            },
            {
                "data": "OvertimeHours", "name": "Overtime", "autoWidth": true
            },
            {
                "data": "TotalWorkedHours", "name": "TotalHours", "autoWidth": true
            },
            {
                "data": "FomattedComplianceInfo", "name": "ComplianceErrors", "autoWidth": true
            },
            {
                "data": "Comment", "name": "Comment", "autoWidth": true
            }
            //{
            //    "data": "ID", "width": "50px", "render": function (data) {
            //        return '<a href="#" onclick="GetShipByID(' + data + ')">Edit</a>';
            //    }
            //}

        ]
    });
}

function GetHours2ForUser() {

    //alert($('textarea#Comments').val());

    var posturl = $('#Showreport3ForUser').val();
    // var GetWorkingHours = $('#GetWorkingHours').val();
    var totalNormal = 0;
    var totalOvertime = 0;
    var total = 0;
    var totalRest = 0;

    var Reports = {
        //  CrewID: $('#ddlCrew').val(),
        SelectedMonthYear: $('.monthYearPicker').val(),

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

            //$('#nm').text(result.BookedHours[0].LastName + ' ,' + result.BookedHours[0].FirstName);
            //$('#rn').text(result.BookedHours[0].RankName);
            //$('#yr').text(result.BookedHours[0].Year);
            //$('#mn').text(result.BookedHours[0].MonthName);

            //$('#sptotalnormalhrs').text(result.BookedHours[0].TotalNormalHours);
            //$('#sptotalovertimehrs').text(result.BookedHours[0].TotalOvertimeHours);
            //$('#sptotal').text(result.BookedHours[0].TotalHours);
            //$('#sptotalRest').text(result.BookedHours[0].TotalRestHours);

            //$('#seamanfooter').text(result.BookedHours[0].LastName + ' ' + result.BookedHours[0].FirstName);


            $.each(result.BookedHours, function (index, item) {
                if (item != null) {
                    //debugger;
                    //loop in table to find the row corresponding to the date
                    //get tr corresponding to that date 
                    var tr = '#' + item.BookDate;
                    //var tr = $('#15');
                    var tdnum = 0;
                    // alert($('#schedule tr #15').val());
                    $(tr).children('td').each(function () {
                        // debugger;
                        if (tdnum == 0) tdnum++
                        else if (tdnum > 0 && tdnum < 25) {
                            //debugger;
                            var hr = item.Hours.substring(tdnum - 1, tdnum);
                            tdnum++;
                            if (hr == "1") {
                                $(this).html('&#9673;');
                            }
                            else if (hr == "3") //01
                            {
                                $(this).html('&#9680;');
                            }
                            else if (hr == "4") //10
                            {
                                $(this).html('&#9681;');
                            }

                        }
                        else if (tdnum == 25) //normal col
                        {
                            //debugger;
                            $(this).html(item.NormalWorkingHours);

                            tdnum++;
                        }
                        else if (tdnum == 26) { //overtime
                            $(this).html(item.OvertimeHours);

                            tdnum++;
                        }
                        else if (tdnum == 27) { //total 
                            $(this).html(item.TotalWorkedHours);

                            tdnum++;
                        }
                        else if (tdnum == 28) { //rest 
                            $(this).html(item.MinTwentyFourHourrest);

                            tdnum++;
                        }
                        else if (tdnum == 29) { //comments 
                            $(this).html(item.Comment);
                            tdnum++;
                        }
                        else if (tdnum == 30) { //min rest in 24  
                            $(this).html(item.MaxRestPeriodInTwentyFourHours);
                            tdnum++;
                        }
                        else if (tdnum == 31) { //min rest in 7  
                            $(this).html(item.MinSevenDayRest);
                            tdnum++;
                        }

                    });


                }
                //alert(item);
            });

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

function SetUpPrintGridForUser() {
    var loadposturl = $('#loaddataForUser').val();

    //do not throw error
    $.fn.dataTable.ext.errMode = 'none';

    //check if datatable is already created then destroy iy and then create it
    if ($.fn.dataTable.isDataTable('#certtable_print')) {
        table = $('#certtable_print').DataTable();
        table.destroy();
    }

    var Reports = {

        SelectedMonthYear: $('.monthYearPicker').val(),
        CrewID: $('#ddlCrew').val()
    };

    console.log(Reports);

    $("#certtable_print").DataTable({
        "processing": true, // for show progress bar
        "serverSide": true, // for process server side
        "filter": false, // this is for disable filter (search box)
        "orderMulti": false, // for disable multiple column at once
        "bLengthChange": false, //disable entries dropdown
        "paging": false,
        "ajax": {
            "url": loadposturl,
            "data": Reports,

            "type": "POST",
            "datatype": "json"
        },
        "columns": [
            {
                "data": "BookDate", "name": "BookDate", "autoWidth": true
            },
            {
                "data": "WorkDate", "name": "BookDate", "autoWidth": true
            },
            {
                "data": "NormalWorkingHours", "name": "NormalHours", "autoWidth": true
            },
            {
                "data": "OvertimeHours", "name": "Overtime", "autoWidth": true
            },
            {
                "data": "TotalWorkedHours", "name": "TotalHours", "autoWidth": true
            },
            {
                "data": "FomattedComplianceInfo", "name": "ComplianceErrors", "autoWidth": true
            }
            //{
            //    "data": "ID", "width": "50px", "render": function (data) {
            //        return '<a href="#" onclick="GetShipByID(' + data + ')">Edit</a>';
            //    }
            //}

        ]
    });


}

function PrintWorkAndRestHoursForUser() {
    var data = [];
    var res = [];
    var day = 1;
    var posturl = $('#pdfreport').val();
    var loopcounter = 0;

    var totalNormal = 0;
    var totalOvertime = 0;
    var total = 0;
    var totalRest = 0;

    var Reports = {
        CrewID: $('#ddlCrew').val(),
        SelectedMonthYear: $('.monthYearPicker').val()

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

            // selectedVessel = result.BookedHours[0].Vessel;
            //selectedCrew = result.BookedHours[0].Crew;
            // console.log(result);

            $.each(result, function (index, item) {
                if (item != null) {
                    //console.log(item);
                    data.push([
                        {
                            text: item.BookDate
                        },
                        {
                            text: item.WorkDate
                        },
                        {
                            text: item.NormalWorkingHours
                        },
                        {
                            text: item.OvertimeHours

                        },
                        {
                            text: item.TotalWorkedHours

                        },
                        {
                            text: item.FomattedComplianceInfo
                        }


                    ]);

                }
            });


            //for (var i = 1; i <= 6; i++) {


            var docDefinition = {
                pageSize: 'A3',
                pageOrientation: 'landscape',

                content: [
                    {
                        text: [
                            {
                                text: "Work and Rest Hours - Variance ",
                                style: "header"
                            },
                            {
                                text: "",
                                style: "anotherStyle"
                            },
                        ]
                    },
                    {
                        text: [
                            {
                                text: "Vessel:",
                                style: "anotherStyle"
                            },
                            {
                                text: "                                                                                                                                  Crew: ",
                                style: "anotherStyle"
                            },
                        ]
                    },
                    // {
                    //  canvas: [
                    //       {
                    //            type: 'line',
                    //  //          x1: 0,
                    //          y1: 5,
                    //           x2: 535,
                    //           y2: 5,
                    //           lineWidth: 0.5
                    //       }
                    //   ]
                    // },

                    {
                        text: [
                            {
                                text: "",
                                style: "header"
                            },
                            {
                                text: "",
                                style: "anotherStyle"
                            },
                        ]
                    },
                    {
                        text: [
                            {
                                text: "Reporting Period:",
                                style: "anotherStyle"
                            },
                            {
                                text: "                                                                                                                Department: ",
                                style: "anotherStyle"
                            },
                        ]
                    },
















                    {
                        style: "tblStyle1",
                        table: {
                            widths: [170, 170, 170, 170, 170, 170],
                            headerRows: 1,
                            body: [
                                ['Day', 'Date', 'Normal Hours', 'Overtime', 'Total Hours', 'Compliance Errors'],
                            ]
                        }
                    },


                    {
                        style: "tblStyle",
                        table: {
                            widths: [170, 170, 170, 170, 170, 170],
                            headerRows: 1,
                            body: data
                        }
                    },














                    {
                        text: [
                            {
                                text: "   ",
                                style: "anotherStyle"
                            },
                            {
                                text: "   ",
                                style: "anotherStyle"
                            },
                            {
                                text: "   ",
                                style: "anotherStyle"
                            }

                        ]
                    },

                ],
                styles: {
                    header: {
                        fontSize: 30,
                        bold: true
                    },
                    anotherStyle: {
                        fontSize: 20,
                        // italics: true,
                        // alignment: 'right'
                    },
                    tblStyle1: {
                        fontSize: 20,
                        // italics: true,
                        // alignment: 'right'
                    },
                    tblStyle: {
                        fontSize: 18,
                        // italics: true,
                        // alignment: 'right'
                    },
                    Margin: {
                        fontSize: 4.8,

                        //	bold: true,
                        alignment: 'right',
                        margin: [282, 0, 0, 282]
                    },
                }
            }

            pdfMake.createPdf(docDefinition).download('daywisecrew.pdf');

            //}
        },
        error: function (errormessage) {
            console.log(errormessage.responseText);
        }
    });


    //for (var i = 0; i < tsdata.length; i = i + 2) {
    //    res[loopcounter] = tsdata.charAt(i) + tsdata.charAt(i + 1);
    //    loopcounter++;
    //}






    //alert(data);
    //console.log(data[2][1]);







}