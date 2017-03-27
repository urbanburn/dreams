class ChangeDreamGrantingToggleToTrue < ActiveRecord::Migration
  def change
    change_column :camps, :grantingtoggle, :boolean, :default => true
  end
end
