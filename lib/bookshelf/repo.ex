defmodule Bookshelf.Repo do
  @moduledoc """
  Stores the decoded list of books from the toml file as `Bookshelf.Books.Book`s in-memory.
  """
  use GenServer

  alias Bookshelf.Books.Book

  def start_link(_init_arg) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @doc """
  Returns a list of `Bookshelf.Books.Book` from the in-memory `Bookshelf.Repo`.
  """
  @spec list_books() :: [Book.t()]
  def list_books() do
    GenServer.call(__MODULE__, :list_books)
  end

  # Callbacks

  @impl true
  def init(:ok) do
    send(self(), :books_please)
    initial_state = []
    {:ok, initial_state}
  end

  @impl true
  def handle_info(:books_please, _initial_state) do
    {:noreply, create_book_structs!()}
  end

  @impl true
  def handle_call(:list_books, _pid, state) do
    {:reply, state, state}
  end

  # Private functions

  @spec create_book_structs!() :: [Book.t()]
  defp create_book_structs!() do
    input = File.read!(data_path())
    %{"books" => books} = Toml.decode!(input)

    Enum.map(books, fn book ->
      book
      |> Map.new(fn {k, v} -> {parse_key(k), parse_value(k, v)} end)
      |> then(&struct!(Book, &1))
    end)
  end

  @spec data_path() :: String.t()
  defp data_path() do
    case System.get_env("PHX_HOST") do
      "bookshelf-meks.fly.dev" -> "/books.toml"
      _ -> "#{File.cwd!()}/priv/books.toml"
    end
  end

  @spec parse_key(String.t()) :: atom()
  defp parse_key("title"), do: :title
  defp parse_key("author"), do: :author
  defp parse_key("genre"), do: :genre
  defp parse_key("status"), do: :status
  defp parse_key("review"), do: :review
  defp parse_key("date_read"), do: :date_read
  defp parse_key("cover_art"), do: :cover_art

  @spec parse_value(String.t(), String.t()) :: String.t() | atom() | [String.t()]
  defp parse_value("status", value), do: parse_status(value)
  defp parse_value("review", value), do: String.split(value, "\n\n")
  defp parse_value(_, value), do: value

  @spec parse_status(String.t()) :: atom()
  defp parse_status("want_to_read"), do: :want_to_read
  defp parse_status("in_progress"), do: :in_progress
  defp parse_status("complete"), do: :complete
end
