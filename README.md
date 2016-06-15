
#### Action Cable Live Templating

1. First attempt is okay.  Updating server 1s after last keyup.
2. Would like to be able to have a fullscreen.
3. Have no idea how this will work in real world production, let alone a setup with significant traffic
4. Make sure to restrict access etc...


## README / TODO
## only on production
- cart image (why isn't it always small?)
- remove session if not found (done?)
- null lineitem route... (i think its fixed?)

#### Front:
- totals on cart get removed if one item is removed (last in quantity) but there are still other items remaining
- cart says "nothing here"... even if something added (sometimes)
- store index - crop image?  or somehow fit different sizes in grid
- next tag, top, previous tag at end
- ability to go back to addresses if on payment step in checkout..
- local cart loaders + local payment loaders
- paypal cancel link...

# later
- photo -> product easier
- disable checkout if no items in cart (halfway there)
- product -> add photo retroactively
- edit photo (actual image)
- calendar pickr appears to be a bit off.. style update?  check local
- reset variant price (from xxx ) after added to card
- when you click off a size/variant chooser it should collapse (not just reclicking on the header)
- notices + errors front end. ?
- custom fields for about etc - TRY IT!
- admin photos index - it would probably be a good idea to dynamically create each selectize as needed, otherwise you're calling tags a bazillion times.
- clean up checkout view -> checkoutviewmodel


#### Admin:
- product photos constraints (? not sure what this means...)
- photos filter by tag
- prepend dolla signs to all number fields


## Theming Support 
- Perhaps lint or other safety check?
- Clean up past stylesheets in public directory
- namespace everything within a body tag, or at least add the theme to the body
- test in production env

### Qs for el
- Do you want a cart page in addition to the pop up cart
- How are you breaking down your navigation?
- max width for site? (ill hook up retina 
- and we can use caching to speed up the site)
- I'd like to do some cool stuff for mobile (or otherwise) with sticky headers and or footers
- under product in indiviidual page?  maybe other prints?

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