module ApplicationHelper
  def pp(value)
    if value.is_a? Hash
      pp_hash value
    else
      pp_string value
    end
  end

  def pp_string(value)
    value.present? ? value : '-'
  end

  def pp_hash(hash)
    raw ap(hash, plain: true)
  end
end
