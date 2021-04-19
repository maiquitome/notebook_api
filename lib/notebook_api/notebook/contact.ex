defmodule NotebookApi.Notebook.Contact do
  use Ecto.Schema
  import Ecto.Changeset

  schema "contacts" do
    field :birthdate, :date
    field :email, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(contact, attrs) do
    contact
    |> cast(attrs, [:name, :email, :birthdate])
    |> validate_required([:name, :email, :birthdate])
  end
end
