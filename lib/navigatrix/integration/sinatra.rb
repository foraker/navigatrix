require "navigatrix/view_helpers"

::Sinatra::Application.send(:helpers, Navigatrix::ViewHelpers)
