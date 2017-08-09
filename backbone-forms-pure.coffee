define ["jquery", "underscore", "backbone", "backbone-forms"], ($, _, Backbone) ->
  Form = Backbone.Form
  Form.template = _.template("<form><div class=\"fieldsets\" data-fieldsets></div><button class=\"button button-small\" type=\"submit\">Save</button><a href=\"javascript:;\" class=\"cancel\">Cancel</span></form>")
  Form.Fieldset.template = _.template("<fieldset data-fields><% if (legend) { %><legend><%= legend %></legend><% } %></fieldset>  ")
  Form.Field.template = _.template("
      <div class=\"field-<%= key %>\">
        <label for=\"<%= editorId %>\"><%= title %></label>
        <div>
          <span data-editor></span>
          <span class=\"help-inline\" data-error></span>
          <span class=\"help-block\"><%= help %></span>
        </div>
      </div>")
  Form.NestedField.template = _.template("
      <div class=\"field-<%= key %>\">
        <div title=\"<%= title %>\" class=\"input-xlarge\">
          <span data-editor></span>
          <div class=\"help-inline\" data-error></div>
        </div>
        <div class=\"help-block\"><%= help %></div>
      </div>")
  if Form.editors.List
    Form.editors.List.template = _.template("
      <div class=\"bbf-list\">
        <ul class=\"clearfix bbf-list\" data-items></ul>
        <button type=\"button\" class=\"btn bbf-add button button-xsmall\" data-action=\"add\">Add</button>
      </div>")
    Form.editors.List.Item.template = _.template("
      <li class=\"clearfix\">
        <span data-editor></span>
        <button type=\"button\" class=\"btn bbf-del button button-xsmall\" data-action=\"remove\">&times;</button>
      </li>")
    Form.editors.List.Object.template = Form.editors.List.NestedModel.template = _.template("<div class=\"bbf-list-modal\"><%= summary %></div>")

