<div align="center">
  <h1>Notebook API</h1>
</div>

### 🚀 Technologies used in this project
* Elixir Programming Language
* Phoenix Web Framework
* elixirs/faker - a library for generating fake data.

<br>
<div align="center">
  <h1>Creating the project from scratch</h1>
</div>

- [Creating the project](#Creating-the-project)
  - [Project creation](#Project-creation)
  - [Database creation](#Database-creation)
- [Creating the first CRUD/Scaffold](#Creating-the-first-CRUD-Scaffold)
  - [Generating the scaffold](#Generating-the-scaffold)
  - [Database migration](#Database-migration)
  - [Install faker](#Install-faker)
  - [Create a task for creating contacts data](#Create-a-task-for-creating-contacts-data)
  - [Seeing the routes](#Seeing-the-routes)
- [Kinds Table](#Kinds-Table)
  - [Adding a new field in the contacts table](#Adding-a-new-field-in-the-contacts-table)
  - [Creating the kinds table](#Creating-the-kinds-table)
  - [Creating kind data](#Creating-kind-data)
  - [Add kind_id data into the contacts table](#Add-kind_id-data-into-the-contacts-table)
  - [Change the task](#Change-the-task)

<div align="center">

  # Creating the project

</div>

### Project creation
```bash
$ mix phx.new notebook_api --no-html --no-webpack
```
### Database creation
```bash
$ cd notebook_api
```
```bash
$ mix ecto.create
```

<div align="center">

  # Creating the first CRUD Scaffold

</div>

### Generating the scaffold
- Generates controller, views, and context for a JSON resource
  ```bash
  $ mix phx.gen.json Contacts Contact contacts name:string email:string birthdate:date
  ```
  * Explaining the above command:
    - mix phx.gen.json
      - é o nome da task do Phoenix para gerar automaticamente todos os componentes do CRUD.
      - Esta task é registrada no Mix no momento da instalação do Phoenix.
      - https://hexdocs.pm/phoenix/mix_tasks.html#mix-phx-gen-json
    - Contacts
      - Para criar um CRUD precisamos de um contexto para não termos colisão de nomes, para isso damos o nome do módulo do contexto onde a estrutura dos componentes do CRUD estarão atreladas;
    - Contact
      - é o nome do Schema;
    - contacts
      - é o nome da tabela;
    - name:string email:string birthdate:date
      - são os nomes das colunas da tabela e seus respectivos tipos.

- Add the _resource_ to your _:api scope_
  ```elixir
  # lib/notebook_api_web/router.ex

  resources "/contacts", ContactController
  ```

### Database migration
- Remember to update your repository by running migrations:
```bash
$ mix ecto.migrate
```

### Install faker
- https://github.com/elixirs/faker
```
$ mix deps.get
```
### Create a task for creating contacts data
- ❌ This command in _rails_ I couldn't find in _phoenix_
  ```bash
  $ rails g task dev setup
  ```
```elixir
# lib/notebook_api/contacts/add_contacts.ex

defmodule NotebookApi.Contacts.AddContacts do
  alias NotebookApi.Contacts.Contact

  def add_contacts(n) when n <= 0 do
  end

  def add_contacts(n) do
    name = Faker.Person.PtBr.name()

    name_email =
      name
      |> String.replace(" ", "")
      |> String.downcase()
      # "árboles más grandes -> arboles mas grandes"
      |> String.normalize(:nfd)
      |> String.replace(~r/[^A-Za-z\s]/u, "")

    NotebookApi.Repo.insert!(
      %Contact{}
      |> Contact.changeset(%{
        birthdate: Faker.Date.date_of_birth(18..65),
        email: "#{name_email}@#{Faker.Internet.PtBr.free_email_service()}",
        name: name,
        kind_id: return_a_kind().id
      })
    )

    add_contacts(n - 1)
  end
end
```

```elixir
# lib/mix/tasks/add_contacts.ex

defmodule Mix.Tasks.AddContacts do
  use Mix.Task
  alias NotebookApi.Notebook.AddContacts

  @shortdoc "Configures the development environment"
  def run(_) do
    # Isso inicializará nossa aplicação
    Mix.Task.run("app.start")

    AddContacts.add_contacts(10)
  end
end
```
show all available tasks
```bash
$ mix help
```
show our task
```bash
$ mix help add_contacts

| | | | | | | | mix add_contacts | | | | | | | | |

Add contacts into database

Location: _build/dev/lib/notebook_api/ebin
```
run our task to register contacts
```bash
$ mix add_contacts
```
### Seeing the routes
```bash
$ mix phx.server
```
- see all routes
  - http://localhost:4000/places-a-route-that-does-not-exist
  - or in the terminal
    ```bash
    $ mix phx.routes
    ```
- see all the people registered
  - http://localhost:4000/api/contacts

<div align="center">

  # Kinds Table

</div>

# Adding a new field in the contacts table
```bash
$ mix ecto.gen.migration contacts_add_kind_id_column
```
```elixir
# priv/repo/migrations/20210422192426_contacts_add_kind_id_column.exs

defmodule NotebookApi.Repo.Migrations.ContactsAddKindIdColumn do
  use Ecto.Migration

  def change do
    alter table(:contacts) do
      add :kind_id, references(:kinds)
    end
  end
end
```
```elixir
# lib/notebook_api/contacts/contact.ex

defmodule NotebookApi.Contacts.Contact do
  use Ecto.Schema
  import Ecto.Changeset

  schema "contacts" do
    field :birthdate, :date
    field :email, :string
    field :name, :string

    # add this line
    belongs_to :kind, NotebookApi.Kinds.Kind

    timestamps()
  end

  @doc false
  def changeset(contact, attrs) do
    contact
    # add :kind_id
    |> cast(attrs, [:name, :email, :birthdate, :kind_id])
    # add :kind_id
    |> validate_required([:name, :email, :birthdate, :kind_id])
  end
end
```

### Creating the kinds table
```bash
$ mix phx.gen.json Kinds Kind kinds description:string
```
```elixir
# lib/notebook_api_web

scope "/api", NotebookApiWeb do
  pipe_through :api

  resources "/contacts", ContactController

  # add this line
  resources "/kinds", KindController
end
```
```bash
$ mix ecto.migrate
```

### Creating kind data
```elixir
# lib/notebook_api/kinds/add_kinds

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
```

### Add kind_id data into the contacts table
```elixir
# lib/notebook_api/contacts/add_contacts.ex

    NotebookApi.Repo.insert!(
      %Contact{}
      |> Contact.changeset(%{
        birthdate: Faker.Date.date_of_birth(18..65),
        email: "#{name_email}@#{Faker.Internet.PtBr.free_email_service()}",
        name: name,
        # add this line:
        kind_id: return_a_kind().id
      })
    )

    add_contacts(n - 1)
  end

  # add this function:
  defp return_a_kind() do
    NotebookApi.Repo.all(NotebookApi.Kinds.Kind)
    |> Enum.random()
  end
```

### Change the task
```elixir
# lib/mix/tasks/add_contacts.ex

defmodule Mix.Tasks.AddContacts do
  @moduledoc "Add contacts into database"
  @shortdoc "Add contacts into database"

  use Mix.Task
  alias NotebookApi.Contacts.AddContacts
  alias NotebookApi.Kinds.AddKinds

  def run(_) do
    # Isso inicializará nossa aplicação
    Mix.Task.run("app.start")

    IO.puts("Adding Kinds...")
    AddKinds.add_kinds()
    IO.puts("Successfully registered kinds!")

    IO.puts("Adding Contacts...")
    AddContacts.add_contacts(100)
    IO.puts("Successfully registered contacts!")
  end
end
```
