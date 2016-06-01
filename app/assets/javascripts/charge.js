modulejs.define('payments', function () {
  var Payments = {
    setup: function () {
      $('.paypal-fields').hide();
      $('.stripe-fields').hide();
      $('.payment-chooser input#order_payment_method_paypal').on('click', function(event) {
        $('.stripe-fields').hide();
        $('.paypal-fields').show();
      });
  
      $('.payment-chooser input#order_payment_method_stripe').on('click', function(event) {
        $('.stripe-fields').show();
        $('.paypal-fields').hide();
      });
  
      $('#exp-year').hide();
      $('#exp-month').hide();

      $('#card_month').change(function () {
        var month = $(this).val();
        $('#exp-month').val(month);
      });

      $('#card_year').change(function () {
        var year = $(this).val();
        $('#exp-year').val(year);
      });
  
      $('form#submit-payment').submit(function (event) {
        if (!$(this).hasClass('paypal-submit')) {
          var $form = $(this);
          $form.find('input[type="submit"]').prop('disabled', true);
          $form.find('input[type="submit"]').attr('data-disable-with', '<i class="fa fa-spinner fa-spin"></i>Paying…');
          Stripe.createToken($form, stripeResponseHandler);
          return false;      
        }
      });
  
  
      $('button[name="paypal"]').on('click', function(event) {
        event.preventDefault();
        $('form#submit-payment').addClass('paypal-submit');
        $('form#submit-payment').get(0).submit();
        return false;
      });
    },
  
    stripeResponseHandler: function (status, response) {
      var $form = $('form#submit-payment');
      if (response.error) {
        $form.find(".payment-errors").text(response.error.message);
        $form.find('input[type="submit"]').prop('disabled', false);
      }else {
        var token = response.id;
        $form.data("remote", 'true');
        $form.append($("<input type='hidden' name='stripeToken' />").val(token));
        $form.get(0).submit();
      }
    }
  
  }



return Payments
  
});

