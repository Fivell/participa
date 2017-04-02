class VerificationController < ApplicationController
  # GET /verificaciones
  def show
    authorize! :show, :verification
  end

  # GET /verificadores
  def step1
    authorize! :step1, :verification
  end

  # GET /verificadores/nueva
  def step2
    authorize! :step2, :verification
  end

  # GET /verificadores/confirmar
  def step3
    authorize! :step3, :verification
  end

  # GET /verificadores/ok
  def result_ok
    authorize! :result_ok, :verification
  end

  # GET /verificadores/ko
  def result_ko
    authorize! :result_ko, :verification
    @user = User.find params[:id]
  end

  # POST /verificadores/search
  def search
    authorize! :search, :verification
    if params[:user]
      @user = User.find_by_email(params[:user][:email])
      if @user
        if @user.is_verified_presentially? 
          flash.now[:notice] = already_verified_alert
          render :step2
        elsif @user.confirmed_at.nil?
          @user.send_confirmation_instructions
          flash.now[:alert] = unconfirmed_email_alert
          render :step2
        else
          render :step3
        end
      else 
        flash.now[:error] = t('verification.alerts.not_found', query1: params[:user][:email], query2: params[:user][:document_vatid] )
        render :step2
      end
    else
      redirect_to verification_step1_path
    end
  end
  
  # POST /verificadores/confirm
  def confirm
    authorize! :confirm, :verification
    @user = User.find params[:id]
    if @user.verify! current_user
      redirect_to verification_result_ok_path
    else
      redirect_to verification_result_ko_path
    end
  end

  private

  def already_verified_alert
    t('verification.alerts.already_presencial', document: @user.document_vatid,
                                                by: @user.verified_by.full_name,
                                                when: @user.verified_at)
  end

  def unconfirmed_email_alert
    t('verification.alerts.unconfirmed_html', email: @user.email).html_safe
  end
end
