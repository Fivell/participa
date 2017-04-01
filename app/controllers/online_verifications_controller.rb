class OnlineVerificationsController < ApplicationController
  before_action :load_user, except: [:index]
  before_action :load_pending_users

  def show
    authorize! :show, :online_verifications

    @events = OnlineVerifications::Event.where(verified: @user)
  end

  def search
    authorize! :seach, :online_verifications

    redirect_to online_verification_path(@user)
  end

  def accept
    authorize! :accept, :online_verifications

    @user.verify_online!(current_user)

    pick_next('accept')
  end

  def reject
    authorize! :reject, :online_verifications

    @user.update!(banned: true)

    pick_next('reject')
  end

  def report
    authorize! :report, :online_verifications

    event = OnlineVerifications::Report.create!(report_params)

    # @todo Handle failures gracefully
    OnlineVerificationMailer.report(event).deliver_now

    pick_next('report')
  end

  def index
    authorize! :index, :online_verifications

    if @pending_users.empty?
      redirect_to root_path,
                  notice: I18n.t('online_verifications.index.no_pending_users')
    end
  end

  private

  def pick_next(action)
    @pending_users.delete(@user)

    if @pending_users.any?
      redirect_to online_verification_path(next_user),
                  notice: I18n.t("online_verifications.#{action}.success")
    else
      redirect_to root_path,
                  notice: I18n.t("online_verifications.you_are_done")
    end
  end

  def next_user
    @pending_users.shuffle.first
  end

  helper_method :next_user

  def load_pending_users
    @pending_users = User.pending_moderation
  end

  def load_user
    @user = User.find(params[:user_id])
  end

  def report_params
    params
      .require(:online_verifications_report)
      .permit(:verified_id, label_ids: [])
      .merge(verifier_id: current_user.id)
  end
end
