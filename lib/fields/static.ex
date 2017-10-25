defmodule EctoFields.Static do
  @moduledoc """
  Enforce a static value for a database column, useful when multiple schemas store data in one table

  ## Examples

      iex> defmodule Test do
      ...>   import EctoFields.Static
      ...>   static_field(UserType, "admin")
      ...> end
      ...> Test.UserType.cast(nil)
      {:ok, "admin"}
      iex> Test.UserType.cast("superadmin")
      :error
      iex> Test.UserType.cast("admin")
      {:ok, "admin"}

      Typical usage in Ecto schemas looks like this:

      iex> defmodule Truck do
      ...>   use Ecto.Schema
      ...>   import EctoFields.Static
      ...>
      ...>   static_field(Type, "truck")
      ...>   static_field(Second, "anything")
      ...>
      ...>   schema "vehicles" do
      ...>     field :type, Type
      ...>     field :second, Second
      ...>     field :license_plate, :string
      ...>     field :make, :string
      ...>   end
      ...> end
      ...> Truck.Type.cast(nil)
      {:ok, "truck"}
      iex> Truck.Second.cast(nil)
      {:ok, "anything"}
  """

  defmacro static_field(module, value) do
    quote do
      defmodule unquote(module) do
        @behaviour Ecto.Type

        def type, do: :string

        # cast for usage in queries and changesets
        def cast(nil), do: {:ok, unquote(value)}
        def cast(val) when val == unquote(value), do: {:ok, unquote(value)}
        def cast(_), do: :error

        # load from the database
        def load(nil), do: {:ok, unquote(value)}
        def load(val) when val == unquote(value), do: {:ok, val}
        # if it's another other than nil or the static value we error out (someone inserted garbage into the database)
        def load(_val), do: :error

        # write to the database
        def dump(_), do: {:ok, unquote(value)}
      end
    end
  end
end
