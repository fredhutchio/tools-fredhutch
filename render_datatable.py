#!/usr/bin/env python

import csv
import itertools
import string
import sys

input = sys.stdin
start_lines = input.readlines(10)
all_input = itertools.chain(iter(start_lines), input)

def detect_delimiter(iterable, char_set):
    matches = (c for c in char_set if c in iterable)
    return next(matches, None)

def detect_csv_dialect(sample):
    try:
        return csv.Sniffer().sniff(sample)
    except:
        return None

delimiter = detect_delimiter(start_lines[0], list('\t, '))
reader = None

if delimiter in list('\t,'):
    # try to detect csv dialect, which should neatly handle quoted separators and stuff
    dialect = detect_csv_dialect(''.join(start_lines))
    if dialect:
        reader = csv.reader(all_input, dialect)

if not reader:
    if delimiter in list(string.whitespace):
        # use str.split() with no arguments to split on arbitrary whitespace strings
        reader = (line.strip().split() for line in all_input)
    else:
        reader = all_input

print """\
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8"></meta>
    <link href="http://netdna.bootstrapcdn.com/twitter-bootstrap/2.3.2/css/bootstrap-combined.no-icons.min.css" rel="stylesheet">
    <style>
div.dataTables_length label {
	float: left;
	text-align: left;
}

div.dataTables_length select {
	width: 75px;
}

div.dataTables_filter label {
	float: right;
}

div.dataTables_info {
	padding-top: 8px;
}

div.dataTables_paginate {
	float: right;
	margin: 0;
}

table.table {
	clear: both;
	margin-bottom: 6px !important;
	max-width: none !important;
}

table.table thead .sorting,
table.table thead .sorting_asc,
table.table thead .sorting_desc,
table.table thead .sorting_asc_disabled,
table.table thead .sorting_desc_disabled {
	cursor: pointer;
	*cursor: hand;
}


table.table thead .sorting { background: url('images/sort_both.png') no-repeat center right; }

//table.table thead .sorting_asc { background: url('images/sort_asc.png') no-repeat center right; }
//table.table thead .sorting_desc { background: url('images/sort_desc.png') no-repeat center right; }
table.table thead .sorting_asc { background: url('http://cdn3.iconfinder.com/data/icons/fatcow/16x16_0140/bullet_arrow_up.png') no-repeat center right; }
table.table thead .sorting_desc { background: url('http://cdn3.iconfinder.com/data/icons/fatcow/16x16_0140/bullet_arrow_down.png') no-repeat center right; }

table.table thead .sorting_asc_disabled { background: url('images/sort_asc_disabled.png') no-repeat center right; }
table.table thead .sorting_desc_disabled { background: url('images/sort_desc_disabled.png') no-repeat center right; }

table.dataTable th:active {
	outline: none;
}

/* Scrolling */
div.dataTables_scrollHead table {
	margin-bottom: 0 !important;
	border-bottom-left-radius: 0;
	border-bottom-right-radius: 0;
}

div.dataTables_scrollHead table thead tr:last-child th:first-child,
div.dataTables_scrollHead table thead tr:last-child td:first-child {
	border-bottom-left-radius: 0 !important;
	border-bottom-right-radius: 0 !important;
}

div.dataTables_scrollBody table {
	border-top: none;
	margin-bottom: 0 !important;
}

div.dataTables_scrollBody tbody tr:first-child th,
div.dataTables_scrollBody tbody tr:first-child td {
	border-top: none;
}

div.dataTables_scrollFoot table {
	border-top: none;
}




/*
 * TableTools styles
 */
.table tbody tr.active td,
.table tbody tr.active th {
	background-color: #08C;
	color: white;
}

.table tbody tr.active:hover td,
.table tbody tr.active:hover th {
	background-color: #0075b0 !important;
}

.table-striped tbody tr.active:nth-child(odd) td,
.table-striped tbody tr.active:nth-child(odd) th {
	background-color: #017ebc;
}

table.DTTT_selectable tbody tr {
	cursor: pointer;
	*cursor: hand;
}

div.DTTT .btn {
	color: #333 !important;
	font-size: 12px;
}

div.DTTT .btn:hover {
	text-decoration: none !important;
}


ul.DTTT_dropdown.dropdown-menu a {
	color: #333 !important; /* needed only when demo_page.css is included */
}

ul.DTTT_dropdown.dropdown-menu li:hover a {
	background-color: #0088cc;
	color: white !important;
}

/* TableTools information display */
div.DTTT_print_info.modal {
	height: 150px;
	margin-top: -75px;
	text-align: center;
}

div.DTTT_print_info h6 {
	font-weight: normal;
	font-size: 28px;
	line-height: 28px;
	margin: 1em;
}

div.DTTT_print_info p {
	font-size: 14px;
	line-height: 20px;
}



/*
 * FixedColumns styles
 */
div.DTFC_LeftHeadWrapper table,
div.DTFC_LeftFootWrapper table,
table.DTFC_Cloned tr.even {
	background-color: white;
}

div.DTFC_LeftHeadWrapper table {
	margin-bottom: 0 !important;
	border-top-right-radius: 0 !important;
	border-bottom-left-radius: 0 !important;
	border-bottom-right-radius: 0 !important;
}

div.DTFC_LeftHeadWrapper table thead tr:last-child th:first-child,
div.DTFC_LeftHeadWrapper table thead tr:last-child td:first-child {
	border-bottom-left-radius: 0 !important;
	border-bottom-right-radius: 0 !important;
}

div.DTFC_LeftBodyWrapper table {
	border-top: none;
	margin-bottom: 0 !important;
}

div.DTFC_LeftBodyWrapper tbody tr:first-child th,
div.DTFC_LeftBodyWrapper tbody tr:first-child td {
	border-top: none;
}

div.DTFC_LeftFootWrapper table {
	border-top: none;
}
    </style>
    <script type="text/javascript" language="javascript" src="http://ajax.aspnetcdn.com/ajax/jQuery/jquery-2.0.0.min.js"></script>
    <script type="text/javascript" language="javascript" src="http://ajax.aspnetcdn.com/ajax/jquery.dataTables/1.9.4/jquery.dataTables.min.js"></script>
    <script type="text/javascript" charset="utf-8">
/* Set the defaults for DataTables initialisation */
$.extend( true, $.fn.dataTable.defaults, {
	"sDom": "<'row-fluid'<'span6'l><'span6'f>r>t<'row-fluid'<'span6'i><'span6'p>>",
	"sPaginationType": "bootstrap",
	"oLanguage": {
		"sLengthMenu": "_MENU_ records per page"
	}
} );


/* Default class modification */
$.extend( $.fn.dataTableExt.oStdClasses, {
	"sWrapper": "dataTables_wrapper form-inline"
} );


/* API method to get paging information */
$.fn.dataTableExt.oApi.fnPagingInfo = function ( oSettings )
{
	return {
		"iStart":         oSettings._iDisplayStart,
		"iEnd":           oSettings.fnDisplayEnd(),
		"iLength":        oSettings._iDisplayLength,
		"iTotal":         oSettings.fnRecordsTotal(),
		"iFilteredTotal": oSettings.fnRecordsDisplay(),
		"iPage":          oSettings._iDisplayLength === -1 ?
			0 : Math.ceil( oSettings._iDisplayStart / oSettings._iDisplayLength ),
		"iTotalPages":    oSettings._iDisplayLength === -1 ?
			0 : Math.ceil( oSettings.fnRecordsDisplay() / oSettings._iDisplayLength )
	};
};


/* Bootstrap style pagination control */
$.extend( $.fn.dataTableExt.oPagination, {
	"bootstrap": {
		"fnInit": function( oSettings, nPaging, fnDraw ) {
			var oLang = oSettings.oLanguage.oPaginate;
			var fnClickHandler = function ( e ) {
				e.preventDefault();
				if ( oSettings.oApi._fnPageChange(oSettings, e.data.action) ) {
					fnDraw( oSettings );
				}
			};

			$(nPaging).addClass('pagination').append(
				'<ul>'+
					'<li class="prev disabled"><a href="#">&larr; '+oLang.sPrevious+'</a></li>'+
					'<li class="next disabled"><a href="#">'+oLang.sNext+' &rarr; </a></li>'+
				'</ul>'
			);
			var els = $('a', nPaging);
			$(els[0]).bind( 'click.DT', { action: "previous" }, fnClickHandler );
			$(els[1]).bind( 'click.DT', { action: "next" }, fnClickHandler );
		},

		"fnUpdate": function ( oSettings, fnDraw ) {
			var iListLength = 5;
			var oPaging = oSettings.oInstance.fnPagingInfo();
			var an = oSettings.aanFeatures.p;
			var i, ien, j, sClass, iStart, iEnd, iHalf=Math.floor(iListLength/2);

			if ( oPaging.iTotalPages < iListLength) {
				iStart = 1;
				iEnd = oPaging.iTotalPages;
			}
			else if ( oPaging.iPage <= iHalf ) {
				iStart = 1;
				iEnd = iListLength;
			} else if ( oPaging.iPage >= (oPaging.iTotalPages-iHalf) ) {
				iStart = oPaging.iTotalPages - iListLength + 1;
				iEnd = oPaging.iTotalPages;
			} else {
				iStart = oPaging.iPage - iHalf + 1;
				iEnd = iStart + iListLength - 1;
			}

			for ( i=0, ien=an.length ; i<ien ; i++ ) {
				// Remove the middle elements
				$('li:gt(0)', an[i]).filter(':not(:last)').remove();

				// Add the new list items and their event handlers
				for ( j=iStart ; j<=iEnd ; j++ ) {
					sClass = (j==oPaging.iPage+1) ? 'class="active"' : '';
					$('<li '+sClass+'><a href="#">'+j+'</a></li>')
						.insertBefore( $('li:last', an[i])[0] )
						.bind('click', function (e) {
							e.preventDefault();
							oSettings._iDisplayStart = (parseInt($('a', this).text(),10)-1) * oPaging.iLength;
							fnDraw( oSettings );
						} );
				}

				// Add / remove disabled classes from the static elements
				if ( oPaging.iPage === 0 ) {
					$('li:first', an[i]).addClass('disabled');
				} else {
					$('li:first', an[i]).removeClass('disabled');
				}

				if ( oPaging.iPage === oPaging.iTotalPages-1 || oPaging.iTotalPages === 0 ) {
					$('li:last', an[i]).addClass('disabled');
				} else {
					$('li:last', an[i]).removeClass('disabled');
				}
			}
		}
	}
} );


/*
 * TableTools Bootstrap compatibility
 * Required TableTools 2.1+
 */
if ( $.fn.DataTable.TableTools ) {
	// Set the classes that TableTools uses to something suitable for Bootstrap
	$.extend( true, $.fn.DataTable.TableTools.classes, {
		"container": "DTTT btn-group",
		"buttons": {
			"normal": "btn",
			"disabled": "disabled"
		},
		"collection": {
			"container": "DTTT_dropdown dropdown-menu",
			"buttons": {
				"normal": "",
				"disabled": "disabled"
			}
		},
		"print": {
			"info": "DTTT_print_info modal"
		},
		"select": {
			"row": "active"
		}
	} );

	// Have the collection use a bootstrap compatible dropdown
	$.extend( true, $.fn.DataTable.TableTools.DEFAULTS.oTags, {
		"collection": {
			"container": "ul",
			"button": "li",
			"liner": "a"
		}
	} );
}


/* Table initialisation */
$(document).ready(function() {
	$('#from_csv').dataTable( {
		"sDom": "<'row'<'span6'l><'span6'f>r>t<'row'<'span6'i><'span6'p>>",
		"sPaginationType": "bootstrap",
		"oLanguage": {
			"sLengthMenu": "_MENU_ records per page"
		}
	} );
} );
    </script>
  </head>
  <body>
    <div class="container" style="margin-top: 10px">
      <table cellpadding="0" cellspacing="0" border="0" class="table table-striped table-bordered" id="from_csv">
        <thead>\
"""

for i, row in enumerate(reader):
    if i == 0:
        print "<tr><th>" + "</th><th>".join(row) + "</th></tr>"
    else:
        print "<tr><td>" + "</td><td>".join(row) + "</td></tr>"

    if i == 0:
        print "</thead><tbody>"

print """\
        </tbody>
      </table>
    </div>
  </body>
</html>\
"""
