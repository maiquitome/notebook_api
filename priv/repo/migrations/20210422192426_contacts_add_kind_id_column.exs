defmodule NotebookApi.Repo.Migrations.ContactsAddKindIdColumn do
  use Ecto.Migration

  def change do
    alter table(:contacts) do
      add :kind_id, references(:kinds)
    end
  end
end
