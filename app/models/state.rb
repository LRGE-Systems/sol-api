class State < ApplicationRecord
  has_many :cities, dependent: :destroy

  belongs_to :country

  validates :name,
            :uf,
            :code,
            presence: true

  validates_uniqueness_of :name, case_sensitive: false
  validates_uniqueness_of :uf, case_sensitive: false
  validates_uniqueness_of :code

  delegate :name, to: :country, prefix: true, allow_nil: true

end
