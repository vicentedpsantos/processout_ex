defmodule ProcessOut.Device do
  @moduledoc """
  Device information attached to a request.
  """

  use ProcessOut.Resource

  field :request_origin
  field :id
  field :channel
  field :ip_address
  field :user_agent
  field :header_accept
  field :header_referer
  field :app_color_depth
  field :app_java_enabled
  field :app_language
  field :app_screen_height
  field :app_screen_width
  field :app_timezone_offset
end
