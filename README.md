# statsmanip
## Ruby stats manipulation

* Sorts, sums, and combines various stats based on arrays at start of code.  
* Runs with [Sinatra](http://sinatrarb.com/), hosting its own httpd.  
* Pulls from sidearm stats
* Example: Visit http://host:8880/stats?sport=mbball&team=syracuse&xmlfile=1 to run manipulations against Syracuse Men's Basketball (source https://sidearmstats.com/syracuse/mbball/1.xml )
* If parameters are not passed with GET, default sport is ``mbball``, default team is ``example`` (set at start of code), default xmlfile is ``1``. 
* Responds with XML with added values for sorting (example: tp_ord for order of players based on total points in basketball), sums (ex. corners added to linescore based on period for soccer), and combinations (ex. hits-atbats from hits + atbats for each player in baseball) 

## Windows Installation for local use
1. Install Ruby
   - I tested using ruby+devkit 3.4.9-1 from https://rubyinstaller.org  
2. Install sinatra, nokogiri and dependencies.
   - At a command prompt, run ``gem install sinatra rackup puma nokogiri``
3. Run stats.rb, allow access to networks as appropriate
4. Point your software at localhost:8880/stats as described in the example above.  
