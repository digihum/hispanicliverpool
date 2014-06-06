// Generated by CoffeeScript 1.7.1
(function() {
  require.config({
    deps: ["main"],
    baseUrl: "assets",
    defnine: {
      underscore: "lib/underscore"
    },
    paths: {
      tpl: "../templates",
      lib: "lib/",
      text: "lib/requirejs-text/text",
      jquery: "http://cdnjs.cloudflare.com/ajax/libs/jquery/1.11.0/jquery",
      underscore: "lib/underscore/underscore-min",
      backbone: "lib/backbone/backbone-min",
      bootstrap: "lib/bootstrap/bootstrap.min",
      backbonePaginator: "lib/backbone-paginator/lib/backbone.paginator.min",
      backgrid: "lib/backgrid/lib/backgrid",
      backgridPaginator: "lib/backgrid-paginator/backgrid-paginator",
      backboneRelational: "lib/backbone-relational/backbone-relational",
      leaflet: "http://cdn.leafletjs.com/leaflet-0.4/leaflet",
      app: "../src/app"
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
