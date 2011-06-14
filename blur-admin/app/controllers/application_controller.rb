class ApplicationController < ActionController::Base
  protect_from_forgery

	require 'thrift/blur'

  enable_authorization do |exception|
    puts params.to_s
    if current_user
      redirect_to root_url, :alert => "Unauthorized"
    else
      redirect_to login_path, :alert => "Please login"
    end
  end

  before_filter :current_user_session, :current_user
  enable_authorization

  def setup_thrift
    @transport = Thrift::FramedTransport.new(Thrift::BufferedTransport.new(Thrift::Socket.new(BLUR_THRIFT[:host], BLUR_THRIFT[:port])))
    protocol = Thrift::BinaryProtocol.new(@transport)
    @client = Blur::Blur::Client.new(protocol)
    @transport.open()
  rescue Thrift::TransportException
    @client = nil
  end
  
  def thrift_client
    setup_thrift unless @client
    @client
  end

  def close_thrift
    @transport.close()
  end

  private
    
    def current_user_session
      return @current_user_session if defined? @current_user_session
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined? @current_user
      @current_user = current_user_session && current_user_session.user
    end
end
