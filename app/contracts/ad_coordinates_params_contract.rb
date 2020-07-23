# frozen_string_literal: true

class AdCoordinatesParamsContract < Dry::Validation::Contract
  params do
    required(:id).filled(:integer)
    required(:coordinates).filled(:array)
  end
end
