// Generated by CoffeeScript 1.7.1
(function() {
  require(["jquery", "underscore", "backbone", "bootstrap", "backbonePaginator"], function($, _, Backbone, Bootstrap, PageableCollection) {
    var Countries, Country, Occupations, PaginatedPeople, People, PeopleListView, PeopleSearch, PeopleSearchResultsView, Person, PersonSingleView, Relationship, Relationships, Router, SearchFormView, htmlEncode, router;
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
      options.url = "http://researchdb.warwick.ac.uk/liverpool/api" + options.url;
    });
    Person = Backbone.Model.extend({
      urlRoot: "/people"
    });
    People = Backbone.Collection.extend({
      url: "/people",
      model: Person,
      parse: function(response) {
        return response;
      }
    });
    PeopleSearch = Backbone.Collection.extend({
      url: function() {
        return "/peoplesearch?" + options.querystring;
      },
      model: Person,
      parse: function(response) {
        return response;
      }
    });
    Backbone.PageableCollection = PageableCollection;
    PaginatedPeople = Backbone.PageableCollection.extend({
      model: Person,
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
    Relationship = Backbone.Model.extend({
      urlRoot: "/relationships"
    });
    Country = Backbone.Model.extend();
    Countries = Backbone.Collection.extend({
      url: "/countries",
      model: Country
    });
    Occupations = Backbone.Collection.extend({
      url: "/occupations"
    });
    Relationships = Backbone.Collection.extend({
      url: function() {
        return "/relationships/" + this.models[0].id;
      },
      model: Relationship
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
            require(["backgrid", "backgridPaginator"], function(Backgrid, BackgridPaginator) {
              var $paginatorExample, ClickableRow, paginator, peopleGrid;
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
                    name: "sex",
                    label: "gender",
                    cell: "string",
                    sortable: true,
                    editable: false
                  }, {
                    name: "id",
                    label: "URL",
                    cell: Backgrid.UriCell.extend({
                      events: {
                        click: "viewPerson"
                      }
                    }),
                    sortable: false,
                    editable: false
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
        var countries, occupations, templated, that;
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
        countries = new Countries();
        countries.fetch({
          dataType: "jsonp",
          success: function(countries) {
            $(countries.models).each(function(index, country) {
              $("#birth-country").append($("<option></option>").attr("value", country.get("country")).text(country.get("country")));
            });
          }
        });
        occupations = new Occupations();
        occupations.fetch({
          dataType: "jsonp",
          success: function(occupations) {
            $(occupations.models).each(function(index, occupation) {
              $("#occupation-category").append($("<option></option>").attr("value", occupation.get("category")).text(occupation.get("category")));
            });
          }
        });
      },
      events: {
        "click div[id^=search-] label.btn": "visualDateUpdate",
        "change input[id$=-start], input[id$=-end]": "valueDateUpdate",
        "submit #search-form": "searchResults"
      },
      searchResults: function(e) {
        var peopleSearchResultsView, queryString;
        e.preventDefault();
        peopleSearchResultsView = new PeopleSearchResultsView();
        queryString = $(e.currentTarget).serialize();
        router.navigate("search/results?" + queryString, {
          trigger: true
        });
        peopleSearchResultsView.render(queryString);
        return false;
      },
      visualDateUpdate: function(event) {
        var optionHit, set, value;
        optionHit = $(event.currentTarget)[0].firstElementChild;
        set = $(optionHit)[0].name.substr(0, 5);
        value = $(optionHit)[0].value;
        switch (value) {
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
        console.log(value);
      },
      valueDateUpdate: function(event) {
        var optionSelected, set;
        console.log(event.type);
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
        console.log("data");
      }
    });
    PeopleSearchResultsView = Backbone.View.extend({
      el: "#page",
      initialize: function() {
        this.peopleResults = new PeopleSearch;
        return this.createBackGrid();
      },
      createBackGrid: function() {
        var that;
        that = this;
        return require(["backgrid"], function(Backgrid) {
          var ClickableRow, myCell;
          myCell = Backgrid.Cell.extend({
            viewingPerson: function() {
              console.log("clicked");
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
                name: "sex",
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
      fuzzyDateRenderer: function(type, date1, date2) {
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
      render: function(options) {
        var person, relationships, that;
        that = this;
        require(["text!../templates/view.html.tpl"], function(template) {
          that.$el.html(_.template(template));
        });
        person = new Person({
          id: options.id
        });
        person.fetch({
          dataType: "jsonp",
          success: function(person) {
            var template;
            person.set({
              birthdate: that.fuzzyDateRenderer(person.get("birthtype"), person.get("birthdate1"), person.get("birthdate2")),
              deathdate: that.fuzzyDateRenderer(person.get("deathtype"), person.get("deathdate1"), person.get("deathdate2"))
            });
            require(["text!../templates/view_details.html.tpl"], function(template) {
              $("#person-details").html(_.template(template, {
                person: person
              }));
            });
            template = _.template($("#breadcrumb-template").html(), {
              breadcrumbs: [
                {
                  url: "#view/" + person.id,
                  title: person.get("forenames") + " " + person.get("surname")
                }
              ]
            });
            $("#breadcrumb").html(template);
          }
        });
        relationships = new Relationships({
          id: options.id
        });
        relationships.fetch({
          dataType: "jsonp",
          success: function(relationships) {
            var template;
            template = void 0;
            if (relationships.models.length > 0) {
              require(["text!../templates/view_relationships.html.tpl"], function(template) {
                $("#relationships").html(_.template(template, {
                  relationships: relationships.models
                }));
              });
            } else {
              template = "No relationships were found.";
              $("#relationships").html(template);
            }
          }
        });
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
      var personSingleView;
      personSingleView = new PersonSingleView();
      personSingleView.render({
        id: id
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
