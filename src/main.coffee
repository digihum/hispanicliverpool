# Set the require.js configuration for your application.
require.config
  baseUrl: "src"
  # Initialize the application with the main application file
  deps: ["main"]
  defnine:
    underscore: "lib/underscore"

  paths:
    
    # Directories
    tpl: "../templates"
    lib: "../assets/lib"
    
    # Location of the text plugin
    text: "../assets/lib/requirejs-text/text"
    
    # Libraries
    jquery: "../assets/lib/jquery/dist/jquery.min"
    underscore: "../assets/lib/underscore/underscore-min"
    backbone: "../assets/lib/backbone/backbone-min"
    bootstrap: "../assets/lib/bootstrap/bootstrap.min"
    "backbone-paginator": "../assets/lib/backbone-paginator/lib/backbone.paginator.min"
    backgrid: "../assets/lib/backgrid/lib/backgrid"
    "backgrid-paginator": "../assets/lib/backgrid-paginator/backgrid-paginator" #the minified version seems to have an issue.
    "backbone-relational": "../assets/lib/backbone-relational/backbone-relational"
    leaflet: "http://cdn.leafletjs.com/leaflet-0.4/leaflet"
    # causing issues: app: "../src" #picked-up
  
  # Sets the configuration for your third party scripts that are not AMD compatible
  shim:
    bootstrap: ["jquery"]


# end Shim Configuration

# App
require ["app"], ->


#this loads app.js, and therefore kicks off the whole shebang!

#require([
#
#  // Load our app module and pass it to our definition function
#  'app',
#], function(App){
#  // The "app" dependency is passed in as "App"
#  App.initialize();
#});