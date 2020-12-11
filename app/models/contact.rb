class Contact < ApplicationRecord

  # Validations
  validates_presence_of :kind
  validates_presence_of :address

  # Kaminari
  paginates_per 5

  # Associations
  belongs_to :kind, optional: true
  has_many :phones
  has_one :address

  accepts_nested_attributes_for :phones, allow_destroy: true
  accepts_nested_attributes_for :address, update_only: true

  def as_json(options={})
    h = super(options)
    h[:birthdate] = (I18n.l(self.birthdate) unless self.birthdate.blank?)
    h
  end

end
