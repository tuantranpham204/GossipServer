class SidekiqAuthConstraint
  def matches?(request)
    # Get the user from the Devise session
    user = request.env["warden"].user(:user)

    # call a Policy directly
    user.present? && SidekiqDashboardPolicy.new(user, :dashboard).show?
  end
end
