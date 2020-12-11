module V1
  class ContactsController < ApplicationController

    include ErrorSerializer

    before_action :authenticate_user!
    before_action :set_contact, only: [:show, :update, :destroy]

    # GET /contacts
    def index
      page_number = params[:page].try(:[], :number)
      page_page   = params[:page].try(:[], :size)

      @contacts = Contact.all.page(params[:page].try(:[], :number))

      render json: @contacts
    end

    # GET /contacts/1
    def show
      render json: @contact, include: [:kind, :address, :phones]#, meta: { author: "Cleiton Corrêa"}#, include: [:kind, :phones, :address]
    end

    # POST /contacts
    def create
      @contact = Contact.new(contact_params)

      if @contact.save
        render json: @contact, include: [:kind, :phones, :address], status: :created, location: @contact
      else
        render json: ErrorSerializer.serialize(@contact.errors) #@contact.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /contacts/1
    def update
      if @contact.update(contact_params)
        render json: @contact, include: [:kind, :phones, :address]
      else
        render json: @contact.errors, status: :unprocessable_entity
      end
    end

    # DELETE /contacts/1
    def destroy
      @contact.destroy
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_contact
        @contact = Contact.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def contact_params
        ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [:title, :content, :author])
      end

      def authenticate
        #Authentication Token
        authenticate_or_request_with_http_token do |token, options|
          hmac_secret = 'my$ecretK3y'
          JWT.decode token, hmac_secret, true, { :algorithm => 'HS256'}
        end
      end
  end
end
