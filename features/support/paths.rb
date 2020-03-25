module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /the home\s?page/
      '/'
    when /the login page/
      '/login'
    when /the logout page/
      '/logout'
    when /the register page/
      '/register'
    when /the all users page/
      '/check_all_users'
    when /the user details page/
      '/check_all_users/details'
    when /the reset password page/
      '/check_all_users/details/set_password'
    when /the adding bookmark page/
      '/adding_bookmarks'

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"

    end
  end
end

World(NavigationHelpers)
