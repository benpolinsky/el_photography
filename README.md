## README / TODO
- adding tags with multiple photos problem..
- clear tag input after upload finished
- reorder tags
- quick way to add or remove tag
- and quick way to add/change caption for each

- very basic dynamic css added
  - Perhaps lint or other safety check?
  - Clean up past stylesheets in public directory
  - namespace everything within a body tag, or at least add the theme to the body
  - test in production env
  - eventually extract theme into gem

- wysiwig - hopefully trix, medium also an option

### Qs

- How are you breaking down your navigation?

Distinct Shop: (with ability to link from photos, so ability to link a product to a photo):
- No tags in shop to start.
- List of photos with a few sizes and then each size would have to have a unique photo.
- So each photo must have a size
- PayPal to start then move to stripe

Products, Variants, Options, OptionValues added to store

Need:
Cart Item
Order Item
Cart
Order
Payment (see weisscoach)

