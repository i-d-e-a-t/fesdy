# encoding: utf-8
class Artist < ActiveRecord::Base
  has_many :appearances
  has_many :festivals, through: :appearances
  has_many :musics

  def setlist(fes)
    appears = Appearance.where(
      festival_id: fes.id,
      artist_id: self.id
    )
    return [] if appears.empty?
    return appears.last.musics
  end
end
