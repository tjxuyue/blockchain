/*-----------------------------------------------------------------------------*/
//TO BUILD THE MAP OF THE USER INFORMATION.
//KEY:THE ADDRESS OF THE VP.
//VALUE:THE REGISTERED USER OF THE VP.
var map = {
	"127.0.0.1:8880" : "NAME1",
	"127.0.0.1:8881" : "NAME2",
	"127.0.0.1:8882" : "NAME3",
	"127.0.0.1:8883" : "NAME4"
};
/*-----------------------------------------------------------------------------*/
//TO QUERY THE DATABASE OF BLOCKCHAIN.
//INPUT:
//VP:THE IP AND PORT OF THE VP.
//CHAINCODENAME:THE CHAINCODE ID OF THE CHAINCODE, IT IS A 32 BITS HASHCODE.
//KEY:THE KEY OF THE TARGET.
//OUTPUT:
//THE OUTPUT OF THE FUNCTION IS A JSON STRING.
//e.g. 
/*
		{
		    "OK": {
		        "Name": "a",
		        "Amount": "70"
		    }
		}
*/
//THE 'AMOUNT' IS THE RESULT OF YOUR QUERY.
function query(vp, chaincodeName, key) {
	var body = "{\"jsonrpc\":\"2.0\",\"method\":\"query\",\"params\":{\"type\":1,"
			+ "\"chaincodeID\":{\"name\":\""
			+ chaincodeName
			+ "\"},"
			+ "\"ctorMsg\":{\"function\":\"query\",\"args\":[\""
			+ key
			+ "\"]},\"secureContext\":\"" + map[vp] + "\"},\"id\":1}";
	var res = accessBlockChain("http://" + vp + "/chaincode", body);
	return res;
}
/*-----------------------------------------------------------------------------*/
//TO MODIFY THE DATABASE OF BLOCKCHAIN.
//INPUT:
//VP:THE IP AND PORT OF THE VP.
//CHAINCODENAME:THE CHAINCODE ID OF THE CHAINCODE, IT IS A 32 BITS HASHCODE.
//KEY:THE KEY OF THE TARGET.
//VALUE:THE VALUE YOU WANT TO ADD OR SUBSTRACT, THE POSITIVE MEANS PLUS AND THE NEGATIVE MEANS SUBSTRACT.
//OUTPUT:
//THE OUTPUT OF THE FUNCTION IS A JSON STRING.
//IF THE OPERATION IS SUCCESS, THE RESPONSE IS 
/*
	{
    	"Status": "OK. Successfully invoked transaction."
	}
*/
//IF THE OPERATION IS FAIL, THE RESPONSE IS 
/*
	{
		"Error":"Nil"
	}
*/
function plus(vp, chaincodeName, key, value) {
	var body = "{\"jsonrpc\":\"2.0\",\"method\":\"invoke\",\"params\":{\"type\":1,"
			+ "\"chaincodeID\":{\"name\":\""
			+ chaincodeName
			+ "\"},"
			+ "\"ctorMsg\":{\"function\":\"plus\",\"args\":[\""
			+ key
			+ "\",\""
			+ value + "\"]},\"secureContext\":\"" + map[vp] + "\"},\"id\":1}";
	var res = accessBlockChain("http://" + vp + "/chaincode", body);
	return res;
}
/*-----------------------------------------------------------------------------*/
//TO UPDATE THE DATABASE OF THE BLOCKCHAIN.
//INPUT:
//VP:THE IP AND PORT OF THE VP.
//CHAINCODENAME:THE CHAINCODE ID OF THE CHAINCODE, IT IS A 32 BITS HASHCODE.
//KEY:THE KEY OF THE TARGET.
//VALUE:THE NEW VALUE.
//OUTPUT:
//THE OUTPUT OF THE FUNCTION IS A JSON STRING.
//IF THE OPERATION IS SUCCESS, THE RESPONSE IS 
/*
	{
    	"Status": "OK. Successfully invoked transaction."
	}
*/
//IF THE OPERATION IS FAIL, THE RESPONSE IS 
/*
	{
		"Error":"Nil"
	}
*/
function update(vp, chaincodeName, key, value) {
	var body = "{\"jsonrpc\":\"2.0\",\"method\":\"invoke\",\"params\":{\"type\":1,"
			+ "\"chaincodeID\":{\"name\":\""
			+ chaincodeName
			+ "\"},"
			+ "\"ctorMsg\":{\"function\":\"update\",\"args\":[\""
			+ key
			+ "\",\""
			+ value
			+ "\"]},\"secureContext\":\""
			+ map[vp]
			+ "\"},\"id\":1}";
	var res = accessBlockChain("http://" + vp + "/chaincode", body);
	return res;
}
/*-----------------------------------------------------------------------------*/
//THIS FUNCTION IS ACCESS THE BLOCK DIRECTLY.
//THE RESULT OF THE FUNCTION IS A JSON STRING.
function accessBlockChain(url, body) {
	var xmlHttp = null;
	try {
		xmlHttp = new XMLHttpRequest();
	} catch (e) {
		try {
			xmlHttp = new ActiveXObject("Msxml2.XMLHTTP");
		} catch (e) {
			xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
		}
	}
	if (xmlHttp == null) {
		alert("Browser does not support HTTP Request");
		return;
	}
	xmlHttp.open("POST", url, false);
	xmlHttp.setRequestHeader("Content-Type", "application/json"); // x-www-form-urlencoded
	xmlHttp.send(body);
	if (xmlHttp.readyState != 0 || xmlHttp.readyState == "complete") {
		return eval('(' + xmlHttp.responseText + ')');
	}
}