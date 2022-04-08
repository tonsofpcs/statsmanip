# statsmanip
Ruby stats manipulation

* Sorts, sums, and combines various stats based on arrays at start of code.  
* Runs with [Sinatra](http://sinatrarb.com/), hosting its own httpd.  
* Pulls from sidearm stats
* Example: Visit http://host:8880/stats?sport=mbball&team=syracuse&xmlfile=1 to run manipulations against Syracuse Men's Basketball (source https://sidearmstats.com/syracuse/mbball/1.xml )
* Responds with XML with added values for sorting (example: tp_ord for order of players based on total points in basketball), sums (ex. corners added to linescore based on period for soccer), and combinations (ex. hits-atbats from hits + atbats for each player in baseball) 
