
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
                "data": "ID", "width": "50px", "render": function (data) {
                    return '<a href="#" onclick="showDetail(' + data + ')"><i class="glyphicon glyphicon-edit" style="color:#000; margin-left: 9px;"></i></a>';
                }
            },
            {
                "data": "ID", "width": "50px", "render": function (data) {
                    return '<a href="#" onclick="showDelete(' + data + ')"><i class="glyphicon glyphicon-trash" style="color:#000; margin-left: 9px;"></i></a>';
                }
            }
        

        ]
    });
}

function SetUpGridForInactiv() {
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
                "data": "ID", "width": "50px", "render": function (data) {
                    return '<a href="#" onclick="showDetail(' + data + ')"><i class="glyphicon glyphicon-edit" style="color:#000; margin-left: 9px;"></i></a>';
                }
            }


        ]
    });
}