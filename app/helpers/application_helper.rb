module ApplicationHelper
  def level_bar(level, max: 10)
    filled = [ level.to_i, max ].min
    empty = max - filled
    "#{'█' * filled}#{'░' * empty}"
  end
end
