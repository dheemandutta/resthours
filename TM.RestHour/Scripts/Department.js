function validate() {
    var isValid = true;

    if ($('#DepartmentMasterName').val().length === 0) {
        $('#DepartmentMasterName').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#DepartmentMasterName').css('border-color', 'lightgrey');
    }


    //if ($('#DepartmentMasterCode').val().length === 0) {
    //    $('#DepartmentMasterCode').css('border-color', 'Red');
    //    isValid = false;
    //}
    //else {
    //    $('#DepartmentMasterCode').css('border-color', 'lightgrey');
    //}
    return isValid;
}

function clearTextBox() {
    //$("#ddlAdmCru option:selected").prop("selected", false);

    $('#ddlAdmCru option:selected').each(function () {
        $(this).prop('selected', false);
    });

    $('#ddlAdmCru').multiselect('refresh');

    //  $('#DepartmentMasterID').val("");
    $('#DepartmentMasterName').val("");
    $('#DepartmentMasterCode').val("");
    $('#ID').val("");
    $('#btnUpdate').hide();
    $('#btnAdd').show();

}

function Add() {

    var GroupsJsonObject = { WF: [] };
    var checkedIds = $('#ddlAdmCru').val();
    console.log('In Dept Add------');
    // console.log(checkedIds);
    GroupsJsonObject.WF.push({ d: checkedIds.join(",") });
    var posturl = $('#Departmentadd').val();
    var res = validate();
    if (res == false) {
        return false;
    }
    if (res) {
        var Department = {
            DepartmentMasterID: $('#DepartmentMasterID').val(),
            DepartmentMasterName: $('#DepartmentMasterName').val(),
            DepartmentMasterCode: $('#DepartmentMasterCode').val()
            //SelectedCrewID: $('#ID').val()
        };

        // console.log(Department);
        $.ajax({
            url: posturl,
            data: JSON.stringify({
                department: Department,
                selectedCrewID: JSON.stringify(GroupsJsonObject)
            }),
            type: "POST",
            contentType: "application/json;charset=utf-8",
            dataType: "json",
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
            //{
            //    "data": "Order", "name": "Order", "autoWidth": true, "className": 'reorder'
            //},
            {
                "data": "DepartmentMasterName", "name": "DepartmentMasterName", "autoWidth": true
            },
            //{
            //    "data": "DepartmentMasterCode", "name": "DepartmentMasterCode", "autoWidth": true
            //},
            {
                "data": "CrewName", "name": "CrewName", "autoWidth": true
            },

            {
                "data": "DepartmentMasterID", "width": "50px", "render": function (data) {
                    return '<a href="#" class="btn btn-info btn-sm" onclick="GetDepartmentByID(' + data + ')"><i class="glyphicon glyphicon-edit"></i></a>';
                }
            },
            //{
            //    "data": "DepartmentMasterID", "width": "50px", "render": function (data) {
            //        return '<a href="#" class="btn btn-info btn-sm" onclick="AdminCrew(' + data + ')"><i class="glyphicon glyphicon-edit"></i></a>';
            //    }
            //},
            {
                "data": "DepartmentMasterID", "width": "50px", "render": function (d) {
                    //debugger;
                    return '<a href="#" class="btn btn-info btn-sm" onclick="Delete(' + d + ')"><i class="glyphicon glyphicon-trash"></i></a>';



                }
            }

        ],
        "rowId": "DepartmentMasterID",
        "dom": "Bfrtip"
    });
}

function GetDepartmentByID(DepartmentMasterID) {
    $('#DepartmentMasterName').css('border-color', 'lightgrey');
    var x = $("#myUrl").val();
    //alert(x);
    //debugger;
    $.ajax({
        url: x,
        data:
        {
            DepartmentMasterID: DepartmentMasterID
        },
        type: "GET",
        contentType: "application/json;charset=UTF-8",
        async: "false",
        dataType: "json",
        success: function (result) {
            //debugger;
            $('#DepartmentMasterID').val(result.DepartmentMasterID);
            $('#DepartmentMasterName').val(result.DepartmentMasterName);
            $('#DepartmentMasterCode').val(result.DepartmentMasterCode);
            //$('#ID').val(result.ID);

            var selectedAdminIds = result.SelectedCrewID;
            var dataarray = selectedAdminIds.split(",");
            console.log(dataarray);

            $('#ddlAdmCru option:selected').each(function () {
                $(this).prop('selected', false);
            });

            $('#ddlAdmCru').multiselect('refresh');
            // $("#ddlAdmCru option:selected").prop("selected", false);
            //  $("#ddlAdmCru option:selected").removeAttr("selected");
            //$("#ddlAdmCru").val(dataarray);
            //$("#ddlAdmCru").trigger("change");
            var i = 0;
            for (i = 0; i < dataarray.length; i++) {
                console.log(dataarray[i]);
                $('input[type="checkbox"][value="' + dataarray[i] + '"]')
                    .attr('checked', true)
                    .trigger('click');
            }




            //if ((result.Scheduled) == true) {
            //    $('#Scheduled').prop('checked', true);
            //}
            //else {
            //    $('#Scheduled').prop('checked', false);
            //}

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

function AdminCrew(DepartmentMasterID) {


    $('#DepartmentMasterName').css('border-color', 'lightgrey');
    $('#DepartmentMasterID').val(DepartmentMasterID);

    $('#ddlAllCrew option:selected').each(function () {
        $(this).prop('selected', false);
    });

    $('#ddlAllCrew').multiselect('refresh');

    var x = $("#myUrlForAssignCrew").val();
    //alert(x);
    //debugger;
    $.ajax({
        url: x,
        data:
        {
            DepartmentMasterID: DepartmentMasterID
        },
        type: "GET",
        contentType: "application/json;charset=UTF-8",
        async: false,
        dataType: "json",
        success: function (result) {

            var option = '';
            //populate html select 
            for (var i = 0; i < result.length; i++) {
                option += '<option value="' + result[i].ID + '">' + result[i].CName + '</option>';
            }

            $('#ddlDeptAdmin').append(option);

           // $('#DepartmentMasterID').val(result.DepartmentMasterID);  

            $('#myModalForAdminCrew').modal('show');
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

function Delete(DepartmentMasterID) {
    var e = $('#deletedata').val();
    var ans = confirm("Are you sure you want to delete this Record?");
    if (ans) {
        // debugger;
        $.ajax({
            url: e,
            data: JSON.stringify({ DepartmentMasterID: DepartmentMasterID }),
            type: "POST",
            contentType: "application/json;charset=UTF-8",
            dataType: "json",
            success: function (result) {
                // debugger;

                if (result == -1) {
                    alert("Department cannot be deleted as this is already used.");
                }
                else if (result == 0) {
                    alert("Department cannot be deleted as this is already used.");
                }
                else {
                    loadData();
                }
            },
            error: function () {
                alert("Department cannot be deleted as this is already used in Crew");
            }
        });
    }
}




function validatedrp() {
    var isValid = true;

    //if ($('#ddlAllCrew').val().length === 0) {
    //    $('#ddlAllCrew').css('border-color', 'Red');
    //    isValid = false;
    //}
    //else {
    //    $('#ddlAllCrew').css('border-color', 'lightgrey');
    //}


    //if ($('#DepartmentMasterCode').val().length === 0) {
    //    $('#DepartmentMasterCode').css('border-color', 'Red');
    //    isValid = false;
    //}
    //else {
    //    $('#DepartmentMasterCode').css('border-color', 'lightgrey');
    //}
    return isValid;
}

function UpdateAssignCrew() {

    var GroupsJsonObject = { WF: [] };
    var checkedIds = $('#ddlAllCrew').val();

    console.log('In Dept Add------');
    // console.log(checkedIds);
    GroupsJsonObject.WF.push({ d: checkedIds.join(",") });
    var posturl = $('#UpdateAssignCrew').val();
    var res = validatedrp();
    if (res == false) {
        return false;
    }
    
    if (res) {
        console.log('I am in');
        console.log($('#DepartmentMasterID').val());
        $.ajax({
            url: posturl,
            data:

            JSON.stringify({
                departmentMasterID: $('#DepartmentMasterID').val(),
                    selectedAdminID: $('#ddlDeptAdmin').val(),
                selectedCrewID: JSON.stringify(GroupsJsonObject)   ///////////////
            }),
            type: "POST",
            contentType: "application/json;charset=utf-8",
            dataType: "json",
            success: function (result) {
                loadData();
                $('#myModalForAdminCrew').modal('hide');
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

                //clearTextBox();
            },
            error: function (errormessage) {
                console.log(errormessage.responseText);
            }
        });
    }
}




function clearTextBox2() {
    $('#DepartmentMasterName').val("");
    $('#DepartmentMasterCode').val("");
}

function validate2() {
    var isValid = true;

    if ($('#DepartmentMasterName').val().length === 0) {
        $('#DepartmentMasterName').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#DepartmentMasterName').css('border-color', 'lightgrey');
    }


    if ($('#DepartmentMasterCode').val().length === 0) {
        $('#DepartmentMasterCode').css('border-color', 'Red');
        isValid = false;
    }
    else {
        $('#DepartmentMasterCode').css('border-color', 'lightgrey');
    }
    return isValid;
}

function AddDepartmentMaster() {

    var posturl = $('#DepartmentMasteradd').val();
    var res = validate2();
    if (res == false) {
        return false;
    }
    // alert(res);
    if (res) {
        var Department = {
          //  DepartmentMasterID: $('#DepartmentMasterID').val(),
            DepartmentMasterName: $('#DepartmentMasterName').val(),
            DepartmentMasterCode: $('#DepartmentMasterCode').val()
        };

        $.ajax({
            url: posturl,
            data: JSON.stringify(Department),
            type: "POST",
            contentType: "application/json;charset=utf-8",
            dataType: "json",

            success: function (response) {
                //debugger;
                // if (response.result == 'Redirect') {
                //show successfull message
                alert('Added Successfully');

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

                window.location = response.url;
                // }
                //else if (response.result == 'Error') {
                //    alert('Data not saved,Please try again');
                //}
            },
            
            error: function (errormessage) {
                console.log(errormessage.responseText);
            }
        });
    }
}