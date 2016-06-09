## README / TODO
- adding tags with multiple photos problem..
- clear tag input after upload finished
- reorder tags
- quick way to add or remove tag
- and quick way to add/change caption for each
- notices + errors front end?  Not sure if needed....
- validate variants

## The Store
 - better null/stale_line_item and support for deleted variants
 - continue to work on ProductView
 - variant price validation - I suppose skip validation on creation (from_options_and_values)
 
## Theming Support 
- very basic dynamic css added
  - Perhaps lint or other safety check?
  - Clean up past stylesheets in public directory
  - namespace everything within a body tag, or at least add the theme to the body
  - test in production env
  - eventually extract theme into gem

- wysiwig - hopefully trix, medium also an option


### Qs for el

- How are you breaking down your navigation?

# As a Gem.../ Refactoring


 - move payment processesing to a background job 
   
 - Webhooks + IPNs aren't necessary for basic payments...
   - Subscriptions, yes they are. (both paypal and stripe)
   - eChecks(paypal)
   - disputes, etc (stripe)
   - So, it'd be a plugin, or perhaps there's one out there already. 
   
 - Comparison to other gems:
   - This is a Rails solution.  
   - It mounts routes, and deals with both backend processing and front end ux.

   - ActiveMerchant is HUGE - this gem will never support 100+ gateways.  
     - I probably won't get past 5: a couple of paypal implementations, stripe, braintree, coinbase, maybe open source bitcoin API
   - ActiveMerchant doesn't support two-step payment gateways that require interaction from the user
     - i.e. bitcoin, or paypal pay on paypal site.
  
   - acts_as_shopping_cart's scope is too narrow