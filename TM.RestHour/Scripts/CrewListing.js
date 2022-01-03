
function showCreateLogin(id) {

    //alert(id);
    var url = $('#newurl').val();

    window.location.href = url + "/Index?mode=update&crew=" + id;
}

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
    //var loadposturl = $('#loaddata').val();
    var loadposturl = $('#loadprintreport').val();

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
                "data": "Nationality", "name": "Nationality", "autoWidth": true
            },
            {
                "data": "RankName", "name": "RankName", "autoWidth": true
            },
            {
                "data": "PassportOrSeaman", "name": "PassportOrSeaman", "autoWidth": true
            },
            //{
            //    "data": "StartDate", "name": "StartDate", "autoWidth": true
            //},
            //{
            //    "data": "EndDate", "name": "EndDate", "autoWidth": true
            //},
            {
                "data": "ID", "width": "50px", "render": function (data) {
                   // return '<a href="#" onclick="AddCrewEdit(' + data + ')"><i class="glyphicon glyphicon-edit" style="color:#000; margin-left: 9px;"></i></a>';
                    return '<a href="#" onclick="CreateNewCrewLogin(' + data + ')"><i class="glyphicon glyphicon-edit" style="color:#000; margin-left: 9px;"></i></a>';
                }
            },
            {
                "data": "ID", "width": "50px", "render": function (data) {
                    return '<a href="#" onclick="showDelete(' + data + ')"><i class="glyphicon glyphicon-trash" style="color:#000; margin-left: 9px;"></i></a>';
                }
            },
            {
                "data": "ID", "width": "50px", "render": function (data) {
                    return '<a href="#" onclick="showDetail(' + data + ')"><i class="glyphicon glyphicon-edit" style="color:#000; margin-left: 9px;"></i></a>';
                }
            },
            {
                "data": "ID", "width": "50px", "render": function (data) {
                    return '<a href="#" onclick="showDetail(' + data + ')"><i class="glyphicon glyphicon-edit" style="color:#000; margin-left: 9px;"></i></a>';
                }
            },
            {
                "data": "ID", "width": "50px", "render": function (data) {
                    return '<a href="#" onclick="showDetail(' + data + ')"><i class="glyphicon glyphicon-edit" style="color:#000; margin-left: 9px;"></i></a>';
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
                    return '<a href="#" onclick="showDetail(' + data + ')"><i class="glyphicon glyphicon-edit" style="color:#000; margin-left: 9px;"></i></a>';
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










function AddCrewEdit() {

    var posturl = $('#UnitaddEdit').val();
    //var passedCrewId = GetParameterValues('crew');

    // alert(passedCrewId);

    // if (res) {
    var Crew = {
        ID: $('#ID').val(),
        FirstName: $('#FirstName').val(),
        MiddleName: $('#MiddleName').val(),
        LastName: $('#LastName').val(),
        Gender: $('#Gender').val(),
        RankID: $('#RankID').val(),
        DepartmentMasterID: $('#DepartmentMasterID').val(),
        CountryID: $('#CountryID').val(),
        DOB1: $('#DOB').val(),
        POB: $('#POB').val(),
        PassportSeamanPassportBook: $('#PassportSeamanPassportBook').val(),
        PassportSeaman: $("input[name='PassportSeaman']:checked").val(),
        CreatedOn1: $('#CreatedOn').val(),
        LatestUpdate1: $('#LatestUpdate').val(),
        Notes: $('textarea#Comments').val(),
        Watchkeeper: document.getElementById("Watchkeeper").checked,
        OvertimeEnabled: document.getElementById("OvertimeEnabled").checked,

        AllowPsychologyForms: document.getElementById("AllowPsychologyForms").checked,

        IssuingStateOfIdentityDocument: $('#IssuingStateOfIdentityDocument').val(),
        ExpiryDateOfIdentityDocument1: $('#ExpiryDateOfIdentityDocument').val()
    };

    $.ajax({
        url: posturl,
        data: JSON.stringify(Crew),
        type: "POST",
        contentType: "application/json;charset=utf-8",
        dataType: "json",

        success: function (response) {
            if (response.result == 'Redirect') {

                //toastr.options = {
                //    "closeButton": false,
                //    "debug": false,
                //    "newestOnTop": false,
                //    "progressBar": false,
                //    "positionClass": "toast-bottom-full-width",
                //    "preventDuplicates": false,
                //    "onclick": null,
                //    "showDuration": "300",
                //    "hideDuration": "1000",
                //    "timeOut": "5000",
                //    "extendedTimeOut": "1000",
                //    "showEasing": "swing",
                //    "hideEasing": "linear",
                //    "showMethod": "fadeIn",
                //    "hideMethod": "fadeOut"
                //};

                // toastr.success("Added Successfully");
                clearTextBox();
                window.location = response.url;
            }
            else if (response.result == 'Error') {
                alert('Error occured. Please relogin and try again');
            }
        },

        error: function (errormessage) {
            console.log(errormessage.responseText);
        }
    });
    //  }
}


function CreateNewCrewLogin(crewId) {
    //var posturl = $('#createNewLogin').val();
    var posturl = "/AddCrew/CreateNewCrewLogin";

    $.ajax({
        url: posturl,
        data: { id: crewId},
        type: "GET",
        contentType: "application/json;charset=utf-8",
        dataType: "json",

        success: function (response) {
           // alert(response.result);
            if (response.result == 'Redirect') {

                

                window.location = response.url;
            }
            else if (response.result == 'Error') {
                alert('Error occured. Please relogin and try again');
            }
        },

        error: function (errormessage) {
            console.log(errormessage.responseText);
        }
    });

}
