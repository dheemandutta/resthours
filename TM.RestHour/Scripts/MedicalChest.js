
function UploadMedicalChestCertificateFile() {
    var res = false;
    //if ($('#ddlCrew').val().length === 0) {
    //    $('#ddlCrew').css('border-color', 'Red');
    //    res = false;
    //}
    //else {
    //    $('#ddlCrew').css('border-color', 'lightgrey');
    //    res = true;
    //}

    //if (res == false) {
    //    return false;
    //}

    //Checking whether FormData is available in browser  
    if (window.FormData !== undefined) {
        var fileUpload = $("#uploadMedicalChestCertificate").get(0);
        var files = fileUpload.files;
        // Create FormData object  
        var fileData = new FormData();

        // Looping over all files and add it to FormData object  
        for (var i = 0; i < files.length; i++) {
            fileData.append(files[i].name, files[i]);
        }

        // Adding one more key to FormData object
        //fileData.append('crewId', crewId);
        //fileData.append('fileType', filetype);
        $.ajax({
            url: '/MedicalChest/UploadMedicalChestCertificateImage',
            type: "POST",
            //datatype: "json",
            //contentType: "application/json; charset=utf-8",
            contentType: false, // Not to set any content header  
            processData: false, // Not to process data  
            data: fileData,
            success: function (result) {
                //alert(result);
                $("#hdnPathMedicalChestCertificateImage").val(result[0]);
                $("#hdnMedicalChestCertificateImageName").val(result[1]);
                //$("#lblSuccMsgCIRM" + filetype).removeClass("hidden");

                //ClearFields();
                //if (filetype == "PastMedicalHistory") {
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

                    toastr.success( "Uploaded Successfully");
                //}

                SaveMedicalChestCertificate();

            },
            error: function (err) {
                alert(err.statusText);
            }
        });
    } else {
        alert("FormData is not supported.");
    }


}


function SaveMedicalChestCertificate() {

    var posturl = $('#saveMedicalChestCertificate').val();
    //var res = validate();
    //if (res == false) {
    //    return false;
    //}
    // alert(res);
    var ChestCerficate = {
        ChestID: $('#ChestId').val(),
        IssuingAuthorityName: $('#IssuingAuthorityName').val(),
        IssueDate: $('#IssuedDate').val(),
        ExpiryDate: $('#ExpiryDate').val(),
        CertificateImageName: $('#hdnMedicalChestCertificateImageName').val(),
        CertificateImagePath: $('#hdnPathMedicalChestCertificateImage').val()
    };

    $.ajax({
        url: posturl,
        data: JSON.stringify(ChestCerficate),
        type: "POST",
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        success: function (result) {
            //$('#myModal').modal('hide');
            // alert('Added Successfully');
            LoadCerticate();
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

            toastr.success("Medical Chest Certificate Added Successfully");

            //clearTextBox();
        },
        error: function (errormessage) {
            console.log(errormessage.responseText);
        }
    });
}


function LoadCerticate() {
    var x = $("#loadMedicalChestCertificate").val();

    $.ajax({
        url: x,
        type: "GET",
        contentType: "application/json;charset=UTF-8",
        dataType: "json",
        success: function (result) {
            //debugger;
            $('#ChestId').val(result.ChestID);
            $('#IssuingAuthorityName').val(result.IssuingAuthorityName);
            $('#IssuedDate').val(result.IssueDate);
            $('#ExpiryDate').val(result.ExpiryDate);
            if (result.CertificateImagePath != null || result.CertificateImagePath !== "" || result.CertificateImagePath !== 'undefine')
                $('#imgCertificate').attr('src', result.CertificateImagePath);
        },
        error: function (errormessage) {
            //debugger;
            console.log(errormessage.responseText);
        }


    });

    return false;

}
