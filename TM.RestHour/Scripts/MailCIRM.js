
function Popup22(data) {

    var mywindow = window.open('', '', 'left=0,top=0,width=1600,height=1400');

    var is_chrome = Boolean(mywindow.chrome);

    mywindow.document.write('<html><head><title></title>');
    mywindow.document.write('</head><body >');
    mywindow.document.write($('#dvprint22').html());
    mywindow.document.write('</body></html>');

    //SetUpPrintGridReport2();

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

function SetUpPrintGridReport2() {
    var loadposturl = $('#loaddata22').val();

    //do not throw error
    $.fn.dataTable.ext.errMode = 'none';

    //check if datatable is already created then destroy iy and then create it
    if ($.fn.dataTable.isDataTable('#certtable_print2')) {
        table = $('#certtable_print2').DataTable();
        table.destroy();
    }

    // alert('hh');
    var table = $("#certtable_print2").DataTable({
        "dom": 'Bfrtip',
        "rowReorder": false,
        "ordering": false,

        "filter": false, // this is for disable filter (search box)
        "orderMulti": false, // for disable multiple column at once
        "bLengthChange": false, //disable entries dropdown
        "paging": false,
        "bInfo": false,

        "ajax": {
            "url": loadposturl,
            "data": JSON.stringify({ equipmentsList: table }),      //////////////////////////////////// Deep /////////////////////////////////
            "type": "POST",
            "datatype": "json"
        },
        "columns": [
            //{
            //    "data": "Order", "name": "Order", "autoWidth": true, "className": 'reorder'
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



function Popup33(data) {

    var mywindow = window.open('', '', 'left=0,top=0,width=1600,height=1400');

    var is_chrome = Boolean(mywindow.chrome);

    mywindow.document.write('<html><head><title></title>');
    mywindow.document.write('</head><body >');
    mywindow.document.write($('#dvprint33').html());
    mywindow.document.write('</body></html>');

    //SetUpPrintGridReport2();

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

function loadData33() {
    var loadposturl = $('#loaddata33').val();
    $.ajax({
        url: loadposturl,
        type: "GET",
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        success: function (result) {
            SetUpGrid33();

        },
        error: function (errormessage) {
            console.log(errormessage.responseText);
        }
    });
}

function SetUpGrid33() {
    var loadposturl = $('#loaddata33').val();

    //do not throw error
    $.fn.dataTable.ext.errMode = 'none';

    //check if datatable is already created then destroy iy and then create it
    if ($.fn.dataTable.isDataTable('#certtable_print3')) {
        table = $('#certtable_print3').DataTable();
        table.destroy();
    }

    // alert('hh');
    var table = $("#certtable_print3").DataTable({
        "dom": 'Bfrtip',
        "rowReorder": false,
        "ordering": false,

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
            //    "data": "Order", "name": "Order", "autoWidth": true, "className": 'reorder'
            //},
            {
                "data": "EquipmentsName", "name": "EquipmentsName", "autoWidth": true
            },
            {
                "data": "Quantity", "name": "Quantity", "autoWidth": true
            },
            {
                "data": "Comment", "name": "Comment", "autoWidth": true
            },
            {
                "data": "ExpiryDate", "name": "ExpiryDate", "autoWidth": true
            },
            {
                "data": "Location", "name": "Location", "autoWidth": true
            }

        ],
        "rowId": "EquipmentsID",
        "dom": "Bfrtip"
    });
}
