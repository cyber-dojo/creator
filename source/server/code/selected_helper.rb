# frozen_string_literal: true
module SelectedHelper

  def selected(visible_files)
    if visible_files.has_key?('readme.txt')
      return 'readme.txt'
    end
    %w( feature spec test .rs ).each do |key|
      file = visible_files.keys.find { |filename| filename.downcase.include?(key) }
      unless file.nil?
        return file
      end
    end
    visible_files.max{ |(_,lhs),(_,rhs)|
      lhs['content'].size <=> rhs['content'].size
    }[0]
  end

end
