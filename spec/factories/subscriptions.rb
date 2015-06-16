# coding: utf-8
# == Schema Information
#
# Table name: subscriptions
#
#  id               :integer          not null, primary key
#  subscriber_id    :integer
#  publication_id   :integer
#  publication_type :string(32)
#  viewed_at        :datetime
#  created_at       :datetime
#  updated_at       :datetime
#  unread_count     :integer          default(0), not null
#

# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :subscription do
    association :subscriber, factory: :user
    publication_type { 'Article' }
    publication_id { create(:article).id.to_s }
    unread_count 0
    updated_at { Time.now }
  end
end
