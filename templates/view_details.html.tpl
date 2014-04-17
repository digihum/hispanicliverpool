    <div class="row">
      <div class="col-sm-6">
        <p>Name: <%- person.get('forenames') %> <%- person.get('surname') %></p>
        <p>Date: <%- person.get('yearonrecord') %> <%- person.get('dateonrecord') %></p>
        <p>Gender: <%- person.get('gender') %></p>
      </div>
      <div class="col-sm-6">
        <p>Citizenship: <%- person.get('citizenship') %></p>
        <p>Country: <%- person.get('country') %></p>
        <p>Place: <%- person.get('place') %></p>
      </div>
    </div>
    <div class="row">
      <div class="col-sm-6">
        <p>Birth Date: <%- person.get('birthdate') %></p>
        <p>Birth Place: <%- person.get('birthplace') %> <%- person.get('birthcountry') %></p>
      </div>
      <div class="col-sm-6">
        <p>Death Date: <%- person.get('deathdate') %></p>
        <p>Death Place: <%- person.get('deathplace') %> <%- person.get('deathcountry') %></p>
      </div>
    </div>
    <div class="row">
      <div class="col-sm-12">
        <%- person.get('notes') %>
      </div>
    </div>