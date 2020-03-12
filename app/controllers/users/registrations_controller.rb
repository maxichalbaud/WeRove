# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  def edit
    @recomendation = Recommendation.new
    @groups = Interest.where.not(parent_id: nil).group_by { |interest| interest.parent.title if interest.parent.present? }
    super
  end

  # PUT /resource
  def update
    @groups = Interest.where.not(parent_id: nil).group_by { |interest| interest.parent.title if interest.parent.present? }
    # remove all user interests
    # current_user.user_interests.delete_all
    if params["user"]["interest_ids"].present?
      UserInterest.where(user_id: current_user.id).delete_all
      # remove all empty options
      # create new user interests
      unless params["user"]["interest_ids"].nil?
        params["user"]["interest_ids"].each do |interest_id|
          UserInterest.create(interest_id: interest_id, user: current_user)
        end
      end
      return redirect_to root_path
    end
    super
  end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:languages])
  # end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    registration_steps_path
  end

  def after_update_path_for(resource)#
    root_path
  end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
