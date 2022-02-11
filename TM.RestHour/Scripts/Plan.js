var categoryId = 0;
var planName = '';
var categoryName = '';
function ClearFields() {
    $('#hdnPlanCategoryId').val('0');
    $('#hdnPlanID').val('0');
    $('#hdnPlanImagePath').val("");
    $('#PlanName').val("");
    planName = '';
    categoryName = '';
    categoryId = 0;
}

function PreviewModal(planId, planName, path) {

    $('#pdfContent').html("");
    $('#pdfContent').html('<embed id="embedPDF" src="" width="100%" height="600px;" />');

    $('#hHeader').html("");
    $('#embedPDF').removeAttr("src");
    var x = decodeURI(path);

    //#region Show Modal
    $('#hHeader').html(planName);
    $('#embedPDF').attr('src', path);

    $('#viewPlanModal').modal('show');
    //#endregion

    //#region


    //$.ajax({
    //    url: "/Plan/PreviewModal",
    //    data:
    //    {
    //        relPDFPath: decodeURI(path)
    //    },
    //    type: "GET",
    //    contentType: "application/json;charset=UTF-8",
    //    dataType: "json",
    //    success: function (result) {

    //        $('#hHeader').html(result.PdfName);
    //        $('#embedPDF').attr('src', result.PdfPath);

    //        $('#pdfPreviewModal').modal('show');

    //    },
    //    error: function (errormessage) {
    //        //debugger;
    //        console.log(errormessage.responseText);
    //    }
    //});

    //#endregion

}

function ShowUploadModal(catId,catName,pId, pName,modalHead) {
    categoryId = catId;
    planName = pName;
    categoryName = catName;
    $('#hdnPlanCategoryId').val(catId);
    
    $('#hdnPlanID').val(pId);
    if (pId === '0') {
        GetPlanByCategoryForDropDown(catId);
        /*$('#ddlPlan').show();*/
        $('#dvPlanName').show();
        $('#btnUploadPlan').val('AddNew');
    }
    else {
        /*$('#ddlPlan').hide();*/
        $('#dvPlanName').hide();
        $('#btnUploadPlan').val('Update');
    }
      
    //#region Show Modal
    $('#myModalLabel').html(modalHead);
    $('#uploadPlanModal').modal('show');
    //#endregion

    

}
function GetPlanByCategoryForDropDown(categoryId) {
    var x = $("#myUrlid0").val();

    $.ajax({
        url: "/Plan/GetPlanByCategoryForDropDown",
        type: "POST",
        data: JSON.stringify({ categoryId: categoryId }),
        //data:
        //{
        //    categoryId: categoryId
        //},
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        success: function (result) {

            var drpPlan = $('#ddlPlan');
            drpPlan.find('option').remove();

            drpPlan.append('<option value=' + '0' + '>' + 'Select' + '</option>');

            $.each(result, function () {
                drpPlan.append('<option value=' + this.PlanId + '>' + this.PlanName + '</option>');
            });

        },
        error: function (errormessage) {
            alert(errormessage.responseText);
        }
    });
}

function UploadPlanFile() {
    var res = false;
    if ($('#hdnPlanCategoryId').val().length === 0) {
        
        res = false;
    }
    else {
        
        res = true;
    }
    if (categoryName === '') {
        res = false;
    }
    else {

        res = true;
    }
    if ($('#btnUploadPlan').val() === 'AddNew') {
        if ($('#PlanName').val().length === 0) {
            $('#PlanName').css('border-color', 'Red');
            res = false;
        }
        else {
            $('#PlanName').css('border-color', 'lightgrey');
            planName = $('#PlanName').val();
            res = true;
        }

    } else {
        if (planName === '') {
            res = false;
        }
        else {

            res = true;
        }
    }
    
    if (res) {
        //Checking whether FormData is available in browser  
        if (window.FormData !== undefined) {
            var fileUpload = $("#uploadPlanImage").get(0);
            var files = fileUpload.files;
            // Create FormData object  
            var fileData = new FormData();

            // Looping over all files and add it to FormData object  
            for (var i = 0; i < files.length; i++) {
                fileData.append(files[i].name, files[i]);
            }

            // Adding one more key to FormData object
            fileData.append('category', categoryName);
            fileData.append('planName', planName);
            $.ajax({
                url: '/Plan/UploadPlanImages',
                type: "POST",
                //datatype: "json",
                //contentType: "application/json; charset=utf-8",
                contentType: false, // Not to set any content header  
                processData: false, // Not to process data  
                data: fileData,
                success: function (result) {
                    //alert(result);

                    $("#lblSuccMsg").text(result[1]);
                    $("#hdnPlanImagePath").val(result[0]);
                    $("#lblSuccMsg").removeClass("hidden");

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

                    toastr.success(result[1] );
                    AddPlan();
                },
                error: function (err) {
                    alert(err.statusText);
                }
            });
        } else {
            alert("FormData is not supported.");
        }

    }
    

}


function AddPlan() {
    var res = false;
    if ($('#hdnPlanCategoryId').val().length === 0) {

        res = false;
    }
    else {

        res = true;
    }
    if ($('#hdnPlanID').val() === 0) {
        res = false;
    }
    else {

        res = true;
    }
    if (planName === '') {
        res = false;
    }
    else {

        res = true;
    }
    if ($('#hdnPlanImagePath').val().length === 0) {
        res = false;
    }
    else {

        res = true;
    }

    if (res) {
        var plan = {
            PlanId: $('#hdnPlanID').val(),
            CategoryId: $('#hdnPlanCategoryId').val(),
            PlanName: planName,
            PlanImagePath: $('#hdnPlanImagePath').val()
        };



        $.ajax({
            url: '/Plan/AddPlan',
            data: JSON.stringify(plan),
            type: "POST",
            contentType: "application/json;charset=utf-8",
            dataType: "json",

            success: function (result) {
                //loadData();
                $('#uploadPlanModal').modal('hide');
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

                ClearFields();
                reloadPage();
            },
            error: function (errormessage) {
                console.log(errormessage.responseText);
            }
        });
    }
    
}

function AddPlanCategory() {
    var res = false;
    if ($('#CategoryName').val().length === 0) {
        $('#CategoryName').css('border-color', 'Red');
        res = false;
    }
    else {
        $('#CategoryName').css('border-color', 'lightgrey');
        res = true;
    }
    if (res) {
        var planCategory = {
            CategoryId: 0,
            CategoryName: $('#CategoryName').val()
        };

        $.ajax({
            url: '/Plan/AddPlanCategory',
            data: JSON.stringify(planCategory),
            type: "POST",
            contentType: "application/json;charset=utf-8",
            dataType: "json",

            success: function (result) {
                //loadData();
                $('#createPlanCategoryModal').modal('hide');
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
                $('#CategoryName').val("");

                reloadPage();
                
            },
            error: function (errormessage) {
                console.log(errormessage.responseText);
            }
        });
    }

}

function reloadPage() {
    
    location.reload();
}