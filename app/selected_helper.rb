module SelectedHelper
  def selected(visible_files)
    return 'readme.txt' if visible_files.key?('readme.txt')

    %w[feature spec test .rs].each do |key|
      file = visible_files.keys.find { |filename| filename.downcase.include?(key) }
      return file unless file.nil?
    end
    visible_files.max do |(_, lhs), (_, rhs)|
      lhs['content'].size <=> rhs['content'].size
    end[0]
  end
end
