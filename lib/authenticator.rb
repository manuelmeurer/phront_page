# This is used to provide an additional set of constraints for accessing certain routes

module Authenticator
  # Limit routes to a known author
  class AuthorConstraint
    def matches?(request)
      session = Session.find_by_id(request.cookie_jar.signed[:phront_page_session_token])
      session&.author
    end
  end

  # Routes only exist if we are in first run mode
  class FirstRunConstraint
    def matches?(request)
      Author.first_run_safe?
    end
  end

  CONSTRAINTS = {
    author: AuthorConstraint,
    first_run: FirstRunConstraint
  }

  def constraints_for(type)
    CONSTRAINTS[type]
  end

  def authenticate(type, &)
    constraints(constraints_for(type).new, &)
  end
end