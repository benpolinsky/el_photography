jQuery(document).ready(function($) {
  if ($('input#order_shipping_same').is(":checked")) {
    modulejs.require('payments').hideShippingAddress();
  } else {
    modulejs.require('payments').showShippingAddress();
  }
  $('input#order_shipping_same').on('click', function () {
    if ($(this).is(":checked")) {
      modulejs.require('payments').hideShippingAddress();
    } else {
      modulejs.require('payments').showShippingAddress();
    }
  })
});

