  <div class="">
      <div class="row">
        <div class="col-sm-1"><strong>Date</strong></div>
        <div class="col-sm-2"><strong>Source</strong></div>
        <div class="col-sm-3"><strong>Record</strong></div>
        <div class="col-sm-6"><strong>Contents</strong></div>
 
      </div>
    <% _.each(addresses, function(address) { %>
      <div class="row">
        <div class="col-sm-1"><%- address.get('recorddate') %></div>
        <div class="col-sm-2"><%- address.get('recordtype') %></div>
        <div class="col-sm-3">Address</div>
        <div class="col-sm-6"><%- address.get('address') %> <%- address.get('district') %> <%- address.get('town') %> <%- address.get('region') %><%- address.get('country') %> (<%- address.get('latitude') %>,<%- address.get('longitude') %>)</div>
      </div>
    <% }); %>
  </div>
