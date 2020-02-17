class Api::MeController < Api::BaseController
  respond_to :json

  def me
    current_user ? (respond_with({ user: current_user })) : respond_with {}
  end

  def test
  	respond_with({ user: "Hello World" })
  end
end

