module Routes
  def web_path(path)
    "#{settings.app_prefix}#{path}"
  end

  def traity_url(path)
    "#{Didentity::Config.traity[:host]}#{path}"
  end
end
