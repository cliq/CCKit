Pod::Spec.new do |s|
  s.name         = "CCKit"
  s.version      = "0.0.3"
  s.summary      = "Cliq Consulting reusable components for iOS."

  s.description  = <<-DESC
                   Helpers, MACROS and MVC iOS components provided by Cliq Consulting.

                   * Lifecycle management for network based models
                   * Common views, view controllers, collection layouts, collection cells and helpers
                   DESC

  s.homepage     = "http://cliqconsulting.com"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.authors      = { "Glenn Marcus" => "glenn@cliqconsulting.com", "Leonardo Lobato" => "leo@cliqconsulting.com" }
  s.social_media_url = "http://twitter.com/cliqconsulting"

  s.platform     = :ios, '7.0'
  
  s.source       = { :git => "https://github.com/cliq/CCKit.git", :tag => s.version.to_s }
  s.source_files  = 'CCKit/**/*.{h,m}'
  s.exclude_files = 'CCKit/CCTwitterLoginManager.{h,m}', 'CCKit/OAuthCore/*', 'CCKit/TWiOSReverseAuth/*'
  s.requires_arc = true
  s.ios.xcconfig = { 'HEADER_SEARCH_PATHS' => '$(PODS_ROOT)/../../CCKit/**' }

end
