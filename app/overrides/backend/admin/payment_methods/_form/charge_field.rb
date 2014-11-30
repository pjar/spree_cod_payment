Deface::Override.new(virtual_path: 'spree/admin/payment_methods/_form',
                     name: 'charge_field_on_payment_method_form',
                     insert_before: '[data-hook="environment"]',
                     partial: 'spree/admin/payment_methods/_form/charge_field')
