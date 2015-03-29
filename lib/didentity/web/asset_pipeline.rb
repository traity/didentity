require 'sprockets'
require 'sprockets-sass'
require 'sprockets-helpers'
require 'compass'
require 'closure-compiler'
require 'yui/compressor'

module AssetPipeline extend self
  def registered(app)
    app.set :assets, assets = Sprockets::Environment.new(app.settings.root)
    app.set :assets_path, -> { byebug; File.join(public_folder, "assets") }
    app.set :assets_precompile, %w(application.js application.css)

    assets.append_path('assets/fonts')
    assets.append_path('assets/javascripts')
    assets.append_path('assets/stylesheets')
    assets.append_path('assets/images')

    app.set :asset_host, ''

    Compass.configuration do |config|
      config.images_dir = 'assets'
      config.images_path = File.join(app.root, 'assets/images')
      config.generated_images_path = File.join(app.root, 'assets/images')
    end

    app.configure :development, :test do
      assets.cache = Sprockets::Cache::FileStore.new('./tmp')
      app.get '/assets/*' do
        env['PATH_INFO'].sub!(%r{^/assets}, '')
        settings.assets.call(env)
      end
    end

    app.configure :production do
      assets.js_compressor  = Closure::Compiler.new
      assets.css_compressor = YUI::CssCompressor.new
    end

    Sprockets::Helpers.configure do |config|
      config.environment = assets
      config.prefix      = '/assets'

      # Force to debug mode in development mode
      # Debug mode automatically sets
      # expand = true, digest = false, manifest = false
      config.debug = app.development?
      # if app.production?
      #   config.asset_host  = 'd21utl1jejzb41.cloudfront.net'
      #   config.protocol    = 'https'
      #   config.digest      = true
      #   config.manifest    = Sprockets::Manifest.new(assets, File.join(app.assets_path, "manifistro.json"))
      # end
    end

    app.helpers Sprockets::Helpers
  end
end

