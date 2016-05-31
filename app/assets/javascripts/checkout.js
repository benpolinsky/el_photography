jQuery(document).ready(function($) {
  $('input#order_shipping_same').on('click', function () {
    if ($(this).is(":checked")) {
      hideShippingAddress();
    } else {
      showShippingAddress();
    }
  })
});

var hideShippingAddress = function () {
  $('.shipping-address').addClass('hidden');
}

var showShippingAddress = function () {
  $('.shipping-address').removeClass('hidden');  
}
