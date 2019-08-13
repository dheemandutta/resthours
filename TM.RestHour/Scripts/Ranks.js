function validate() {
    var isValid = true;

    if ($('#RankName').val().length === 0) {
        $('#RankName').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#RankName').css('border-color', 'lightgrey');
    }
    return isValid;
}
//SSG
function Add() {
    var posturl = $('#Rankadd').val();
    var res = validate();
    if (res == false) {
        return false;
    }
    var Ranks = {
        ID: $('#ID').val(),
        RankName: $('#RankName').val(),
        Description: $('#Description').val(),
        Scheduled: document.getElementById("Scheduled").checked
    };

    $.ajax({
        url: posturl,
        data: JSON.stringify(Ranks),
        type: "POST",
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        success: function (result) {
            loadData();
            $('#myModal').modal('hide');
        },
        error: function (errormessage) {
            console.log(errormessage.responseText);
        }
    });
}

function clearTextBox() {
    $('#ID').val("");
    $('#RankName').val("");
    $('#Description').val("");
    $('#Scheduled').val("");
    $('#btnUpdate').hide();
    $('#btnAdd').show();

}

function AddNewRanks() {
    //debugger;
    var addnew = $('#addnew').val();
    var res = validate();
    if (res == false) {
        return false;
    }
    var Ranks = {
        ID: $('#ID').val(),
        RankName: $('#RankName').val(),
        Description: $('#Description').val(),
        Scheduled: $('#Scheduled').val()
    };
    //debugger;
    $.ajax({
        url: addnew,
        data: JSON.stringify(Ranks),
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
    if ($.fn.dataTable.isDataTable('#certtable')) {
        table = $('#certtable').DataTable();
        table.destroy();
    }


    // alert('hh');
    var table = $("#certtable").DataTable({
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
                  "data": "Order", "name": "Order", "autoWidth": true, "className": 'reorder'
              },
            {
                "data": "RankName", "name": "RankName", "autoWidth": true
            },
              {
                  "data": "Description", "name": "Description", "autoWidth": true
              },
                //{
                //    "data": "Scheduled", "name": "Scheduled", "autoWidth": true
                //},
                 
                  //{
                  //    data: "ID", "width": "50px", "render": function (d) {
                  //        return '<a href="#" onclick="ShowChildren(' + d + ')">Crew</a>';
                  //    }
                  //},
                  {
                      name: 'action',
                      data: null,
                      title: 'Action',
                      searchable: false,
                      sortable: false,
                      render: function (data, type, full, meta) {
                          if (type === 'display') {
                              var $span = $('<span></span>');

                              if (meta.row > 0) {
                                  $('<a class="dtMoveUp"><img src="../background/up.png" style="width:14px;"></a>').appendTo($span);
                              }

                              $('<a class="dtMoveDown"><img src="../background/down.png" style="width:14px;"></a>').appendTo($span);

                              return $span.html();
                          }
                          return data;
                      }
                  },
                  {
                      "data": "ID", "width": "50px", "render": function (data) {
                          return '<a href="#" class="btn btn-info btn-sm" onclick="GetRanksByID(' + data + ')"><i class="glyphicon glyphicon-edit"></i></a>';
                      }
                  },
                  {
                      "data": "ID", "width": "50px", "render": function (d) {
                          //debugger;
                          return '<a href="#" class="btn btn-info btn-sm" onclick="Delete(' + d + ')"><i class="glyphicon glyphicon-trash"></i></a>';


                      }
                  }

        ],
        //"columnDefs": [
        //     { orderable: false, targets: [1, 2, 3] }
        //],
        //"rowReorder": { dataSrc : 'Order' },
        "select": true,
        "rowId": "ID",
        "drawCallback": function (settings) {
            $('#certtable tr:last .dtMoveDown').remove();

            // Remove previous binding before adding it
            $('.dtMoveUp').unbind('click');
            $('.dtMoveDown').unbind('click');

            // Bind clicks to functions
            $('.dtMoveUp').click(moveUp);
            $('.dtMoveDown').click(moveDown);
        }
    });

    table.on('click', 'tr', function () {
        var id = table.row(this).data();
        ShowChildren(id.ID);
        //alert('Clicked row id ' + id.ID);
    });

    //table.on('row-reorder', function (e, details, edit) {
    //    var names = {};
    //    var ids = {};
    //    var updateurl = $('#updateRank').val();
    //    var RanksJsonObject = { WF: [] };

    //    setTimeout(function () {
    //        // console.log(table.columns(1).data());
    //       // names = JSON.stringify(table.columns(1).data().eq(0));
    //      //  ids = JSON.stringify(table.columns(0).data().eq(0));




    //        var x = table.columns(1).data().eq(0).length;
    //        var i;

    //        for (i = 0; i < x; i++)
    //        {
    //            RanksJsonObject.WF.push({
    //                Id: table.columns(0).data().eq(0)[i],
    //                RankName: table.columns(1).data().eq(0)[i]
    //            });
    //        }
    //        //debugger;
    //        $.ajax({
    //            url: updateurl,
    //            data: JSON.stringify({ 'ranks': JSON.stringify(RanksJsonObject) }),
    //            type: "POST",
    //            contentType: "application/json;charset=utf-8",
    //            dataType: "json",
    //            async: "false",
    //            success: function (result) {
    //                loadData();
    //               // $('#myModal').modal('hide');
    //            },
    //            error: function (errormessage) {
    //                console.log(errormessage.responseText);
    //            }
    //        });

    //    }, 10);

    //});

    // Move the row up
    function moveUp() {
        var tr = $(this).parents('tr');
        moveRow(tr, 'up');

        setTimeout(function () { updatedatabase() }, 15);

    }

    // Move the row down
    function moveDown() {
        var tr = $(this).parents('tr');
        moveRow(tr, 'down');

        setTimeout(function () { updatedatabase() }, 15);
    }

    // Move up or down (depending...)
    function moveRow(row, direction) {
        //debugger;
        var index = table.row(row).index();

        var order = -1;
        if (direction === 'down') {
            order = 1;
        }

        var data1 = table.row(index).data();
        data1.Order += order;

        var data2 = table.row(index + order).data();
        data2.Order += -order;

        table.row(index).data(data2);
        table.row(index + order).data(data1);

        table.page(0).draw(false);
    }

    function updatedatabase() {
        var names = {};
        var ids = {};
        var updateurl = $('#updateRank').val();
        var RanksJsonObject = { WF: [] };


        var x = table.columns(1).data().eq(0).length;
        var i;

        for (i = 0; i < x; i++) {
            RanksJsonObject.WF.push({
                Id: table.columns(0).data().eq(0)[i],
                RankName: table.columns(1).data().eq(0)[i]
            });
        }
        //debugger;
        $.ajax({
            url: updateurl,
            data: JSON.stringify({ 'ranks': JSON.stringify(RanksJsonObject) }),
            type: "POST",
            contentType: "application/json;charset=utf-8",
            dataType: "json",
            async: "false",
            success: function (result) {
                loadData();
                // $('#myModal').modal('hide');
            },
            error: function (errormessage) {
                console.log(errormessage.responseText);
            }
        });
    }
}

function GetRanksByID(ID) {
    $('#RankName').css('border-color', 'lightgrey');
    var x = $("#myUrl").val();
    //alert(x);
    //debugger;
    $.ajax({
        url: x,
        data:
            {
                ID: ID
            },
        type: "GET",
        contentType: "application/json;charset=UTF-8",
        dataType: "json",
        success: function (result) {
            //debugger;
            $('#ID').val(result.ID);
            $('#RankName').val(result.RankName);
            $('#Description').val(result.Description);
            if ((result.Scheduled) == true)
            {
                $('#Scheduled').prop('checked', true);
            }
            else
            {
                $('#Scheduled').prop('checked', false);
            }

            $('#myModal').modal('show');
            $('#btnUpdate').show();
            $('#btnAdd').hide();
        },
        error: function (errormessage) {
            //debugger;
            console.log(errormessage.responseText);
        }
    });
    return false;
}

function Update() {
    // alert();
    var i = $('#Rankadd').val();
    var empObj = {

        ID: $('#ID').val(),
        RankName: $('#RankName').val(),
        Description: $('#Description').val(),
        Scheduled: $("[id*=Scheduled]").is(':checked')
    };
    // debugger;
    $.ajax({

        url: i,
        data: JSON.stringify(empObj),
        type: "POST",
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        success: function (result) {
            loadData();
            //debugger;
            $('#myModal').modal('hide');

            $('#ID').val("");
            $('#RankName').val("");
            $('#Description').val("");
            $('#Scheduled').val("");
        },
        error: function (errormessage) {
            console.log(errormessage.responseText);
        }

    });
}

function Delete(ID) {
    var e = $('#deletedata').val();
    var ans = confirm("Are you sure you want to delete this Record?");
    if (ans) {
        // debugger;
        $.ajax({
            url: e,
            data: JSON.stringify({ ID: ID }),
            type: "POST",
            contentType: "application/json;charset=UTF-8",
            dataType: "json",
            success: function (result) {
                // debugger;

                if (result == -1) {
                    alert("Rank cannot be deleted as this is already used in Crew.");
                }
                else if (result == 0) {
                    alert("Rank cannot be deleted as this is already used in Crew.");
                }
                else {
                    loadData();
                }
            },
            error: function () {
                alert("Rank cannot be deleted as this is already used in Crew");
            }
        });
    }
}

