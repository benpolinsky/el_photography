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
  });
  
  
  $('.select-product-photos').on('click', '.select-product-photo', function () {
    $('.select-product-photo').removeClass('active').addClass('inactive');
    $(this).removeClass('inactive').addClass('active');
    $('#photo_id').val($(this).data('id'));
  });
  
});

function disableQuantityField(field) {
  $(field).parent().siblings('.field.quantity').children('.quantity-input').attr('disabled', 'disabled')
}

function enableQuantityField(field) {
  $(field).parent().siblings('.field.quantity').children('.quantity-input').removeAttr('disabled');
}