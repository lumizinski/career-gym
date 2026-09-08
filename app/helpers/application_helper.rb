module ApplicationHelper
  def level_bar(level, max: 10)
    filled = [ level.to_i, max ].min
    empty = max - filled
    "#{'█' * filled}#{'░' * empty}"
  end

  def confidence_label(confidence)
    case confidence.to_i
    when 8..10
      "High"
    when 5..7
      "Medium"
    else
      "Low"
    end
  end
end
