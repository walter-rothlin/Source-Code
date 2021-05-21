var recordsFound = 100;

function GetCoordinatesForAdresse() {

    recordsFound = 0;
    
    var xhr = new XMLHttpRequest();
    // console.log(xhr);
    adrPatternEncoded = encodeURI(document.getElementById('AdressPattern').value);
    xhr.open("GET", "https://api3.geo.admin.ch/1912100956/rest/services/ech/SearchServer?sr=2056&searchText="+ adrPatternEncoded + "&lang=en&type=locations" , true);

    xhr.onload = function() {
        //console.log(this.responseText);
        var response;
		try
		{
			response = JSON.parse(this.responseText);
		}
		catch
		{
			console.log(this.responseText);
			return;
		}
        // console.log(response);
        document.getElementById('ResultSetView').innerHTML = "";
        response.results.forEach(element => appendTo('ResultSetView',element.attrs));
        if (recordsFound >= 50) {
           document.getElementById('ResCount').innerHTML = "To many results";
           document.getElementById('ResultSetView').innerHTML = "";
        } else if (recordsFound == 1) {
           document.getElementById('ResCount').innerHTML = "Validated!";
        } else if (recordsFound < 1) {
           document.getElementById('ResCount').innerHTML = "Not found!";
        } else {
           document.getElementById('ResCount').innerHTML = "<B>" + recordsFound + "</B>";
           console.log(recordsFound);
        }
    }
    xhr.send();
}

function appendTo(id, aAttr){
    recordsFound = recordsFound + 1;
    document.getElementById(id).innerHTML = document.getElementById(id).innerHTML + "<TR><TD>" + recordsFound + ":" + aAttr.label + "</TD>" + "<TD>" + aAttr.lon + "</TD>" + "<TD>" + aAttr.lat + "</TD></TR>";
}
