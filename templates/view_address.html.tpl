  <div class="">
    <% _.each(addresses, function(address) { %>
      <div class="row">
        <div class="col-sm-1"><%- address.get('recorddate') %></div>
        <div class="col-sm-2"><%- address.get('recordtype') %></div>
        <div class="col-sm-3">Address</div>
        <div class="col-sm-6"><%- address.get('query') %></div>
      </div>
    <% }); %>
  </div>
  <br />
  <div id="address-map" style="height: 250px; width: 100%;">
  </div>