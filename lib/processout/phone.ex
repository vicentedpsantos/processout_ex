defmodule ProcessOut.Phone do
  @moduledoc """
  Phone number split into its dialing code and number.
  """

  use ProcessOut.Resource

  field :number
  field :dialing_code
end
