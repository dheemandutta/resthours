
function GetTableData() {
    var loadposturl = $('#loaddatareport').val();
    $.ajax({
        url: loadposturl,
        type: "GET",
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        success: function (result) {

            console.log(result);

            console.log(result.data.MentalHealthPostJoiningList);
            SetUpGrid(result.data.MentalHealthPostJoiningList);

            console.log(result.data.MentalHealthPreSignOffList);
            SetUpGridPreSignOff(result.data.MentalHealthPreSignOffList);
        },
        error: function (errormessage) {
            console.log(errormessage.responseText);
        }
    });
}

function SetUpGrid(jsondata) {

    //do not throw error
    $.fn.dataTable.ext.errMode = 'none';

    //check if datatable is already created then destroy iy and then create it
    if ($.fn.dataTable.isDataTable('#Listtable')) {
        table = $('#Listtable').DataTable();
        table.destroy();
    }

    $("#Listtable").DataTable({
        "processing": true, // for show progress bar
        //"serverSide": true, // for process server side
        "filter": false, // this is for disable filter (search box)
        "orderMulti": false, // for disable multiple column at once
        "bLengthChange": false, //disable entries dropdown
        "stateSave": true,
        data: jsondata,
        //"ajax": {
        //    "url": loadposturl,
        //    "type": "POST",
        //    "datatype": "json"
        //},
        "columns": [
            {
                "data": "CrewName", "name": "CrewName", "autoWidth": true
            },
            {
                //"data": "IsLocusTested", "name": "IsLocusTested", "autoWidth": true
                "data": "IsLocusTested", "width": "50px", "render": function (data, type, row) {
                    if (data == true) {
                        return '<a style="border-radius: 5px;"><img src="/images/G.png" width="16" height="16"></a>';
                    }
                    else if (data == false) {
                        return '<a style="border-radius: 5px;"><img src="/images/R.png" width="16" height="16"></a>';
                    }
                }
            },
            {
                //"data": "IsMassTested", "name": "IsMassTested", "autoWidth": true
                "data": "IsMassTested", "width": "50px", "render": function (data, type, row) {
                    if (data == true) {
                        return '<a style="border-radius: 5px;"><img src="/images/G.png" width="16" height="16"></a>';
                    }
                    else if (data == false) {
                        return '<a style="border-radius: 5px;"><img src="/images/R.png" width="16" height="16"></a>';
                    }
                }
            },
            {
                //"data": "IsPSQ30Tested", "name": "IsPSQ30Tested", "autoWidth": true
                "data": "IsPSQ30Tested", "width": "50px", "render": function (data, type, row) {
                    if (data == true) {
                        return '<a style="border-radius: 5px;"><img src="/images/G.png" width="16" height="16"></a>';
                    }
                    else if (data == false) {
                        return '<a style="border-radius: 5px;"><img src="/images/R.png" width="16" height="16"></a>';
                    }
                }
            },
            {
                //"data": "IsBeckTested", "name": "IsBeckTested", "autoWidth": true
                "data": "IsBeckTested", "width": "50px", "render": function (data, type, row) {
                    if (data == true) {
                        return '<a style="border-radius: 5px;"><img src="/images/G.png" width="16" height="16"></a>';
                    }
                    else if (data == false) {
                        return '<a style="border-radius: 5px;"><img src="/images/R.png" width="16" height="16"></a>';
                    }
                }
            },
            {
                //"data": "IsZ1Tested", "name": "IsZ1Tested", "autoWidth": true
                "data": "IsZ1Tested", "width": "50px", "render": function (data, type, row) {
                    if (data == true) {
                        return '<a style="border-radius: 5px;"><img src="/images/G.png" width="16" height="16"></a>';
                    }
                    else if (data == false) {
                        return '<a style="border-radius: 5px;"><img src="/images/R.png" width="16" height="16"></a>';
                    }
                }
            },
            {
                //"data": "IsZ2Tested", "name": "IsZ2Tested", "autoWidth": true
                "data": "IsZ2Tested", "width": "50px", "render": function (data, type, row) {
                    if (data == true) {
                        return '<a style="border-radius: 5px;"><img src="/images/G.png" width="16" height="16"></a>';
                    }
                    else if (data == false) {
                        return '<a style="border-radius: 5px;"><img src="/images/R.png" width="16" height="16"></a>';
                    }
                }
            },
            {
                //"data": "IsRoseTested", "name": "IsRoseTested", "autoWidth": true
                "data": "IsRoseTested", "width": "50px", "render": function (data, type, row) {
                    if (data == true) {
                        return '<a style="border-radius: 5px;"><img src="/images/G.png" width="16" height="16"></a>';
                    }
                    else if (data == false) {
                        return '<a style="border-radius: 5px;"><img src="/images/R.png" width="16" height="16"></a>';
                    }
                }
            },
            {
                //"data": "IsEmotionalTested", "name": "IsEmotionalTested", "autoWidth": true
                "data": "IsEmotionalTested", "width": "50px", "render": function (data, type, row) {
                    if (data == true) {
                        return '<a style="border-radius: 5px;"><img src="/images/G.png" width="16" height="16"></a>';
                    }
                    else if (data == false) {
                        return '<a style="border-radius: 5px;"><img src="/images/R.png" width="16" height="16"></a>';
                    }
                }
            },
            {
                "data": "PostJoiningDate", "name": "PostJoiningDate", "autoWidth": true
            }
        ]
    });
}

function SetUpGridPreSignOff(jsondata) {

    //do not throw error
    $.fn.dataTable.ext.errMode = 'none';

    //check if datatable is already created then destroy iy and then create it
    if ($.fn.dataTable.isDataTable('#ListtablePreSignOff')) {
        table = $('#ListtablePreSignOff').DataTable();
        table.destroy();
    }

    $("#ListtablePreSignOff").DataTable({
        "processing": true, // for show progress bar
        //"serverSide": true, // for process server side
        "filter": false, // this is for disable filter (search box)
        "orderMulti": false, // for disable multiple column at once
        "bLengthChange": false, //disable entries dropdown
        "stateSave": true,
        data: jsondata,
        //"ajax": {
        //    "url": loadposturl,
        //    "type": "POST",
        //    "datatype": "json"
        //},
        "columns": [
            {
                "data": "CrewName", "name": "CrewName", "autoWidth": true
            },
            {
                "data": "IsLocusTested", "width": "50px", "render": function (data, type, row) {
                    if (data == true) {
                        return '<a style="border-radius: 5px;"><img src="/images/G.png" width="16" height="16"></a>';                       
                    }
                    else if (data == false) {
                        return '<a style="border-radius: 5px;"><img src="/images/R.png" width="16" height="16"></a>';
                    }
                }
            },
            {
                "data": "IsMassTested", "width": "50px", "render": function (data, type, row) {
                    if (data == true) {
                        return '<a style="border-radius: 5px;"><img src="/images/G.png" width="16" height="16"></a>';
                    }
                    else if (data == false) {
                        return '<a style="border-radius: 5px;"><img src="/images/R.png" width="16" height="16"></a>';
                    }
                }
            },
            {
                //"data": "IsPSQ30Tested", "name": "IsPSQ30Tested", "autoWidth": true
                "data": "IsPSQ30Tested", "width": "50px", "render": function (data, type, row) {
                    if (data == true) {
                        return '<a style="border-radius: 5px;"><img src="/images/G.png" width="16" height="16"></a>';
                    }
                    else if (data == false) {
                        return '<a style="border-radius: 5px;"><img src="/images/R.png" width="16" height="16"></a>';
                    }
                }
            },
            {
                //"data": "IsBeckTested", "name": "IsBeckTested", "autoWidth": true
                "data": "IsBeckTested", "width": "50px", "render": function (data, type, row) {
                    if (data == true) {
                        return '<a style="border-radius: 5px;"><img src="/images/G.png" width="16" height="16"></a>';
                    }
                    else if (data == false) {
                        return '<a style="border-radius: 5px;"><img src="/images/R.png" width="16" height="16"></a>';
                    }
                }
            },
            {
                //"data": "IsZ1Tested", "name": "IsZ1Tested", "autoWidth": true
                "data": "IsZ1Tested", "width": "50px", "render": function (data, type, row) {
                    if (data == true) {
                        return '<a style="border-radius: 5px;"><img src="/images/G.png" width="16" height="16"></a>';
                    }
                    else if (data == false) {
                        return '<a style="border-radius: 5px;"><img src="/images/R.png" width="16" height="16"></a>';
                    }
                }
            },
            {
                //"data": "IsZ2Tested", "name": "IsZ2Tested", "autoWidth": true
                "data": "IsZ2Tested", "width": "50px", "render": function (data, type, row) {
                    if (data == true) {
                        return '<a style="border-radius: 5px;"><img src="/images/G.png" width="16" height="16"></a>';
                    }
                    else if (data == false) {
                        return '<a style="border-radius: 5px;"><img src="/images/R.png" width="16" height="16"></a>';
                    }
                }
            },
            {
                //"data": "IsRoseTested", "name": "IsRoseTested", "autoWidth": true
                "data": "IsRoseTested", "width": "50px", "render": function (data, type, row) {
                    if (data == true) {
                        return '<a style="border-radius: 5px;"><img src="/images/G.png" width="16" height="16"></a>';
                    }
                    else if (data == false) {
                        return '<a style="border-radius: 5px;"><img src="/images/R.png" width="16" height="16"></a>';
                    }
                }
            },
            {
                //"data": "IsEmotionalTested", "name": "IsEmotionalTested", "autoWidth": true
                "data": "IsEmotionalTested", "width": "50px", "render": function (data, type, row) {
                    if (data == true) {
                        return '<a style="border-radius: 5px;"><img src="/images/G.png" width="16" height="16"></a>';
                    }
                    else if (data == false) {
                        return '<a style="border-radius: 5px;"><img src="/images/R.png" width="16" height="16"></a>';
                    }
                }
            },
            {
                "data": "PreSignOffDate", "name": "PreSignOffDate", "autoWidth": true
            }
        ]
    });
}
