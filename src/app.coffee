require [
  "jquery"
  "underscore"
  "backbone"
  "bootstrap"
  "backbonePaginator"
  "backboneRelational"
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
    if options.url.split(":")[0] != "http"
      options.url = "http://researchdb.warwick.ac.uk/liverpool/api" + options.url
    return

  Address = Backbone.RelationalModel.extend()

  Addresses = Backbone.Collection.extend(
    model: Address
  )

  Occupation = Backbone.RelationalModel.extend()
  Occupations = Backbone.Collection.extend 
    url: "/occupations"
    model: Occupation

  Relationship = Backbone.RelationalModel.extend()

  Relationships = Backbone.Collection.extend(
    url: ->
      "/relationships/" + @models[0].id
    model: Relationship
  )

  FlatPerson = Backbone.Model.extend()

  Person = Backbone.RelationalModel.extend(
    urlRoot: "/people"
    relations: [
      type: Backbone.HasMany
      key: 'relationships'
      relatedModel: Relationship
      collectionType: Occupations
      reverseRelation: 
        key: 'person',
        includeInJSON: 'id'
    ,
      type: Backbone.HasMany
      key: 'occupations'
      relatedModel: Occupation
      collectionType: Occupations
      reverseRelation: 
        key: 'person',
        includeInJSON: 'id'
    ,
      type: Backbone.HasMany
      key: 'addresses'
      relatedModel: Address
      collectionType: Addresses
      reverseRelation: 
        key: 'person',
        includeInJSON: 'id'
    ]
    parse: (response) ->
          # use some render helpers to add to the model some text to format fuzzy date types
      @.birthdate = @fuzzyDateMaker @birthtype, @birthdate1, @birthdate2
      @.deathdate = @fuzzyDateMaker @deathtype, @deathdate1, @deathdate2
      _.each response.addresses, (address) ->
        query = []
        query.push address.address.split(",")[1].trim() + " " + address.address.split(",")[0].trim() #street
        #address.district != "" && query.push address.district currently causes failed lookup
        query.push "Liverpool"
        address.region != "" && query.push address.region
        address.country != "" && query.push address.country
        address.query = query.join ", "
      response
    fuzzyDateMaker: (type, date1, date2) ->
      
      #takes the HL way of representing fuzzy dates, and returns a formatted string. 
      switch type
        when "exactly"
          return date1
        when "between"
          return "between " + ((if isset(date1) then date1 else "unknown")) + " and " + ((if isset(date2) then date2 else "unknown"))
        when "unknown", null
          "unknown"
    )

  People = Backbone.Collection.extend(
    url: "/people"
    model: FlatPerson
    parse: (response) ->
      response
  )
  PeopleSearch = Backbone.Collection.extend(
    url: ->
      "/peoplesearch?" + options.querystring
    model: FlatPerson
    parse: (response) ->
      response
    )

  Backbone.PageableCollection = PageableCollection

  PaginatedPeople = Backbone.PageableCollection.extend(
    model: FlatPerson
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


  Place = Backbone.RelationalModel.extend(
      idAttribute: 'place'
    )

  Places = Backbone.Collection.extend(
    model: Place
    parse: (response)->
      console.log @, response, "parsing place"
      response
  )
 

  Country = Backbone.RelationalModel.extend(
    relations: [
      type: Backbone.HasMany
      key: 'places'
      relatedModel: Place
      reverseRelation: 
          key: 'country'
      ]
    parse: (response) ->
      response
  )

  Countries = Backbone.Collection.extend(
    url: "/countriesfull"
    model: Country
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
            myCell = Backgrid.Cell.extend 
              viewingPerson: (e) ->
                e.preventDefault();
                return router.navigate "view/" + this.model.get("id"), 
                  trigger: true
              render: ->
                @$el.html("<button class='btn btn-primary btn-xs'>Records</button>")
                return @
              events: 
                "click": "viewingPerson"
            ClickableRow = Backgrid.Row.extend
              events: 
                "click": "rowClicked"
              rowClicked: ->
                return router.navigate "view/" + this.model.get("id"), { trigger: true }
            
            peopleGrid = new Backgrid.Grid(
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
                {
                  cell: myCell
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

      @countries = new Countries()
      @countries.fetch
        dataType: "jsonp"
        success: (countries) ->
          $(countries.models).each (index, country) ->
            $("select[name=birthCountry]").append $("<option></option>").attr("value", country.get("country")).text(country.get("country"))
            return
          return

      occupations = new Occupations()
      occupations.fetch
        dataType: "jsonp"
        success: (occupations) ->
          $(occupations.models).each (index, occupation) ->
            $("#occupation-category").append $("<option></option>").attr("value", occupation.get("category")).attr("data-id",occupation.get("id")).text(occupation.get("category"))
            return
          return
      return

    events:
      "click div[id^=search-] label.btn": "visualDateUpdate"
      "change input[id$=-start], input[id$=-end]": "valueDateUpdate"
      "click label[id$=-include]": "dateSelectorUpdate"
      "submit #search-form": "searchResults"
      "change select[name=birthCountry]": "placesUpdate"

    searchResults: (e) ->
      e.preventDefault()
      @$el.html $("#view-loading").html()
      peopleSearchResultsView = new PeopleSearchResultsView()
      queryString = $(e.currentTarget).serialize()
      router.navigate "search/results?" + queryString,
        trigger: true
      peopleSearchResultsView.search queryString
      false

    dateSelectorUpdate: (event) ->
      #reset
      $("#birth-start, #birth-and, #death-start, #death-and").hide()
      $("input[name^=date-type]:checked").each ->
        @.checked = false;
      $("label.disabled").removeClass("disabled")
      return true

    visualDateUpdate: (event) ->
      optionHit = $(event.currentTarget)[0].firstElementChild
      set = $("input[name='birth-death']:checked").val() #this returns birth or death
      unset = $("input[name='birth-death']:not(:checked)").val() #this returns birth or death

      switch optionHit.value
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
      return

    valueDateUpdate: (event) ->

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

      return

    placesUpdate: (event) ->
      that = @
      @country = @countries.findWhere country: $(event.currentTarget).children("option:selected")[0].value
      switch @country.get("places").models.length
        when 1
          $("select[name=birthPlace]")
            .empty()
            .attr("disabled",true)
          $.each(@country.get("places").models
            (index, place) ->
              $("select[name=birthPlace]").append $("<option></option>").attr("value", place.get("place")).text(place.get("place"))
          )
        when 0
          $("select[name=birthPlace]")
            .empty()
            .attr("disabled",true)
        else
          $("select[name=birthPlace]")
            .empty()
            .attr("disabled",false)
            .append $("<option></option>").attr("value", "").text("-- " + @country.get("places").models.length + " places within " + @country.get("country") + " --" )
          $.each(@country.get("places").models
            (index, place) ->
              $("select[name=birthPlace]").append $("<option></option>").attr("value", place.get("place")).text(place.get("place"))
          )
      initialize: ->
        _.bindAll(@,'render','placesLookup')
        @model.bind('change:places', @placesLookup)
  )



  PeopleSearchResultsView = Backbone.View.extend(
    el: "#page",
    initialize: ->
      @$el.html $("#view-loading").html()
      @peopleResults = new PeopleSearch
      @createBackGrid()

    createBackGrid: ->
      that = @
      require ["backgrid"], (Backgrid) ->
        myCell = Backgrid.Cell.extend 
                viewingPerson: (e) ->
                  e.preventDefault();
                  return router.navigate "view/" + this.model.get("id"), 
                    trigger: true
                render: ->
                  @$el.html("<button class='btn btn-primary btn-xs'>Records</button>")
                  return @
                events: 
                  "click": "viewingPerson"
         ClickableRow = Backgrid.Row.extend
            events:
              "click": "rowClicked"
            rowClicked: ->
              return router.navigate "view/" + this.model.get("id"), { trigger: true }

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
            {
              className: "button"
              cell: myCell 
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
    el: "#page",
    initialize: ->
      @listenTo @model, 'change', @.render
      @model.fetch
        dataType: "jsonp"

    render: (options) ->
      that = @
      require ["text!../templates/view.html.tpl"], (template) ->
        that.$el.html _.template(template)
        return
      # render the person partial 
      require ["text!../templates/view_details.html.tpl"], (template) ->
        $("#person-details").html _.template(template,
          person: that.model
        )
        return
          
      # now we have a name, add this to the breadcrumb
      template = _.template($("#breadcrumb-template").html(),
        breadcrumbs: [
          url: "#view/" + @model.get("id")
          title: @model.get("forenames") + " " + @model.get("surname")
        ]
      )
      $("#breadcrumb").html template


      if @model.get("relationships").models.length > 0
        require ["text!../templates/view_relationships.html.tpl"], (template) ->
          $("#relationships").html _.template template,
            relationships: that.model.get("relationships").models
          
      else
        # can't name the person because it is loaded syncronously.
        template = "No relationships were found for " + @model.get("forenames") + "."
        $("#relationships").html template

      if @model.get("occupations").models.length > 0
        require ["text!../templates/view_occupation.html.tpl"], (template) ->
          $("#bibliographical-details").append _.template template,
            occupations: that.model.get("occupations").models

      if @model.get("addresses").models.length > 0
        require ["text!../templates/view_address.html.tpl"], (template) ->
          $("#bibliographical-details").append _.template template,
            addresses: that.model.get("addresses").models

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
    if person = Person.findModel {id: id} 
    else
      person = new Person id: id
    personSingleView = new PersonSingleView({model: person})
    return

  router.on "route:viewPersonResults", (querystring) ->
    peopleSearchResultsView = new PeopleSearchResultsView()
    peopleSearchResultsView.search querystring
    return


  Backbone.history.start()
  return
