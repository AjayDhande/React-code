define ['backbone',
        'views/components/node',
        'templates/people/tree_node',
        'templates/people/tree_list'], (Backbone,
        NodeView, nodeTemplate, listTemplate) ->
  class PeopleNodeView extends NodeView
    className: 'position-holder'
    templates:
      node: nodeTemplate
      list: listTemplate


