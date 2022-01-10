
function showDetail(id)
{
  
    //alert(id);
    var url = $('#newurl').val();

    window.location.href = url + "/Index?mode=update&crew=" + id;
}

function showDelete(id) {

   // confirm("Are you sure?");
    if (confirm("Are you sure?")) {
        // your deletion code
        var posturl = $('#newurl1').val();
        var redirecturl = $('#crewlisturl').val();

        var CrewDelete = {
            ID: id
        };

        $.ajax({
            url: posturl,
            data: JSON.stringify({ ID: id }),
            type: "POST",
            contentType: "application/json;charset=utf-8",
            dataType: "json",
            success: function (result) {
                //loadData();
                //$('#myModal').modal('hide');
                //showDetail(id);
                window.location.href = redirecturl;
            },
            error: function (errormessage) {
                console.log(errormessage.responseText);
            }
        });
    }
    return false;


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
            SetUpPrintGridReport();
        },
        error: function (errormessage) {
            console.log(errormessage.responseText);
        }
    });
}

function loadDataForInactiv() {
    var loadposturl = $('#loaddataForInactiv').val();
    $.ajax({
        url: loadposturl,
        type: "GET",
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        success: function (result) {
            SetUpGridForInactiv();

        },
        error: function (errormessage) {
            console.log(errormessage.responseText);
        }
    });
}


//['ID', 'Name', 'RankName', 'StartDate', 'Edit','Delete'],
function SetUpGrid() {

    SetUpPrintGridReport();
    var loadposturl = $('#loaddata').val();

    //do not throw error
    $.fn.dataTable.ext.errMode = 'none';

    //check if datatable is already created then destroy iy and then create it
    if ($.fn.dataTable.isDataTable('#CrewListtable')) {
        table = $('#CrewListtable').DataTable();
        table.destroy();
    }

    $("#CrewListtable").DataTable({
        "processing": true, // for show progress bar
        "serverSide": true, // for process server side
        "filter": false, // this is for disable filter (search box)
        "orderMulti": false, // for disable multiple column at once
        "bLengthChange": false, //disable entries dropdown
        "stateSave": true,
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
                "data": "RankName", "name": "RankName", "autoWidth": true
            },
            {
                "data": "StartDate", "name": "StartDate", "autoWidth": true
            },
            {
                "data": "EndDate", "name": "EndDate", "autoWidth": true
            },
            {
                "data": "ID", "width": "50px", "render": function (data) {
                    return '<a href="#" class="edit_Icon" onclick="showDetail(' + data + ')"><i class="fas fa-edit"></i></a>';
                }
            },
            {
                "data": "ID", "width": "50px", "render": function (data) {
                    return '<a href="#" class="delete_Icon" onclick="showDelete(' + data + ')"><i class="fas fa-trash"></i></a>';
                }
            }
        

        ]
    });
}

function SetUpGridForInactiv() {
    //SetUpPrintGridReport();

    var loadposturl = $('#loaddataForInactiv').val();

    //do not throw error
    $.fn.dataTable.ext.errMode = 'none';

    //check if datatable is already created then destroy iy and then create it
    if ($.fn.dataTable.isDataTable('#CrewListtableloaddataForInactiv')) {
        table = $('#CrewListtableloaddataForInactiv').DataTable();
        table.destroy();
    }

    $("#CrewListtableloaddataForInactiv").DataTable({
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
                "data": "Name", "name": "Name", "autoWidth": true
            },
            {
                "data": "RankName", "name": "RankName", "autoWidth": true
            },
            {
                "data": "StartDate", "name": "StartDate", "autoWidth": true
            },
            {
                "data": "EndDate", "name": "EndDate", "autoWidth": true
            },
            {
                "data": "ID", "width": "50px", "render": function (data) {
                    return '<a href="#"  class="edit_Icon" onclick="showDetail(' + data + ')"><i class="fas fa-edit"></i></a>';
                }
            }


        ]
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


function SetUpPrintGridReport() {
    var loadposturl2 = $('#loadprintreport').val();

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




        "stateSave": true,


        "ajax": {
            "url": loadposturl2,
            "type": "POST",
            "datatype": "json"
        },
        "columns": [
            {
                "data": "Name", "name": "Name", "autoWidth": true
            },
            {
                "data": "RankName", "name": "RankName", "autoWidth": true
            },
            {
                "data": "StartDate", "name": "StartDate", "autoWidth": true
            }
           
          
        ]
    });
}