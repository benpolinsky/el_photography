// setup, as a function, is way too big... break IT UP!
// dry it up too
// and this should probably be defined as a wizard

modulejs.define('payments', function () {
  var Payments = {
    setup: function () {
      var next_step = $('.wizard-step.active');

      $('.paypal-fields').hide();
      $('.stripe-fields').hide();
      $('.stripe-info').hide();
      $('.paypal-info').hide();
      $('.payment-chooser input#order_payment_method_paypal').on('click', function(event) {
        $('.payment-chooser input#order_payment_method_stripe').next('label').removeClass('active');
        $(this).next('label').addClass('active');
        
        $('.stripe-info').hide();
        $('.stripe-fields').hide();
        $('.paypal-info').show();
        $('.paypal-fields').show();
        $('html, body').animate({
          scrollTop: $(this).parent().offset().top
          }, 400);  
      });
  
      $('.payment-chooser input#order_payment_method_stripe').on('click', function(event) {
        $('.payment-chooser input#order_payment_method_paypal').next('label').removeClass('active');
        $(this).next('label').addClass('active');
        $('.stripe-fields').show();
        $('.stripe-info').show();
        $('.paypal-fields').hide();
        $('.paypal-info').hide();
        $('html, body').animate({
          scrollTop: $(this).parent().offset().top
          }, 400, function () {
            $('#order_credit_card_number').focus();
          });
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
      
      $('.wizard-step.inactive').find('form').find(':input').prop('disabled', true);
      
      
      
      $('html, body').animate({
        scrollTop: next_step.offset().bottom
        }, 400, function () {
        next_step.focus()      
      });

      
      $('form#submit-payment').submit(function (event) {
        if (!$(this).hasClass('paypal-submit')) {
          var Loader = modulejs.require('loader');
          Loader.start();
          var $form = $(this);
          $form.find('input[type="submit"]').prop('disabled', true);
          $form.find('input[type="submit"]').attr('data-disable-with', '<i class="fa fa-spinner fa-spin"></i>Paying…');
          Stripe.createToken($form, Payments.stripeResponseHandler);
          return false;      
        }
      });
  
  
      $('button[name="paypal"]').on('click', function(event) {
        var Loader = modulejs.require('loader');
        Loader.start();
        event.preventDefault();
        $('form#submit-payment').addClass('paypal-submit');
        $('form#submit-payment').get(0).submit();
        return false;
      });
    },
  
    stripeResponseHandler: function (status, response) {
      var $form = $('form#submit-payment');
      if (response.error) {
        var Loader = modulejs.require('loader');
        Loader.stop();
        $form.find(".payment-errors").text(response.error.message);
        $form.find('input[type="submit"]').prop('disabled', false);
      } else {
        var token = response.id;
        $form.data("remote", 'true');
        $form.append($("<input type='hidden' name='stripeToken' />").val(token));
        $form.get(0).submit();
      }
    },
    
    hideShippingAddress: function () {
      $('a.enter-shipping-address').removeClass('disabled hidden');
      
      $('a.ship-to-same').text('Proceed');
      $('.shipping-address').addClass('hidden');
      $('.shipping-address').find(':input').prop('disabled', true);
    },

    showShippingAddress: function () {
      $('a.ship-to-same').text('Whoops!  Ship to my billing address, please.');
      $('a.enter-shipping-address').addClass('disabled hidden');
      $('.shipping-address').removeClass('hidden');  
      $('.shipping-address').find(':input').prop('disabled', false);
    }
  }
  
  return Payments  
});

