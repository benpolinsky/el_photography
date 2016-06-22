BpCustomFields::GroupTemplate.create!([
  {name: "About", visible: nil},
  {name: "Contact", visible: nil}
])

BpCustomFields::FieldTemplate.create!([
  {name: "Contact Page Title", label: "Contact Page Title", group_template_id: 2, field_type: "string", min: "", max: "", required: false, instructions: "", default_value: "", placeholder_text: nil, prepend: "", append: "", rows: nil, date_format: "", time_format: "", accepted_file_types: "", toolbar: "Full", choices: "", multiple: false, parent_id: nil, row_order: 1},
  {name: "Contact Page Text", label: "Contact Page Text", group_template_id: 2, field_type: "text", min: "", max: "", required: false, instructions: "", default_value: "", placeholder_text: nil, prepend: "", append: "", rows: nil, date_format: "", time_format: "", accepted_file_types: "", toolbar: "Full", choices: "", multiple: false, parent_id: nil, row_order: 2},
  {name: "About Page Title", label: "About Page Title", group_template_id: 1, field_type: "string", min: "", max: "", required: false, instructions: "", default_value: "", placeholder_text: nil, prepend: "", append: "", rows: nil, date_format: "", time_format: "", accepted_file_types: "", toolbar: "Full", choices: "", multiple: false, parent_id: nil, row_order: 3},
  {name: "About Page Text", label: "About Page Text", group_template_id: 1, field_type: "text", min: "", max: "", required: false, instructions: "", default_value: "", placeholder_text: nil, prepend: "", append: "", rows: nil, date_format: "", time_format: "", accepted_file_types: "", toolbar: "Full", choices: "", multiple: false, parent_id: nil, row_order: 4},
  {name: "About Image", label: "About Image", group_template_id: 1, field_type: "image", min: "", max: "", required: false, instructions: "", default_value: "", placeholder_text: nil, prepend: "", append: "", rows: nil, date_format: "", time_format: "", accepted_file_types: "", toolbar: "Full", choices: "", multiple: false, parent_id: nil, row_order: 5}
])

BpCustomFields::AbstractResource.create!([
  {name: "about"},
  {name: "contact"}
])

BpCustomFields::Appearance.create!([
  {resource: "BpCustomFields::AbstractResource", resource_id: "about", appears: true, row_order: nil, group_template_id: 1},
  {resource: "BpCustomFields::AbstractResource", resource_id: "contact", appears: true, row_order: nil, group_template_id: 2}
])
