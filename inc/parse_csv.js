var t = new Date();
var date = t.toISOString().slice(0,10).replace(/-/g,"");


var fs = require('fs');
var file_h = fs.open('workspace/'+date+'.csv', 'r');
var line = file_h.readLine();


function read_next_line(){
	console.log(line);
	var page = require('webpage').create();
	page.open('http://'+line, function(status) {
		console.log('page loaded');
		/* ------------------------------------------------------------ */
		/* get DOM to parse from loaded url                             */
		var element = page.evaluate(function() {

			var el = document.getElementsByTagName('meta').item(name='generator');
			return el.getAttribute('content');
		});
		console.log(element);
		line = file_h.readLine();
		read_next_line(); 
	});
}
read_next_line(); 
    


//file_h.close();



