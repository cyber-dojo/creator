require 'json'

class Creator

  def initialize(externals)
    @externals = externals
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def group_create_custom(display_name:)
    id = saver.group_create_custom(display_name)
    manifest = saver.group_manifest(id)
    pull_image_onto_nodes(id, manifest['image_name'])
    id
  end

  def group_create(language_name:, exercise_name:)
    id = saver.group_create2(language_name, exercise_name)
    manifest = saver.group_manifest(id)
    pull_image_onto_nodes(id, manifest['image_name'])
    id
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def kata_create_custom(display_name:)
    id = saver.kata_create_custom(display_name)
    manifest = saver.kata_manifest(id)
    pull_image_onto_nodes(id, manifest['image_name'])
    id
  end

  def kata_create(language_name:, exercise_name:)
    id = saver.kata_create2(language_name, exercise_name)
    manifest = saver.kata_manifest(id)
    pull_image_onto_nodes(id, manifest['image_name'])
    id
  end

  private

  def pull_image_onto_nodes(id, image_name)
    # runner is deployed as a kubernetes daemonSet which
    # means you cannot make http requests to individual runners.
    # So instead, send the request many times (it is asynchronous),
    # and rely on one request reaching each node. If a node is missed
    # it simply means the image will get pulled onto the node on the
    # first run_cyber_dojo_sh() call, and at the browser, the [test]
    # will result in an hour-glass icon.
    16.times { runner.pull_image(id, image_name) }
  end

  #- - - - - - - - - - - - - - - - - -

  def runner
    @externals.runner
  end

  def saver
    @externals.saver
  end

end
