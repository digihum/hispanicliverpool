// Generated by CoffeeScript 1.7.1
(function() {
  require.config({
    baseUrl: "src",
    deps: ["main"],
    defnine: {
      underscore: "lib/underscore"
    },
    paths: {
      tpl: "../templates",
      lib: "../assets/lib",
      text: "../assets/lib/requirejs-text/text",
      jquery: "../assets/lib/jquery/dist/jquery.min",
      underscore: "../assets/lib/underscore/underscore-min",
      backbone: "../assets/lib/backbone/backbone-min",
      bootstrap: "../assets/lib/bootstrap/bootstrap.min",
      backbonePaginator: "../assets/lib/backbone-paginator/lib/backbone.paginator.min",
      backgrid: "../assets/lib/backgrid/lib/backgrid",
      backgridPaginator: "../assets/lib/backgrid-paginator/backgrid-paginator",
      backboneRelational: "../assets/lib/backbone-relational/backbone-relational",
      leaflet: "http://cdn.leafletjs.com/leaflet-0.4/leaflet"
    },
    shim: {
      backbone: {
        deps: ["underscore", "jquery"],
        exports: "Backbone"
      },
      backgrid: {
        deps: ["jquery", "backbone"],
        exports: "Backgrid"
      },
      backgridPaginator: {
        deps: ["jquery", "backbone", "backgrid"],
        exports: "BackgridPaginator"
      },
      bootstrap: ["jquery"]
    }
  });

  require(["app"], function() {});

}).call(this);
