require [ "jquery", "backbone", "bootstrap" ], ->
  htmlEncode = (value) ->
    $("<div/>").text(value).html()
  $.fn.serializeObject = ->
    o = {}
    a = @serializeArray()
    $.each a, ->
      if o[@name] isnt `undefined`
        o[@name] = [ o[@name] ]  unless o[@name].push
        o[@name].push @value or ""
      else
        o[@name] = @value or ""

    o

  $.ajaxPrefilter (options, originalOptions, jqXHR) ->
    options.url = "/researchdb/html/liverpool/api" + options.url

  class Person extends Backbone.Model
    urlRoot: "/people"
  class People extends Backbone.Collection

    url: "/people"
    model: Person
  
  class Relationship extends Backbone.Model
    urlRoot: "/relationships"

  class Country extends Backbone.Model
    urlRoot: "/country"

  )

  Relationship = Backbone.Model.extend(urlRoot: "/relationships")

  Country = Backbone.Model.extend()

  Countries = Backbone.Collection.extend(
    url: "/countries"
    model: Country

  class Relationships extends Backbone.Collection
    model: Relationship
    url: "/relationships/" + @id
    parse: (response) ->
      console.log response
      response

  
  people = new People() # create a global collection of all people

  class PeopleListView extends Backbone.View
    el: "#homepage"
    initialize: ->
      @$el.html $("#view-loading").html()
      that = @
      people.fetch
        dataType: "jsonp"
        type: "GET"
        success: (result,b,c) ->
          console.log result,b,c
          require [ "text!../templates/list.html.tpl" ], (template) ->
            that.render _.template(template,
              persons: people.models
            )
        error: (a,b,c) ->
          console.log a,b,c



    render: (template) ->
      that = @
      breadcrumb_template = _.template($("#breadcrumb-template").html(),
        breadcrumbs: []
      )
      $("#breadcrumb").html breadcrumb_template
      $("#page").empty()
      if people.length is 0
        @$el.html $("#view-loading").html()
      else
        if template
          require [ "jquery.datatables", "jquery.datatables_bootstrap_3" ], ->
            that.$el.html template
            resultsTable = $("#persons-table").dataTable(
              sDom: "<'row'<'col-sm-6'<'form-group'l>><'col-sm-6'fi>r>t<'row'<'col-sm-12'>><'row'<'col-sm-12'p>>"
              sPaginationType: "bootstrap"
              stateSave: true
              bFilter: false
              aoColumnDefs: [
                bSortable: false #disable sortables on these columns (starts at 0)
                aTargets: [ 3 ]
               ]
              oLanguage:
                sLengthMenu: "_MENU_ people per page"
            )

          @$el.show()
        else
          @$el.show()
  
  class SearchFormView extends Backbone.View
    el: "#page"
    render: (options) ->
      that = @
      templated = _.template($("#breadcrumb-template").html(),
        breadcrumbs: [
          title: "Search"
          url: "/search"
         ]
      )
      $("#breadcrumb").html templated

      require [ "text!../templates/search.html.tpl" ], (template) ->
        that.$el.html _.template(template)

      countries = new Countries()
      console.log "fetch countries"
      #fetch the countries collection with an ajax call
      countries.fetch
        dataType: "jsonp"
        data: []
        success: (countries) ->
          console.log "countries: ", countries
        error: (response) ->
          console.log response
        reset: true

    events:
      "click div[id^=search-] label.btn": "visualDateUpdate"
      "change input[id$=-start], input[id$=-end]": "valueDateUpdate"
      "submit #search-form": "searchResults"

    searchResults: ->
      alert "not quite ready yet"
      false

    visualDateUpdate: (event) ->
      optionHit = $(event.currentTarget)[0].firstElementChild
      set = $(optionHit)[0].name.split("-")[0]
      value = parseInt($(optionHit)[0].value)
      switch value
        when 0
          $("#" + set + "-end, #" + set + "-and").hide()
          $("#" + set + "-start").show()
        when 1
          $("#" + set + "-start, #" + set + "-and").hide()
          $("#" + set + "-end").show()
        when 2
          $("#" + set + "-end, #" + set + "-and").hide()
          $("#" + set + "-start").show()
        when 3
          $("#" + set + "-end, #" + set + "-and, #" + set + "-start").show()
        else
      @valueDateUpdate event
      console.log "visual"

    valueDateUpdate: (event) ->
      console.log event.type
      set = event.currentTarget.id.split("-")[0]
      optionSelected = parseInt(event.currentTarget.id.split("-")[2])  if event.type is "click"
      optionSelected = parseInt($("input[name=" + set + "-range]:checked").val())  if event.type is "change"
      switch optionSelected
        when 0 #precice
          $("#" + set + "-start").val ""  if $("#" + set + "-start").val() is "0000"
          $("#" + set + "-end").val $("#" + set + "-start").val()
        when 1 #before
          $("#" + set + "-start").val "0000"
          $("#" + set + "-end").val ""  if $("#" + set + "-end").val() is "9999"
        when 2 #after
          $("#" + set + "-end").val "9999"
          $("#" + set + "-start").val ""  if $("#" + set + "-start").val() is "0000"
        when 3 #between
          console.log "evaluating: ", $("#" + set + "-start").val(), $("#" + set + "-end").val()
          $("#" + set + "-start").val ""  if $("#" + set + "-start").val() is "0000"
          $("#" + set + "-end").val ""  if $("#" + set + "-end").val() is "9999"
        else
      console.log "data"
    @
  
  class PersonSingleView extends Backbone.View
    el: "#page"
    fuzzyDateRenderer: (type, date1, date2) ->
      
      #takes the HL way of representing fuzzy dates, and returns a formatted string. 
      switch type
        when "exactly"
          return date1
        when "between"
          return "between " + ((if isset(date1) then date1 else "unknown")) + " and " + ((if isset(date2) then date2 else "unknown"))
        when "unknown", null
          "unknown"

    render: (options) ->
      that = this
      require [ "text!../templates/view.html.tpl" ], (template) ->
        that.$el.html _.template(template)

      person = new Person(id: options.id)
      person.fetch
        dataType: "jsonp"
        success: (person) ->
          
          # use some render helpers to add to the model some text to format fuzzy date types
          person.set
            birthdate: that.fuzzyDateRenderer(person.get("birthtype"), person.get("birthdate1"), person.get("birthdate2"))
            deathdate: that.fuzzyDateRenderer(person.get("deathtype"), person.get("deathdate1"), person.get("deathdate2"))

          
          # render the person partial 
          require [ "text!../templates/view_details.html.tpl" ], (template) ->
            $("#person-details").html _.template(template,
              person: person
            )

          
          # now we have a name, add this to the breadcrumb
          template = _.template($("#breadcrumb-template").html(),
            breadcrumbs: [
              url: "#view/" + person.id
              title: person.get("forenames") + " " + person.get("surname")
             ]
          )
          $("#breadcrumb").html template

      
      #create a new relationships collection for this person
      relationships = new Relationships(id: options.id)
      
      #fetch the relationships collection with an ajax call
      relationships.fetch
        dataType: "jsonp"
        success: (relationships) ->
          template = undefined
          
          #evaluate whether this person has any relationships in the collection to display
          if relationships.models.length > 0
            require [ "text!../templates/view_relationships.html.tpl" ], (template) ->
              $("#relationships").html _.template(template,
                relationships: relationships.models
              )

          else
            
            # cant name the person because it is loaded syncronously.
            template = "No relationships were found."
            $("#relationships").html template

  
  class Router extends Backbone.Router
    routes:
      "": "home"
      "view/:id": "viewPerson"
      new: "editPerson"
      list: "home"
      search: "searchForm"

  router = new Router
  
  #because peopleListView is special, we need to have this outside of the init router, otherwise it doesn't work when we call a subpage directly etc.
  router.on "route:home", ->
    peopleListView = new PeopleListView()
    peopleListView.render()

  router.on "route:searchForm", ->
    searchFormView = new SearchFormView()
    $("#homepage").hide()
    searchFormView.render()

  router.on "route:viewPerson", (id) ->
    personSingleView = new PersonSingleView()
    $("#homepage").hide()
    personSingleView.render id: id

  Backbone.history.start()
