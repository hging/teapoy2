# coding: utf-8
# == Schema Information
#
# Table name: announcements
#
#  id         :integer          not null, primary key
#  content    :text(65535)
#  created_at :datetime
#  updated_at :datetime
#

class Announcement < ActiveRecord::Base
end
