defmodule NotebookApi.Repo.Migrations.CreateContacts do
  use Ecto.Migration

  def change do
    create table(:contacts) do
      add :name,      :string
      add :email,     :string
      add :birthdate, :date
      # add_if_not_exists :kind_id,   references(:kinds)

      timestamps()
    end

  end
end
