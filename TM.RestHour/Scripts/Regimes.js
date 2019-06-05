function GetDataForRegimes() {
    //debugger;
    var Regimes = $('#getDataForRegimes').val();

    $.ajax({
        url: Regimes,
       // data: JSON.stringify({ requestNumber: $('#txtrequestNumber').val() }),
        type: "POST",
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        success: function (result) {
            //set p tag values here 
           
            // $('#Name').text(result.Name);
           // console.log(result[4].MinContRestIn24Hours);
            $('#MinContRestIn24Hours').text(result[4].MinContRestIn24Hours);
            $('#MinTotalRestIn24Hours').text(result[4].MinTotalRestIn24Hours);
            $('#MinTotalRestIn7Days').text(result[4].MinTotalRestIn7Days);

            $('#MinContRestIn24Hours0').text(result[0].MinContRestIn24Hours);
            $('#MinTotalRestIn24Hours0').text(result[0].MinTotalRestIn24Hours);
            $('#MinTotalRestIn7Days0').text(result[0].MinTotalRestIn7Days);

            $('#MinContRestIn24Hours1').text(result[1].MinContRestIn24Hours);
            $('#MaxTotalWorkIn24Hours1').text(result[1].MaxTotalWorkIn24Hours);
            $('#MaxTotalWorkIn7Days1').text(result[1].MaxTotalWorkIn7Days);

            $('#MinContRestIn24Hours2').text(result[2].MinContRestIn24Hours);
            $('#MinTotalRestIn24Hours2').text(result[2].MinTotalRestIn24Hours);
            $('#MinTotalRestIn7Days2').text(result[2].MinTotalRestIn7Days);
            
        },
        error: function (errormessage) {
            console.log(errormessage.responseText);
        }
    });
}

function DisableButton() {

    var x = $("#getisactiveregime").val();
    $.ajax({
        url: x,

        type: "POST",
        contentType: "application/json;charset=UTF-8",
        dataType: "json",
        success: function (result) {
            console.log(result);

            if (result.RegimeID === 1) {
                $('#btnAdd1').attr('disabled', true);
                $('#btnAdd2').attr('disabled', false);
                $('#btnAdd3').attr('disabled', false);
                $('#btnAdd7').attr('disabled', false);
                $('#btnAdd4').attr('disabled', false);
                $('#btnAdd9').attr('disabled', false);
            }
            else if (result.RegimeID === 5) {
                $('#btnAdd1').attr('disabled', false);
                $('#btnAdd2').attr('disabled', true);
                $('#btnAdd3').attr('disabled', false);
                $('#btnAdd7').attr('disabled', false);
                $('#btnAdd4').attr('disabled', false);
                $('#btnAdd9').attr('disabled', false);
            }
            else if (result.RegimeID === 3) {
                $('#btnAdd1').attr('disabled', false);
                $('#btnAdd2').attr('disabled', false);
                $('#btnAdd3').attr('disabled', true);
                $('#btnAdd7').attr('disabled', false);
                $('#btnAdd4').attr('disabled', false);
                $('#btnAdd9').attr('disabled', false);
            }
            else if (result.RegimeID === 7) {
                $('#btnAdd1').attr('disabled', false);
                $('#btnAdd2').attr('disabled', false);
                $('#btnAdd3').attr('disabled', false);
                $('#btnAdd7').attr('disabled', true);
                $('#btnAdd4').attr('disabled', false);
                $('#btnAdd9').attr('disabled', false);
            }
            else if (result.RegimeID === 4) {
                $('#btnAdd1').attr('disabled', false);
                $('#btnAdd2').attr('disabled', false);
                $('#btnAdd3').attr('disabled', false);
                $('#btnAdd7').attr('disabled', false);
                $('#btnAdd4').attr('disabled', true);
                $('#btnAdd9').attr('disabled', false);
            }
            else if (result.RegimeID === 9) {
                $('#btnAdd1').attr('disabled', false);
                $('#btnAdd2').attr('disabled', false);
                $('#btnAdd3').attr('disabled', false);
                $('#btnAdd7').attr('disabled', false);
                $('#btnAdd4').attr('disabled', false);
                $('#btnAdd9').attr('disabled', true);
            }
        },
        error: function (errormessage) {
            //debugger;
            console.log(errormessage.responseText);
        }
    });

}


function AddTab1() {

    //alert($('textarea#Comments').val());

    var posturl = $('#Tabadd1').val();
    //var res = validate();
    //if (res == false) {
    //    return false;
    //}
    var Tab = {
        //ID: $('#ID').val(),
        //ShipName: $('#ShipName').val(),
        ////Regime: $('input:radio[name=RName]:checked').val(),
        Regime: 1,

        //RegimeStartDate: $('#RegimeStartDate').val(),
        //RegimeID: $('#RegimeID').val(),

        //VesselID: $('#VesselID').val()
    };

    $.ajax({
        url: posturl,
        data: JSON.stringify(Tab),
        type: "POST",
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        //success: function (result) {

        //},
        success: function (result) {

            var msg = "Data Saved Successfully";
            //$('#btnAdd1').attr('disabled', true);
            //$('#btnAdd2').attr('disabled', false);
            //$('#btnAdd3').attr('disabled', false);
            //$('#btnAdd7').attr('disabled', false);
            //$('#btnAdd4').attr('disabled', false);
            DisableButton();
            $('#myModal').modal('show');
            $('#succMsg').html(msg);

            clearTextBox();
        }
        ,
        error: function (errormessage) {
            console.log(errormessage.responseText);
        }
    });
}

function AddTab2() {

    //alert($('textarea#Comments').val());

    var posturl = $('#Tabadd2').val();
    //var res = validate();
    //if (res == false) {
    //    return false;
    //}
    var Tab = {
        //ID: $('#ID').val(),
        //ShipName: $('#ShipName').val(),
        ////Regime: $('input:radio[name=RName]:checked').val(),
        Regime: 5,

        //RegimeStartDate: $('#RegimeStartDate').val(),
        //RegimeID: $('#RegimeID').val(),

        //VesselID: $('#VesselID').val()
    };

    $.ajax({
        url: posturl,
        data: JSON.stringify(Tab),
        type: "POST",
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        //success: function (result) {

        //},
        success: function (result) {

            var msg = "Data Saved Successfully";
            //$('#btnAdd1').attr('disabled', false);
            //$('#btnAdd2').attr('disabled', true);
            //$('#btnAdd3').attr('disabled', false);
            //$('#btnAdd7').attr('disabled', false);
            //$('#btnAdd4').attr('disabled', false);
            DisableButton();
            $('#myModal').modal('show');
            $('#succMsg').html(msg);

            clearTextBox();
        }
        ,
        error: function (errormessage) {
            console.log(errormessage.responseText);
        }
    });
}

function AddTab3() {

    //alert($('textarea#Comments').val());

    var posturl = $('#Tabadd3').val();
    //var res = validate();
    //if (res == false) {
    //    return false;
    //}
    var Tab = {
        //ID: $('#ID').val(),
        //ShipName: $('#ShipName').val(),
        ////Regime: $('input:radio[name=RName]:checked').val(),
        Regime: 3,

        //RegimeStartDate: $('#RegimeStartDate').val(),
        //RegimeID: $('#RegimeID').val(),

        //VesselID: $('#VesselID').val()
    };

    $.ajax({
        url: posturl,
        data: JSON.stringify(Tab),
        type: "POST",
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        //success: function (result) {

        //},
        success: function (result) {

            var msg = "Data Saved Successfully";
            //$('#btnAdd1').attr('disabled', false);
            //$('#btnAdd2').attr('disabled', false);
            //$('#btnAdd3').attr('disabled', true);
            //$('#btnAdd7').attr('disabled', false);
            //$('#btnAdd4').attr('disabled', false);
            DisableButton();
            $('#myModal').modal('show');
            $('#succMsg').html(msg);

            clearTextBox();
        }
        ,
        error: function (errormessage) {
            console.log(errormessage.responseText);
        }
    });
}

function AddTab7() {

    //alert($('textarea#Comments').val());

    var posturl = $('#Tabadd7').val();
    //var res = validate();
    //if (res == false) {
    //    return false;
    //}
    var Tab = {
        //ID: $('#ID').val(),
        //ShipName: $('#ShipName').val(),
        ////Regime: $('input:radio[name=RName]:checked').val(),
        Regime: 7,

        //RegimeStartDate: $('#RegimeStartDate').val(),
        //RegimeID: $('#RegimeID').val(),

        //VesselID: $('#VesselID').val()
    };

    $.ajax({
        url: posturl,
        data: JSON.stringify(Tab),
        type: "POST",
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        //success: function (result) {

        //},
        success: function (result) {

            var msg = "Data Saved Successfully";
            //$('#btnAdd1').attr('disabled', false);
            //$('#btnAdd2').attr('disabled', false);
            //$('#btnAdd3').attr('disabled', false);
            //$('#btnAdd7').attr('disabled', true);
            //$('#btnAdd4').attr('disabled', false);
            DisableButton();
            $('#myModal').modal('show');
            $('#succMsg').html(msg);

            clearTextBox();
        }
        ,
        error: function (errormessage) {
            console.log(errormessage.responseText);
        }
    });
}

function AddTab4() {

    //alert($('textarea#Comments').val());

    var posturl = $('#Tabadd4').val();
    //var res = validate();
    //if (res == false) {
    //    return false;
    //}
    var Tab = {
        //ID: $('#ID').val(),
        //ShipName: $('#ShipName').val(),
        ////Regime: $('input:radio[name=RName]:checked').val(),
        Regime: 4,

        //RegimeStartDate: $('#RegimeStartDate').val(),
        //RegimeID: $('#RegimeID').val(),

        //VesselID: $('#VesselID').val()
    };

    $.ajax({
        url: posturl,
        data: JSON.stringify(Tab),
        type: "POST",
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        //success: function (result) {

        //},
        success: function (result) {

            var msg = "Data Saved Successfully";
            //$('#btnAdd1').attr('disabled', false);
            //$('#btnAdd2').attr('disabled', false);
            //$('#btnAdd3').attr('disabled', false);
            //$('#btnAdd7').attr('disabled', false);
            //$('#btnAdd4').attr('disabled', true);
            DisableButton();
            $('#myModal').modal('show');
            $('#succMsg').html(msg);

            clearTextBox();
        }
        ,
        error: function (errormessage) {
            console.log(errormessage.responseText);
        }
    });
}

function AddTab9() {

    //alert($('textarea#Comments').val());

    var posturl = $('#Tabadd9').val();
    //var res = validate();
    //if (res == false) {
    //    return false;
    //}
    var Tab = {
        //ID: $('#ID').val(),
        //ShipName: $('#ShipName').val(),
        ////Regime: $('input:radio[name=RName]:checked').val(),
        Regime: 9,

        //RegimeStartDate: $('#RegimeStartDate').val(),
        //RegimeID: $('#RegimeID').val(),

        //VesselID: $('#VesselID').val()
    };

    $.ajax({
        url: posturl,
        data: JSON.stringify(Tab),
        type: "POST",
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        //success: function (result) {

        //},
        success: function (result) {

            var msg = "Data Saved Successfully";
            //$('#btnAdd1').attr('disabled', false);
            //$('#btnAdd2').attr('disabled', false);
            //$('#btnAdd3').attr('disabled', false);
            //$('#btnAdd7').attr('disabled', false);
            //$('#btnAdd4').attr('disabled', true);
            DisableButton();
            $('#myModal').modal('show');
            $('#succMsg').html(msg);

            clearTextBox();
        }
        ,
        error: function (errormessage) {
            console.log(errormessage.responseText);
        }
    });
}