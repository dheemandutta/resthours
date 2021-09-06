function validate() {
    var isValid = true;

    if ($('input[type=radio][name="q1"]:checked').length == 0) {
        alert("Please select one option of each questions.");
        isValid = false;
    }

    if ($('input[type=radio][name="q2"]:checked').length == 0) {
        alert("Please select one option of each questions.");
        isValid = false;
    }

    if ($('input[type=radio][name="q3"]:checked').length == 0) {
        alert("Please select one option of each questions.");
        isValid = false;
    }

    if ($('input[type=radio][name="q4"]:checked').length == 0) {
        alert("Please select one option of each questions.");
        isValid = false;
    }

    if ($('input[type=radio][name="q5"]:checked').length == 0) {
        alert("Please select one option of each questions.");
        isValid = false;
    }

    if ($('input[type=radio][name="q6"]:checked').length == 0) {
        alert("Please select one option of each questions.");
        isValid = false;
    }

    if ($('input[type=radio][name="q7"]:checked').length == 0) {
        alert("Please select one option of each questions.");
        isValid = false;
    }

    if ($('input[type=radio][name="q8"]:checked').length == 0) {
        alert("Please select one option of each questions.");
        isValid = false;
    }

    if ($('input[type=radio][name="q9"]:checked').length == 0) {
        alert("Please select one option of each questions.");
        isValid = false;
    }

    if ($('input[type=radio][name="q10"]:checked').length == 0) {
        alert("Please select one option of each questions.");
        isValid = false;
    }

    return isValid;
}



function Save_LocusOfControl() {

    var posturl = $('#Save_LocusOfControl').val();
   var res = validate()
    if (res == false) {
      return false;
    }

    if (res) {
        var array = [];
        //var i = 0;

        $("#myForm1 input[type=radio]:checked").each(function () {
            if (this.checked == true) {
                array.push(this.value)
                //i = i + 1;
            }
        });

        console.log(array);

        $.ajax({
            url: posturl,
            type: "POST",
            datatype: "json",
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify(array),
            success: function (result) {
                alert("This form has been submitted ");
            },
            error: function (err) {
                alert(err.statusText);
            }
        });
    }
}


function Save_BeckDepressionInventoryIIFinal() {

    var posturl = $('#Save_BeckDepressionInventoryIIFinal').val();
    var array = [];
    //var i = 0;

    $("#myForm1 input[type=radio]:checked").each(function () {
        if (this.checked == true) {
            array.push(this.value)
            //i = i + 1;
        }
    });

    console.log(array);

    $.ajax({
        url: posturl,
        type: "POST",
        datatype: "json",
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify(array),
        success: function (result) {
            alert("hi");
        },
        error: function (err) {
            alert(err.statusText);
        }
    });

}


function Save_EmotionalIntelligenceQuizForLeadership() {

    var posturl = $('#Save_EmotionalIntelligenceQuizForLeadership').val();
    var array = [];
    //var i = 0;

    $("#myForm1 input[type=radio]:checked").each(function () {
        if (this.checked == true) {
            array.push(this.value)
            //i = i + 1;
        }
    });

    console.log(array);

    $.ajax({
        url: posturl,
        type: "POST",
        datatype: "json",
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify(array),
        success: function (result) {
            alert("hi");
        },
        error: function (err) {
            alert(err.statusText);
        }
    });

}


function Save_InstructionsForPSSFinal() {

    var posturl = $('#Save_InstructionsForPSSFinal').val();
    var array = [];
    //var i = 0;

    $("#myForm1 input[type=radio]:checked").each(function () {
        if (this.checked == true) {
            array.push(this.value)
            //i = i + 1;
        }
    });

    console.log(array);

    $.ajax({
        url: posturl,
        type: "POST",
        datatype: "json",
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify(array),
        success: function (result) {
            alert("hi");
        },
        error: function (err) {
            alert(err.statusText);
        }
    });

}


function Save_MASSMindfulnessScaleFinal() {

    var posturl = $('#Save_MASSMindfulnessScaleFinal').val();
    var array = [];
    //var i = 0;

    $("#myForm1 input[type=radio]:checked").each(function () {
        if (this.checked == true) {
            array.push(this.value)
            //i = i + 1;
        }
    });

    console.log(array);

    $.ajax({
        url: posturl,
        type: "POST",
        datatype: "json",
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify(array),
        success: function (result) {
            alert("hi");
        },
        error: function (err) {
            alert(err.statusText);
        }
    });

}


function Save_PSQ30_PERCIEVED_STRESS_QUESTIONAIRE() {

    var posturl = $('#Save_PSQ30_PERCIEVED_STRESS_QUESTIONAIRE').val();
    var array = [];
    //var i = 0;

    $("#myForm1 input[type=radio]:checked").each(function () {
        if (this.checked == true) {
            array.push(this.value)
            //i = i + 1;
        }
    });

    console.log(array);

    $.ajax({
        url: posturl,
        type: "POST",
        datatype: "json",
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify(array),
        success: function (result) {
            alert("hi");
        },
        error: function (err) {
            alert(err.statusText);
        }
    });

}


function Save_ROSENBERG_SELF_esteem_scale_final() {

    var posturl = $('#Save_ROSENBERG_SELF_esteem_scale_final').val();
    var array = [];
    //var i = 0;

    $("#myForm1 input[type=radio]:checked").each(function () {
        if (this.checked == true) {
            array.push(this.value)
            //i = i + 1;
        }
    });

    console.log(array);

    $.ajax({
        url: posturl,
        type: "POST",
        datatype: "json",
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify(array),
        success: function (result) {
            alert("hi");
        },
        error: function (err) {
            alert(err.statusText);
        }
    });

}


function Save_Zhao_ANXIETY() {

    var posturl = $('#Save_Zhao_ANXIETY').val();
    var array = [];
    //var i = 0;

    $("#myForm1 input[type=radio]:checked").each(function () {
        if (this.checked == true) {
            array.push(this.value)
            //i = i + 1;
        }
    });

    console.log(array);

    $.ajax({
        url: posturl,
        type: "POST",
        datatype: "json",
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify(array),
        success: function (result) {
            alert("hi");
        },
        error: function (err) {
            alert(err.statusText);
        }
    });

}
