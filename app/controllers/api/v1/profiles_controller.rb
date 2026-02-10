class Api::V1::ProfilesController < ApplicationController
  def search
    query = params[:q].presence || "*"
    @profiles = Profile.search(
      query,
      fields: [
        "username^10",
        "full_name",
        "name",
        "surname",
        "reversed_full_name"
      ],
      match: :word_start,
      misspellings: { edit_distance: 1 },
      page: params[:page],
      per_page: params[:per_page]
    )
    authorize @profiles, :search?, policy_class: Api::V1::ProfilePolicy
    paginate(
      data:
            @profiles.map do |profile|
                {
                    capacity: current_user.id == params[:user_id] ? "host" : "guest",
                    user_id: profile.user_id,
                    username: profile.user.username,
                    email: profile.is_email_public ? profile.user.email : nil,
                    name: profile.name,
                    surname: profile.surname,
                    bio: profile.bio,
                    dob: profile.dob,
                    gender:  profile.is_gender_public ? profile.gender : nil,
                    relationship_status: profile.is_rel_status_public ? profile.relationship_status : nil,
                    avatar_url: profile.avatar_url,
                    bg_img_url: profile.bg_img_url,
                    friends_amount: profile.user.friends_amount,
                    followers_amount: profile.user.followers_amount,
                    following_amount: profile.user.following_amount,
                    is_email_public: profile.is_email_public,
                    is_gender_public: profile.is_gender_public,
                    is_rel_status_public: profile.is_rel_status_public
                  }
            end,
          meta: {
            total_pages: @profiles.total_pages,
            total_count: @profiles.total_count,
            current_page: @profiles.current_page,
            per_page: @profiles.per_page
          })
  end

  def show
    @profile = Profile.find_by(user_id: params[:id])
    authorize @profile, :show?, policy_class: Api::V1::ProfilePolicy
    if !@profile
      error(message: I18n.t("errors.resource_not_found", resource: "Profile"), status: :not_found)
    elsif current_user.id == @profile.user_id
      # response for host capacity
      profile_json = @profile.as_json
      succeed(
        data: {
          capacity: "host",
          username: @profile.user.username,
          email: @profile.user.email,
          avatar_url: @profile.avatar_url,
          bg_img_url: @profile.bg_img_url,
          friends_amount: @profile.user.friends_amount,
          followers_amount: @profile.user.followers_amount,
          following_amount: @profile.user.following_amount,
          **profile_json
        }
      )
    else
      # response for guest capacity
      succeed(
        data: {
          capacity: "guest",
          user_id: @profile.user_id,
          username: @profile.user.username,
          email: @profile.is_email_public ? @profile.user.email : nil,
          name: @profile.name,
          surname: @profile.surname,
          bio: @profile.bio,
          dob: @profile.dob,
          gender:  @profile.is_gender_public ? @profile.gender : nil,
          relationship_status: @profile.is_rel_status_public ? @profile.relationship_status : nil,
          avatar_url: @profile.avatar_url,
          bg_img_url: @profile.bg_img_url,
          friends_amount: @profile.user.friends_amount,
          followers_amount: @profile.user.followers_amount,
          following_amount: @profile.user.following_amount,
          is_email_public: @profile.is_email_public,
          is_gender_public: @profile.is_gender_public,
          is_rel_status_public: @profile.is_rel_status_public
        }
      )
    end
  end

  def update
    @profile = Profile.find_by(user_id: current_user.id)
    permitted_params = params.permit(:name, :surname, :bio, :dob, :gender, :relationship_status, :is_email_public, :is_gender_public, :is_rel_status_public)
    authorize @profile, :update?, policy_class: Api::V1::ProfilePolicy
    if !@profile
      error(message: I18n.t("errors.resource_not_found", resource: "Profile"), status: :not_found)
    elsif @profile.update(permitted_params)
      profile_json = @profile.as_json
      succeed(
        data: {
          capacity: "host",
          username: @profile.user.username,
          email: @profile.user.email,
          avatar_url: @profile.avatar_url,
          bg_img_url: @profile.bg_img_url,
          friends_amount: @profile.user.friends_amount,
          followers_amount: @profile.user.followers_amount,
          following_amount: @profile.user.following_amount,
          **profile_json
        }
      )
    else
      error(message: I18n.t("errors.validation_error"), status: :unprocessable_entity)
    end
  end


  def update_images
    @profile = Profile.find_by(user_id: current_user.id)
    authorize @profile, :update?, policy_class: Api::V1::ProfilePolicy
    if !@profile
      error(message: I18n.t("errors.resource_not_found", resource: "Profile"), status: :not_found)
      return
    end
    type = params[:type]
    case type
    when "avatar"
        @profile.update(avatar: params[:image])
    when "bg_img"
        @profile.update(bg_img: params[:image])
    end
    succeed(data: { url: type == "avatar" ? @profile.avatar_url : @profile.bg_img_url })
  end

  def get_images
    @profile = Profile.find_by(user_id: params[:user_id])
    type = params[:type]
    authorize @profile, :get_images?, policy_class: Api::V1::ProfilePolicy
    if !@profile
      error(message: I18n.t("errors.resource_not_found", resource: "Profile"), status: :not_found)
    else
      succeed(data: { "#{type}_url": type == "avatar" ? @profile.avatar_url : @profile.bg_img_url })
    end
  end
end
