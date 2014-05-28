  <div class="">
      <div class="row">
        <div class="col-sm-1"><strong>Date</strong></div>
        <div class="col-sm-2"><strong>Source</strong></div>
        <div class="col-sm-3"><strong>Record</strong></div>
        <div class="col-sm-6"><strong>Contents</strong></div>
 
      </div>
    <% _.each(occupations, function(occupation) { %>
      <div class="row">
        <div class="col-sm-1"><%- occupation.get('recorddate') %></div>
        <div class="col-sm-2"><%- occupation.get('recordtype') %></div>
        <div class="col-sm-3">Occupation</div>
        <div class="col-sm-6"><%- occupation.get('category') %> -> <%- occupation.get('detail') %></div>
      </div>
    <% }); %>
  </div>