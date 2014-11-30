class AddChargeToSpreePaymentMethod < ActiveRecord::Migration
  def up
    if table_exists?('spree_payment_methods') && !column_exists?(:spree_payment_methods, :charge, :decimal)
      add_column :spree_payment_methods, :charge, :decimal, precision: 10, scale: 2
    end
  end

  def down
    if table_exists?('spree_payment_methods') && column_exists?(:spree_payment_methods, :charge, :decimal)
      remove_column :spree_payment_methods, :charge
    end
  end
end
