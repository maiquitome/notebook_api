defmodule NotebookApi.Repo.Migrations.CreateKinds do
  use Ecto.Migration

  def change do
    create table(:kinds) do
      add :description, :string

      timestamps()
    end

  end
end
