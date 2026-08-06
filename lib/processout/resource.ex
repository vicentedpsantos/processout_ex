defmodule ProcessOut.Resource do
  @moduledoc """
  Declares ProcessOut resource structs and their JSON decoding.

  `use ProcessOut.Resource` and declare fields with `field/2`. The macro
  defines the struct and a `from_map/1` function that builds it from an
  API response map (string keys), recursively casting nested resources:

      defmodule ProcessOut.Coupon do
        use ProcessOut.Resource

        field :id
        field :project, cast: ProcessOut.Project
        field :amount_off
      end

  A `cast:` field accepts either an expanded object (cast into the given
  module), a list of objects, or a plain identifier string (kept as is),
  matching the ProcessOut `expand` mechanics.
  """

  defmacro __using__(_opts) do
    quote do
      import ProcessOut.Resource, only: [field: 1, field: 2]

      Module.register_attribute(__MODULE__, :po_fields, accumulate: true)
      @before_compile ProcessOut.Resource
    end
  end

  @doc """
  Declares a struct field. Options:

    * `:cast` - module used to decode the value when it is a map (or a
      list of maps)
  """
  defmacro field(name, opts \\ []) do
    quote do
      @po_fields {unquote(name), unquote(opts[:cast])}
    end
  end

  defmacro __before_compile__(env) do
    fields = env.module |> Module.get_attribute(:po_fields) |> Enum.reverse()
    names = Enum.map(fields, &elem(&1, 0))

    quote do
      defstruct unquote(names)

      @type t :: %__MODULE__{}

      @doc "Builds a `#{inspect(__MODULE__)}` from an API response map."
      @spec from_map(map() | nil) :: t() | nil
      def from_map(nil), do: nil

      def from_map(data) when is_map(data) do
        ProcessOut.Resource.build(__MODULE__, unquote(Macro.escape(fields)), data)
      end
    end
  end

  @doc false
  def build(module, fields, data) do
    Enum.reduce(fields, struct(module), fn {name, cast}, acc ->
      case Map.fetch(data, to_string(name)) do
        {:ok, value} -> Map.put(acc, name, cast_value(value, cast))
        :error -> acc
      end
    end)
  end

  defp cast_value(value, nil), do: value
  defp cast_value(value, module) when is_map(value), do: module.from_map(value)

  defp cast_value(value, module) when is_list(value),
    do: Enum.map(value, &cast_value(&1, module))

  defp cast_value(value, _module), do: value
end
