  <h1><i class="fa fa-search"></i>People Search</h1>
<form id="search-form" class="form-horizontal" role="form">
  <div class="form-group">
    <label  class="col-sm-2 control-label col-xs-3" for="surnames">Suname(s)</label>
    <div class="col-sm-3 col-xs-9">
    <input type="email" class="form-control " id="surnames" name="surnames"  placeholder="accepts multiple names"></div>
    <label class="col-sm-2 col-xs-3 control-label" for="fornames">Forename(s)</label>
    <div class="col-sm-3 col-xs-9">
    <input type="text" class="form-control" id="forenames" name="forenames"  placeholder="accepts multiple names"></div>

  </div>  


  <div class="form-group" >    <label class="col-sm-2 col-xs-3 control-label" for="gender" >Gender</label>
    <div class="btn-group col-sm-10" data-toggle="buttons">

    <label class="btn btn-default" >
      <input type="checkbox" name="gender" value="m"/>M
    </label>
    <label class="  btn btn-default">
      <input type="checkbox" name="gender" value="f"/>F
    </label>
    <label class="  btn btn-default">
      <input type="checkbox" name="gender" value="u"/>Unknown
      </label></div>
  </div>
    <div class="form-group">
  <label class="col-sm-2 control-label col-xs-3" for="occupation">Occupation</label>
      <div class="col-sm-3 col-xs-9"><select class="form-control">Occupation</select></div>
  </div>
    <hr/>

    <div class="form-group">
      <div class="col-sm-2">
        <div class="btn-group btn-group-justified" data-toggle="buttons">
          <label class="btn btn-default" id="birth-include">
            <input type="radio" name="birth-death" value="0"/>Birth
          </label>
          <label class="  btn btn-default" id="death-include">
            <input type="radio" name="birth-death" value="1"/>Death
          </label>
        </div>
      </div>
      <div class="col-sm-10">
      <div>
        <div class="form-inline" id="search-birth">
 
          <div class="form-group-inline-block">
            <div class="btn-group" data-toggle="buttons">
              <label class="btn btn-default" id="birth-range-0">
                <input type="radio" name="birth-range" value="0"/>Precice
              </label>
              <label class="  btn btn-default" id="birth-range-1">
                <input type="radio" name="birth-range" value="1"/>Before
              </label>
              <label class="  btn btn-default" id="birth-range-2">
                <input type="radio" name="birth-range" value="2"/>After
              </label>
              <label class="  btn btn-default" id="birth-range-3">
                <input type="radio" name="birth-range" value="3"/>Between
              </label>
            </div>
          </div>
          <div class="form-group-inline-block">
            <label class="sr-only control-label">Start Date</label>
            <input type="text" class="form-control" id="birth-start" name="birth-start"  placeholder="YYYY" style="display:none" size="5" >
          </div>
          <div class="form-group-inline-block">
            <label class="control-label" for="birth-end" id="birth-and" style="display:none">and</label>
            <input type="text" class="form-control" id="birth-end" name="birth-end" placeholder="YYYY" style="display:none" size="5">
          </div>
        </div>
      </div>
    </div>
    <div class="form-group">
      <label class="col-sm-2 control-label col-xs-3" for="birth-country">Country</label>
      <div class="btn-group col-sm-6 col-xs-9" >
        <select class="form-control" name="birth-country" id="birth-country">
        </select>
      </div>
    </div>
    <div class="form-group">
      <label class="col-sm-2 control-label col-xs-3" for="birth-place" >Place</label>
      <div class="btn-group col-sm-6 col-xs-9" >
        <select class="form-control" name="birth-place">
          <option>place</option>
          <option>place</option>
          <option>place</option>
          <option>place</option>
        </select>
      </div>
    </div>
    </div>
    </div>
    </div>
    </div>

  <div id="search-death" class="panel panel-default">
  <div class="panel-heading"><h4 class="panel-title"><a data-toggle="collapse" data-parent="#search-death" href="#search-death-content">Include death criteria</a></h4></div>
    <div id="search-death-content" class="panel-collapse collapse">
      <div class="panel-body">
  <div class="form-group watch">
    <label class="col-sm-2 control-label col-xs-3" for="death-range">Year</label>
    <div class="col-sm-6 col-xs-12">
    <div class="btn-group btn-group-justified " data-toggle="buttons">
        <label class="btn btn-default" id="death-range-0">
      <input type="radio" name="death-range" value="0"/>Precice
    </label>
    <label class="  btn btn-default"  id="death-range-1">
      <input type="radio" name="death-range" value="1"/>Before
    </label>
    <label class="  btn btn-default" id="death-range-2">
      <input type="radio" name="death-range" value="2"/>After
      </label>
          <label class="  btn btn-default" id="death-range-3">
      <input type="radio" name="death-range" value="3"/>Between
      </label>
    </div>
    </div>
    </div>
    <div class="form-group">
      <div class="col-sm-offset-2 col-sm-10 form-inline">
        <input type="text" class="form-control" id="death-start" name="death-start" placeholder="YYYY" style="display:none">

      <label class="control-label" for="death-end" id="death-and" style="display:none">and</label>

        <input type="text" class="form-control" id="death-end" name="death-end" placeholder="YYYY" style="display:none"></div>
    </div>
    <div class="form-group">
      <label class="col-sm-2 control-label col-xs-3" for="death-country">Country</label>
      <div class="col-sm-6 col-xs-9" >
        <select class="form-control" name="death-country">
          <option>country</option>
          <option>country</option>
          <option>country</option>
          <option>country</option>
        </select>
      </div>
    </div>

    <div class="form-group">
      <label class="col-sm-2 control-label col-xs-3" for="death-place" >Place</label>
      <div class="col-sm-6 col-xs-9" >
        <select class="form-control" name="death-place">
          <option>place</option>
          <option>place</option>
          <option>place</option>
          <option>place</option>
        </select>
      </div>
    </div>
    </div>

    </div></div>
      <div class="form-group form-options">
    <div class="col-sm-offset-2 col-sm-10">
  <button type="submit" class="btn btn-primary"><i class="fa fa-search"></i>  Search</button>
  <button type="reset" class="btn btn-danger" data-dismiss="modal" value="reset">Clear</button>

  </div>
</form>