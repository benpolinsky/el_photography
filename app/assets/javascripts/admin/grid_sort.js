$(document).ready(function() {
  var loader = modulejs.require('loader');
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

        var new_position, previous_item, next_item;
        var item_id = ui.item.data('item-id');
        var post_path = ui.item.data('post-path');
        var position = ui.item.index();
        previous_item = ui.item.prev();
        if (previous_item.length > 0) {
          new_position = previous_item.data('rank') + 1
        } else {
          next_item = ui.item.next();
          new_position = next_item.data('rank') - 1
        }
       loader.start()
        console.log(new_position)
        $.ajax({
          type: "POST",
          url: post_path,
          dataType: "script",
          data: {
            item: {
              item_id: item_id, 
              row_order_position: new_position
            }
          },
          success: function (response) {
            loader.stop()
            console.log('success')
          }
        })
      }
    })
  }
});