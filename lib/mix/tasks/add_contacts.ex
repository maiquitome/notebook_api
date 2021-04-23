defmodule Mix.Tasks.AddContacts do
  @moduledoc "Add contacts into database"
  @shortdoc "Add contacts into database"

  use Mix.Task
  alias NotebookApi.Contacts.AddContacts
  alias NotebookApi.Kinds.AddKinds

  def run(n) do
    # Isso inicializará nossa aplicação
    Mix.Task.run("app.start")

    IO.puts("Adding Kinds...")
    AddKinds.add_kinds()
    IO.puts("Successfully registered kinds!")

    IO.puts("Adding Contacts...")
    AddContacts.add_contacts(n)
    IO.puts("Successfully registered contacts!")
  end
end
