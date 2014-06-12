// Generated by CoffeeScript 1.7.1
(function() {
  require(["jquery", "underscore", "backbone", "bootstrap", "backbone-paginator", "backbone-relational"], function($, _, Backbone, Bootstrap, PageableCollection) {
    var Address, Addresses, Countries, Country, FlatPerson, GeoCode, MapView, Occupation, Occupations, PaginatedPeople, People, PeopleListView, PeopleSearch, PeopleSearchResultsView, Person, PersonSingleView, Place, Places, Relationship, Relationships, Router, SearchFormView, htmlEncode, router;
    htmlEncode = function(value) {
      return $("<div/>").text(value).html();
    };
    $.fn.serializeObject = function() {
      var a, o;
      o = {};
      a = this.serializeArray();
      $.each(a, function() {
        if (o[this.name] !== undefined) {
          if (!o[this.name].push) {
            o[this.name] = [o[this.name]];
          }
          o[this.name].push(this.value || "");
        } else {
          o[this.name] = this.value || "";
        }
      });
      return o;
    };
    $.ajaxPrefilter(function(options, originalOptions, jqXHR) {
      if (options.url.split(":")[0] !== "http") {
        options.url = "http://researchdb.warwick.ac.uk/liverpool/api" + options.url;
      }
    });
    Address = Backbone.RelationalModel.extend();
    Addresses = Backbone.Collection.extend({
      model: Address
    });
    Occupation = Backbone.RelationalModel.extend();
    Occupations = Backbone.Collection.extend({
      url: "/occupations",
      model: Occupation
    });
    Relationship = Backbone.RelationalModel.extend();
    Relationships = Backbone.Collection.extend({
      url: function() {
        return "/relationships/" + this.models[0].id;
      },
      model: Relationship
    });
    FlatPerson = Backbone.Model.extend();
    Person = Backbone.RelationalModel.extend({
      urlRoot: "/people",
      relations: [
        {
          type: Backbone.HasMany,
          key: 'relationships',
          relatedModel: Relationship,
          collectionType: Occupations,
          reverseRelation: {
            key: 'person',
            includeInJSON: 'id'
          }
        }, {
          type: Backbone.HasMany,
          key: 'occupations',
          relatedModel: Occupation,
          collectionType: Occupations,
          reverseRelation: {
            key: 'person',
            includeInJSON: 'id'
          }
        }, {
          type: Backbone.HasMany,
          key: 'addresses',
          relatedModel: Address,
          collectionType: Addresses,
          reverseRelation: {
            key: 'person',
            includeInJSON: 'id'
          }
        }
      ],
      parse: function(response) {
        response.birthdate = this.fuzzyDateMaker(response.birthtype, response.birthdate1, response.birthdate2);
        response.deathdate = this.fuzzyDateMaker(response.deathtype, response.deathdate1, response.deathdate2);
        response.gender = this.genderMaker(response.sex);
        _.each(response.addresses, function(address) {
          var query;
          query = [];
          query.push(address.address.split(",")[1].trim() + " " + address.address.split(",")[0].trim());
          query.push("Liverpool");
          address.region !== "" && query.push(address.region);
          address.country !== "" && query.push(address.country);
          return address.query = query.join(", ");
        });
        return response;
      },
      fuzzyDateMaker: function(type, date1, date2) {
        switch (type) {
          case "exactly":
            return date1;
          case "between":
            return "between " + (isset(date1) ? date1 : "unknown") + " and " + (isset(date2) ? date2 : "unknown");
          case "unknown":
          case null:
            return "unknown";
        }
      },
      genderMaker: function(sex) {
        switch (sex) {
          case "m":
            return "Male";
          case "f":
            return "Female";
          case "":
          case "unknown":
          case null:
            return "Unknown";
        }
      }
    });
    People = Backbone.Collection.extend({
      url: "/people",
      model: FlatPerson,
      parse: function(response) {
        return response;
      }
    });
    PeopleSearch = Backbone.Collection.extend({
      url: function() {
        return "/peoplesearch?" + options.querystring;
      },
      model: FlatPerson,
      parse: function(response) {
        return response;
      }
    });
    Backbone.PageableCollection = PageableCollection;
    PaginatedPeople = Backbone.PageableCollection.extend({
      model: FlatPerson,
      url: "/peoplepaginated",
      state: {
        firstPage: 1,
        sortKey: "surname",
        pageSize: 20
      },
      parse: function(response) {
        this.state.totalRecords = parseInt(response.total);
        this.state.lastPage = Math.ceil(response.total / this.state.pageSize);
        return response.data;
      },
      parseRecords: function(response) {
        return response.data;
      },
      parseState: function(response) {
        this.state.totalRecords = parseInt(response.total);
        this.state.lastPage = Math.ceil(response.total / this.state.pageSize);
        return this.state;
      }
    });
    Place = Backbone.RelationalModel.extend({
      idAttribute: 'place'
    });
    Places = Backbone.Collection.extend({
      model: Place,
      parse: function(response) {
        console.log(this, response, "parsing place");
        return response;
      }
    });
    Country = Backbone.RelationalModel.extend({
      relations: [
        {
          type: Backbone.HasMany,
          key: 'places',
          relatedModel: Place,
          reverseRelation: {
            key: 'country'
          }
        }
      ],
      parse: function(response) {
        return response;
      }
    });
    Countries = Backbone.Collection.extend({
      url: "/countriesfull",
      model: Country
    });
    PeopleListView = Backbone.View.extend({
      el: "#page",
      initialize: function() {
        var people, that;
        that = this;
        this.$el.html($("#view-loading").html());
        people = new PaginatedPeople();
        return $.when(people.getFirstPage({
          dataType: "jsonp",
          error: function(args) {
            return console.log(arguments);
          }
        })).done(function() {
          return that.render(people);
        });
      },
      render: function(people) {
        var breadcrumb_template, that;
        that = this;
        breadcrumb_template = _.template($("#breadcrumb-template").html(), {
          breadcrumbs: []
        });
        $("#breadcrumb").html(breadcrumb_template);
        this.$el.empty();
        if (!people) {
          this.$el.html($("#view-loading").html());
        } else {
          if (people) {
            require(["backgrid", "backgrid-paginator"], function(Backgrid, BackgridPaginator) {
              var $paginatorExample, ClickableRow, myCell, paginator, peopleGrid;
              myCell = Backgrid.Cell.extend({
                viewingPerson: function(e) {
                  e.preventDefault();
                  return router.navigate("view/" + this.model.get("id"), {
                    trigger: true
                  });
                },
                render: function() {
                  this.$el.html("<button class='btn btn-primary btn-xs'>Records</button>");
                  return this;
                },
                events: {
                  "click": "viewingPerson"
                }
              });
              ClickableRow = Backgrid.Row.extend({
                events: {
                  "click": "rowClicked"
                },
                rowClicked: function() {
                  return router.navigate("view/" + this.model.get("id"), {
                    trigger: true
                  });
                }
              });
              peopleGrid = new Backgrid.Grid({
                row: ClickableRow,
                columns: [
                  {
                    name: "surname",
                    cell: "string",
                    sortable: true,
                    editable: false
                  }, {
                    name: "forenames",
                    cell: "string",
                    sortable: true,
                    editable: false
                  }, {
                    name: "gender",
                    label: "gender",
                    cell: "string",
                    sortable: true,
                    editable: false
                  }, {
                    cell: myCell
                  }
                ],
                collection: people
              });
              $paginatorExample = $("#page");
              $paginatorExample.append(peopleGrid.render().el);
              paginator = new Backgrid.Extension.Paginator({
                collection: people
              });
              $paginatorExample.append(paginator.render().el);
            });
            this.$el.show();
          } else {
            this.$el.show();
          }
        }
      }
    });
    SearchFormView = Backbone.View.extend({
      el: "#page",
      render: function(options) {
        var occupations, templated, that;
        that = this;
        templated = _.template($("#breadcrumb-template").html(), {
          breadcrumbs: [
            {
              title: "Search",
              url: "/search"
            }
          ]
        });
        $("#breadcrumb").html(templated);
        require(["text!../templates/search.html.tpl"], function(template) {
          that.$el.html(_.template(template));
        });
        this.countries = new Countries();
        this.countries.fetch({
          dataType: "jsonp",
          success: function(countries) {
            $(countries.models).each(function(index, country) {
              $("select[name=birthCountry]").append($("<option></option>").attr("value", country.get("country")).text(country.get("country")));
            });
          }
        });
        occupations = new Occupations();
        occupations.fetch({
          dataType: "jsonp",
          success: function(occupations) {
            $(occupations.models).each(function(index, occupation) {
              $("#occupation-category").append($("<option></option>").attr("value", occupation.get("category")).attr("data-id", occupation.get("id")).text(occupation.get("category")));
            });
          }
        });
      },
      events: {
        "click div[id^=search-] label.btn": "visualDateUpdate",
        "change input[id$=-start], input[id$=-end]": "valueDateUpdate",
        "click label[id$=-include]": "dateSelectorUpdate",
        "submit #search-form": "searchResults",
        "change select[name=birthCountry]": "placesUpdate"
      },
      searchResults: function(e) {
        var peopleSearchResultsView, queryString;
        e.preventDefault();
        this.$el.html($("#view-loading").html());
        peopleSearchResultsView = new PeopleSearchResultsView();
        queryString = $(e.currentTarget).serialize();
        router.navigate("search/results?" + queryString, {
          trigger: true
        });
        peopleSearchResultsView.search(queryString);
        return false;
      },
      dateSelectorUpdate: function(event) {
        $("#birth-start, #birth-and, #death-start, #death-and").hide();
        $("input[name^=date-type]:checked").each(function() {
          return this.checked = false;
        });
        $("label.disabled").removeClass("disabled");
        return true;
      },
      visualDateUpdate: function(event) {
        var optionHit, set, unset;
        optionHit = $(event.currentTarget)[0].firstElementChild;
        set = $("input[name='birth-death']:checked").val();
        unset = $("input[name='birth-death']:not(:checked)").val();
        switch (optionHit.value) {
          case "exactly":
            $("#" + set + "-end, #" + set + "-and").hide();
            $("#" + set + "-start").show();
            break;
          case "before":
            $("#" + set + "-start, #" + set + "-and").hide();
            $("#" + set + "-end").show();
            break;
          case "after":
            $("#" + set + "-end, #" + set + "-and").hide();
            $("#" + set + "-start").show();
            break;
          case "between":
            $("#" + set + "-end, #" + set + "-and, #" + set + "-start").show();
            break;
        }
        this.valueDateUpdate(event);
      },
      valueDateUpdate: function(event) {
        var optionSelected, set;
        set = event.currentTarget.id.split("-")[0];
        if (event.type === "click") {
          optionSelected = parseInt(event.currentTarget.id.split("-")[2]);
        }
        if (event.type === "change") {
          optionSelected = parseInt($("input[name=" + set + "type]:checked").val());
        }
        switch (optionSelected) {
          case "excatly":
            if ($("#" + set + "-start").val() === "0000") {
              $("#" + set + "-start").val("");
            }
            $("#" + set + "-end").val($("#" + set + "-start").val());
            break;
          case "before":
            $("#" + set + "-start").val("0000");
            if ($("#" + set + "-end").val() === "9999") {
              $("#" + set + "-end").val("");
            }
            break;
          case "after":
            $("#" + set + "-end").val("9999");
            if ($("#" + set + "-start").val() === "0000") {
              $("#" + set + "-start").val("");
            }
            break;
          case "between":
            console.log("evaluating: ", $("#" + set + "-start").val(), $("#" + set + "-end").val());
            if ($("#" + set + "-start").val() === "0000") {
              $("#" + set + "-start").val("");
            }
            if ($("#" + set + "-end").val() === "9999") {
              $("#" + set + "-end").val("");
            }
            break;
        }
      },
      placesUpdate: function(event) {
        var that;
        that = this;
        this.country = this.countries.findWhere({
          country: $(event.currentTarget).children("option:selected")[0].value
        });
        switch (this.country.get("places").models.length) {
          case 1:
            $("select[name=birthPlace]").empty().attr("disabled", true);
            $.each(this.country.get("places").models, function(index, place) {
              return $("select[name=birthPlace]").append($("<option></option>").attr("value", place.get("place")).text(place.get("place")));
            });
            break;
          case 0:
            $("select[name=birthPlace]").empty().attr("disabled", true);
            break;
          default:
            $("select[name=birthPlace]").empty().attr("disabled", false).append($("<option></option>").attr("value", "").text("-- " + this.country.get("places").models.length + " places within " + this.country.get("country") + " --"));
            $.each(this.country.get("places").models, function(index, place) {
              return $("select[name=birthPlace]").append($("<option></option>").attr("value", place.get("place")).text(place.get("place")));
            });
        }
        return {
          initialize: function() {
            _.bindAll(this, 'render', 'placesLookup');
            return this.model.bind('change:places', this.placesLookup);
          }
        };
      }
    });
    PeopleSearchResultsView = Backbone.View.extend({
      el: "#page",
      initialize: function() {
        this.$el.html($("#view-loading").html());
        this.peopleResults = new PeopleSearch;
        return this.createBackGrid();
      },
      createBackGrid: function() {
        var that;
        that = this;
        return require(["backgrid"], function(Backgrid) {
          var ClickableRow, myCell;
          myCell = Backgrid.Cell.extend({
            viewingPerson: function(e) {
              e.preventDefault();
              return router.navigate("view/" + this.model.get("id"), {
                trigger: true
              });
            },
            render: function() {
              this.$el.html("<button class='btn btn-primary btn-xs'>Records</button>");
              return this;
            },
            events: {
              "click": "viewingPerson"
            }
          });
          ClickableRow = Backgrid.Row.extend({
            events: {
              "click": "rowClicked"
            },
            rowClicked: function() {
              return router.navigate("view/" + this.model.get("id"), {
                trigger: true
              });
            }
          });
          return that.peopleGrid = new Backgrid.Grid({
            row: ClickableRow,
            columns: [
              {
                name: "surname",
                cell: "string",
                sortable: true,
                editable: false
              }, {
                name: "forenames",
                cell: "string",
                sortable: true,
                editable: false
              }, {
                name: "gender",
                label: "gender",
                cell: "string",
                sortable: true,
                editable: false
              }, {
                className: "button",
                cell: myCell
              }
            ],
            collection: that.peopleResults
          });
        });
      },
      search: function(querystring) {
        var that;
        that = this;
        return $.when(this.peopleResults.fetch({
          dataType: "jsonp",
          url: "/peoplesearch?" + querystring
        })).done(function() {
          return that.render();
        });
      },
      render: function() {
        var breadcrumb_template, that;
        that = this;
        breadcrumb_template = _.template($("#breadcrumb-template").html(), {
          breadcrumbs: [
            {
              url: "#search",
              title: "People Search"
            }
          ]
        });
        breadcrumb_template = _.template($("#breadcrumb-template").html(), {
          breadcrumbs: [
            {
              url: "#search",
              title: "People Search"
            }, {
              url: "",
              title: "Showing search results (" + that.peopleResults.length + ")"
            }
          ]
        });
        $("#breadcrumb").html(breadcrumb_template);
        this.$el.empty();
        return this.$el.append(this.peopleGrid.render().el);
      }
    });
    PersonSingleView = Backbone.View.extend({
      el: "#page",
      initialize: function() {
        this.listenTo(this.model, 'change', this.render);
        return this.model.fetch({
          dataType: "jsonp"
        });
      },
      render: function(options) {
        var template, that;
        that = this;
        require(["text!../templates/view.html.tpl"], function(template) {
          that.$el.html(_.template(template));
        });
        require(["text!../templates/view_details.html.tpl"], function(template) {
          $("#person-details").html(_.template(template, {
            person: that.model
          }));
        });
        template = _.template($("#breadcrumb-template").html(), {
          breadcrumbs: [
            {
              url: "#view/" + this.model.get("id"),
              title: this.model.get("forenames") + " " + this.model.get("surname")
            }
          ]
        });
        $("#breadcrumb").html(template);
        if (this.model.get("relationships").models.length > 0) {
          require(["text!../templates/view_relationships.html.tpl"], function(template) {
            return $("#relationships").empty().html(_.template(template, {
              relationships: that.model.get("relationships").models
            }));
          });
        }
        if (this.model.get("occupations").models.length > 0) {
          require(["text!../templates/view_occupation.html.tpl"], function(template) {
            $("#bibliographical-details .loading").remove();
            return $("#bibliographical-details").append(_.template(template, {
              occupations: that.model.get("occupations").models
            }));
          });
        }
        if (this.model.get("addresses").models.length > 0) {
          return require(["text!../templates/view_address.html.tpl"], function(template) {
            return $("#bibliographical-details").append(_.template(template, {
              addresses: that.model.get("addresses").models
            }, that.mapView = new MapView(), that.mapView.render(), _.each(that.model.get("addresses").models, function(address) {
              var geocode;
              if (address.get("latitude") && address.get("longitude")) {
                return that.mapView.addMarker(address.get("latitude"), address.get("longitude"));
              } else {
                geocode = new GeoCode({
                  id: address.get("query")
                });
                geocode.fetchFind({
                  dataType: "jsonp"
                });
                return that.listenTo(geocode, 'change', that.addMarker);
              }
            })));
          });
        }
      },
      addMarker: function(geocode) {
        return this.mapView.addMarker(geocode.get("latitude"), geocode.get("longitude"), geocode.get("id"));
      }
    });
    MapView = Backbone.View.extend({
      el: "#address-map",
      initialize: function() {
        return require(["leaflet"], function() {
          return this.map = L.map("address-map").setView([0, 0], 10);
        });
      },
      render: function(options) {
        var that;
        that = this;
        return require(["leaflet"], function() {
          L.tileLayer('http://{s}.tiles.mapbox.com/v3/steveranford.icifhpgl/{z}/{x}/{y}.png', {
            attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://mapbox.com">Mapbox</a>',
            maxZoom: 18
          }).addTo(this.map);
          return $(that.el).hide();
        });
      },
      addMarker: function(lat, long, popupContent) {
        var that;
        that = this;
        return require(["leaflet"], function() {
          var location;
          location = L.latLng(lat, long);
          L.marker(location).addTo(this.map).bindPopup(popupContent).openPopup();
          this.map.setView([lat, long], 15);
          return $(that.el).show();
        });
      }
    });
    GeoCode = Backbone.Model.extend({
      urlRoot: "http://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer/",
      parse: function(response) {
        var geocode;
        geocode = {};
        if (response.locations.length > 0) {
          geocode.longitude = response.locations[0].feature.geometry.x || '';
          geocode.latitude = response.locations[0].feature.geometry.y || '';
        }
        return geocode;
      },
      fetchFind: function(options) {
        options = options || {};
        if (options.url === void 0) {
          options.url = this.urlRoot + "find?f=pjson&text=" + this.id;
        }
        return Backbone.Model.prototype.fetch.call(this, options);
      }
    });
    Router = Backbone.Router.extend({
      routes: {
        "": "home",
        "view/:id": "viewPerson",
        "new": "editPerson",
        list: "home",
        search: "searchForm",
        "search/results?:querystring": "viewPersonResults",
        "search/results": "searchForm"
      }
    });
    router = new Router;
    router.on("route:home", function() {
      var peopleListView;
      peopleListView = new PeopleListView();
    });
    router.on("route:searchForm", function() {
      var searchFormView;
      searchFormView = new SearchFormView();
      searchFormView.render();
    });
    router.on("route:viewPerson", function(id) {
      var person, personSingleView;
      if (person = Person.findModel({
        id: id
      })) {

      } else {
        person = new Person({
          id: id
        });
      }
      personSingleView = new PersonSingleView({
        model: person
      });
    });
    router.on("route:viewPersonResults", function(querystring) {
      var peopleSearchResultsView;
      peopleSearchResultsView = new PeopleSearchResultsView();
      peopleSearchResultsView.search(querystring);
    });
    Backbone.history.start();
  });

}).call(this);
