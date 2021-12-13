function AddOptions() {

    //alert($('textarea#Comments').val());

    var posturl = $('#Optionsadd').val();
    //var res = validate();
    //if (res == false) {
    //    return false;
    //}
    var Options = {

        AdjustmentValue: $('#AdjustmentValue').val(),
        AdjustmentDate1: $('#AdjustmentDate').val()
    };

    $.ajax({
        url: posturl,
        data: JSON.stringify(Options),
        type: "POST",
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        //success: function (result) {

        //},
        success: function (result) {

            toastr.options = {
                "closeButton": false,
                "debug": false,
                "newestOnTop": false,
                "progressBar": false,
                "positionClass": "toast-bottom-full-width",
                "preventDuplicates": false,
                "onclick": null,
                "showDuration": "300",
                "hideDuration": "1000",
                "timeOut": "5000",
                "extendedTimeOut": "1000",
                "showEasing": "swing",
                "hideEasing": "linear",
                "showMethod": "fadeIn",
                "hideMethod": "fadeOut"
            };

            toastr.success("Added Successfully");

          //  alert('Added Successfully');
            SetUpGrid();
            clearTextBox();

        }
        ,
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
    if ($.fn.dataTable.isDataTable('#Mastertable')) {
        table = $('#Mastertable').DataTable();
        table.destroy();
    }

    $("#Mastertable").DataTable({
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
                "data": "AdjustmentDate1", "name": "AdjustmentDate1", "align=right": true
            },
            {
                "data": "AdjustmentValue", "name": "AdjustmentValue", "autoWidth": true
            }

        ]
    });
}