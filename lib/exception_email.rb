def request_headers
  env.inject({}){|acc, (k,v)| acc[$1.downcase] = v if k =~ /^http_(.*)/i; acc}
end

def send_exception_email e
  require 'email_init'
  Pony.mail(
    :subject => "[wikindle] Exception: #{e.message[0..29]}",
    :body => <<-BODY
#{e.message}

#{e.backtrace.join("\n")}

#{request.request_method} #{request.url}
Body: #{request.body.read.inspect}
Cookies: #{request.cookies.inspect}
IP: #{request.ip}
Referrer: #{request.referrer.inspect}

#{request_headers.map{|k,v|"#{k.upcase} => #{v.inspect}"}.join("\n")}

Time: #{Time.now}
    BODY
  )
end


