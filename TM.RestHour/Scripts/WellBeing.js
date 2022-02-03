
function GetNonComplianceDetails() {

    var posturl = $('#GetNonComplianceDetails').val();
    //debugger;
    var htmlstr2 = '';
    var statustext2 = false;

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