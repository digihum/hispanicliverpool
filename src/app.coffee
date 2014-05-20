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
    options.url = "http://researchdb.warwick.ac.uk/liverpool/api" + options.url
    return

  Person = Backbone.Model.extend(urlRoot: "/people")
  People = Backbone.Collection.extend(
    url: "/people"
    model: Person
    parse: (response) ->
      response
  )
  PeopleSearch = Backbone.Collection.extend(
    url: ->
      "/peoplesearch?" + options.querystring
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
      @state.totalRecords = parseInt(response.total)
      @state.lastPage = Math.ceil(response.total / @state.pageSize)
      response.data
    parseRecords: (response) ->
      response.data
    parseState: (response) ->
      @state.totalRecords = parseInt(response.total)
      @state.lastPage = Math.ceil(response.total / @state.pageSize)
      @state
  )

  Relationship = Backbone.Model.extend(urlRoot: "/relationships")

  Country = Backbone.Model.extend()

  Countries = Backbone.Collection.extend(
    url: "/countries"
    model: Country
  )

  Occupations = Backbone.Collection.extend url: "/occupations"

  Relationships = Backbone.Collection.extend(
    url: ->
      "/relationships/" + @models[0].id

    model: Relationship
  )

  PeopleListView = Backbone.View.extend(
    el: "#page"
    initialize: ->
      that = @
      @$el.html $("#view-loading").html()
      people = new PaginatedPeople()
      $.when people.getFirstPage 
        dataType: "jsonp"
        error: (args) ->
            console.log arguments
      .done ->
        that.render(people)

    render: (people) ->
      that = @
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
                  cell: Backgrid.UriCell.extend(
                    events:
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

      occupations = new Occupations()
      occupations.fetch
        dataType: "jsonp"
        success: (occupations) ->
          $(occupations.models).each (index, occupation) ->
            $("#occupation-category").append $("<option></option>").attr("value", occupation.get("category")).text(occupation.get("category"))
            return
          return
      return

    events:
      "click div[id^=search-] label.btn": "visualDateUpdate"
      "change input[id$=-start], input[id$=-end]": "valueDateUpdate"
      "submit #search-form": "searchResults"

    searchResults: (e) ->
      e.preventDefault()
      peopleSearchResultsView = new PeopleSearchResultsView()
      queryString = $(e.currentTarget).serialize()
      router.navigate "search/results?" + queryString,
        trigger: true
      peopleSearchResultsView.render queryString
      false

    visualDateUpdate: (event) ->
      optionHit = $(event.currentTarget)[0].firstElementChild
      set = $(optionHit)[0].name.substr(0,5) #this returns birth or death
      value = $(optionHit)[0].value
      switch value
        when "exactly"
          $("#" + set + "-end, #" + set + "-and").hide()
          $("#" + set + "-start").show()
        when "before"
          $("#" + set + "-start, #" + set + "-and").hide()
          $("#" + set + "-end").show()
        when "after"
          $("#" + set + "-end, #" + set + "-and").hide()
          $("#" + set + "-start").show()
        when "between"
          $("#" + set + "-end, #" + set + "-and, #" + set + "-start").show()
        else
      @valueDateUpdate event
      console.log value
      return

    valueDateUpdate: (event) ->
      console.log event.type
      set = event.currentTarget.id.split("-")[0]
      optionSelected = parseInt(event.currentTarget.id.split("-")[2])  if event.type is "click"
      optionSelected = parseInt($("input[name=" + set + "type]:checked").val())  if event.type is "change"
      switch optionSelected
        when "excatly" #precice
          $("#" + set + "-start").val ""  if $("#" + set + "-start").val() is "0000"
          $("#" + set + "-end").val $("#" + set + "-start").val()
        when "before" #before
          $("#" + set + "-start").val "0000"
          $("#" + set + "-end").val ""  if $("#" + set + "-end").val() is "9999"
        when "after" #after
          $("#" + set + "-end").val "9999"
          $("#" + set + "-start").val ""  if $("#" + set + "-start").val() is "0000"
        when "between" #between
          console.log "evaluating: ", $("#" + set + "-start").val(), $("#" + set + "-end").val()
          $("#" + set + "-start").val ""  if $("#" + set + "-start").val() is "0000"
          $("#" + set + "-end").val ""  if $("#" + set + "-end").val() is "9999"
        else
      console.log "data"
      return
  )



  PeopleSearchResultsView = Backbone.View.extend(
    el: "#page",
    initialize: ->
      @peopleResults = new PeopleSearch
      @createBackGrid()
    createBackGrid: ->
      that = @
      require ["backgrid"], (Backgrid) ->
        ClickableRow = Backgrid.Row.extend({
          events: 
            "click" : "rowClicked"
          rowClicked: ->
            router.navigate "view/" + this.model.get("id"),
              trigger: true
   
          
        });
        that.peopleGrid = new Backgrid.Grid(
          row: ClickableRow
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
          ],
          collection: that.peopleResults
        )
    search: (querystring) ->
      that = @
      $.when @peopleResults.fetch
        dataType: "jsonp"
        url: "/peoplesearch?" + querystring
      .done ->
        that.render()
    render: ->
      that = @
      breadcrumb_template = _.template($("#breadcrumb-template").html(),
        breadcrumbs: [url: "#search",title: "People Search"]
      )
      breadcrumb_template = _.template($("#breadcrumb-template").html(),
        breadcrumbs: [{url: "#search",title: "People Search"},{url: "",title:"Showing search results (" + that.peopleResults.length + ")"}]
      )
      $("#breadcrumb").html breadcrumb_template
      @$el.empty()

      @$el.append @peopleGrid.render().el

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
    "search/results?:querystring": "viewPersonResults" #not tested, in place to permit direct access
    "search/results": "searchForm"
  )
  router = new Router
  
  #because peopleListView is special, we need to have this outside of the init router, otherwise it doesn't work when we call a subpage directly etc.
  router.on "route:home", ->
    peopleListView = new PeopleListView()
    return

  router.on "route:searchForm", ->
    searchFormView = new SearchFormView()
    searchFormView.render()
    return

  router.on "route:viewPerson", (id) ->
    personSingleView = new PersonSingleView()
    personSingleView.render id: id
    return

  router.on "route:viewPersonResults", (querystring) ->
    peopleSearchResultsView = new PeopleSearchResultsView()
    peopleSearchResultsView.search querystring
    return


  Backbone.history.start()
  return
