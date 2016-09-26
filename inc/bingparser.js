/* ===========================================*/
/* BING ULTRA FAST CRAWLER                    */
/* author: gdurtan                            */
/* usage in terminal:                         */
/* phantomjs bingparser.js searchquery        */
/* ===========================================*/

var url = 'http://www.bing.com/search?q='; 
var query = 'akcesoria%2Bkomputerowe';
var pagina = 1;
var counter = 0;

/* ===========================================*/
/* Technical functions _______________________*/

function get_url(){
	return url+query+'&first='+pagina+'1';
}
function extractEmails ( text ){
    return text.match(/([a-zA-Z0-9._-]+@[a-zA-Z0-9._-]+\.[a-zA-Z0-9._-]+)/gi);
}
function extractUrls ( text ){
    return text.match(/https?:[-a-zA-Z0-9@:%_\+.~#?&//=]{2,256}\.[a-z]{2,4}\b(\/[-a-zA-Z0-9@:%_\+.~#?&//=]*)?/gi);
}
function get_host(data) {
  var    a      = document.createElement('a');
         a.href = data;
  return a.hostname;
}

/* ===========================================*/
/* Init phantom browser ______________________*/

var page = require('webpage').create(),
  system = require('system'),
  t, address;

/* ===========================================*/
/* init data _________________________________*/

var t = new Date();
var date = t.toISOString().slice(0,10).replace(/-/g,"");


var query = system.args[1];

/* ===========================================*/
/* Init Filesystem ___________________________*/

var fs = require('fs');
var path = 'workspace/'+query+'.csv';
var path = 'workspace/'+date+'.csv';
var content = '';

/* ===========================================*/
/* check is bash command have query argument _*/

if (system.args.length === 1) {
  console.log('Usage: bingparser.js <some search query>');
  phantom.exit();
}

/* ===========================================*/
/* main crawler method _______________________*/

function crawlingPage(){
	
	page.open(get_url(), function(status) {

 		/* ------------------------------------------------------------ */
 		/* get DOM to parse from loaded url                             */
 		var current = page.evaluate(function() {
        	return document.getElementById("b_results").querySelector(".sb_pagS").textContent;
    	});
		
		/* ------------------------------------------------------------ */
    	/* Check is browser have more pages and if doesnt kill proces   */
    	if(current == pagina){
    		fs.write(path, content, 'w');
    		console.log( '------------------------------------------------------------');
			console.log( '  _____ ___ ___ _____   ___ ___ _  _ ___ ___ _  _ ___ ___    ');
			console.log( ' |_   _| __/ __|_   _| | __|_ _| \| |_ _/ __| || | __|   \  ');
			console.log( '   | | | _|\__ \ | |   | _| | || .` || |\__ \ __ | _|| |) | ');
			console.log( '   |_| |___|___/ |_|   |_| |___|_|\_|___|___/_||_|___|___/  ');
			console.log( '');
			console.log( '------------------------------------------------------------');
    		console.log( 'Summary. Cravled '+pagina+' Bing sites and '+counter+' urls' );
    		phantom.exit();
    	}
		
		/* ------------------------------------------------------------ */
		/* Grab URLs from current page                                  */
		var content_to_parse = page.evaluate(function() {
			//return document.body.innerHTML;
			return document.getElementById("b_results").innerHTML;
		});

		/* ------------------------------------------------------------ */
		/* Get result data array                                        */
		var result = extractUrls(content_to_parse); 
		for (var i = 0; i < result.length; i++) {
			var res = get_host(result[i]);

			/* filter bing translator urls */
			if(res != 'www.microsofttranslator.com'){
				console.log( get_host(result[i]) );
				content += get_host(result[i])+"\n";
				//content += get_host(result[i])+","+query+"\n";
				counter++;
			}
		};
		
		/* ------------------------------------------------------------ */
		/* increment page and run crawler again */
		pagina++;
		crawlingPage(); 

	});
}

/* ===========================================*/
/* run main crawler method ___________________*/
crawlingPage(); 
