# config/initializers/recaptcha.rb
Recaptcha.configure do |config|
  config.site_key  = '6LfLLV8UAAAAAHDNGBIg2qslOARq1kABi3q9QTHj'
  config.secret_key = '6LfLLV8UAAAAAKRWdRdbol3Py9DdQ6Uv09M0lhoX'
  # Uncomment the following line if you are using a proxy server:
  # config.proxy = 'http://myproxy.com.au:8080'
end