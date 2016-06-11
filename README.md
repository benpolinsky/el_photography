## README / TODO
- admin photos index - it would probably be a good idea to dynamically create each selectize as needed, otherwise you're calling tags a bazillion times.
- notices + errors front end.

## Theming Support 
- very basic dynamic css added
  - Perhaps lint or other safety check?
  - Clean up past stylesheets in public directory
  - namespace everything within a body tag, or at least add the theme to the body
  - test in production env
  - eventually extract theme into gem

### Qs for el

- How are you breaking down your navigation?

# As a Gem.../ Refactoring
 - nicer parsley errors
 - nicer localized slider (for cart etc)
 - better null/stale_line_item and support for deleted variants
 - continue to work on ProductView
 - move payment processesing to a background job 
   
 - Webhooks + IPNs aren't necessary for basic payments...
   - Subscriptions, yes they are. (both paypal and stripe)
   - eChecks(paypal)
   - disputes, etc (stripe)
   - So, it'd be a plugin, or perhaps there's one out there already. 
   
 - Comparison to other gems:
   - ActiveMerchant is HUGE and OLD - this gem will never support 100+ gateways.  
     - I probably won't get past 5: a couple of paypal implementations, stripe, braintree, coinbase, maybe open source bitcoin API
     - it also has no dependencies on legacy code or gateways
   - ActiveMerchant doesn't support two-step payment gateways that require interaction from the user
     - i.e. bitcoin, or paypal pay on paypal site.

   - acts_as_shopping_cart's scope is too narrow