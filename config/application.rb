# encoding: utf-8
require File.expand_path('../boot', __FILE__)

require 'rails/all'
# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.UA-576087-6
ENV['GOOGLE_ACCOUNT_ID'] = 'UA-576087-6'
ENV['SITE_NAME'] = '博聆网'
GC::Profiler.enable

$revision = ''
if File.exists?('REVISION')
  $revision = IO.read('REVISION')
elsif File.exists?('.hg')
  $revision = `hg log -r . --template '{rev}\n'` rescue nil
elsif File.exists?('.git')
  $revision = `git rev-parse --short HEAD` rescue nil
end
$revision.strip!

Bundler.require(*Rails.groups)

module Teapoy
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(
        #{config.root}/lib
        #{config.root}/app/helpers
        #{config.root}/app/posts
        #{config.root}/app/observers)
    # config.paths['config/routes'] += Dir[Rails.root.join("config/routes/*.rb")].sort
    config.paths["config/routes"] = Dir[Rails.root.join("config/routes/*.rb")].sort
    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer
    #
    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Beijing'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    config.i18n.default_locale = :zh

    # JavaScript files you want as :defaults (application.js is always included).
    # config.action_view.javascript_expansions[:defaults] = %w(rails.js plugins.js doT.js floorlink.js jquery.qtip.pack.js)
    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password, :password_confirmation]
    # config.active_record.whitelist_attributes = true
    # config.active_record.identity_map = true
    config.assets.enabled = true
    config.assets.version = '1.0'
    config.generators do |g|
      g.orm :active_record
    end
    #observers_root = Rails.root.join('app/observers').to_s
    config.mongoid.observers = %w(
            inbox/deliver
            notification/mention
            notification/reply
            reputation/rating
            reputation/post
            article/sync_social
            subscription/article
    ).map{|i|"#{i}_observer"}
    config.active_record.observers =
            #article/charge
        %w( user/registration
            ).map{|i|"#{i}_observer"}
    config.after_initialize do |app|
      groups = Rails.groups(:assets => [:development, :test])
      if groups.include?('assets') or groups.include?(:assets)
          app.config.sass.load_paths << "#{Rails.root}/app/assets/stylesheets"
          app.config.sass.load_paths << "#{Gem.loaded_specs['compass-blueprint'].full_gem_path}/frameworks/compass/stylesheets"
          app.config.sass.load_paths << "#{Gem.loaded_specs['compass-blueprint'].full_gem_path}/frameworks/blueprint/stylesheets"
          Sass::Plugin.options[:load_paths] = app.config.sass.load_paths
      end
    end
    Haml::Template.options[:format] = :xhtml
    Haml::Template.options[:encoding] = 'utf-8'
    config.action_view.sanitized_allowed_tags = %w(p div h1 h2 h3 h4 h5 h6 ol ul li strong em u b i span table thead tbody tfoot th tr td caption img embed a  br cite sub sup ins acronym q)
    config.action_view.sanitized_allowed_attributes = %w(id class style href title alt colspan rowspan allowfullscreen src quality width height align allowscriptaccess type)
    # for method override in params
    # require File.join(Rails.root, 'lib/method_override_with_params' )
    # config.middleware.swap Rack::MethodOverride, MethodOverrideWithParams rescue nil
    config.middleware.use 'Rack::RawUpload'#, :paths => ['/users/*/avatar']

    #config.middleware.use Weixin::Middleware, "94dj43l3Zus9qh9i73I9dhf028873x", '/weixin'
    #config.threadsafe!
    config.assets.paths << "#{Rails.root}/app/assets/fonts"
    config.assets.precompile << /\.(?:svg|eot|woff|ttf)$/
    config.assets.precompile +=  %w(tip-twitter.css screen.css
        style.css ie.css handheld.css print.css mobile.css mobile.js mobile2.js
        plugins.js
        admin.css admin.js
        vendor/dd_belatedpng.js
        my.css
        mobile_old.css
        dist/*.js
        dist/*.css
    )
    I18n.enforce_available_locales = false

    config.middleware.insert_before 0, "Rack::Cors" do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :post, :options, :put, :patch]
      end
    end

  end
end
