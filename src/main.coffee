# Set the require.js configuration for your application.
require.config
  
  # Initialize the application with the main application file
  deps: ["main"]
  baseUrl: "assets"
  defnine:
    underscore: "lib/underscore"

  paths:
    
    # Directories
    tpl: "../templates"
    lib: "lib/"
    
    # Location of the text plugin
    text: "lib/requirejs-text/text"
    
    # Libraries
    jquery: "http://cdnjs.cloudflare.com/ajax/libs/jquery/1.11.0/jquery"
    underscore: "lib/underscore/underscore-min"
    backbone: "lib/backbone/backbone-min"
    bootstrap: "lib/bootstrap/bootstrap.min"
    backbonePaginator: "lib/backbone-paginator/lib/backbone.paginator.min"
    backgrid: "lib/backgrid/lib/backgrid"
    backgridPaginator: "lib/backgrid-paginator/backgrid-paginator" #the minified version seems to have an issue.
    backboneRelational: "lib/backbone-relational/backbone-relational"
    app: "../src/app"

  
  # Sets the configuration for your third party scripts that are not AMD compatible
  shim:
    backbone:
      deps: [
        "underscore"
        "jquery"
      ]
      exports: "Backbone" #attaches "Backbone" to the window object

    backgrid:
      deps: [
        "jquery"
        "backbone"
      ]
      exports: "Backgrid"

    backgridPaginator:
      deps: [
        "jquery"
        "backbone"
        "backgrid"
      ]
      exports: "BackgridPaginator"

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