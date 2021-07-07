function GetCoordinatesForAdresse() {
			
			var xhr = new XMLHttpRequest();
			// console.log(xhr);
            adrPatternEncoded = encodeURI(document.getElementById("AdressPattern").value);
            xhr.open("GET", "https://api3.geo.admin.ch/1912100956/rest/services/ech/SearchServer?sr=2056&searchText="+ adrPatternEncoded + "&lang=en&type=locations" , true);
		
			xhr.onload = function(){
				//console.log(this.responseText);
				var response = JSON.parse(this.responseText);
				// console.log(response);
				document.getElementById('ResultSetView').innerHTML = "";
				response.results.forEach(element => appendTo('ResultSetView',element.attrs));
			}	
			xhr.send();
   }
   
   function appendTo(id, aAttr){
	   document.getElementById(id).innerHTML = document.getElementById(id).innerHTML + "<TR><TD>" + aAttr.label + "</TD>" + "<TD>" + aAttr.lon + "</TD>" + "<TD>" + aAttr.lat + "</TD></TR>";
   }
   
   