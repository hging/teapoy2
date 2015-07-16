# == Schema Information
#
# Table name: stories
#
#  id           :integer          not null, primary key
#  guestbook_id :integer
#  author_id    :integer
#  content      :text(65535)
#  created_at   :datetime
#  updated_at   :datetime
#  likes_count  :integer          default(0), not null
#  picture      :string(255)
#  anonymous    :boolean          default(FALSE), not null
#  email        :string(64)
#
# Indexes
#
#  index_stories_on_email                       (email)
#  index_stories_on_guestbook_id_and_author_id  (guestbook_id,author_id)
#

class StorySerializer < ActiveModel::Serializer
  attributes :id, :content
  has_one :guestbook
  has_one :author
end
