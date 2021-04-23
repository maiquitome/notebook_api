defmodule NotebookApi.Kinds.Kind do
  use Ecto.Schema
  import Ecto.Changeset

  schema "kinds" do
    field :description, :string

    timestamps()
  end

  @doc false
  def changeset(kind, attrs) do
    kind
    |> cast(attrs, [:description])
    |> validate_required([:description])
  end
end
