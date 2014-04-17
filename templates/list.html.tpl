<table class="table table-striped table-bordered" id="persons-table">
  <thead>
    <tr>
      <th>Forename(s)</th><th>Surname</th><th>Gender</th><th>&nbsp;</th>
    </tr>
  </thead>
  <tbody>
    <% _.each(persons, function(person) { %>
      <tr>
        <td><%- person.get('forenames') %></td>
        <td><%- person.get('surname') %></td>
        <td><%- person.get('gender') %></td>
        <td><a class="btn btn-primary btn-xs" href="#view/<%= person.id %>">View Record</a></td>
      </tr>
    <% }); %></tbody>
</table>