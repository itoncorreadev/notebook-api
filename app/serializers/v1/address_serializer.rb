module V1
  class AddressSerializer < ActiveModel::Serializer
    attributes :id, :street, :city

    belongs_to :contact do
      link(:related) {v1_contact_address_url(object.contact.id)}
    end
  end
end
