
## README / TODO


#### Admin:
- photos filter by tag
- prepend dolla signs to all number fields
- add loader to caption editing

# later
- password protect entire site fpr preview
- filters ()/photos) and tables sortable
- cart remove "keep shopping"
- admin product show -> up it to preview
- (I’ll add the ability to add an existing photo to a product that doesn’t have one.)
- ability to go back to addresses if on payment step in checkout..
- photo -> product easier
- disable checkout if no items in cart (halfway there)
- product -> add photo retroactively
- edit photo (actual image)
- calendar pickr appears to be a bit off.. style update?  check local
- parsley maybe too much stuff?
- custom fields for about etc - TRY IT! - only going to work if you can load onto a resource without a page.... for now.. maybe code a liquid template?
- admin photos index - it would probably be a good idea to dynamically create each selectize as needed, otherwise you're calling tags a bazillion times.
- clean up checkout view -> checkoutviewmodel
- local loaders for cart + payment rather than the large loaders you are using...
- test out of stock functionality

## Theming Support 
- Perhaps lint or other safety check?
- Clean up past stylesheets in public directory
- namespace everything within a body tag, or at least add the theme to the body
- test in production env
- css to aws

### Qs for el
- store index - crop image?  or somehow fit different sizes in grid
- under product in indiviidual page?  maybe other prints?
- is there a different name you'd like used for 'products'  prints?


### on deploy
- caching
- look into retina


# As a Gem.../ Refactoring
- Now that you've got a few views, you can extract common logic to a parent class, probably abstract but maybe not.
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