# coding: utf-8
class AddParentToComment < ActiveRecord::Migration
  def self.up
    add_column :comments, :parent_id, :integer
  end

  def self.down
    remove_column :comments, :parent_id
  end
end
