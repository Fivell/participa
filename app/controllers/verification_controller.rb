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
          flash.now[:notice] = t('verification.alerts.already_presencial', document: @user.document_vatid, by: @user.verified_by.full_name, when: @user.verified_at)
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

end
