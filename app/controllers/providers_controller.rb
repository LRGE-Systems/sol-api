class ProvidersController < ApplicationController
  include CrudController

  PERMITTED_PARAMS = [
    :name, :document, :type, :organization_id,

    address_attributes: [
      :id, :address, :number, :neighborhood, :city_id, :cep, :complement,
      :reference_point, :latitude, :longitude
    ],

    legal_representative_attributes: [
      :id, :name, :nationality, :civil_state, :rg, :cpf, :valid_until,

      address_attributes: [
        :id, :address, :number, :neighborhood, :city_id, :cep, :complement,
        :reference_point, :latitude, :longitude
      ]
    ],

    provider_classifications_attributes: [
      :id, :classification_id, :_destroy
    ],

    suppliers_attributes: [
      :name, :email, :phone, :cpf, :password, :password_confirmation, :organization_id
    ],

    attachments_attributes: [
      :id, :file, :_destroy
    ]
  ].freeze

  expose :provider

  private

  def resource
    provider
  end

  def resource_key
    :provider
  end

  def provider_params
    pr = params.require(:provider).permit(*PERMITTED_PARAMS)
    org = Organization.find(params[:organization_id])
    pr[:organization_id] = org.id
    pr[:suppliers_attributes][0][:organization_id] = org.id
    pr
  end
end
