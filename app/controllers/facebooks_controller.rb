class FacebooksController < ApplicationController

    require 'httparty' 

    def get_facebook_login_url( permissions, state )
		# endpoint for facebook login dialog
		endpoint = 'https://www.facebook.com/' + ENV["FB_GRAPH_VERSION"] + '/dialog/oauth'

		params = { # login url params required to direct user to facebook and promt them with a login dialog
			'client_id' => ENV["FB_APP_ID"],
			'redirect_uri' => ENV["FB_REDIRECT_URI"],
			'state' => state,
			'scope' => permissions,
			'auth_type' => 'rerequest'
		}

		# return login url
		return endpoint + '?' + params.collect { |k,v| "#{k}=#{v}" }.join('&')
	end

   
    

    def getAccessTokenWithCode( code )
        endpoint = ENV["FB_GRAPH_DOMAIN"] + ENV["FB_GRAPH_VERSION"] + '/oauth/access_token'
        response = HTTParty.get(
         endpoint,
          headers: { 
             "Content-Type" => "application/json",
           },
           query: {
             client_id: ENV["FB_APP_ID"],
             client_secret: ENV["FB_APP_SECRET"],
             redirect_uri: ENV["FB_REDIRECT_URI"],
             code: code
            })
         render json: {  response: response }
	end
    
    def fbLoginUrl 
        fb_state = rand( 1..1000000 );
      fbLoginUrl = get_facebook_login_url( 'email,public_profile', fb_state );
    end
    
    def show
        render json: {
            fbLoginUrl: fbLoginUrl,
           code: params[:code]

          }
    end

end

