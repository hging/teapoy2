# coding: utf-8
# == Schema Information
#
# Table name: devices
#
#  id        :integer          not null, primary key
#  device_id :string(255)
#  token     :string(255)
#  user_id   :integer
#
# Indexes
#
#  index_devices_on_device_id  (device_id)
#  index_devices_on_token      (token)
#  index_devices_on_user_id    (user_id)
#

# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :device do
    id "MyString"
    token "MyString"
  end
end
