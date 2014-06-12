    <div class="row">
      <div class="col-sm-6">
        <p>Name: <%- person.get('forenames') %> <%- person.get('surname') %></p>
        <p>Gender: <%- person.get('gender') %></p>
      </div>
            <div class="col-sm-6">
        <p>Birth Year: <%- person.get('birthdate') %></p>
        <p>Birth Place: <%- person.get('birthplace') %> <%- person.get('birthcountry') %></p>
      </div>
    </div>
    <div class="row">
      <div class="col-sm-6">
        <% if (person.get('notes')) { %>
        <h4>Notes</h4>
        <p> 
          <%- person.get('notes') %></p>
        <% }; %>
      </div>

      <div class="col-sm-6">
        <p>Death Year: <%- person.get('deathdate') %></p>
        <p>Death Place: <%- person.get('deathplace') %> <%- person.get('deathcountry') %></p>
      </div>
    </div>
