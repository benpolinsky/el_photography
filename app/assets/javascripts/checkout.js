jQuery(document).ready(function($) {
  var payments = require('./payments');
  window.payments = payments;
  payments.hideShippingAddress();
  $('a.enter-shipping-address').on('click', function () {
    payments.showShippingAddress();
    return false
  });
  
  $('a.ship-to-same').on('click', function () {
    payments.hideShippingAddress();
    $('input#order_shipping_same').val('true');
    $(this).parents('form').submit();
    return false
  });
});

