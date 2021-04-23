defmodule NotebookApi.Contacts.Contact do
  use Ecto.Schema
  import Ecto.Changeset

  schema "contacts" do
    field :birthdate, :date
    field :email, :string
    field :name, :string

    belongs_to :kind, NotebookApi.Kinds.Kind

    timestamps()
  end

  @doc false
  def changeset(contact, attrs) do
    contact
    |> cast(attrs, [:name, :email, :birthdate, :kind_id])
    |> validate_required([:name, :email, :birthdate, :kind_id])
  end
end
