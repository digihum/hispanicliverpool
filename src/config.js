// Set the require.js configuration for your application.
require.config({
  // Initialize the application with the main application file
  deps: ["main"],

  paths: {
    // JavaScript folders
    libs: "../",
    plugins: "../",

    // Libraries
    underscore: "../underscore",
    backbone: "../backbone",

    // Shim Plugin
    use: "../use"
  },

  use: {
    backbone: {
      deps: ["use!underscore"],
      attach: "Backbone"
    },

    underscore: {
      attach: "_"
    }
  }
});