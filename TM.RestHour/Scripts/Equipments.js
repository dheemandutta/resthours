function validate() {
    var isValid = true;

    if ($('#EquipmentsName').val().length === 0) {
        $('#EquipmentsName').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#EquipmentsName').css('border-color', 'lightgrey');
    }

    //if ($('#Comment').val().length === 0) {
    //    $('#Comment').css('border-color', 'Red');
    //    isValid = false;
    //}
    //else {
    //    $('#Comment').css('border-color', 'lightgrey');
    //}

    if ($('#Quantity').val().length === 0) {
        $('#Quantity').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#Quantity').css('border-color', 'lightgrey');
    }

    return isValid;
}

function clearTextBox() {
    $('#EquipmentsName').val("");
    $('#Comment').val("");
    $('#Quantity').val("");
}

function SaveEquipments() {

    //alert($('textarea#Comments').val());
    //debugger;
    var posturl = $('#SaveEquipments').val();
    var res = validate();
    if (res == false) {
        return false;
    }
     //alert(res);
    if (res) {
        var Equipments = {
            //ID: $('#ID').val(),
            EquipmentsName: $('#EquipmentsName').val(),
            Quantity: $('#Quantity').val(),
            Comment: $('#Comment').val(),
           
           
            //Notes: $('textarea#Comments').val(),
        };

        $.ajax({
            url: posturl,
            data: JSON.stringify(Equipments),
            type: "POST",
            contentType: "application/json;charset=utf-8",
            dataType: "json",

            //success: function (result) {

            //    alert('Added Successfully');

            //    clearTextBox();
            //    }         
            //,



            success: function (result) {
                loadData();
                $('#myModal').modal('hide');
                // alert('Added Successfully');

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

                clearTextBox();
            },
            error: function (errormessage) {
                console.log(errormessage.responseText);
            }
        });
     }
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
    if ($.fn.dataTable.isDataTable('#Equipmentstable')) {
        table = $('#Equipmentstable').DataTable();
        table.destroy();
    }


    // alert('hh');
    var table = $("#Equipmentstable").DataTable({
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














function validate2() {
    var isValid = true;

    if ($('#MedicineName').val().length === 0) {
        $('#MedicineName').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#MedicineName').css('border-color', 'lightgrey');
    }

    //if ($('#Comment').val().length === 0) {
    //    $('#Comment').css('border-color', 'Red');
    //    isValid = false;
    //}
    //else {
    //    $('#Comment').css('border-color', 'lightgrey');
    //}

    if ($('#Quantity').val().length === 0) {
        $('#Quantity').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#Quantity').css('border-color', 'lightgrey');
    }

    return isValid;
}

function clearTextBox2() {
    $('#MedicineName').val("");
    $('#Quantity').val("");
}

function SaveMedicine() {

    //alert($('textarea#Comments').val());
    //debugger;
    var posturl = $('#SaveMedicine').val();
    var res = validate2();
    if (res == false) {
        return false;
    }
    //alert(res);
    if (res) {
        var Medicine = {
            //ID: $('#ID').val(),
            MedicineName: $('#MedicineName').val(),
            Quantity: $('#Quantity').val(),
          


            //Notes: $('textarea#Comments').val(),
        };

        $.ajax({
            url: posturl,
            data: JSON.stringify(Medicine),
            type: "POST",
            contentType: "application/json;charset=utf-8",
            dataType: "json",

            //success: function (result) {

            //    alert('Added Successfully');

            //    clearTextBox();
            //    }         
            //,



            success: function (result) {
                loadData2();
                $('#myModal').modal('hide');
                // alert('Added Successfully');

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

                clearTextBox2();
            },
            error: function (errormessage) {
                console.log(errormessage.responseText);
            }
        });
    }
}

function loadData2() {
    var loadposturl = $('#loaddata').val();
    $.ajax({
        url: loadposturl,
        type: "GET",
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        success: function (result) {
            SetUpGrid2();

        },
        error: function (errormessage) {
            console.log(errormessage.responseText);
        }
    });
}

function SetUpGrid2() {
    var loadposturl = $('#loaddata').val();

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