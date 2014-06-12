  <div class="">
    <% _.each(occupations, function(occupation) { %>
      <div class="row">
        <div class="col-sm-1"><%- occupation.get('recorddate') %></div>
        <div class="col-sm-2"><%- occupation.get('recordtype') %></div>
        <div class="col-sm-3">Occupation</div>
        <div class="col-sm-6"><%- occupation.get('detail') %>, category: <a href="#search/results?occupation-category=<%- occupation.get('category') %>"><%- occupation.get('category') %></a></div>
      </div>
    <% }); %>
  </div>