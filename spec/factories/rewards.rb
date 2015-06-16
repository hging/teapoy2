# == Schema Information
#
# Table name: rewards
#
#  id          :integer          not null, primary key
#  rewarder_id :integer          not null
#  post_id     :string(24)
#  winner_id   :integer          not null
#  amount      :integer
#  anonymous   :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do
  factory :reward do
    association :winner, factory: :user
    association :rewarder, factory: :rich_user
    association :post, factory: :post
    amount { rand(1..100) }
  end
end
