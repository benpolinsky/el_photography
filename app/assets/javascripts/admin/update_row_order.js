jQuery(function() {
  var loader = modulejs.require('loader');
  var cells, desired_width, table_width;
  if ($('table.sortable').length > 0) {
    table_width = $('table.sortable').width();
    cells = $('.table').find('tr')[0].cells.length;
    desired_width = table_width / cells + 'px';
    $('.table td').css('width', desired_width);
    return $('.sortable').sortable({
      axis: 'y',
      items: '.row-item',
      cursor: 'move',
      handle: '.handle',
      sort: function(e, ui) {
        return ui.item.addClass('active-item-shadow');
      },
      stop: function(e, ui) {
        ui.item.removeClass('active-item-shadow');
        return ui.item.children('td').effect('highlight', {}, 1000);
      },
      update: function(e, ui) {
      
        var item_id, position, post_path;
        item_id = ui.item.data('item-id');
        post_path = ui.item.data('post-path');
        position = ui.item.index();
          loader.start();
         $.ajax({
          type: 'POST',
          url: post_path,
          dataType: 'script',
          data: {
            item: {
              item_id: item_id,
              row_order_position: position
            }
          },
          success: function(response) {
            loader.stop();
            console.log('success');
          }
        });
      }
    });
  }
});
