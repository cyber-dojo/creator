# frozen_string_literal: true
require_relative 'http_json_hash/service'

class ExternalCreator

  def initialize(http)
    @http = HttpJsonHash::service(self.class.name, http, 'creator-server', 4523)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  def alive?
    @http.get(__method__, {})
  end

  def ready?
    @http.get(__method__, {})
  end

  def sha
    @http.get(__method__, {})
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  def group_create_custom(display_names)
    @http.post(__method__, {display_names:display_names})
  end

  def kata_create_custom(display_name)
    @http.post(__method__, {display_name:display_name})
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  def group_create(exercise_name, languages_names)
    @http.post(__method__, {
      exercise_name:exercise_name,
      languages_names:languages_names
    })
  end

  def kata_create(exercise_name, language_name)
    @http.post(__method__, {
      exercise_name:exercise_name,
      language_name:language_name
    })
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  def deprecated_group_create_custom(display_name)
    @http.post(__method__, {display_name:display_name})
  end

  def deprecated_kata_create_custom(display_name)
    @http.post(__method__, {display_name:display_name})
  end

end
