//
//
//
//   source:https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/DatenFiles/JS_HTML/AdressLocator/AdresseToKoordinates_04a_Complete.css


function updateUI_List(resultList) 
{   
    let table = document.getElementById("ResultSetView");
    table.innerHTML = "";
    resultList.forEach(function(element, index){
        appendTo(table,element.attrs,index);
    })
}

function appendTo(table, aAttr, index){
    var row = document.createElement("tr");
    var cellIndex = document.createElement("td");
    var cellName = document.createElement("td");
    var cellLong = document.createElement("td");
    var cellLat = document.createElement("td");
    cellIndex.innerText = index;
    cellName.innerHTML = aAttr.label;
    cellLong.innerHTML = aAttr.lon;
    cellLat.innerHTML = aAttr.lat;
    row.appendChild(cellIndex);
    row.appendChild(cellName);
    row.appendChild(cellLong);
    row.appendChild(cellLat);
    table.appendChild(row);
}

async function textChanged(e) {
    let result = await getListCoordinates(document.getElementById("AdressPattern").value);
    updateUI_List(result);

    let errorMessage = document.getElementById("LblSearchStatus");
    if (result.length >= 50) {
        errorMessage.innerHTML  = "To many results";
        errorMessage.className = "LblSearchStatus inComplete";
    } else if (result.length === 1) {
        errorMessage.innerHTML  = "Found!";
        errorMessage.className = "LblSearchStatus found";
    } else if (result.length < 1) {
        errorMessage.innerHTML  = "Not found!";
        errorMessage.className = "LblSearchStatus notFound";
    } else {
        errorMessage.innerHTML  = "Records found:" + result.length;
        errorMessage.className = "LblSearchStatus inComplete";
    }
}