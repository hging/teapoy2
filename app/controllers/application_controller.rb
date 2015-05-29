# encoding: utf-8
#require "application_responder"
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  #self.responder = ApplicationResponder
  include Pundit

  before_filter :login_required, unless: -> { request.format == :json }

  respond_to :html, :js, :json, :mobile, :wml
  protect_from_forgery
  include AuthenticatedSystem
  include AnonymousCache
  # include PostLock
  include MobileSystem
  # include SeoMethods
  #include AuthorizedSystem
  #include SuperCache
  #check_authorization
  rescue_from ActionController::UnknownFormat, with: :show_404

  Channels = %w(搞笑	 图区	生活 	校园 时尚	文学 影视 动漫 情感 娱乐 女性 科技 游戏	地域	 社会	体育 行业 你懂的	博聆 其他)
  EMOJI_NAMES = %w(sun cloud rain snow thunder typhoon mist sprinkle aries taurus gemini cancer leo virgo libra scorpius sagittarius capricornus aquarius pisces sports baseball golf tennis soccer ski basketball motorsports pocketbell train subway bullettrain car rvcar bus ship airplane house building postoffice hospital bank atm hotel twentyfourhours gasstation parking signaler toilet restaurant cafe bar beer fastfood boutique hairsalon karaoke movie upwardright carouselpony music art drama event ticket smoking nosmoking camera bag book ribbon present birthday telephone mobilephone memo tv game cd heart spade diamond club eye ear rock scissors paper downwardright upwardleft foot shoe eyeglass wheelchair newmoon moon1 moon2 moon3 fullmoon dog cat yacht xmas downwardleft phoneto mailto faxto info01 info02 mail by-d d-point yen free id key enter clear search new flag freedial sharp mobaq one two three four five six seven eight nine zero ok heart01 heart02 heart03 heart04 happy01 angry despair sad wobbly up note spa cute kissmark shine flair annoy punch bomb notes down sleepy sign01 sign02 sign03 impact sweat01 sweat02 dash sign04 sign05 slate pouch pen shadow chair night soon on end clock appli01 appli02 t-shirt moneybag rouge denim snowboard bell door dollar pc loveletter wrench pencil crown ring sandclock bicycle japanesetea watch think confident coldsweats01 coldsweats02 pout gawk lovely good bleah wink happy02 bearing catface crying weep ng clip copyright tm run secret recycle r-mark danger ban empty pass full leftright updown school wave fuji clover cherry tulip banana apple bud maple cherryblossom riceball cake bottle noodle bread snail chick penguin fish delicious smile horse pig wine shock)

  def render *args
    #set_theme(params[:theme] || cookies[:theme] || @group.try(:theme))
    # logger.debug [@theme, cookies[:theme], @group.try(:theme)].join(' ')

    set_theme(@theme || cookies[:theme] || @group.try(:theme))
    super
  end

  protected

  def default_url_options(opts={})
    if request.format == :wml and logged_in? and request.session_options[:id]
      opts.merge!({(request.session_options[:key] || '_session_id') => request.session_options[:id]})
    end
    opts
  end

  def render_feed options = {}
    @options = options
    render :template => "common/rss.xml.builder", :layout => false, :content_type => 'text/xml'
  end
  # Handle public-facing errors by rendering the "error" liquid template
  def show_404 target=''
    show_error "Page \"#{target}\" Not Found", :not_found
  end

  def show_notice(content)
    @notice = content
    render :template => 'common/notice', :layout => false
  end

  def show_error(message = 'An error occurred.', status = :internal_server_error)
    @message = message
    render :template => 'common/error', :status => status, :layout => false
  end

  def inspect_object(object)
    case object
    when Hash, Array
      object.inspect
    when ActionController::Base
      "#{object.controller_name}##{object.action_name}"
    else
      object.to_s
    end
  end

  # after_filter :remove_session_for_http_auth
  # def remove_session_for_http_auth
  #   if !request.authorization.blank?
  #     current_user_session.destroy if current_user_session
  #     request.reset_session
  #     cookies.each do |key|
  #       cookies.delete key
  #     end
  #   end
  # end

  def cache_key_for_current_user(name)
    if logged_in?
      case name
      when Hash
        name.merge(:current_user => current_user.to_param, :format => request.format.to_sym)
      when Array
        name.unshift(current_user.to_param)
        name << request.format.to_sym
      when String
        name += "#{current_user.to_param}.#{request.format.to_sym}"
      end
    end
    name
  end

  def body_attributes(opt=nil)
    @body_attributes ||= {:class => body_class_names}
    return @body_attributes unless opt
    @body_attributes.reverse_merge!(opt)
  end

  def body_class_names
    today = Date.today
    [controller_name, "#{controller_name}-#{action_name}",
     logged_in? ? 'logged_in' : 'not_logged_in',
    "y#{today.year}", "m#{today.month}", "d#{today.day}"
    ]
  end

  helper_method :cache_key_for_current_user, :body_attributes, :body_class_names

  def check_domain
    if g = Group.find_by_domain(request.domain)
      @group = g
    end
  end
  before_filter :check_domain

  after_filter :set_access_control_headers
  def set_access_control_headers
    # logger.debug(request.headers.inspect)
    headers['Access-Control-Allow-Origin'] = request.headers['Origin'] || '*'
    headers['Access-Control-Request-Method'] = 'GET, POST, OPTIONS'
  end


  def find_user
    @user ||= User.find_by_login!(params[:user_id])
  end


  def group
    @group ||= Group.find_by_alias(params[:group_id])
  end
  alias find_group group

  def article_path(*args)
    group_article_path(*args)
  end

  def articles_path(*args)
    group_articles_path(*args)
  end

  def new_article_path(*args)
    new_group_article_path(*args)
  end

  helper_method :article_path, :articles_path, :new_article_path
  def default_serializer_options
    {
      root: false
    }
  end

  def set_flash(type, object: nil)
    flash[:from] = action_name
    flash[:type] = type
    flash[:object_type] = object.class.name
    flash[:object_id]   = object.id
  end
end
