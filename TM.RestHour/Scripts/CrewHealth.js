//function ShowChildren(childdata) {
//    var lposturl = $('#lcd').val();
//    var pcatId = childdata;

//    if ($.fn.dataTable.isDataTable('#childtable')) {
//        table = $('#childtable').DataTable();
//        table.destroy();
//    }

//    $("#childtable").DataTable({
//        "processing": true, // for show progress bar
//        "serverSide": true, // for process server side
//        "filter": false, // this is for disable filter (search box)
//        "orderMulti": false, // for disable multiple column at once
//        "bLengthChange": false, //disable entries dropdown
//        "bInfo": false,
//        "deferRender": true,
//        "ajax": {
//            "url": lposturl,
//            "type": "POST",
//            "data": {
//                ID: pcatId

//            },
//            "datatype": "json"
//        },

//        "columns": [

//            { "data": "Name", "name": "Name", "autoWidth": true },
//            // { "data": "FundCategoryName", "name": "FundCategoryName", "autoWidth": true }

//            //{
//            //    "data": "FundCategoryId", "width": "50px", "render": function (data) {
//            //        return '<a href="#" onclick="GetFundCategoryById(' + data + ')">Edit</a>';
//            //    }
//            //},
//            //{
//            //    "data": "FundCategoryId", "width": "50px", "render": function (d) {
//            //        //debugger;
//            //        return '<a href="#" onclick="Delete(' + d + ')">Delete</a>';
//            //    }
//            //}

//        ],

//        "rowId": "ID",
//        "dom": "Bfrtip",
//        "fnDrawCallback": function (oSettings) {
//            if ($('#childtable tr').length < 11) {
//                $('.dataTables_paginate').hide();
//            }
//        }
//    });
//}





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
    var loadposturl = $('#loaddata').val();

    //do not throw error
    $.fn.dataTable.ext.errMode = 'none';

    //check if datatable is already created then destroy iy and then create it
    if ($.fn.dataTable.isDataTable('#CrewHealthtable')) {
        table = $('#CrewHealthtable').DataTable();
        table.destroy();
    }
    
    // alert('hh');
    var table = $("#CrewHealthtable").DataTable({
        "dom": 'Bfrtip',
        "rowReorder": false,
        "ordering": false,
        "filter": false, // this is for disable filter (search box)

        "ajax": {
            "url": loadposturl,
            "type": "POST",
            "datatype": "json"
        },
        "columns": [
            {
                "data": "CrewName", "name": "CrewName", "autoWidth": true
            },
            {
                "data": "Weight", "name": "Weight", "autoWidth": true
            },
            {
                "data": "BMI", "name": "BMI", "autoWidth": true
            },
            //{
            //    "data": "BP", "name": "BP", "autoWidth": true
            //},
            {
                "data": "BloodSugarLevel", "name": "BloodSugarLevel", "autoWidth": true
            },
            {
                "data": "Systolic", "name": "Systolic", "autoWidth": true
            },
            {
                "data": "Diastolic", "name": "Diastolic", "autoWidth": true
            },
            {
                "data": "UrineTest", "name": "UrineTest", "autoWidth": true
            },
            {
                "data": "UnannouncedAlcohol", "name": "UnannouncedAlcohol", "autoWidth": true
            },
            {
                "data": "AnnualDH", "name": "AnnualDH", "autoWidth": true
            },
            {
                "data": "Month", "name": "Month", "autoWidth": true
            }
           

        ],
        "rowId": "MedicalAdvisoryID",
        "dom": "Bfrtip"
    });
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
                "data": "CrewName", "name": "CrewName", "autoWidth": true
            },
            {
                "data": "Weight", "name": "Weight", "autoWidth": true
            },
            {
                "data": "BMI", "name": "BMI", "autoWidth": true
            },
            //{
            //    "data": "BP", "name": "BP", "autoWidth": true
            //},
            {
                "data": "BloodSugarLevel", "name": "BloodSugarLevel", "autoWidth": true
            },
            {
                "data": "Systolic", "name": "Systolic", "autoWidth": true
            },
            {
                "data": "Diastolic", "name": "Diastolic", "autoWidth": true
            },
            {
                "data": "UrineTest", "name": "UrineTest", "autoWidth": true
            },
            {
                "data": "UnannouncedAlcohol", "name": "UnannouncedAlcohol", "autoWidth": true
            },
            {
                "data": "AnnualDH", "name": "AnnualDH", "autoWidth": true
            },
            {
                "data": "Month", "name": "Month", "autoWidth": true
            }

        ]
    });
}


function GetCrewDetailsForHealthByID() {

    var x = $("#GetCrewDetailsForHealth").val();
    $.ajax({
        url: x,
        data:
        {
            crewID: $('#ddlCrew').val()
        },
        type: "GET",
       // data: JSON.stringify({ 'ID': ID }),
        contentType: "application/json;charset=UTF-8",
        dataType: "json",
        success: function (result) {
            //debugger;
            //$('#ID').val(result.ID);
            $('#Name').val(result.Name);
            $('#DOB').val(result.DOB);
            $('#RankName').val(result.RankName);

            $('#ActiveFrom').val(result.ActiveFrom);

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

function GetCrewDetailsForHealthByID2() {

    var x = $("#GetCrewDetailsForHealth2").val();
    $.ajax({
        url: x,
        data:
        {
            crewID: $('#ddlCrew').val()
        },
        type: "GET",
        // data: JSON.stringify({ 'ID': ID }),
        contentType: "application/json;charset=UTF-8",
        dataType: "json",
        success: function (result) {
            //debugger;
            //$('#ID').val(result.ID);
            $('#Name').val(result.Name);
            $('#DOB').val(result.DOB);
            $('#RankName').val(result.RankName);

            $('#ActiveFrom').val(result.ActiveFrom);
            $('#LatestUpdate').val(result.LatestUpdate);
            $('#FirstName').val(result.FirstName);
            $('#MiddleName').val(result.MiddleName);
            $('#LastName').val(result.LastName);
            $('#PassportSeamanPassportBook').val(result.PassportSeamanPassportBook);
            $('#Seaman').val(result.Seaman);
            $('#POB').val(result.POB);

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


function SaveServiceTerms() {
    //debugger;
    var saveServiceTerms = $('#saveServiceTerms').val();
    //var res = validate();
    //if (res == false) {
    //    return false;
    //}
    var ServiceTerms = {
        CrewID: $('#ddlCrew').val(),
        ActiveTo: $('#LatestUpdate').val(),
    };
    //debugger;
    $.ajax({
        url: saveServiceTerms,
        data: JSON.stringify(ServiceTerms),
        type: "POST",
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        success: function (response) {
            //debugger;
            if (response.result == 'Redirect') {
                //show successfull message
                alert('Data Saved Successfully');
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






function loadDataServiceTerms() {
    var loadposturl = $('#loaddataServiceTerms').val();
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

function SetUpGridServiceTerms() {
    var loadposturl = $('#loaddataServiceTerms').val();

    //do not throw error
    $.fn.dataTable.ext.errMode = 'none';

    //check if datatable is already created then destroy iy and then create it
    if ($.fn.dataTable.isDataTable('#CrewServiceTerms')) {              
        table = $('#CrewServiceTerms').DataTable();
        table.destroy();
    }

    // alert('hh');
    var table = $("#CrewServiceTerms").DataTable({
        "dom": 'Bfrtip',
        "rowReorder": false,
        "ordering": false,
        "filter": false, // this is for disable filter (search box)

        "ajax": {
            "url": loadposturl,
            "type": "POST",
            "datatype": "json"
        },
        "columns": [
            {
                "data": "Name", "name": "Name", "autoWidth": true
            },
            {
                "data": "ActiveFrom", "name": "ActiveFrom", "autoWidth": true
            },
            {
                "data": "ActiveTo", "name": "ActiveTo", "autoWidth": true
            }

        ],
        "rowId": "MedicalAdvisoryID",
        "dom": "Bfrtip"
    });
}









function GetJoiningMedicalFileDatawByID() {

    var x = $("#GetJoiningreportUrl").val();
    var cId = $('#ddlCrew').val();
    $.ajax({
        url: x,
        data:
        {
            CrewId: cId
        },
        type: "GET",
        contentType: "application/json;charset=UTF-8",
        dataType: "json",
        success: function (result) {
            //debugger;
            console.log(result);
            $('#ifrjoiningreport').attr('src', result);

        },
        error: function (errormessage) {
            //debugger;
            console.log(errormessage.responseText);
        }
    });
}





//////////////////////////////////////////////////////////////////////////



function loadData22() {
    var loadposturl = $('#loaddata22').val();
    $.ajax({
        url: loadposturl,
        type: "GET",
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        success: function (result) {
            SetUpPrintGridReport2();

        },
        error: function (errormessage) {
            console.log(errormessage.responseText);
        }
    });
}



function Popup22(data) {


    var mywindow = window.open('', '', 'left=0,top=0,width=1600,height=1400');

    var is_chrome = Boolean(mywindow.chrome);

    mywindow.document.write('<html><head><title></title>');
    mywindow.document.write('</head><body >');
    mywindow.document.write($('#dvprint22').html());
    mywindow.document.write('</body></html>');

    SetUpPrintGridReport2();

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




function SetUpPrintGridReport2() {
    var loadposturl = $('#loaddata22').val();

    //do not throw error
    $.fn.dataTable.ext.errMode = 'none';

    //check if datatable is already created then destroy iy and then create it
    if ($.fn.dataTable.isDataTable('#certtable_print2')) {
        table = $('#certtable_print2').DataTable();
        table.destroy();
    }

    $("#certtable_print2").DataTable({
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

            //{
            //    "data": "MedicineID", "name": "MedicineID", "autoWidth": true
            //},
            {
                "data": "MedicineName", "name": "MedicineName", "autoWidth": true
            },
            {
                "data": "Quantity", "name": "Quantity", "autoWidth": true
            },
            {
                "data": "ExpiryDate", "name": "ExpiryDate", "autoWidth": true
            },
            {
                "data": "Location", "name": "Location", "autoWidth": true
            }

        ],
        "rowId": "MedicineID",
        "dom": "Bfrtip"
    });
}

function SaveCrewTemperature() {
    //debugger;
    var savecrewtemperature = $('#savecrewtemperature').val();
    //var res = validate();
    //if (res == false) {
    //    return false;
    //}
    var crewTemperature = {
        CrewID: $('#ddlCrew').val(),
        Temperature: $('#Temperature').val(),
        Unit: $('#ddlUnit').val(),
        ReadingDate: $('#ReportsDate').val(),
        ReadingTime: $('#ddlTime').val(),
        Comment: $('#Remarks').val(),
    };
    //debugger;
    $.ajax({
        url: savecrewtemperature,
        data: JSON.stringify(crewTemperature),
        type: "POST",
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        success: function (result) {
            
            if (result >0) {
                //show successfull message
                alert('Data Saved Successfully');
             // window.location = response.url;

                $('#ddlCrew').val('');
                $('#Temperature').val('');
                $('#ddlUnit').val('');
                $('#ReportsDate').val('');
                $('#ddlTime').val('');
                $('#Remarks').val('');

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