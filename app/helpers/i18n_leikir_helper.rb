module I18nLeikirHelper

  def t(*args)
    raw(I18n.t(*args))
  end

end
