  <h1><i class="fa fa-search"></i>People Search</h1>
<form id="search-form" class="form-horizontal" role="form">
  <div class="form-group">
    <label  class="col-sm-2 control-label col-xs-3" for="surname">Suname(s)</label>
    <div class="col-sm-3 col-xs-9">
    <input type="text" class="form-control " id="surname" name="surname"  placeholder="accepts multiple names"></div>
    <label class="col-sm-2 col-xs-3 control-label" for="fornames">Forename(s)</label>
    <div class="col-sm-3 col-xs-9">
    <input type="text" class="form-control" id="forenames" name="forenames"  placeholder="accepts multiple names"></div>

  </div>  


  <div class="form-group" >    <label class="col-sm-2 col-xs-3 control-label" for="sex" >Gender</label>
    <div class="btn-group col-sm-10" data-toggle="buttons">

    <label class="btn btn-default" >
      <input type="checkbox" name="sex" value="m"/>M
    </label>
    <label class="  btn btn-default">
      <input type="checkbox" name="sex" value="f"/>F
    </label>
    <label class="  btn btn-default">
      <input type="checkbox" name="sex" value="unknonwn"/>Unknown
      </label></div>
  </div>
    <div class="form-group">
  <label class="col-sm-2 control-label col-xs-3" for="occupation">Occupation</label>
  <div class="col-sm-3 col-xs-9"><select class="form-control" name="occupation-category" id="occupation-category"><option value="">-- select occupation type --</option></select></div>
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
              <label class="btn btn-default" id="birth-exactly">
                <input type="radio" name="birthtype" value="exactly"/>Precice
              </label>
              <label class="  btn btn-default" id="birth-before">
                <input type="radio" name="birthtype" value="before"/>Before
              </label>
              <label class="  btn btn-default" id="birth-after">
                <input type="radio" name="birthtype" value="after"/>After
              </label>
              <label class="  btn btn-default" id="birth-between">
                <input type="radio" name="birthtype" value="between"/>Between
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
        <select placeholder="select a birth country" class="form-control" name="birth-country" id="birth-country">
                    <option value=""> -- select a country -- </option>
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
    <label class="col-sm-2 control-label col-xs-3" for="deathtype">Year</label>
    <div class="col-sm-6 col-xs-12">
    <div class="btn-group btn-group-justified " data-toggle="buttons">
        <label class="btn btn-default" id="death-exactly">
      <input type="radio" name="deathtype" value="exactly"/>Precice
    </label>
    <label class="  btn btn-default"  id="death-before">
      <input type="radio" name="deathtype" value="before"/>Before
    </label>
    <label class="  btn btn-default" id="death-after">
      <input type="radio" name="deathtype" value="after"/>After
      </label>
          <label class="  btn btn-default" id="death-between">
      <input type="radio" name="deathtype" value="between"/>Between
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
        </select>
      </div>
    </div>

    <div class="form-group">
      <label class="col-sm-2 control-label col-xs-3" for="death-place" >Place</label>
      <div class="col-sm-6 col-xs-9" >
        <select class="form-control" name="death-place">
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