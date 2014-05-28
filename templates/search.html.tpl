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
      <input type="checkbox" name="sex" value="unknown"/>Unknown
      </label></div>
  </div>
    <div class="form-group">
  <label class="col-sm-2 control-label col-xs-3" for="occupation">Occupation</label>
  <div class="col-sm-3 col-xs-9"><select class="form-control" name="occupation-category" id="occupation-category"><option value="">-- select occupation type --</option></select></div>
  </div>
    <hr/>

    <div class="form-group">
      <label class="col-sm-2 control-label" for="birth-death">Dates</label>
      <div class="col-sm-10" id="search-dates">
        <div class="inline-block">
          <div class="">
           <div class="btn-group btn-group" data-toggle="buttons">
            <label class="btn btn-default" id="birth-include">
              <input type="radio" name="birth-death" value="birth"/>Birth
            </label>
            <label class="  btn btn-default" id="death-include">
              <input type="radio" name="birth-death" value="death"/>Death
            </label>
          </div>
        </div>
      </div>

        <div class="inline-block">
          <div class="btn-group" data-toggle="buttons">
            <label class="btn btn-default disabled" id="exactly">
              <input type="radio" name="date-type" value="exactly"/>Precice
            </label>
            <label class="  btn btn-default disabled" id="before">
              <input type="radio" name="date-type" value="before"/>Before
            </label>
            <label class="  btn btn-default disabled" id="after">
              <input type="radio" name="date-type" value="after"/>After
            </label>
            <label class="  btn btn-default disabled" id="between">
              <input type="radio" name="date-type" value="between"/>Between
            </label>
          </div>
        
        </div>
      </div>
    </div>
    <div class="form-group">
      <div class="col-sm-10 col-sm-offset-2">
        <div class="inline-block">
          <label class="sr-only control-label">Start Date</label>
          <input type="text" class="form-control" id="birth-start" name="birth-start"  placeholder="YYYY" style="display:none" size="5" >
        </div>
        <div class="inline-block">
          <label class="control-label" for="birth-end" id="birth-and" style="display:none">and</label>
        </div>
        <div class="inline-block">
          <input type="text" class="form-control" id="birth-end" name="birth-end" placeholder="YYYY" style="display:none" size="5">
        </div>
        <div class="inline-block">
          <label class="sr-only control-label">Start Date</label>
          <input type="text" class="form-control" id="death-start" name="death-start"  placeholder="YYYY" style="display:none" size="5" >
        </div>
        <div class="inline-block">
          <label class="control-label" for="birth-end" id="death-and" style="display:none">and</label>
          <input type="text" class="form-control" id="death-end" name="death-end" placeholder="YYYY" style="display:none" size="5">
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
        <select class="form-control" name="birth-place" disabled="true">
        </select>
      </div>
    </div>
    </div>
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