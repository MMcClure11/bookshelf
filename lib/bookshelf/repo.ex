defmodule Bookshelf.Repo do
  @moduledoc """
  Stores the decoded list of books from the toml file as `Bookshelf.Books.Book`s in-memory.
  """
  use GenServer

  alias Bookshelf.Books

  def start_link(_init_arg) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @doc """
  Returns a list of `Bookshelf.Books.Book` from the in-memory `Bookshelf.Repo`.
  """
  @spec list_books() :: [Books.Book.t()]
  def list_books() do
    GenServer.call(__MODULE__, :list_books)
  end

  # Callbacks

  @impl true
  def init(:ok) do
    Kernel.send(self(), :books_please)
    initial_state = []
    {:ok, initial_state}
  end

  @impl true
  def handle_info(:books_please, _initial_state) do
    {:noreply, Books.create_book_structs()}
  end

  @impl true
  def handle_call(:list_books, _pid, state) do
    {:reply, state, state}
  end
end
