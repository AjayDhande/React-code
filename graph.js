define(['jquery', 'goog!visualization,1,packages:[corechart]'], function($) {
    var app = {},
    $el,
    gurl = "http://chart.apis.google.com/chart?",
    hover = "hover";

    app.init = function() {
        var data = window.gdata, graph;
	    if (!data) return;
        for (var x = data.graphs.length - 1; graph = data.graphs[x]; x--) {
            var name = graph.name;
			// Todo come up with a more robust way of filtering this. Only show data on relavent pages.
			if(!$('#'+name).length)
				continue;
            if (name.slice(0, 20) == "multiple_choice_dist")
                name = "multiple_choice_dist";

            switch (name) {
                case "active-teams-chart":
                    activeAccounts(graph.values.inactive, graph.values.draft, graph.values.total, graph.name);
                break;

                case "average-allocation-chart":
                    averageAllocation(graph.values, graph.name);
                break;

                case "hires-departures-chart":
                    growthChart(graph.values, graph.name);
                break;

                case "performance-chart":
                    performanceReview(graph.keys, graph.values, graph.name, graph.colors, graph.ratings);
                break;

                case "performance-levels-chart":
                    performanceLevels(graph.values, graph.name, graph.colors || null,graph.size, graph.backgroundColor);
                break;

                case "performance-rating-dist":
                  performanceRatingDist(graph.values, graph.name, graph.title);
                break;

                case "performance-statuses-chart":
                    performanceStatuses(graph.values, graph.name, graph.colors);
                break;

                case "salary-chart":
                    salaryHistory(graph.values, graph.name, data.name, graph.tier || '', graph.currencyUnit || '$');
                break;

                case "total-employees-chart":
                    totalEmployees(graph.values.total, graph.values.billable, graph.name);
                break;

                case "multiple_choice_dist":
                    multipleChoiceDist(graph.values, graph.name);
                break;
            }
        }
    }
    function activeAccounts(inactive, draft, total, par) {
        var totalWidth = 205,
        inactiveWidth = Math.ceil(totalWidth * (inactive / total)),
        draftWidth = Math.ceil(totalWidth * (draft/total)) ,
        $chart = $([
           '<div class="bar-total">',
           '<div class="bar-loss" style="right:', totalWidth-inactiveWidth, 'px;"></div>',
           '<div class="bar-divider" style="left:', inactiveWidth, 'px;"></div>',
           '<div class="bar-new" style="left:', inactiveWidth+1, 'px;"></div>',
           '<span class="text-loss" style="right:', totalWidth-inactiveWidth+5, 'px;">', inactive, ' inactive</span>',
           '<span class="text-new" style="left:', inactiveWidth+5, 'px;">', draft, ' draft</span>',
           '</div>'].join('')),
        $par = $('#'+par),
        $bl = $chart.find(".bar-loss"),
        $bn = $chart.find(".bar-new"),
        $tl = $chart.find(".text-loss"),
        $tn = $chart.find(".text-new");

        $par.find(".loading").remove();
        $par.append($chart.fadeIn(500, function() {
            $bl.animate({ width: inactiveWidth }, 1000);
            $bn.animate({ width: draftWidth }, 1000);
        }));
        $bl.hover(function() { $tl.addClass(hover); }, function() { $tl.removeClass(hover); });
        $bn.hover(function() { $tn.addClass(hover); }, function() { $tn.removeClass(hover); });
    }
    function averageAllocation(vals, name) {
        var backgroundColor = "#E3EEFB",
            gridlines = { color: backgroundColor },
            data = new google.visualization.DataTable(),
            options = {
                animation: { duration: 1500, ease: 'out' },
                backgroundColor: backgroundColor,
                colors:["#2C7CC7"],
                hAxis: {
                    baselineColor: backgroundColor,
                    gridlines: gridlines,
                    textPosition: "none"
                },
                legend: { position: "none" },
                pointSize: 4,
                vAxis: {
                    baselineColor: backgroundColor,
                    gridlines: gridlines,
                    textStyle: {
                        color: "#6B6B6B", fontSize: 12
                    }
                },
                height: 88,
                width: 210
            };

        data.addColumn("date", "Date");
        data.addColumn("number", "Allocation");
        data.addRows(vals);

        var chart = new google.visualization.LineChart(document.getElementById(name));

        chart.draw(data, options);
    }
    function growthChart(vals, name) {
		if (!vals.length)
			return
        var width = 680,
            height = 216,
            data = new google.visualization.DataTable(),
            clone = vals.slice().sort(function (a, b) { return a[1] < b[1] ? -1 : 1; }),
            subtrahend = ((""+clone[clone.length - 1][1]).length + 1) * 10 + 25,
            options = {
                animation: { duration: 1500, easing: 'out' },
                areaOpacity: .1, chartArea: { width: width - subtrahend }, color:["#2C7BC6"],
                hAxis: { // baselineColor:"#C7C7C7" (not working)
                    gridlines: { color:"#FFFFFF" }, showTextEvery: 1,
                    slantedText: false, textStyle: {
                        color: "#6B6B6B", fontSize: 9
                    }, viewWindow: { min: 0, max: 1 }, // For animating
                }, legend: { position: "none" }, vAxis: {
                    format: "#,###", gridlines: { color:"#FFFFFF" }, textStyle: {
                        color: "#6B6B6B", fontSize: 11
                    }
                }
            };


        data.addColumn("string", "Month");
        data.addColumn("number", "Employees");
        data.addRows(vals);

        var chart = new google.visualization.AreaChart(document.getElementById(name)),
            handler;

        handler = google.visualization.events.addListener(chart, 'ready', function() {
            google.visualization.events.removeListener(handler);
            options.hAxis.viewWindow.max = vals.length;
            chart.draw(data, options);
        });

        chart.draw(data, options);
    }
    function noInfo(elem) {
      $('#'+elem).append("<div>Not enough info.</div>")
          .parent().find(".loading").remove();
    }
    function performanceRatingDist(values, name, title) {
      if (values.length > 1) {
        var data = new google.visualization.DataTable();
        data.addColumn("date", "Date")
        data.addColumn("number", "Rating")
        data.addRows(values);

        var current = new Date();
        var year = current.getFullYear();
        var month = current.getMonth();
        var date = current.getDate();

        var options = {
          title: title,
          colors: ['#4c9be6'],
          legend: { position: 'none' },
          fontName: 'Proxima',
          hAxis: {
            format: 'MMM yyyy',
            textStyle: { color: "#4f5962", fontSize: 14 },
            baselineColor: "transparent",
            gridlines: { color: "transparent" }
          },
          pointSize: 6,
          dataOpacity: 1.0,
          lineWidth: 3,
          vAxis: {
            textStyle: { color: "#4f5962" },
            baselineColor: "#e7e8ea",
            baseline: 0
          }
        }

        var chart = new google.visualization.LineChart(document.getElementById(name))
        chart.draw(data, options)
      }
    }
    function performanceStatuses(values, name, colors) {
      if (values.length > 1) {
        var data = google.visualization.arrayToDataTable(values)
        var options = {
          height: 250,
          chartArea: { width: '100%', height: '80%' },
          legend: { position: 'right', alignment: 'end' },
          pieHole: 0.6,
          colors: colors,
          pieSliceText: 'none',
          pieSliceBorderColor: 'transparent',
          fontName: 'Proxima'
        }

        var chart = new google.visualization.PieChart(document.getElementById(name));
        chart.draw(data, options);
      }
    }

    function performanceLevels(vals, name, colors,size, backgroundColor) {
        var width = size[0],
            height = size[1],
            $elem = $('#'+name),
            $legend = $elem.next("ul"),
            colors = colors || ["#5BB800", "#FFAF1F", "#E1601C", "#828282"],
            data = new google.visualization.DataTable();

        data.addColumn("string", "Level");
        data.addColumn("number", "Employees");
        data.addRows(vals);

        var tmpl = '<li><span style="background-color:$color$;"></span> &nbsp;$name$</li>',
            content = "",
            l = colors.length; // Caching colors.length to save lookups
        for (var x = vals.length-1; x >= 0; x--) {
            content = tmpl.replace("$name$", vals[x][0]).replace("$color$", colors[x % l]) + content;
        }

        var chart = new google.visualization.PieChart(document.getElementById(name));

        google.visualization.events.addListener(chart, "ready", function() {
            $legend.hide().html(content).fadeIn(500);
        });

        chart.draw(data, {
            backgroundColor: backgroundColor,
            chartArea: { left:0,height: "80%", width: "88%" },
            colors: colors,
            legend: { position: "none" },
            pieSliceTextStyle: {
                color: "#FFFFFF", fontSize: 12
            }
        });
    }
  function performanceReview(years, vals, name, colors, ratings) {
    if (vals.length < 1) {
      // No values, abort and show the user a message
      noInfo(name);
      return;
    }
		// Calculate distances:
		var totalRange = 100,
				totalVals = ratings.length,
				distanceBetween = parseInt(totalRange / totalVals),
				ratingsString = '',
				valueArray = [],
				chxpString = '0',
				valueString = ''

		$.each(ratings,function(index,r){
			ratingsString += "|"+r
			valueArray[r] = distanceBetween + distanceBetween*index
			chxpString += ","+(distanceBetween + distanceBetween*index)
		})
		$.each(vals,function(index,val){
			valueString += index?',':''
			valueString += valueArray[val]
		})

    var width = 385, height = 200,
        url = gurl + [
          "chdlp=b", "chg=0,"+distanceBetween+",0,0", "chma=|5", "chxp="+chxpString,
          "chxr=1,0,1", "chxs=0,636363,12,1,_,FFFFFF|1,040404,14,0,l,0A0707",
          "chxt=y,x", "chbh=25,25", "cht=bvs", "chco=" + colors,

          // Formatted values
          "chs=" + width + "x" + height,
          "chd=t:" + valueString,
          'chxl=0:' + ratingsString + '|1:|' + years.join('|')
        ].join('&'),
        attrs = { 'src': url, 'width': width, 'height': height },
        $par = $('#'+name);

    // Append the image to the parent, and fade in on load
    $par.append($("<img />").hide().attr(attrs).load(function() {
      $el = $(this);
      $el.parent().find(".loading").remove();
      $el.fadeIn(500);
    }));
  }
  function salaryHistory(vals, elem, name, tier, currencyUnit) {
    if (vals.length < 1) {
      noInfo(elem);
      return;
    }

    var width = 500, height = 220,
        data = new google.visualization.DataTable(),
        formatter = new google.visualization.NumberFormat({
          prefix: currencyUnit, fractionDigits: 0
        });

    data.addColumn("string", "Year");
    data.addColumn("number", tier+" Average");
    data.addColumn("number", name);
    data.addRows(vals);
    formatter.format(data, 1);
    formatter.format(data, 2);

    var chart = new google.visualization.LineChart(document.getElementById(elem));
    chart.draw(data,
			{
				width: width,
				height: height,
				colors: [ "#040404", "#84C1E1" ],
	      legend: { position: "top" },
				chartArea:{ width:width-200 },
				hAxis: {
	        textStyle: { color: "#040404", fontSize: 14 },
					baselineColor: "#CDCACB",
	        gridlines: { color: "#CDCACB" }
	      },
				pointSize: 4,
				vAxis: {
	        format: currencyUnit+"###,###",
					textStyle: { color: "#636363" }
	    	}
			}
		);
  }
  function totalEmployees(total, billable, par) {
    var tw = 215,
        bw = Math.ceil((tw / total) * parseInt(billable.replace(',',''),10)),
        $chart = $([
          '<div class="billable-total">',
            '<div class="billable-new">',
              '<span>', billable,' Allocated</span>',
            '</div>',
          '</div>'].join('')),
        $bn = $chart.find(".billable-new"),
        $tx = $chart.find("span").hide(),
        $par = $('#' + par);

    $par.find(".loading").remove();
    $par.append($chart.fadeIn(500, function() {
      $bn.animate({ width: bw }, 1000, function() {
        $tx.fadeIn(500);
      });
    }));
  }
  function multipleChoiceDist(data, id) {
    var data = google.visualization.arrayToDataTable(data);

    new google.visualization.ColumnChart(document.getElementById(id)).
      draw(data, { width:  600,
                   height: 160,
                   title:  "Multiple Choice Distribution",
                   colors: ['#91C4F5','#31AEFF','#00C1CB','#186AB7'],
                   legend: {position: 'right'},
                   hAxis: {title: "",
                           minValue: 0},
                   chartArea: {left:'0',width:'40%'},
                   bar: {groupWidth:'90%'}
                 });
  }

  app.init();
  return app;
});
