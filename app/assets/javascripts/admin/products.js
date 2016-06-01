$(document).ready(function() {
  if ($('#product_using_inventory').is(":checked")) {
    enableQuantityField();
  } else {
    disableQuantityField();
  }
  
  $('#product_using_inventory').on('click', function () {
    if ($(this).is(":checked")) {
      enableQuantityField();
    } else {
      disableQuantityField();
    }
  })
});

function disableQuantityField() {
  $('#product_quantity').attr('disabled', 'disabled')
}

function enableQuantityField() {
  $('#product_quantity').removeAttr('disabled');
}