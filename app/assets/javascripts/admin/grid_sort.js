$(document).ready(function() {
  if ($('.big-grid.sortable').length > 0){
    $('.sortable').sortable({
      axis: '',
      cursor: 'move',
      sort: function (e, ui) {
        ui.item.addClass('active-item-shadow');
      },
      stop: function (e, ui) {
        ui.item.removeClass('active-item-shadow');
        ui.item.effect('highlight', {}, 1000);
      },
      update: function (e, ui) {
        item_id = ui.item.data('item-id');
        post_path = ui.item.data('post-path');
        position = ui.item.index();
        $.ajax({
          type: "POST",
          url: post_path,
          dataType: "json",
          data: {
            item: {
              item_id: item_id, 
              row_order_position: position
            }
          }
        })
      }
    })
  }
});