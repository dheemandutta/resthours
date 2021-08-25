
function Save_LocusOfControl() {

    var posturl = $('#Save_LocusOfControl').val();
    var LocusOfControl = {
      
        q1: $("input[name='q1']:checked").parent('label').text(),


    };

    $.ajax({
        url: posturl,
        type: "POST",
        datatype: "json",
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify(LocusOfControl),
        success: function (result) {
            alert("hi");

        },
        error: function (err) {
            alert(err.statusText);
        }
    });
}



