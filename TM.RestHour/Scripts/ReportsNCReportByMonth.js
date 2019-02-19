function PrintPdf() {

    //get data 
    var posturl = $('#Reportsadd9').val();
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

function GetDayWiseCrewData() {

    var posturl = $('#Showreport19').val();
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
                $('#yr').text(result.BookedHours[0].Year);
                $('#mn').text(result.BookedHours[0].MonthName);



                var positionCounter = 0;;
                $.each(result.BookedHours, function (index, item) {
                    if (item != null) {

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
                                    $(this).html(result.BookedHours[index].LastName + ' ' + result.BookedHours[index].FirstName);

                                    //tdnum++;
                                }
                                if (tdnum == 1) //Nationality
                                {
                                    //debugger;
                                    $(this).html(result.BookedHours[index].Nationality);


                                }
                                if (tdnum == 2) //RankName
                                {
                                    //debugger;
                                    $(this).html(result.BookedHours[index].RankName);


                                }

                                else if (tdnum > 2 && tdnum < 33) {
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
                                    $(this).html(result.BookedHours[index].LastName + ' ' + result.BookedHours[index].FirstName);

                                    //tdnum++;
                                }
                                if (tdnum == 1) //Nationality
                                {
                                    //debugger;
                                    $(this).html(result.BookedHours[index].Nationality);


                                }
                                if (tdnum == 2) //RankName
                                {
                                    //debugger;
                                    $(this).html(result.BookedHours[index].RankName);


                                }

                                else if (tdnum > 2 && tdnum < 33) {
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
    var posturl = $('#Showreport19').val();
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
                if (item != null) {
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
                            text: result.BookedHours[index].TotalWorkedHours,
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

function PrintReport2() {
    //alert('hi');
    var htmlstr = '';
    var statustext = false;
    var printurl = $('#printReport29').val();

    $.ajax({
        url: printurl,
        data: JSON.stringify({ 'letterText': $('#txtbodytext').text() }),
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
        $('#dvprint2').val(htmlstr);
        var divtoprint = $('#dvprint2');

        Popup2(htmlstr);
    }

}