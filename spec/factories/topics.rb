# == Schema Information
#
# Table name: topics
#
#  id             :integer          not null, primary key
#  tag_line       :string(255)
#  user_id        :integer          default(0), not null
#  created_at     :datetime
#  status         :string(7)        default("pending"), not null
#  group_id       :integer          default(0), not null
#  comment_status :string(15)       default("open"), not null
#  anonymous      :boolean          default(FALSE), not null
#  updated_at     :datetime
#  title          :string(255)
#  top_post_id    :integer
#  score          :integer          default(0)
#  posts_count    :integer          default(0)
#  views          :integer          default(0), not null
#
# Indexes
#
#  created_at                                          (group_id,status,created_at)
#  index_topics_on_group_id_and_status_and_updated_at  (group_id,status,updated_at)
#  status                                              (status,group_id,id)
#

FactoryGirl.define do
  factory :empty_topic, class: Topic do
    title { Forgery(:lorem_ipsum).words(rand(3..10), random: true) }
    association :group
    status 'publish' # usually we're testing published topics
    association :user
    anonymous false
  end

  factory :topic, parent: :empty_topic do
    content{ Forgery::LoremIpsum.paragraph }

    after(:create){ |topic|
      topic.make_top_post
      topic.posts_count = 1
      topic.save
    }
  end
end
