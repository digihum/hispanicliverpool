  <div class="">
      <div class="row">
        <div class="col-sm-1"><strong>Date</strong></div>
        <div class="col-sm-3"><strong>Surname</strong></div>
        <div class="col-sm-3"><strong>Forenames</strong></div>
        <div class="col-sm-3"><strong>Relationship</strong></div>
        <div class="col-sm-2"></div>
      </div>
    <% _.each(relationships, function(relationship) { %>
      <div class="row">
        <div class="col-sm-1"><%- relationship.get('infodate') %></div>
        <div class="col-sm-3"><%- relationship.get('surname') %></div>
        <div class="col-sm-3"><%- relationship.get('forenames') %></div>
        <div class="col-sm-3"><%- relationship.get('relationship') %></div>
        <div class="col-sm-2"><a class="btn btn-primary btn-xs" href="#view/<%- relationship.get('id') %>">View Record</a></div>
      </div>
    <% }); %>
    </div>