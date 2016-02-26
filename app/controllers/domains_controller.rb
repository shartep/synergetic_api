class DomainsController < ApplicationController
  require 'net/http'
  include ActionController::HttpAuthentication::Basic::ControllerMethods

  http_basic_authenticate_with name: 'admin3', password: '', only: :create

  # GET /domains
  # GET /domains.json
  def index
    @domains = Domain.all

    render json: @domains
  end

  # POST /domains
  # POST /domains.json
  def create
    @domain = Domain.new(domain_params)

    url = URI.parse(@domain.url)
    if url.scheme == 'https'
      begin
        res = Net::HTTP.get_response(url)
      rescue
      end
    end

    if res.is_a?(Net::HTTPOK) && @domain.save
      render json: @domain, status: :created, location: @domain
    else
      render json: @domain.errors, status: :unprocessable_entity
    end
  end

  private
    def domain_params
      params.require(:domain).permit(:url)
    end
end
