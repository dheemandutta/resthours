



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

//function SetUpGrid() {
//    var loadposturl = $('#loaddata').val();
//    //check if datatable is already created then destroy iy and then create it
//    if ($.fn.dataTable.isDataTable('#certtable')) {
//        table = $('#certtable').DataTable();
//        table.destroy();
//    }

//    $("#certtable").DataTable({
//        "processing": true, // for show progress bar
//        "serverSide": true, // for process server side
//        "filter": false, // this is for disable filter (search box)
//        "orderMulti": false, // for disable multiple column at once
//        "bLengthChange": false, //disable entries dropdown
//        "ajax": {
//            "url": loadposturl,
//            "type": "POST",
//            "datatype": "json"
//        },
//        "columns": [
//            {
//                "data": "RankName", "name": "RankName", "autoWidth": true
//            },
//              {
//                  "data": "Description", "name": "Description", "autoWidth": true
//              },
//                {
//                    "data": "Scheduled", "name": "Scheduled", "autoWidth": true
//                }
//                ,
//                  {
//                      data: "ID", "width": "50px", "render": function (d) {
//                          return '<a href="#" onclick="ShowChildren(' + d + ')">Crew</a>';
//                      }
//                  }
//            //{
//            //    "data": "ID", "width": "50px", "render": function (data) {
//            //        return '<a href="#" onclick="GetShipByID(' + data + ')">Edit</a>';
//            //    }
//            //}

//        ]
//    });
//}


function ShowChildren(childdata) {
    var lposturl = $('#lcd').val();
    var pcatId = childdata;

    //do not throw error
    $.fn.dataTable.ext.errMode = 'none';

    if ($.fn.dataTable.isDataTable('#childtable')) {
        table = $('#childtable').DataTable();
        table.destroy();
    }

    $("#childtable").DataTable({
        "processing": true, // for show progress bar
        "serverSide": true, // for process server side
        "filter": false, // this is for disable filter (search box)
        "orderMulti": false, // for disable multiple column at once
        "bLengthChange": false, //disable entries dropdown
        "bInfo": false,
        "deferRender": true,
        "ajax": {
            "url": lposturl,
            "type": "POST",
            "data": {
                ID: pcatId

            },
            "datatype": "json"
        },

        "columns": [

            { "data": "Name", "name": "Name", "autoWidth": true },
           // { "data": "FundCategoryName", "name": "FundCategoryName", "autoWidth": true }

                //{
                //    "data": "FundCategoryId", "width": "50px", "render": function (data) {
                //        return '<a href="#" onclick="GetFundCategoryById(' + data + ')">Edit</a>';
                //    }
                //},
                //{
                //    "data": "FundCategoryId", "width": "50px", "render": function (d) {
                //        //debugger;
                //        return '<a href="#" onclick="Delete(' + d + ')">Delete</a>';
                //    }
                //}

        ],

        "rowId": "ID",
        "dom": "Bfrtip",
        "fnDrawCallback": function (oSettings) {
            if ($('#childtable tr').length < 11 )
            {
                //$('.dataTables_paginate').hide();
                $('#childtable_paginate').hide();
            }
        }
    });
}