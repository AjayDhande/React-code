(function($) {
    var CustomCheck = function(el, opts) {
        // Defaults are below
        var settings = $.extend({}, $.fn.customCheck.defaults, opts),
        $el = $(el),
        checked = 'checked',
        klass = 'hover',
				klasses = $el.attr('class'),
        c = $el.is(':' + checked),
        id = $el.attr('id'),
        // Use text of label for title on span
        l = $('label[for="' + id + '"]'),
        // Unless the tab index is manually set, jQuery may not be able to 
        // get it using the attr() method, so we'll check multiple places
        // and then make sure its at least a number
        ti = $el.attr('tabindex') || $el.get(0).tabIndex || 0;

        // Set id on input if it doesn't have one
        if (!id || id.length < 1) {
            id = $el.attr('id', 'check_input_' + $.fn.customCheck.uid++).attr('id');
        }

        // Create span node
        $el.each(function(){
          if ( $(this).parents("[id$=_blueprint]").length ) return true;
          $(this).before("<span id='cc_" + id + "' title='" + l.text() + "' class='"+ klasses + ((c)?' ' + checked : '') + "' role='" + checked + "' aria-checked='" + ((c) ? 'true' : 'false')+"' aria-controls='" + id + "' />")
        })
        var cb = $el.parent().find('span#cc_' + id);

        if(cb.length){
          $el
              // Attach handlers to the original input node to redirect to ours
              .bind('click',function(e, triggered) {
                  triggered = $el.attr('triggered') // Trigger not passing paramer on checkbox
                  // Avoid infinite loop & double checking
                  if (triggered == "true") { $el.attr('triggered',false); return; }
                  onClick($el, cb, settings, true);
              })
              // Hide the original input box
              .hide();
 
 
          // IE doesn't fire click event on checkbox when label clicked
          l.click(function(e) {
              cb.click(); // does double duty in all but IE
              return false;
          });
 
          cb
              // Make span look 'clickable'
              .css({ cursor: 'pointer' })
              // Attach handlers to the span
              .click(function(e) {
                  e.preventDefault();
                  onClick($el, cb, settings, false);
              })
              .keypress(function(e) {
                  var k = (e.which) ? e.which : ((e.keyCode) ? e.keyCode : 0);
                  // Trigger on space or enter keys
                  if (k == 13 || k == 32) {
                      $(this).click();
                  }
              })
              // Add class to span on hover
              .hover(
                  function() {
                      $(this).addClass(klass);
                  },
                  function() {
                      $(this).removeClass(klass);
                  }
              )
              // Set the tabIndex to make span focusable and enable key controls
              // we use DOM property versus jQuery because some older browsers
              // won't let you set the tabindex using the manner jQuery does
              .get(0).tabIndex = ti;
        }
        var onClick = function(el, cb, o, inputClick) {
            // Determine if we need to check input box. i.e. if input is 
            // checked and span has 'checked' class, need to flip it
            var checked = 'checked';
            if (cb.hasClass(checked) === el.is(':' + checked) && !inputClick) {
                // el.trigger('click', [true]); Cant use this. Trigger not working on checkbox???
                el.attr('triggered',true)
                el.trigger('click', [true]);
            }
            // Now change the span attributes to complete the ruse
            //	Unless its a radio thats already checked
	          var c = el.is(':' + checked);
            if(!cb.hasClass(checked) || !el.is(':radio')){
              cb.toggleClass(checked)
                .attr({ 'aria-checked': '' + ((c) ? 'true':'false') });
            }

            // Handle radio buttons
            if (el.is(':radio') ) {
              $('input[name="'+el.attr('name')+'"]').not(el).each(function() {
                $('#cc_'+this.id)
                    .removeClass(checked)
                    .attr({'aria-checked': 'false' });
              });
            }
            
            // Timeout to allow for 'checking' to occur before callback
            setTimeout(function() {  
                o.onCheck.apply(el, [c]);
            }, 25);
        }
    };
    $.fn.customCheck = function(options) {
        return this.each(function(idx, el) {
            var $el = $(this), key = 'customCheck';
            // Return early if this element already has a plugin instance
            if ($el.data(key)) { return; }
            if ($el.is(':checkbox') || $el.is(':radio')) {
                // Pass options to plugin constructor
                var customCheck = new CustomCheck(this, options);
                // Store plugin object in this element's data
                $el.data(key, customCheck);
            }
        });
    };

    // Static properties
    $.fn.customCheck.uid = 0;
    
    // Default settings
    $.fn.customCheck.defaults = { onCheck:function(){  } };
})(jQuery);


