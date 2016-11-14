# jQuery ->
#   if $('table.sortable').length > 0
#     table_width = $('table.sortable').width()
#     cells = $('.table').find('tr')[0].cells.length
#     desired_width = table_width / cells + 'px'
#     $('.table td').css('width', desired_width)
#
#     $('.sortable').sortable(
#       axis: 'y'
#       items: '.row-item'
#       cursor: 'move'
#       handle: '.handle'
#
#       sort: (e, ui) ->
#         ui.item.addClass('active-item-shadow')
#       stop: (e, ui) ->
#         ui.item.removeClass('active-item-shadow')
#         # highlight the row on drop to indicate an update
#         ui.item.children('td').effect('highlight', {}, 1000)
#       update: (e, ui) ->
#         item_id = ui.item.data('item-id')
#         post_path = ui.item.data('post-path')
#         position = ui.item.index() # this will not work with paginated items, as the index is zero on every page
#         $.ajax(
#           type: 'POST'
#           url: post_path
#           dataType: 'json'
#           data: { item: {item_id: item_id, row_order_position: position } }
#         )
#     )