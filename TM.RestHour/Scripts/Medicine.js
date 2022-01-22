function loadData2() {
    SetUpGrid2();
    loadData2Print();
}

function SetUpGrid2() {
    var loadposturl = $('#loaddata2').val();

    var Country = $('#CountryID').val();
    var Category = $('#Category').val();
    var NoOfCrew = $('#NoOfCrew').val();

    //do not throw error
    $.fn.dataTable.ext.errMode = 'none';

    //check if datatable is already created then destroy iy and then create it
    if ($.fn.dataTable.isDataTable('#Medicinetable')) {
        table = $('#Medicinetable').DataTable();
        table.destroy();
    }


    // alert('hh');
    var table = $("#Medicinetable").DataTable({
        "dom": 'Bfrtip',
        "rowReorder": false,
        "ordering": false,
        "filter": false, // this is for disable filter (search box)

        "ajax": {
            "url": loadposturl,
            "type": "POST",
            "datatype": "json",
            "data": {
                Country: Country,
                Category: Category,
                NoOfCrew: NoOfCrew
            },
        },
        "columns": [
            //{
            //    "data": "Order", "name": "Order", "autoWidth": true, "className": 'reorder'
            //},
            {
                "data": "MedicineName", "name": "MedicineName", "autoWidth": true
            },
            {
                "data": "ReqQty", "name": "ReqQty", "autoWidth": true
            },
            {
                "data": "Unit", "name": "Unit", "autoWidth": true
            },
            {
                "data": "BatchNo", "name": "BatchNo", "autoWidth": true
            },
            {
                "data": "BatchQuantity", "name": "BatchQuantity", "autoWidth": true
            },
            {
                "data": "PresentQuantity", "name": "PresentQuantity", "autoWidth": true
            },
            {
                "data": "ExpiryDate", "name": "ExpiryDate", "autoWidth": true
            },
            {
                "data": "Location", "name": "Location", "autoWidth": true
            },
            {
                "data": "PrescribedFor", "name": "PrescribedFor", "autoWidth": true
            }
            //,{
            //    "data": "MedicineID", "width": "50px", "render": function (data) {
            //        return '<a href="#" class="btn btn-info btn-sm" onclick="GetMedicineByID(' + data + ')"><i class="fas fa-edit"></i></a>';
            //    }
            //},
            //{
            //    "data": "MedicineID", "width": "50px", "render": function (d) {
            //        //debugger;
            //        return '<a href="#" class="btn btn-info btn-sm" onclick="DeleteMedicine(' + d + ')"><i class="fas fa-trash"></i></a>';
            //    }
            //}

        ],
        "rowId": "MedicineID",
        "dom": "Bfrtip"
    });
}





function loadData2Print() {
    SetUpGrid2Print();
}

function SetUpGrid2Print() {
    var loadposturl = $('#loaddata2Print').val();

    var Country = $('#CountryID').val();
    var Category = $('#Category').val();
    var NoOfCrew = $('#NoOfCrew').val();

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

        "ajax": {
            "url": loadposturl,
            "type": "POST",
            "datatype": "json",
            "data": {
                Country: Country,
                Category: Category,
                NoOfCrew: NoOfCrew
            },
        },
        "columns": [
            //{
            //    "data": "Order", "name": "Order", "autoWidth": true, "className": 'reorder'
            //},
            {
                "data": "MedicineName", "name": "MedicineName", "autoWidth": true
            },
            {
                "data": "ReqQty", "name": "ReqQty", "autoWidth": true
            },
            {
                "data": "Unit", "name": "Unit", "autoWidth": true
            },
            {
                "data": "BatchNo", "name": "BatchNo", "autoWidth": true
            },
            {
                "data": "BatchQuantity", "name": "BatchQuantity", "autoWidth": true
            },
            {
                "data": "PresentQuantity", "name": "PresentQuantity", "autoWidth": true
            },
            {
                "data": "ExpiryDate", "name": "ExpiryDate", "autoWidth": true
            },
            {
                "data": "Location", "name": "Location", "autoWidth": true
            },
            {
                "data": "PrescribedFor", "name": "PrescribedFor", "autoWidth": true
            }
            //,{
            //    "data": "MedicineID", "width": "50px", "render": function (data) {
            //        return '<a href="#" class="btn btn-info btn-sm" onclick="GetMedicineByID(' + data + ')"><i class="fas fa-edit"></i></a>';
            //    }
            //},
            //{
            //    "data": "MedicineID", "width": "50px", "render": function (d) {
            //        //debugger;
            //        return '<a href="#" class="btn btn-info btn-sm" onclick="DeleteMedicine(' + d + ')"><i class="fas fa-trash"></i></a>';
            //    }
            //}

        ],
        "rowId": "MedicineID",
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


