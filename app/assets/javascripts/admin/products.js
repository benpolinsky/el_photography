$(document).ready(function() {
  $('.product_using_inventory').each(function(index) {
    if ($(this).is(":checked")) {
      enableQuantityField(this);
    } else {
      disableQuantityField(this);
    }
  });

  
  $('.product_using_inventory').on('click', function () {
    if ($(this).is(":checked")) {
      enableQuantityField(this);
    } else {
      disableQuantityField(this);
    }
  })
});

function disableQuantityField(field) {
  $(field).parent().siblings('.field.quantity').children('.quantity-input').attr('disabled', 'disabled')
}

function enableQuantityField(field) {
  $(field).parent().siblings('.field.quantity').children('.quantity-input').removeAttr('disabled');
}