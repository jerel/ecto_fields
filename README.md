# EctoFields

Provides commonly used fields for Ecto projects.

## Installation

To install EctoFields:

  1. Add ecto_fields to your list of dependencies in `mix.exs`:

        def deps do
          [{:ecto_fields, "~> 0.0.1"}]
        end

  2. Use the fields in your Ecto schema:

        schema "user" do
          field :name, :string
          field :email, EctoFields.Email
          field :website, EctoFields.URL
          field :ip_address, EctoFields.IP
        end

