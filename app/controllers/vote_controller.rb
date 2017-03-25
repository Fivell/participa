class VoteController < ApplicationController
  layout "full", only: [:create]
  before_action :authenticate_user! 
  
  def send_sms_check
    authorize! :send_sms_check, :vote

    if current_user.send_sms_check!
      redirect_to sms_check_vote_path(params[:election_id]), flash: {info: "El código ha sido enviado a tu teléfono móvil." }
    else
      redirect_to sms_check_vote_path(params[:election_id]), flash: {error: "Ya se ha solicitado un código recientemente." }
    end
  end

  def sms_check
    authorize! :sms_check, :vote

    @election_id = params[:election_id]
    @election = Election.find @election_id
  end

  def create
    authorize! :create, :vote

    @election = Election.find params[:election_id]
    if @election.is_active? 
      if @election.has_valid_user_created_at? current_user
        if @election.has_valid_location_for? current_user
          if @election.requires_sms_check?
            if params[:sms_check_token].nil?
              redirect_to sms_check_vote_path(params[:election_id])
            elsif !current_user.valid_sms_check? params[:sms_check_token]
              redirect_to sms_check_vote_path(params[:election_id]), flash: {error: "El código introducido es incorrecto."}
            end
          end
          @scoped_agora_election_id = @election.scoped_agora_election_id current_user
        else
          redirect_to root_url, flash: {error: "No hay votaciones en tu municipio." }
        end
      else
        redirect_to root_url, flash: {error: "Tu usuario no tiene la antigüedad requerida para participar en esta votación."}
      end
    else
      redirect_to root_url, flash: {error: "Ha llegado la fecha límite para votar. La votación está cerrada." }
    end
  end

  def create_token
    authorize! :create_token, :vote

    election = Election.find params[:election_id]
    if election.is_active?
      if election.has_valid_user_created_at? current_user
        if election.has_valid_location_for? current_user
          vote = current_user.get_or_create_vote(election.id)
          message = vote.generate_message
          render :content_type => 'text/plain', :status => :ok, :text => "#{vote.generate_hash message}/#{message}"
        else
          flash[:error] = "No hay votaciones en tu municipio."
          render :content_type => 'text/plain', :status => :gone, :text => root_url
        end
      else
        flash[:error] = "Tu usuario no tiene la antigüedad requerida para participar en esta votación."
        render :content_type => 'text/plain', :status => :gone, :text => root_url
      end
    else
      flash[:error] = "Ha llegado la fecha límite para votar. La votación está cerrada."
      render :content_type => 'text/plain', :status => :gone, :text => root_url
    end
  end

  def check
    authorize! :check, :vote

    @election = Election.find params[:election_id]
    if @election.has_valid_location_for? current_user
      @scoped_agora_election_id = @election.scoped_agora_election_id current_user
    else
      redirect_to root_url, flash: {error: "No hay votaciones en tu municipio." }
    end
  end
end
