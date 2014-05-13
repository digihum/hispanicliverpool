require [
  "jquery"
  "underscore"
  "backbone"
  "bootstrap"
  "backbonePaginator"
], ($, _, Backbone, Bootstrap, PageableCollection) ->
  htmlEncode = (value) ->
    $("<div/>").text(value).html()
  $.fn.serializeObject = ->
    o = {}
    a = @serializeArray()
    $.each a, ->
      if o[@name] isnt `undefined`
        o[@name] = [o[@name]]  unless o[@name].push
        o[@name].push @value or ""
      else
        o[@name] = @value or ""
      return

    o

  $.ajaxPrefilter (options, originalOptions, jqXHR) ->
    options.url = "http://localhost/researchdb/html/liverpool/api" + options.url
    return

  Person = Backbone.Model.extend(urlRoot: "/people")
  People = Backbone.Collection.extend(
    url: "/people"
    model: Person
    parse: (response) ->
      response
  )
  Backbone.PageableCollection = PageableCollection
  PaginatedPeople = Backbone.PageableCollection.extend(
    model: Person
    url: "/peoplepaginated"
    state:
      firstPage: 1
      sortKey: "surname"
      pageSize: 20

    parse: (response) -> 
      @state.totalRecords = response.total
      @state.lastPage = Math.ceil(response.total / @state.pageSize)
      response.data
    parseRecords: (response) ->
      response.data
    parseState: (response) ->
      @state.totalRecords = response.total
      @state.lastPage = Math.ceil(response.total / @state.pageSize)

  )

  Relationship = Backbone.Model.extend(urlRoot: "/relationships")

  Country = Backbone.Model.extend()

  Countries = Backbone.Collection.extend(
    url: "/countries"
    model: Country
  )
  Relationships = Backbone.Collection.extend(
    url: ->
      "/relationships/" + @models[0].id

    model: Relationship
  )
  people = new PaginatedPeople() # create a global collection of all people
  PeopleListView = Backbone.View.extend(
    el: "#page"
    initialize: ->
      @$el.html $("#view-loading").html()
      that = this
      people.getFirstPage success: (result) ->
        that.render result
        return
      return
    render: (people) ->
      that = this
      breadcrumb_template = _.template($("#breadcrumb-template").html(),
        breadcrumbs: []
      )
      $("#breadcrumb").html breadcrumb_template
      @$el.empty()

      if !people
        @$el.html $("#view-loading").html()
      else
        if people

          require [
            "backgrid"
            "backgridPaginator"
          ], (Backgrid, BackgridPaginator) ->
            peopleGrid = new Backgrid.Grid(
              columns: [
                {
                  name: "surname"
                  cell: "string"
                  sortable: true
                  editable: false
                }
                {
                  name: "forenames"
                  cell: "string"
                  sortable: true
                  editable: false
                }
                {
                  name: "sex"
                  label: "gender"
                  cell: "string"
                  sortable: true
                  editable: false
                }
                {
                  name: "id"
                  label: "URL"
                  cell: Backgrid.UriCell.extend(events:
                    click: "viewPerson"
                  )
                  sortable: false
                  editable: false
                }
              ]
              collection: people
            )
            $paginatorExample = $("#page")
            $paginatorExample.append peopleGrid.render().el

            paginator = new Backgrid.Extension.Paginator(collection: people)
            $paginatorExample.append paginator.render().el
            return
          @$el.show()
        else
          @$el.show()
      return
  )
  SearchFormView = Backbone.View.extend(
    el: "#page"
    render: (options) ->
      that = this
      templated = _.template($("#breadcrumb-template").html(),
        breadcrumbs: [
          title: "Search"
          url: "/search"
        ]
      )
      $("#breadcrumb").html templated
      require ["text!../templates/search.html.tpl"], (template) ->
        that.$el.html _.template(template)
        return

      countries = new Countries()
      countries.fetch
        dataType: "jsonp"
        success: (countries) ->
          $(countries.models).each (index, country) ->
            $("#birth-country").append $("<option></option>").attr("value", country.get("country")).text(country.get("country"))
            return

          return

      return

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
      return

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
      return
  )
  PersonSingleView = Backbone.View.extend(
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
      require ["text!../templates/view.html.tpl"], (template) ->
        that.$el.html _.template(template)
        return

      person = new Person(id: options.id)
      person.fetch
        dataType: "jsonp"
        success: (person) ->
          
          # use some render helpers to add to the model some text to format fuzzy date types
          person.set
            birthdate: that.fuzzyDateRenderer(person.get("birthtype"), person.get("birthdate1"), person.get("birthdate2"))
            deathdate: that.fuzzyDateRenderer(person.get("deathtype"), person.get("deathdate1"), person.get("deathdate2"))

          
          # render the person partial 
          require ["text!../templates/view_details.html.tpl"], (template) ->
            $("#person-details").html _.template(template,
              person: person
            )
            return

          
          # now we have a name, add this to the breadcrumb
          template = _.template($("#breadcrumb-template").html(),
            breadcrumbs: [
              url: "#view/" + person.id
              title: person.get("forenames") + " " + person.get("surname")
            ]
          )
          $("#breadcrumb").html template
          return

      
      #create a new relationships collection for this person
      relationships = new Relationships(id: options.id)
      
      #fetch the relationships collection with an ajax call
      relationships.fetch
        dataType: "jsonp"
        success: (relationships) ->
          template = undefined
          
          #evaluate whether this person has any relationships in the collection to display
          if relationships.models.length > 0
            require ["text!../templates/view_relationships.html.tpl"], (template) ->
              $("#relationships").html _.template(template,
                relationships: relationships.models
              )
              return

          else
            
            # can't name the person because it is loaded syncronously.
            template = "No relationships were found."
            $("#relationships").html template
          return

      return
  )
  Router = Backbone.Router.extend(routes:
    "": "home"
    "view/:id": "viewPerson"
    new: "editPerson"
    list: "home"
    search: "searchForm"
  )
  router = new Router
  
  #because peopleListView is special, we need to have this outside of the init router, otherwise it doesn't work when we call a subpage directly etc.
  router.on "route:home", ->
    peopleListView = new PeopleListView()
    peopleListView.render()
    return

  router.on "route:searchForm", ->
    searchFormView = new SearchFormView()
    $("#homepage").hide()
    searchFormView.render()
    return

  router.on "route:viewPerson", (id) ->
    personSingleView = new PersonSingleView()
    $("#homepage").hide()
    personSingleView.render id: id
    return

  Backbone.history.start()
  return
