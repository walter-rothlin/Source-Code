async function isValidAddress(searchString)
{
    if(await getNumberOfResults(searchString) === 1)
    {
        return true;
    }
    else
    {
        return false;
    }
}

async function getNumberOfResults(searchString)
{
    let response = await getListCoordinates(searchString);
    return response.length;
}

async function getListCoordinates(searchString)
{
    if(searchString.length > 0)
    {
        let baseUrl = "https://api3.geo.admin.ch/1912100956/rest/services/ech/SearchServer?sr=2056&searchText=";
        let requestUrl = baseUrl + searchString + "&lang=en&type=locations";
        let response =  await getRequest(requestUrl);
        return response["results"];
    }
    return null;
}

async function getRequest(url)
{
    let requestOptions = {
        method: 'GET',
        redirect: 'follow'
      };
    let request = await fetch(url, requestOptions);
    let response = await request.json();
    //console.log(response);
    return response;
}
