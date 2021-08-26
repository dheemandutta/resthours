
function Save_LocusOfControl() {

    var posturl = $('#Save_LocusOfControl').val();
    var LocusOfControl = {
        q1: $("input[name='q1']:checked").parent('label').text(),
    };
    /////////////////////////////////////////////////
    var length = 10;
    var array = [];
    //var i = 0;

    $("#myForm1 input[type=radio]:checked").each(function () {
        if (this.checked == true) {
            array.push(this.value)
            //i = i + 1;
        }
    });

    console.log(array);
    ///////////////////////////////////

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



