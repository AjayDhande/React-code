define ['jquery', 'backbone'], ($, Backbone) ->
  class HomeView extends Backbone.View
    render: ->
    	@options.headerView.setTitle('','header-namely')
    	
    	
    	
