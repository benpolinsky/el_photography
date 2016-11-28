jQuery(document).ready(function($) {
  
  $('body.not-mobile .order-form-right').sticky({topSpacing: 10})

  modulejs.require('payments').hideShippingAddress();
  $('a.enter-shipping-address').on('click', function () {
    modulejs.require('payments').showShippingAddress();
    return false
  });
  
  $('a.ship-to-same').on('click', function () {
    modulejs.require('payments').hideShippingAddress();
    $('input#order_shipping_same').val('true');
    $(this).parents('form').submit();
    return false
  });
});

