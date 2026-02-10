class Api::V1::ProfileController < ApplicationController
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
                    user_id: profile.user_id,
                    username: profile.user.username,
                    email: profile.is_email_public ? profile.user.email : nil,
                    name: profile.name,
                    surname: profile.surname,
                    bio: profile.bio,
                    dob: profile.dob,
                    gender:  profile.is_gender_public ? profile.gender : nil,
                    relationship_status: profile.is_rel_status_public ? profile.relationship_status : nil,
                    status: profile.is_email_public ? profile.status : nil,
                    avatar_data: {
                      url: profile.avatar_data["url"]
                    },
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
end
