defmodule NotebookApi.Kinds.AddKinds do
  alias NotebookApi.Kinds.Kind

  def add_kinds() do
    kinds = ["Amigo", "Comercial", "Conhecido"]

    kinds
    |> Enum.each(
      &NotebookApi.Repo.insert!(
        %Kind{}
        |> Kind.changeset(%{description: &1})
      )
    )
  end
end
