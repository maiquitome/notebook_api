defmodule Mix.Tasks.People do
  @moduledoc "Add people into database"
  @shortdoc "Add people into database"

  use Mix.Task
  alias NotebookApi.Notebook.People

  def run(_) do
    # Isso inicializará nossa aplicação
    Mix.Task.run("app.start")

    People.add_people(100)
  end
end
