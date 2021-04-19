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
  - [Create a task for creating people data](#Create-a-task-for-creating-people-data)
  - [Seeing the routes](#Seeing-the-routes)


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
  $ mix phx.gen.json Notebook Contact contacts name:string email:string birthdate:date
  ```
  * Explaining the above command:
    - mix phx.gen.json
      - é o nome da task do Phoenix para gerar automaticamente todos os componentes do CRUD.
      - Esta task é registrada no Mix no momento da instalação do Phoenix.
      - https://hexdocs.pm/phoenix/mix_tasks.html#mix-phx-gen-json
    - Notebook
      - Para criar um CRUD precisamos de um contexto para não termos colisão de nomes, para isso damos o nome do módulo do contexto onde a estrutura dos componentes do CRUD estarão atreladas;
    - Contact
      - é o nome do Schema;
    - contacts
      - é o nome da tabela;
    - name:string email:string birthdate:date
      - são os nomes das colunas da tabela e seus respectivos tipos.

- Add the _resource_ to your _:api scope_ in *lib/notebook_api_web/router.ex*
  ```elixir
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
### Create a task for creating people data
- ❌ This command in _rails_ I couldn't find in _phoenix_
  ```bash
  $ rails g task dev setup
  ```
in the *lib/notebook_api/notebook/people.ex*
```elixir
defmodule NotebookApi.Notebook.People do
  alias NotebookApi.Notebook.Contact

  def add_people(n) when n <= 0 do
    IO.puts "Successfully registered contacts!"
  end

  def add_people(n) do
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
      |> Contact.changeset(
        %{
          birthdate: Faker.Date.date_of_birth(18..65),
          email: "#{name_email}@#{Faker.Internet.PtBr.free_email_service}",
          name: name
        }
      )
    )
    add_people(n - 1)
  end
end
```

in the *lib/mix/tasks/people.ex*
```elixir
defmodule Mix.Tasks.People do
  use Mix.Task
  alias NotebookApi.Notebook.People

  @shortdoc "Configures the development environment"
  def run(_) do
    # Isso inicializará nossa aplicação
    Mix.Task.run("app.start")

    People.add_people(10)
  end
end
```
show all available tasks
```bash
$ mix help
```
show our task
```bash
$ mix help people

| | | | | | | | mix people | | | | | | | | |

Add people into database

Location: _build/dev/lib/notebook_api/ebin
```
run our task to register people
```bash
$ mix people
```
### Seeing the routes
```bash
$ mix phx.server
```
- see all routes
  - http://localhost:4000/places a route that does not exist
  - or in the terminal
    ```bash
    $ mix phx.routes
    ```
- see all the people registered
  - http://localhost:4000/api/contacts
