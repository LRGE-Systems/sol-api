module Administrator
  class CooperativesController < AdminController
    include CrudController

    load_and_authorize_resource

    PERMITTED_PARAMS = [
      :name, :cnpj,

      address_attributes: [
        :id, :address, :number, :neighborhood, :city_id, :cep, :complement,
        :reference_point, :latitude, :longitude, :phone, :email,:country_id
      ],

      legal_representative_attributes: [
        :id, :name, :nationality, :civil_state, :rg, :cpf, :valid_until,:email,

        address_attributes: [
          :id, :address, :number, :neighborhood, :city_id, :cep, :complement,
          :reference_point, :latitude, :longitude, :phone, :email, :country_id,
        ]

      ]
    ].freeze

    expose :cooperatives, -> { find_cooperatives }
    expose :cooperative

    before_action :set_paper_trail_whodunnit

    private

    def resource
      cooperative
    end

    def resources
      cooperatives.for_user(current_user)
    end

    def find_cooperatives
      Cooperative.for_user(current_user).accessible_by(current_ability).includes(:address)
    end

    def cooperative_params
      pr = params.require(:cooperative).permit(*PERMITTED_PARAMS)
      pr[:organization] = current_user.organization
      pr
    end
  end
end
