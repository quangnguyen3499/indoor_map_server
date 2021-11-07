# == Schema Information
#
# Table name: markers
#
#  id        :bigint           not null, primary key
#  pair_name :string(191)
#
class Marker < ApplicationRecord
  has_one :direction
end
