// Set the require.js configuration for your application.
require.config({
  // Initialize the application with the main application file
  deps: ["main"],
  baseUrl: "assets",
  paths: {

    // Libraries
    jquery: 'http://cdnjs.cloudflare.com/ajax/libs/jquery/1.11.0/jquery',
    underscore: "lib/underscore",
    backbone: "lib/backbone",
    bootstrap: "lib/bootstrap.min",
    "jquery.datatables": "lib/jquery.datatables.min",
    "jquery.datatables_bootstrap_3": "lib/datatables_bootstrap_3",
    app: "../src/app"
  },
   // Sets the configuration for your third party scripts that are not AMD compatible
  shim: {

      "backbone": {
          deps: ["underscore", "jquery"],
          exports: "Backbone"  //attaches "Backbone" to the window object
      }

  }, // end Shim Configuration

    underscore: {
      attach: "_"
    }
  
});


require(["app"], function(Backbone) {
  console.log(Backbone); // is Backbone!
});

/*require([

  // Load our app module and pass it to our definition function
  'app',
], function(App){
  // The "app" dependency is passed in as "App"
  App.initialize();
});*/