defmodule NotebookApiWeb.KindView do
  use NotebookApiWeb, :view
  alias NotebookApiWeb.KindView

  def render("index.json", %{kinds: kinds}) do
    %{data: render_many(kinds, KindView, "kind.json")}
  end

  def render("show.json", %{kind: kind}) do
    %{data: render_one(kind, KindView, "kind.json")}
  end

  def render("kind.json", %{kind: kind}) do
    %{id: kind.id,
      description: kind.description}
  end
end
