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

    var loadposturl = $('#loaddatareport').val();
    //do not throw error
    $.fn.dataTable.ext.errMode = 'none';

    //check if datatable is already created then destroy iy and then create it
    if ($.fn.dataTable.isDataTable('#Listtable')) {
        table = $('#Listtable').DataTable();
        table.destroy();
    }

    $("#Listtable").DataTable({
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
                "data": "CrewName", "name": "CrewName", "autoWidth": true
            },
            {
                "data": "IsLocusTested", "name": "IsLocusTested", "autoWidth": true
            },
            {
                "data": "IsMassTested", "name": "IsMassTested", "autoWidth": true
            },
            {
                "data": "IsPSQ30Tested", "name": "IsPSQ30Tested", "autoWidth": true
            },
            {
                "data": "IsBeckTested", "name": "IsBeckTested", "autoWidth": true
            },
            {
                "data": "IsZ1Tested", "name": "IsZ1Tested", "autoWidth": true
            },
            {
                "data": "IsZ2Tested", "name": "IsZ2Tested", "autoWidth": true
            },
            {
                "data": "IsRoseTested", "name": "IsRoseTested", "autoWidth": true
            },
            {
                "data": "IsEmotionalTested", "name": "IsEmotionalTested", "autoWidth": true
            },
            {
                "data": "PostJoiningDate", "name": "PostJoiningDate", "autoWidth": true
            }
        ]
    });
}
