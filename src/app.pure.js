require(["jquery","underscore","backbone","bootstrap","backbonePageable"], function($,_,Backbone,Bootstrap,PageableCollection) {

    function htmlEncode(value){
      return $('<div/>').text(value).html();
    }
    $.fn.serializeObject = function() {
      var o = {};
      var a = this.serializeArray();
      $.each(a, function() {
          if (o[this.name] !== undefined) {
              if (!o[this.name].push) {
                  o[this.name] = [o[this.name]];
              }
              o[this.name].push(this.value || '');
          } else {
              o[this.name] = this.value || '';
          }
      });
      return o;
    };

    $.ajaxPrefilter( function( options, originalOptions, jqXHR ) {
      options.url = 'http://localhost/researchdb/html/liverpool/api'  + options.url;

    });

    var Person = Backbone.Model.extend({
      urlRoot: '/people' 
    });  

    var People = Backbone.Collection.extend({
      url: '/people',
      model: Person,
      parse: function(response){
        return response;
      }
    });

    Backbone.PageableCollection = PageableCollection;

     var PaginatedPeople = Backbone.PageableCollection.extend({
      model: Person,
      paginator_core: {
        dataType: 'json',
        url: '/peoplepaginated'
      },
      url: '/peoplepaginated',
     state: {
        firstPage: 1,
        sortKey: "surname",
        pageSize: 20,
      },
     
      parse: function (response) {
        this.state.totalRecords = response.total;
        this.state.totalPages, this.state.lastPage = Math.ceil(response.total / this.state.pageSize);
        return response.data;
      }
     
    });



    var Relationship = Backbone.Model.extend({
      urlRoot: '/relationships'
    })

    var Country = Backbone.Model.extend();

    var Countries = Backbone.Collection.extend({
      url: '/countries',
      model: Country
    })

    var Relationships = Backbone.Collection.extend({
      url: function() {
        return '/relationships/' + this.models[0].id
      },
      model: Relationship
    })

    var people = new PaginatedPeople(); // create a global collection of all people

    var PeopleListView = Backbone.View.extend({
      el: '#homepage',
      initialize: function () {
        this.$el.html($('#view-loading').html());
        var that = this;
        people.getFirstPage({
          success: function(result) {
              that.backgrid(result);
          }
        });
      },
      backgrid: function(people){
        require(["backgrid","backbonePageable","backgridPaginator"], function(Backgrid,BackgridPaginator){
        var peopleGrid = new Backgrid.Grid({

          columns: [{
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
            label:"URL",
            cell: Backgrid.UriCell.extend({
              events: {click: "viewPerson"}
            }),
            sortable: false,
            editable: false
          }
          ],
          collection: people
        });

        var $paginatorExample = $("#page");

        $paginatorExample.append(peopleGrid.render().el);
        console.log(people);
        var paginator = new Backgrid.Extension.Paginator({
          collection: people
        });

        $paginatorExample.append(paginator.render().el);

      });
      },
      render: function (template) {
        var that = this;
        var breadcrumb_template = _.template($('#breadcrumb-template').html(), {breadcrumbs: []});
        $('#breadcrumb').html(breadcrumb_template);
        $('#page').empty();
          if(people.length == 0) {
            this.$el.html($('#view-loading').html());
          } else {
            if(template){
              require(["jquery.datatables","jquery.datatables_bootstrap_3"], function(){
              that.$el.html(template);
              var resultsTable = $("#persons-table").dataTable( {
                "sDom": "<'row'<'col-sm-6'<'form-group'l>><'col-sm-6'fi>r>t<'row'<'col-sm-12'>><'row'<'col-sm-12'p>>",
                "sPaginationType": "bootstrap",
                "stateSave": true,
                "bFilter": false,
                "aoColumnDefs": [
                      { "bSortable": false, "aTargets": [3] } //disable sortables on these columns (starts at 0)
                  ] ,
                "oLanguage": {
                  "sLengthMenu": "_MENU_ people per page"
                }
              });
            });
            this.$el.show(); 
            } else {
            this.$el.show(); 
          }
        } 
      }
    });

    var SearchFormView = Backbone.View.extend({
      el: '#page',
      render: function(options){
        var that = this;
        var templated = _.template($('#breadcrumb-template').html(), {breadcrumbs: [{title:"Search",
          url: "/search", }]});
        $('#breadcrumb').html(templated);
        require(["text!../templates/search.html.tpl"], function(template){
          that.$el.html(_.template(template));
        });

        countries = new Countries();
        countries.fetch({
          dataType: 'jsonp',
          success: function(countries) {
            console.log(countries.models);
            $(countries.models).each(function(index, country){
            $("#birth-country").append($("<option></option>").
                      attr("value",country.get("country")).
                      text(country.get("country")));
            });

          }
        })
      },
      events: {
        "click div[id^=search-] label.btn":"visualDateUpdate",
        "change input[id$=-start], input[id$=-end]": "valueDateUpdate",
        "submit #search-form": "searchResults"
      },
      searchResults: function(){
        alert("not quite ready yet");
        return false;
      },
      visualDateUpdate: function(event){
        var optionHit = $(event.currentTarget)[0].firstElementChild;
        var set = $(optionHit)[0].name.split("-")[0];
        var value = parseInt($(optionHit)[0].value);
        switch(value){
          case 0:
            $("#" + set + "-end, #" + set + "-and").hide();
            $("#" + set + "-start").show();
            break;
          case 1:
            $("#" + set + "-start, #" + set + "-and").hide();
            $("#" + set + "-end").show();
            break;
          case 2:
            $("#" + set + "-end, #" + set + "-and").hide();
            $("#" + set + "-start").show();
            break;  
          case 3:
            $("#" + set + "-end, #" + set + "-and, #" + set + "-start").show();
            break;       
          default:
            break;
        }
        this.valueDateUpdate(event);
        console.log("visual");
      },
      valueDateUpdate: function(event){
        console.log(event.type);
        var set = event.currentTarget.id.split("-")[0];
        if(event.type == "click"){
          var optionSelected = parseInt(event.currentTarget.id.split('-')[2]);          
        }
        if(event.type == "change"){
          var optionSelected = parseInt($("input[name=" + set + "-range]:checked").val()); 
        };
        switch(optionSelected){
          case 0: //precice
            if($("#"+set+"-start").val() == "0000"){
              $("#"+set+"-start").val("");
            }
            $("#"+set+"-end").val($("#"+set+"-start").val());
            break;
          case 1: //before
            $("#"+set+"-start").val("0000");
            if($("#"+set+"-end").val() == "9999"){
              $("#"+set+"-end").val("");
            }
            break;
          case 2: //after
            $("#"+set+"-end").val("9999")
            if($("#"+set+"-start").val() == "0000"){
              $("#"+set+"-start").val("");
            }
            break;
          case 3: //between
          console.log("evaluating: ",$("#"+set+"-start").val(),$("#"+set+"-end").val());
            if($("#"+set+"-start").val() == "0000"){
              $("#"+set+"-start").val("");
            }
            if($("#"+set+"-end").val() == "9999"){
              $("#"+set+"-end").val("");
            }
            break;
          default:
            break;

        }
                console.log("data");      }
   })




    var PersonSingleView = Backbone.View.extend({
      el: '#page',
      fuzzyDateRenderer: function(type,date1,date2){
        //takes the HL way of representing fuzzy dates, and returns a formatted string. 
        switch(type){
          case "exactly":
            return date1;
            break;
          case "between":
            return "between " + (isset(date1)?date1:"unknown") + " and " + (isset(date2)?date2:"unknown");
            break;
          case "unknown":
          case null:
            return "unknown";
        }
      },
      render: function (options) {
        var that = this;
        require(["text!../templates/view.html.tpl"], function(template){
          that.$el.html(_.template(template));
        });

        var person = new Person({id: options.id});
        person.fetch({
          dataType: 'jsonp',
          success: function(person) {

              // use some render helpers to add to the model some text to format fuzzy date types
              person.set({ 
                birthdate: that.fuzzyDateRenderer(person.get('birthtype'),person.get('birthdate1'),person.get('birthdate2')),
                deathdate: that.fuzzyDateRenderer(person.get('deathtype'),person.get('deathdate1'),person.get('deathdate2'))
                   });
              // render the person partial 


              require(["text!../templates/view_details.html.tpl"], function(template){
                $("#person-details").html(_.template(template, {person: person}));
              });


              // now we have a name, add this to the breadcrumb
              var template = _.template($('#breadcrumb-template').html(), {breadcrumbs: [{url: "#view/"+person.id,
                title: person.get('forenames') + " " + person.get('surname')}]});
              $('#breadcrumb').html(template);
            }
          });

        //create a new relationships collection for this person
        relationships = new Relationships({id: options.id })
        //fetch the relationships collection with an ajax call
        relationships.fetch({
          dataType: 'jsonp',
          success: function(relationships) {
            var template;
            //evaluate whether this person has any relationships in the collection to display
            if(relationships.models.length > 0 ){  
              require(["text!../templates/view_relationships.html.tpl"], function(template){
              $("#relationships").html(_.template(template, {relationships: relationships.models}));
              });
            } else {
              // can't name the person because it is loaded syncronously.
              template = "No relationships were found.";
              $('#relationships').html(template);
            }

          }
        })
      }
    });



    var Router = Backbone.Router.extend({
        routes: {
          "" : "home", 
          "view/:id": "viewPerson",
          "new": "editPerson",
          "list": "home",
          "search":"searchForm"
        }
    });

    var router = new Router;
    //because peopleListView is special, we need to have this outside of the init router, otherwise it doesn't work when we call a subpage directly etc.

    router.on('route:home', function() {
      var peopleListView = new PeopleListView();      
      peopleListView.render();
    });

    router.on('route:searchForm', function(){
      var searchFormView = new SearchFormView();
      $('#homepage').hide();
      searchFormView.render();
    });

    router.on('route:viewPerson', function(id) {
      var personSingleView = new PersonSingleView();
      $('#homepage').hide();
      personSingleView.render({id: id});
    });

    Backbone.history.start();


});