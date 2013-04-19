###
# Compass
###

# Susy grids in Compass
# First: gem install susy
# require 'susy'

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy (fake) files
# page "/this-page-has-no-template.html", :proxy => "/template-file.html" do
#   @which_fake_page = "Rendering a fake page with a variable"
# end

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

require 'navigation'
require 'quicklinks'

set :markdown_engine, :redcarpet
set :markdown, :layout_engine => :erb, 
               :tables => true, 
               :autolink => true,
               :smartypants => true,
               :fenced_code_blocks => true

set :css_dir, 'stylesheets'

set :js_dir, 'javascripts'

set :images_dir, 'images'

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript

  # Enable cache buster
  # activate :cache_buster

  # Use relative URLs
  # activate :relative_assets

  # Compress PNGs after build
  # First: gem install middleman-smusher
  # require "middleman-smusher"
  # activate :smusher

  # Or use a different image path
  # set :http_path, "/Content/images/"
end

# For syntax highlighting .. middleman-syntax
activate :syntax

# For navigation breadcrumbs
activate :navigation

# For generated intra-page links
activate :quicklinks

helpers do
  class Middleman::Sitemap::Page
    def banner_url
      p= "/" + app.images_dir + "/banner/" + self.path.gsub(/\.html$/, ".jpg")
      unless File.exists?(app.source_dir+p)
        p = self.parent ? self.parent.banner_url : "/" + app.images_dir + "/banner/default.jpg"
      end
      return p
    end

    def label
      self.data && self.data['menu_title'] || self.parent.nil? ? "home" : File.basename(self.directory_index? ? File.dirname(self.path) : self.path, ".html").gsub("_", " ")
    end
  end

  def banner_img(opts={:width=>700, :height=>120})
    image_tag current_page.banner_url, opts
  end
end

require 'rack/rewrite'
use Rack::Rewrite do
  r301 '/getting-started.html', '/index.html'
  r301 '/frameworks.html', '/docs/using/deploying-apps/'
  r301 '/frameworks/java/spring/spring.html', '/docs/using/deploying-apps/jvm/spring-getting-started.html'
  r301 '/frameworks/java/spring/spring-insight.html', '/docs/using/deploying-apps/jvm/spring-getting-started.html'
  r301 '/frameworks/java/spring/tutorials/springmvc-jpa-postgres/spring-getting-started-with-sts.html', '/docs/using/deploying-apps/jvm/spring-getting-started.html'
  r301 '/frameworks/java/spring/tutorials/springmvc-jpa-postgres/springmvc-template-project.html', '/docs/using/deploying-apps/jvm/spring-getting-started.html'
  r301 '/frameworks/java/spring/tutorials/springmvc-jpa-postgres/spring-expensereport-app-tutorial.html', '/docs/using/deploying-apps/jvm/spring-getting-started.html' 
  r301 '/frameworks/java/spring/tutorials/springmvc-jpa-postgres/expensereport-app-with-spring-security.html', '/docs/using/deploying-apps/jvm/spring-getting-started.html'
  r301 '/frameworks/java/spring/grails.html', '/docs/using/deploying-apps/jvm/grails-getting-started.html'
  r301 '/frameworks/scala/scala.html', '/docs/using/deploying-apps/jvm/'
  r301 '/frameworks/scala/lift.html', '/docs/using/deploying-apps/jvm/lift-getting-started.html'
  r301 '/frameworks/play/play.html', '/docs/using/deploying-apps/jvm/play-getting-started.html'
  r301 '/frameworks/play/java-getting-started.html', '/docs/using/deploying-apps/jvm/play-getting-started.html'
  r301 '/frameworks/play/scala-getting-started.html', '/docs/using/deploying-apps/jvm/play-getting-started.html'
  r301 '/frameworks/play/java-mysql.html', '/docs/using/deploying-apps/jvm/play-getting-started.html'
  r301 '/frameworks/play/java-postgresql.html', '/docs/using/deploying-apps/jvm/play-getting-started.html'
  r301 '/frameworks/play/java-mongodb.html', '/docs/using/deploying-apps/jvm/play-getting-started.html'
  r301 '/frameworks/nodejs/nodejs.html', '/docs/using/deploying-apps/javascript/'
  r301 '/frameworks/nodejs/nodeAutoReconfig.html', '/docs/using/deploying-apps/javascript/'
  r301 '/frameworks/ruby/ruby-rails-sinatra.html', '/docs/using/deploying-apps/ruby/'
  r301 '/frameworks/ruby/ruby.html', '/docs/using/deploying-apps/ruby/'
  r301 '/frameworks/ruby/ruby-cf.html', '/docs/using/deploying-apps/ruby/'
  r301 '/frameworks/ruby/installing-ruby.html', '/docs/using/deploying-apps/ruby/'
  r301 '/frameworks/ruby/ruby-simple.html', '/docs/using/deploying-apps/ruby/'
  r301 '/frameworks/ruby/rails-3-0.html', '/docs/using/deploying-apps/ruby/'
  r301 '/frameworks/ruby/rails-3-1.html', '/docs/using/deploying-apps/ruby/'
  r301 '/frameworks/ruby/sinatra.html', '/docs/using/deploying-apps/ruby/sinatra-getting-started.html'
  r301 '/infrastructure/overview.html', '/index.html'
  r301 '/infrastructure/micro/mcf.html', '/docs/running/micro_cloud_foundry/'
  r301 '/infrastructure/micro/installing-mcf.html', '/docs/running/micro_cloud_foundry/'
  r301 '/infrastructure/micro/using-mcf.html', '/docs/running/micro_cloud_foundry/'
  r301 '/services/mongodb/grails-mongodb.html', '/docs/using/deploying-apps/jvm/grails-service-bindings.html'
  r301 '/services/mongodb/nodejs-mongodb.html', '/docs/using/deploying-apps/javascript/services.html'
  r301 '/services/rabbitmq/nodejs-rabbitmq.html', '/docs/using/deploying-apps/javascript/services.html'
  r301 '/services/mongodb/ruby-mongodb.html', '/docs/using/deploying-apps/ruby/ruby-service-bindings.html'
  r301 '/services/mongodb/ruby-mongodb-gridfs.html', '/docs/using/deploying-apps/ruby/ruby-service-bindings.html'
  r301 '/services/mysql/grails-mysql.html', '/docs/using/deploying-apps/jvm/grails-service-bindings.html'
  r301 '/services/mysql/ruby-mysql.html', '/docs/using/deploying-apps/ruby/ruby-service-bindings.html'
  r301 '/services/rabbitmq/ruby-rabbitmq.html', '/docs/using/deploying-apps/ruby/ruby-service-bindings.html'
  r301 '/services/rabbitmq/spring-rabbitmq.html', '/docs/using/deploying-apps/jvm/spring-service-bindings.html'
  r301 '/services/redis/redis.html', '/docs/using/deploying-apps/ruby/ruby-service-bindings.html'
  r301 '/services/redis/ruby-redis.html', '/docs/using/deploying-apps/ruby/ruby-service-bindings.html'
  r301 '/tools/vmc/vmc.html', '/docs/using/managing-apps/cf/'
  r301 '/tools/vmc/installing-vmc.html', '/docs/using/managing-apps/cf/'
  r301 '/tools/vmc/debugging.html', '/docs/using/managing-apps/cf/'
  r301 '/tools/vmc/vmc-quick-ref.html', '/docs/using/managing-apps/cf/'
  r301 '/tools/vmc/vmc-non-interactive.html', '/docs/using/managing-apps/cf/'
  r301 '/tools/vmc/manifests.html', '/docs/using/managing-apps/cf/'
  r301 '/tools/vmc/caldecott.html', '/docs/using/tunnelling-with-services.html'
  r301 '/tools/STS/sts-eclipse.html', '/docs/using/managing-apps/ide/sts.html'
  r301 '/tools/STS/configuring-STS.html', '/docs/using/managing-apps/ide/sts.html'
  r301 '/tools/STS/debugging-CF-Eclipse.html', '/docs/using/managing-apps/ide/sts.html'
  r301 '/tools/STS/deploying-CF-Eclipse.html', '/docs/using/managing-apps/ide/sts.html'
  r301 '/tools/STS/remote-CF-Eclipse.html', '/docs/using/managing-apps/ide/sts.html'
  r301 '/tools/gallery/box.html', '/index.html'
  r301 '/tools/deploying-apps.html', '/docs/using/deploying-apps/'
  r301 '/samples/samples.html', 'https://github.com/cloudfoundry-samples'
  r301 '/samples/cool-apps.html', 'https://github.com/cloudfoundry-samples'
  r301 '/services.html', '/docs/using/services.html'
  r301 '/services/mongodb/mongodb.html', '/docs/using/services.html'
  r301 '/services/mysql/mysql-overview.html', '/docs/using/services.html'
  r301 '/services/mysql/mysql.html', '/docs/using/services.html'
  r301 '/services/rabbitmq/rabbitmq.html', '/docs/using/services.html'
  r301 '/services/rabbitmq/faq-rabbitmq.html', '/docs/using/services.html'
  r301 '/services/postgres/postgres.html', '/docs/using/services.html'
  r301 '/services/postgres/postgres-ruby.html', '/docs/using/services.html'
end

